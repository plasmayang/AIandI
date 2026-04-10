# Idea: AI-Driven GitOps Provisioning from Inbox

**Status:** Draft / Unprocessed
**Tags:** #gitops #automation #ai-agent

## The Concept
Can we trigger full infrastructure deployments just by dropping a natural language request into `00-inbox/`?

## Workflow
1. I write a quick note: "Deploy a new Ubuntu VM for testing Docker containers, 2GB RAM." and save it to `00-inbox/new-vm-request.md`.
2. A scheduled AI Agent (running via GitHub Actions or a local cron) scans the inbox.
3. The AI parses the request, determines it's an infrastructure task, and translates it into Terraform code.
4. The AI opens a Pull Request modifying the `infrastructure/` directory.
5. I review the PR. If approved, GitOps (via `.github/workflows`) provisions the server and configures Tailscale/Doppler.

## Feasibility
Needs robust prompt engineering and safety guardrails (only allow PR creation, never auto-apply without human approval).