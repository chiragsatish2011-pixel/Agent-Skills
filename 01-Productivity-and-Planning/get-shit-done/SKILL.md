---
name: get-shit-done
description: "High-velocity phased execution engine (GSD). Deconstructs large features and ambitious refactors into strictly isolated phases, executes each atomically, and verifies them before proceeding, avoiding context window bloat and hallucinatory degradation."
metadata:
  version: 1.0.0
  category: productivity-and-planning
---

# Get Shit Done (GSD): Phased Execution & Context-Preserving Engine

Large software features fail in AI workflows for one primary reason: **Context Window Bloat**. When an agent attempts to plan, write, refactor, and debug an entire multi-file system in a single unconstrained run, the context fills up, the agent loses track of early instructions, hallucinates APIs, and creates tangled diffs.

**Get Shit Done (GSD)** solves this by enforcing an uncompromising phased workflow with hard verification checkpoints between every phase.

---

## The GSD Execution Pipeline

```
┌────────────────────────────────────────────────────────┐
│               FEATURE SPEC / USER REQUEST              │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
     ┌──────────────────────────────────────────────────┐
     │ Phase Breakdown: Split into 3-5 Atomic Phases    │
     │  - Phase 1: Contracts & Data Schema (Types/DB)   │
     │  - Phase 2: Core Logic / Service Layer           │
     │  - Phase 3: API / Client / UI Integration        │
     │  - Phase 4: Edge Cases & Hardening               │
     │  - Phase 5: End-to-End Verification              │
     └──────────────────────┬───────────────────────────┘
                            │
              ┌─────────────┴─────────────┐
              ▼                           │
   ┌──────────────────────┐               │
   │ Execute Phase N      │               │
   └──────────┬───────────┘               │
              │                           │
              ▼                           │
   ┌──────────────────────┐               │
   │ Hard Verification:   │               │
   │ Run test / build /   │               │
   │ typecheck command    │               │
   └──────────┬───────────┘               │
              │                           │
       Does it pass?                      │
        ├── NO  ──► Debug & Fix (Max 3)   │
        └── YES ──► Checkpoint & Progress │
                            │             │
              ┌─────────────┘             │
              ▼                           │
     [Are all phases done?] ── NO ────────┘
              │ YES
              ▼
   ┌──────────────────────┐
   │ Ship / Final Summary │
   └──────────────────────┘
```

---

## The 4 Golden Rules of GSD

### 1. One Phase at a Time (Atomic Execution)
- Never start coding Phase 2 until Phase 1 has compiled, run, and passed verification.
- If a phase becomes too large (> 5 files or > 250 lines of diff), split it immediately into sub-phases (Phase 1A, Phase 1B).

### 2. Evidence Before Advancement
- Assertions like *"It should work now"* are strictly prohibited.
- Before declaring a phase complete, run the explicit compiler, linter, or test command (e.g., `npm run build`, `pytest`, `cargo check`, `go test ./...`) and inspect real stdout/stderr output.

### 3. Context Conservation (/compact Awareness)
- When transitioning between heavy phases, recommend or trigger context compacting so the context window remains clean and sharp.
- Persist state into a lightweight status tracker `.gsd/STATE.md` or a markdown artifact so that if context is cleared, the agent resumes in seconds without re-asking questions.

### 4. Zero Unnecessary Dependencies
- Do not install new third-party packages unless the user explicitly requested them or no native solution exists. Keep dependencies lean.

---

## The GSD State Tracking Schema (`.gsd/STATE.md`)

```markdown
# GSD Tracking Dashboard

**Goal:** [One-sentence feature objective]
**Current Phase:** Phase 2 of 4
**Health:** 🟢 GREEN (Tests passing)

---

### Phases
- [x] **Phase 1: Domain Models & Schema** (Completed 2026-11-05)
  - Output: `src/types/auth.ts`, `prisma/schema.prisma`
  - Verification: `npx prisma validate && npm run typecheck` (PASSED)
- [ ] **Phase 2: Authentication Service & Token Signing** (IN PROGRESS)
  - Scope: `src/services/auth.ts`, `tests/auth.test.ts`
  - Verification target: `npm test tests/auth.test.ts`
- [ ] **Phase 3: Route Handlers & Middleware Integration**
- [ ] **Phase 4: E2E Verification & Security Hardening**

---

### Recent Checkpoints & Context
- Migrations generated and applied cleanly.
- Redis connection string configured in `.env.example`.
```

---

## Recovery Protocol
If an unrecoverable compilation error or regression occurs during a phase:
1. Revert uncommitted changes in that phase: `git checkout -- <dirty-files>`.
2. Review the error message with a fresh perspective.
3. Formulate an alternative approach with a smaller diff.
