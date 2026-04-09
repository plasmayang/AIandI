# 🤖 Agentic GitOps Operations Center

> **Building a portable, stateless, and absolute zero-trust Agentic GitOps Operations Center.**

This repository is a standardized framework for managing infrastructure through AI agents (e.g., `gemini-cli`, `claude-code`, `opencode`) and deterministic scripts. It follows a "Zero-Leak" philosophy where credentials never touch the disk and environment state is ephemeral.

---

## 🤝 Agent Onboarding (The Handshake)

If you are an AI Agent assisting in this repository, follow these rules of engagement:

1.  **Research First**: Always read the `docs/` and `src/` directories to understand the specific SOP (Standard Operating Procedure) for a task before suggesting or executing changes.
2.  **No Secrets**: Never print, log, or commit API keys or tokens. Use the **Doppler** integration for all secret management.
3.  **Deterministic Execution**: Prefer calling existing scripts in `src/` (Skills) over generating raw bash commands for critical infrastructure changes.
4.  **Validate**: Always verify network connectivity (Tailscale) and credential status (Doppler) before performing remote operations.

---

## 🏗️ Core Architecture

This center is built on five pillars of secure, automated operations:

*   **🧠 Brain (Logic):** This GitHub Repository — The source of truth for SOPs, Skills, and IaC.
*   **🦾 Body (Compute):** GitHub Codespaces — An ephemeral, containerized execution environment.
*   **⚡ Nerves (Network):** [Tailscale](https://tailscale.com/) — Secure, peer-to-peer networking to reach any node globally.
*   **❤️ Heart (Secrets):** [Doppler](https://www.doppler.com/) — Memory-only secret injection. No `.env` files allowed.
*   **🤖 Hands (Execution):** AI Agents — Translating high-level intent into audited, scripted actions.

---

## 🏁 Quick Start: The "Ignition" Sequence

To initialize the operations center in a new environment:

1.  **Bootstrap Secrets**:
    ```bash
    # Securely input your Doppler Service Token
    export DOPPLER_TOKEN=$(read -s -p "🔑 Enter Doppler Service Token: " token && echo $token)
    doppler secrets verify
    ```

2.  **Establish Network**:
    ```bash
    # Start Tailscale and connect to the private mesh
    sudo tailscaled > /dev/null 2>&1 &
    TAILSCALE_KEY=$(doppler secrets get TAILSCALE_AUTH_KEY --plain)
    sudo tailscale up --authkey=${TAILSCALE_KEY} --hostname=ops-center --accept-routes
    ```

3.  **Initialize AI Agent**:
    ```bash
    # Run your preferred agent with Doppler secret injection
    doppler run -- gemini-cli
    # OR
    doppler run -- claude
    ```

---

## 📂 Repository Layout

- `docs/`: **The Knowledge Base.** Architectural guides and SOPs for specific infrastructure scenarios (e.g., storage mapping, secret management).
- `src/`: **The Skill Set.** Deterministic scripts and agent skill definitions.
    - `doppler-manager/`: Specialized skill for handling secret lifecycles.
    - `scripts/`: General automation and maintenance scripts.
- `.devcontainer/`: IaC for the "Body" (the execution environment).

---

## 🛡️ Zero-Trust Guardrails

- **Stateless Environment**: The execution environment is destroyed after use. No persistent local data.
- **Just-in-Time Injection**: Secrets are injected into process memory at runtime via `doppler run`.
- **White-Box Safety**: High-risk actions (reboots, deletions, network changes) must be backed by a "White-Box" script in `src/` to prevent LLM hallucinations.

---

## 🛠️ Contributing a New Skill

1.  **Write the SOP**: Document the procedure in `docs/`.
2.  **Code the Script**: Implement the deterministic logic in `src/`.
3.  **Define the Skill**: For agents like `gemini-cli`, add the task definition to the relevant `SKILL.md`.

---

## 📜 License

This project is licensed under the [LICENSE](LICENSE) terms.
