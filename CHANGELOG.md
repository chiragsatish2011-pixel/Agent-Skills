# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-11-05

### Added
- **Core Headline Skills Installed**:
  - `ponytail`: Minimal code bias and negative-diff token efficiency layer.
  - `code-review-agents`: 5-agent PR review swarm (Bug Hunter, Security Auditor, Git Context, Comment Verifier, Confidence Synthesizer).
  - `claude-mem`: Persistent cross-session architecture and preference memory.
  - `obsidian-brain`: Second brain knowledge graph linking with `[[wikilinks]]`.
  - `get-shit-done` (`gsd`): Phased execution engine and context window conservation.
  - `zoo-code`: Multi-model orchestration, quota failover, and rate-limit switching.
  - `wrap-loop`: Autonomous goal completion engine with crash and reboot recovery.
  - `coderabbit`: Real-time pre-commit code review and security gate.
- **Categorized Portable Structure**:
  - 105 individual skills organized across 7 functional categories.
  - `08-Plugins-and-Bundles` containing 6 complete plugins with `plugin.json` manifests, including `antigravity-power-pack`.
- **Installers & Tooling**:
  - `install.ps1`: Automated PowerShell installer for Windows (`global` or `workspace`).
  - `install.sh`: Portable Bash installer for Linux, macOS, and WSL.
  - `INSTALL.bat`: Double-clickable Windows batch launcher.
  - `INDEX.json`: Machine-readable metadata catalog of all 105 skills.
- **Dual-Audience Documentation**:
  - `README.md`: Distinct, visually highlighted sections for Humans and AI Agents.
  - `AGENTS.md`: Machine-readable agent execution rules and skill routing matrix.
- **GitHub Repository Readiness**:
  - CI validation workflow (`.github/workflows/ci-validate.yml`).
  - Standard issue templates and pull request template.
  - `.gitignore`, `.gitattributes`, `LICENSE` (MIT), and `CONTRIBUTING.md`.
