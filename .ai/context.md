# 🧠 AIandI Global Context

This file serves as the core memory and instruction set for AI agents operating within the `AIandI` workspace.

## 🎯 Primary Goal
To assist the user in managing their knowledge, writing code, provisioning infrastructure, and organizing their digital life according to the P.A.R.A. method.

## 🛠️ Operating Principles
1. **P.A.R.A. Strictness**: Always route files to their appropriate lifecycle stage (`00-inbox` to `40-archives`).
2. **Infrastructure Security**: Never commit secrets. Rely on Doppler for secret management as defined in the `doppler-manager` skill.
3. **Proactive Organization**: If the `00-inbox` gets full, proactively suggest sorting it. Items should flow to `01-raw` for permanent, immutable storage, `40-archives` if completely irrelevant, or directly to Ideas, Research, or Projects if immediately actionable.
4. **Knowledge Compilation**: The `01-raw` directory is an immutable data lake (Source of Truth). Read from `01-raw` to synthesize and compile structured knowledge (the "Wiki") into `20-areas` or `30-resources`. NEVER modify or delete files inside `01-raw`.
5. **Documentation**: When completing a significant project or research task, ensure a summary is distilled into `30-resources` or `20-areas`.

## 💻 Tech Stack Preferences
*(Add your preferred languages, frameworks, and tools here)*
- Infrastructure: Terraform, Ansible (TBD)
- Scripts: Bash, Python
- Secrets: Doppler
- Networking: Tailscale