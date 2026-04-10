# Area: GitOps Architecture & Principles

This domain tracks the core knowledge and guiding principles for all infrastructure management within the `AIandI` ecosystem.

## The 4 Principles of GitOps
*(According to OpenGitOps standards)*

1. **Declarative:** A system managed by GitOps must have its desired state expressed declaratively.
2. **Versioned and Immutable:** The desired state is stored in a way that enforces immutability, versioning, and retains a complete version history. (This is why we use Git).
3. **Pulled Automatically:** Software agents automatically pull the desired state declarations from the source.
4. **Continuously Reconciled:** Software agents continuously observe actual system state and attempt to apply the desired state.

## Implementation in AIandI
- **State Source:** `infrastructure/` directory.
- **Reconciliation Engine:** GitHub Actions (for push-based CI/CD) or external agents (if adopting pull-based tools like ArgoCD later).
- **Security:** Zero secrets in Git. Runtime injection via Doppler.