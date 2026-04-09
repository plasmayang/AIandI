# 🧠 AIandI: My Second Brain & Operations Center

> **The central nervous system for my ideas, knowledge, projects, and infrastructure.**

Welcome to `AIandI` (AI and I). This repository is a unified workspace designed to be a true "Second Brain" augmented by Artificial Intelligence. It is built on a hybrid architecture combining the **P.A.R.A. Method** (Projects, Areas, Resources, Archives) with **Modern Monorepo** engineering principles.

Here, ideas are captured, knowledge is distilled, code is written, and servers are provisioned—all facilitated by AI Copilots like Gemini.

---

## 🗂️ The P.A.R.A. Architecture

This repository is strictly organized to maintain flow and separation of concerns:

- **`00-inbox/` 📥**: The raw intake. Transient landing zone for quick captures and unstructured thoughts.
- **`01-raw/` 🥩**: The immutable source of truth (Karpathy's LLM Wiki concept). A permanent, read-only data lake for original articles, research papers, logs, and unedited notes. The AI compiles structured knowledge from here but NEVER modifies these files.
- **`02-ideas/` 💡**: The incubator. Brainstorming, project proposals, and concepts being explored with AI.
- **`03-research/` 🔬**: Deep dives. Technical research, evaluations of new tools, and reading notes.
- **`10-projects/` 🚀**: Active execution. Source code for active applications, scripts, or focused engineering tasks with a defined end goal.
- **`20-areas/` 🌐**: Ongoing responsibilities. Long-term maintenance domains (e.g., HomeLab architecture, finance, health).
- **`30-resources/` 📚**: The library. Reusable assets, templates, standard operating procedures (SOPs), and shared scripts.
- **`40-archives/` 🗄️**: Cold storage. Completed projects, abandoned ideas, and outdated documents.

## 🤖 The AI Nervous System

This workspace is designed to be deeply understood by AI agents.

- **`.ai/`**: The AI's context engine. Contains custom system instructions, prompt templates, and specialized agent **skills** (e.g., `.ai/skills/doppler-manager`).
- **`infrastructure/`**: The GitOps engine. Declarative Infrastructure as Code (IaC) and the original Agentic Operations Center (see `infrastructure/README.md`).
- **`.github/`**: Automation pipelines and workflows.

---

## 🤝 AI Collaboration Rules

If you are an AI agent assisting in this repository:

1. **Context is King**: Always check `.ai/context.md` (if it exists) to understand the current preferences and state of the workspace.
2. **Respect the Flow**: Ensure new content is routed to the correct P.A.R.A. directory. Don't pollute `10-projects` with raw ideas; put them in `02-ideas` first.
3. **Keep it Clean**: Suggest moving stagnant items to `40-archives` and processing the `00-inbox` regularly.
4. **GitOps Supremacy**: When modifying infrastructure, rely on the SOPs in `30-resources/sops/` and the IaC in `infrastructure/`. Never leak secrets.

---

*This is a living system. It evolves as I do.*
