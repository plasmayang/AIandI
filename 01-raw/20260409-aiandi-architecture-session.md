# Session Record: AIandI Architecture, Karpathy's LLM Wiki, and GitOps
**Date:** 2026-04-09

## Context
This document captures the foundational architectural discussion for the `AIandI` repository. The goal was to build a "Second Brain + Geek Operations Center" that seamlessly blends human cognitive workflows with AI automation and GitOps execution.

## Key Decisions & Philosophies

### 1. The P.A.R.A + GitOps Hybrid
We adopted the P.A.R.A method (Projects, Areas, Resources, Archives) for information lifecycle management, but extended it to support actual code execution and infrastructure deployment. 

### 2. Alignment with Andrej Karpathy's "LLM Wiki"
We analyzed Karpathy's 3-folder structure (`raw/`, `wiki/`, `outputs/`) and integrated its core philosophy:
- `01-raw/` is established as the **immutable Source of Truth**. Humans drop data here; AI reads it but never modifies it.
- AI synthesizes this raw data into structured knowledge stored in `20-areas/` and `30-resources/` (acting as the `wiki/`).
- We concluded that `AIandI` is a **superset** of the LLM Wiki. It does knowledge management AND engineering.

### 3. The "Symbiosis of Blueprint and Workshop"
We corrected the fallacy that "human dimensions" and "machine dimensions" are isolated. 
- **Numbered Folders (00-40)**: The Human Dimension (The Blueprint) - Tracks the lifecycle of thoughts and goals.
- **Unnumbered Folders (.ai, infrastructure, .github)**: The Machine Dimension (The Workshop) - Enforces system conventions and provides execution context.
They form a continuous loop: Ideas -> Research -> Infrastructure (Code) -> SOPs (Resources).

### 4. GitOps Mapping in AIandI
GitOps is not a single folder; it's a workflow distributed across the architecture:
- `infrastructure/`: The **State** (What should exist - Terraform, YAML).
- `.github/`: The **Engine** (How it gets deployed - Actions workflows).
- `30-resources/sops/`: The **Rules** (Human intervention guidelines and disaster recovery).
- `10-projects/`: The **Custom Tooling** (Developing custom CLI tools for ops).
