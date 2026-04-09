# 🚀 极空间 + Cloudflare Tunnel 部署 Infisical 密钥中心指南

## 架构总览
* **存储层**：使用极空间 NAS (ZSpace) 本地磁盘挂载 PostgreSQL 数据库，确保核心凭据数据的物理主权。
* **服务层**：通过极空间 Docker 部署 Infisical（服务端）及其依赖环境，提供全功能的 API 与 Web UI。
* **网络层**：利用 Cloudflare Tunnel (cloudflared) 建立拨出式隧道，实现免公网 IP、免端口映射的公网安全访问，同时借助 Cloudflare WAF 抵御公网扫描。
* **安全层**：端到端加密架构，结合内网 Tailscale 备用通道，实现“公网便捷获取 + 内网降级容灾”的混合态势。

---

## 阶段一：前置准备与环境变量生成

### 1. 准备加密密钥
Infisical 需要几个高强度的随机字符串来确保数据加密与认证安全。
在任意 Linux 终端或 VPS 执行以下命令生成随机秘钥，并**妥善记录**：
```bash
# 生成 32 字节的十六进制字符串 (用于 ENCRYPTION_KEY)
openssl rand -hex 32

# 生成另一个 32 字节的十六进制字符串 (用于 AUTH_SECRET)
openssl rand -hex 32
```

### 2. 获取 Cloudflare Tunnel Token
1. 登录 Cloudflare Zero Trust 控制台 (Zero Trust -> Networks -> Tunnels)。
2. 创建一个新的 Tunnel（如命名为 `zspace-infisical`）。
3. 环境选择 Docker，复制生成的安装命令中的 `ey...` 开头的长串 Token。
4. 在 Public Hostname 标签页，将你的域名（如 `secret.yourdomain.com`）路由到内网服务 `http://infisical:8080`（注意此处的 `infisical` 是后续 Docker 内部的容器名）。

---

## 阶段二：极空间 (ZSpace) 容器编排与部署

### 1. 创建持久化数据目录
在极空间的文件管理器中，进入你专门存放 Docker 数据的个人文件夹（建议避免在团队空间进行数据库高频读写），新建以下目录：
* `/docker/infisical/db-data`
* `/docker/infisical/redis-data`

### 2. 编写与执行 Docker Compose
由于包含多个联动容器，建议通过极空间开启 SSH 后执行，或使用极空间的 Docker Compose 功能。

创建 `docker-compose.yml`：
```yaml
version: '3'

networks:
  infisical_net:
    driver: bridge

services:
  db:
    image: postgres:14-alpine
    container_name: infisical-db
    restart: always
    environment:
      POSTGRES_USER: infisical
      POSTGRES_PASSWORD: your_strong_db_password
      POSTGRES_DB: infisical
    volumes:
      - /极空间实际路径/docker/infisical/db-data:/var/lib/postgresql/data
    networks:
      - infisical_net

  redis:
    image: redis:alpine
    container_name: infisical-redis
    restart: always
    volumes:
      - /极空间实际路径/docker/infisical/redis-data:/data
    networks:
      - infisical_net

  infisical:
    image: infisical/infisical:latest
    container_name: infisical-backend
    restart: always
    depends_on:
      - db
      - redis
    environment:
      - NODE_ENV=production
      - DB_URL=postgresql://infisical:your_strong_db_password@db:5432/infisical
      - REDIS_URL=redis://redis:6379
      - ENCRYPTION_KEY=填入你在阶段一生成的ENCRYPTION_KEY
      - AUTH_SECRET=填入你在阶段一生成的AUTH_SECRET
      - SITE_URL=https://secret.yourdomain.com # 你的公网访问域名
    ports:
      - "8080:8080" # 映射到极空间局域网，方便内网调试
    networks:
      - infisical_net

  tunnel:
    image: cloudflare/cloudflared:latest
    container_name: infisical-tunnel
    restart: always
    command: tunnel --no-autoupdate run --token 填入你在阶段一获取的CF_Token
    networks:
      - infisical_net
```
*(注意：请将 `/极空间实际路径/` 替换为极空间内真实的绝对路径)*

执行 `docker-compose up -d` 启动服务。

---

## 阶段三：初始化与客户端接入测试

### 1. Web UI 初始化
1. 在公网环境通过浏览器访问 `https://secret.yourdomain.com`。
2. 注册第一个管理员账号。**强烈建议在完成初始注册后，进入平台设置关闭外部注册 (Disable public sign-ups)。**
3. 创建一个新的项目（Project）并添加一些测试用的环境变量。

### 2. 外部 VPS (Linux) 获取密钥测试
在外部机器上安装 Infisical CLI 工具并测试机器级别的提取：

```bash
# 1. 安装 CLI (以 Debian/Ubuntu 为例)
curl -1sLf 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.deb.sh' | sudo -E bash
sudo apt-get update && sudo apt-get install infisical

# 2. 登录并配置项目 (使用 Machine Identity 或直接登录)
infisical login --domain https://secret.yourdomain.com

# 3. 动态注入环境变量运行脚本测试
infisical run --env=prod -- python3 main.py
```

---

## 🛠️ 避坑与运维备忘录

1. **内网降级通道（Tailscale）**：若 Cloudflare 出现故障，VPS 端的自动化脚本可能会拉取凭据失败。建议在 VPS 上将 `secret.yourdomain.com` 写入 `/etc/hosts` 并指向极空间的 Tailscale 虚拟 IP（如 `100.x.x.x`），配合本地反向代理，实现纯内网回退。
2. **数据库备份是生命线**：WebDAV 适合大文件备份。极度建议编写一个定时脚本，每天使用 `pg_dump` 导出数据库，并压缩保存到你设定的极空间备份目录下。如果数据库丢失或损坏，所有加密密码将永久无法找回。
3. **Cloudflare WAF 加固**：因为 Infisical 承载了所有核心凭据，务必在 Cloudflare 仪表盘中配置 WAF 规则，例如：拦截不在你常用活动国家/地区的访问请求，或者对 `/api/v1/auth` 路径开启限流防御。