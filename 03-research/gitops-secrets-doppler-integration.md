# Research: Zero-Trust Secrets in GitOps Workflows

**Topic:** How to securely manage secrets in a purely GitOps-driven HomeLab without exposing them to the Git repository or CI/CD logs.
**Date:** 2026-04-09

## Current Landscape
- **Problem:** GitOps requires declarative state, but hardcoding secrets (like DB passwords or Tailscale keys) in Git is a massive security violation.
- **Traditional Solutions:** 
  - SOPS (Mozilla) - Encrypts files in Git. Clunky key management.
  - Sealed Secrets (Bitnami) - Kubernetes specific.

## Proposed Strategy: Doppler + GitHub Actions + Terraform
Instead of encrypting secrets in the repo, we inject them at runtime.

1. **Doppler as SSOT:** All secrets live in Doppler SaaS.
2. **CI/CD Injection:** GitHub Actions uses a Doppler Service Token (stored securely in GitHub Repository Secrets, the *only* secret needed there) to pull necessary variables during the pipeline run.
3. **Terraform Integration:** The Terraform Doppler Provider dynamically fetches secrets during `terraform plan` and `terraform apply`, passing them to the target resources (e.g., passing a DB password to a cloud provider API) without ever writing them to disk.

## Next Steps
- Create a proof-of-concept in `10-projects/` to test Terraform Doppler provider.
- Document the findings as an SOP in `30-resources/`.