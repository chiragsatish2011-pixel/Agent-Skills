# AGENTS.md — Autonomous Agent Directive & Execution Standard

> **Machine-Readable Agent Directive:** This document governs AI Agent behavior when operating within or referencing this Skill Repository. All models (Gemini, Claude, GPT, local LLMs) MUST parse and adhere to these directives.

---

## 🤖 1. Core Operating Principles

1. **Progressive Disclosure:** Never ingest every skill at once. Keep context light. Scan `INDEX.json` or category manifests to locate the specific `<skill>/SKILL.md` needed, then load only that skill file.
2. **Read Before Execution:** Before claiming to run a skill workflow, you MUST read the target `SKILL.md` in full using your file read tool.
3. **Evidence Over Assertions:** Never claim that code compiles, tests pass, or features work without executing the corresponding terminal verification command and citing the output.
4. **Minimal Diff Bias (Ponytail):** Default to zero code or surgical diffs. Do not rewrite whole files when a targeted edit solves the problem.

---

## 🧭 2. Skill Routing Matrix for Agents

When a user request matches the left column, route immediately to the skill in the right column:

| Trigger / User Intent | Target Skill Path | Primary Action |
| :--- | :--- | :--- |
| **"Write minimal code", "Keep token usage down", "YAGNI check"** | `01-Productivity-and-Planning/ponytail` | Execute Negative Diff Gate before editing |
| **"Break this down", "Plan this feature in phases", "Avoid context loss"** | `01-Productivity-and-Planning/get-shit-done` | Initialize phased breakdown with `.gsd/STATE.md` |
| **"Keep running until done", "Run autonomous loop", "Handle crashes"** | `01-Productivity-and-Planning/wrap-loop` | Initialize `.wrap/checkpoint.json` and autonomous loop |
| **"Review PR", "5-agent review", "Security & bug check on diff"** | `03-Code-Quality-and-Review/code-review-agents` | Deploy 5 review lenses; filter findings < 85% confidence |
| **"Review before commit", "Pre-commit check", "CodeRabbit"** | `03-Code-Quality-and-Review/coderabbit` | Check staged git diffs against OWASP & logic checklists |
| **"Remember our decisions", "Save session context", "Memory"** | `02-Memory-and-Knowledge/claude-mem` | Read or write to `.agents/memory/MEMORY.md` |
| **"Obsidian vault", "Connect notes", "Second brain", "Wikilinks"** | `02-Memory-and-Knowledge/obsidian-brain` | Format notes with YAML frontmatter and `[[wikilinks]]` |
| **"Quota limit reached", "Switch model", "Fallback provider"** | `05-Developer-Tools-and-Infra/zoo-code` | Failover execution state to alternative model tier |
| **"Make UI look designed, not generic AI", "Anti-slop"** | `04-Design-and-Frontend/design-taste-frontend` | Apply high-craft typography, layout, and palette rules |
| **"Add motion", "Make interface feel alive", "Emil motion"** | `04-Design-and-Frontend/emil-design-eng` | Apply spring curves, intentional easing, and tactile feedback |
| **"Polish design", "Sweep UI details", "Impeccable"** | `04-Design-and-Frontend/impeccable` | Execute design tokens, spacing scale, and `/polish` sweep |
| **"Clone app", "Reverse-engineer UI flow"** | `06-Fullstack-and-Replica/replica-*` | Run full Replica pipeline from recon to launch |
| **"Convert code to Stitch", "Extract design system"** | `07-Stitch-and-Creative/stitch-*` | Extract static HTML, tokens, or components |

---

## ⚡ 3. Multi-Agent Swarm Protocols

When subagent tools (`invoke_subagent`) are available:
1. **Parallel Exploration:** Dispatch distinct subagents with the `flash` or `flash_lite` model for read-only codebase greps or document surveys.
2. **Review Delegation:** Dispatch the `code-review-agents` swarm onto distinct branches or diffs.
3. **Isolated Workspaces:** Use `branch` or `share` workspace modes when subagents generate large experimental codebases to prevent polluting the primary working tree.

---

## 🛑 4. Absolute Bans for Autonomous Agents

- ❌ DO NOT delete user data or uncommitted git changes without explicit confirmation.
- ❌ DO NOT bypass compiler errors by adding `@ts-ignore` or `# noqa` unless explicitly directed.
- ❌ DO NOT introduce heavy external libraries for trivial utility tasks.
- ❌ DO NOT claim tasks are finished without running test/build verification commands.
