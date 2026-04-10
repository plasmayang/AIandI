# Project: GitOps Core Infrastructure Bootstrap

**Status:** Planned
**Goal:** Establish the foundational GitOps pipeline for the `AIandI` Operations Center.

## Objectives
1. Create the initial `.github/workflows/terraform-apply.yml` pipeline.
2. Define the remote state backend for Terraform (e.g., using a free tier object storage or a secure local backend via Tailscale).
3. Bootstrap the first actual resource (e.g., configuring a basic Cloudflare DNS record or a dummy VPS) purely through a Pull Request.

## Execution Plan
- [ ] Setup Terraform structure in `infrastructure/terraform/`.
- [ ] Configure Doppler Service Token for GitHub Actions.
- [ ] Write the CI/CD pipeline script.
- [ ] Test the pipeline with a non-destructive resource.