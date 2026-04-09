# 基于 AI Agent 的零信任极简运维中枢构建指南

## 1. 架构愿景
本架构旨在构建一个**便携、无状态、绝对零信任**的 Agentic GitOps 运维中心。只需一个浏览器，即可随时随地拉起一个拥有完整算力、安全接入全局内网、并由 AI Agent 驱动的超级控制台，实现对所有物理机、云平台和项目的一站式管理。

系统销毁后不留任何痕迹，GitHub 仓库仅作为“逻辑躯壳”和知识库，彻底消除单点故障（SPOF）与凭据泄露风险。

## 2. 核心组件拓扑
* **唯一的“事实来源”（大脑）：** GitHub Repository（存放文档、SOP 脚本、AI-Skill 提示词、IaC 配置）。
* **计算与环境载体（躯干）：** GitHub Codespaces（提供弹性的云端容器环境）。
* **全局组网通道（神经）：** Tailscale（将云端容器动态接入包含所有设备的私有虚拟局域网）。
* **凭据注入中心（心脏）：** Doppler（集中管理密钥，通过手动交互式触发注入，实现内存级隔离）。
* **意图解析与执行引擎（手脚）：** AI CLI 工具（如 `gemini-cli`、`claude-code`、`opencode`）。

## 3. 核心设计哲学

### 3.1 极简主义与绝对无状态 (Stateless & Zero-Trust)
拒绝在 GitHub Secrets 中硬编码任何高权限 Token。DevContainer 启动时仅作为“哑终端”，不具备任何云端或内网操作权限。所有密钥（包括 Doppler 主 Token）均在启动后由人类管理员手动交互输入，密钥仅存活于当前 Bash Session 的内存中。容器休眠或销毁，权限即刻湮灭。

### 3.2 业务逻辑的“灰白盒”分离
在质量管理和系统运维中，必须严格控制“变更风险”与“执行偏差”。
* **确定性（白盒）：** 涉及服务重启、数据库备份、网络变配等高危刚性动作，必须沉淀为严格的 Python 或 Bash 代码（SOP）。
* **概率性（灰盒）：** 日志提炼、意图解析、故障排查建议等弹性动作，交由大模型（Prompt）处理。
将两者结合，把确定性代码封装为 AI 的“Skill（工具）”，确保 AI 在执行关键任务时处于严密的受控状态，杜绝大模型幻觉带来的破坏。

---

## 4. 落地指南："抄作业"标准作业程序 (SOP)

### Step 1: 基础设施即代码 (IaC) 预装配
在 GitHub 仓库中创建 `.devcontainer/devcontainer.json` 和对应的 `Dockerfile`。
**目标：** 仅完成基础工具的二进制文件安装，**绝不启动任何服务**。

```json
{
  "name": "GitOps Hub",
  "image": "mcr.microsoft.com/devcontainers/base:debian",
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "postCreateCommand": "bash .devcontainer/install_tools.sh" 
  // install_tools.sh 中包含：apt-get install tailscale, curl -Ls https://cli.doppler.com/install.sh | sh, npm install -g @google/generative-ai-cli 等。
}
```

### Step 2: 编写 "Just-in-Time" 唤醒脚本 (Bootstrap)
在仓库根目录创建 `Makefile` 或 `bootstrap.sh`。这是整个系统的“点火开关”。该脚本必须解决生命周期时序问题：输入凭据 -> 激活 Doppler -> 激活 Tailscale -> 启动 AI Agent。

```bash
#!/bin/bash
# bootstrap.sh: 钢铁网络点火程序

# 1. 安全交互输入 (密码不回显，防泄漏)
read -s -p "🔑 Enter Doppler Token to awaken the Hub: " USER_DOPPLER_TOKEN
echo ""

# 2. 内存级变量注入
export DOPPLER_TOKEN=$USER_DOPPLER_TOKEN

# 3. 验证并拉取环境配置
echo "⏳ Validating credentials and fetching secrets via Doppler..."
doppler secrets verify || { echo "❌ Doppler Auth Failed."; exit 1; }

# 4. 提取 Tailscale 组网密钥并静默组网
echo "🌐 Connecting to Tailnet..."
TAILSCALE_KEY=$(doppler secrets get TAILSCALE_AUTH_KEY --plain)
sudo tailscaled > /dev/null 2>&1 &
sleep 2
sudo tailscale up --authkey=${TAILSCALE_KEY} --hostname=gitops-codespace --accept-routes

# 5. 启动 AI 运维中枢
echo "🤖 Network established. Activating AI Agent..."
# 通过 Doppler 运行你的 AI CLI，使其能读取到所有注入的环境变量
doppler run -- gemini-cli --skill-path ./skills
```

### Step 3: 构建受控的 AI Skill 体系
在仓库中建立 `skills/` 目录。
**防爆红线：** Token 与高敏感数据绝不能进入 LLM 的上下文。AI 只需要知道“何时调用工具”，工具内部通过 Doppler 自动拉取凭据执行。

例如，创建一个 `db_backup_skill.py`，配置给 AI 的描述仅为：“用于备份主数据库”。代码内部逻辑为：
```python
import os
import subprocess

# AI 侧不可见，由本地运行时通过 Doppler 注入
DB_USER = os.environ.get("DB_USER")
DB_PASS = os.environ.get("DB_PASS")
DB_HOST = os.environ.get("DB_HOST")

# 确定性的白盒执行代码
subprocess.run(["mysqldump", f"-h{DB_HOST}", f"-u{DB_USER}", f"-p{DB_PASS}", "main_db", ">", "backup.sql"])
```

---

## 5. 典型业务流转场景范例

**场景：每周系统风险审查自动化**

借助这套机制，你可以将运维风险把控与团队的管理节奏无缝对接。例如，利用配置好的 AI Agent 执行 `make bootstrap` 唤醒环境后，下达指令：

> "调用内网节点巡检 Skill，扫描所有核心云服务器和物理机的系统日志与服务运行状态，生成本周关键运维偏差报告。"

AI 将通过 Tailscale 穿透至各个物理与云端节点，利用确定的脚本抓取数据，再利用 LLM 的能力进行提炼。这样一来，便能确保在每周五下午4点组织技术专家进行一小时的技术盲区拆解会议时，你手头已经准备好了详尽、客观且由 AI 初筛过本周关键偏差和工艺/系统风险的数据底座，大幅提升复盘与决策的效率。