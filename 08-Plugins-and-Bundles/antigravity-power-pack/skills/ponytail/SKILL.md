---
name: ponytail
description: "Efficiency layer and negative-diff gate that evaluates whether new code is actually necessary before writing a single line. Drastically reduces token consumption, bloat, and technical debt by enforcing YAGNI, standard library re-use, refactoring over accretion, and minimal surgical edits."
metadata:
  version: 1.0.0
  category: efficiency-and-architecture
---

# Ponytail: Minimal Code Bias & Token Efficiency Layer

> "The cheapest, fastest, and most reliable components of a computer system are those that aren't there." — Gordon Bell

Ponytail is an efficiency protocol that intercepts the urge to write new code. Modern AI agents tend to over-engineer: generating speculative abstractions, boilerplate classes, redundant utility functions, and bloated implementations when a concise 3-line adjustment or an existing helper function was already sufficient.

When Ponytail is active, you MUST pass through the **Negative Diff Gate** before writing or modifying any code.

---

## The Negative Diff Gate (Mandatory Pre-Code Checklist)

Before generating code or editing any file, execute this internal 5-point evaluation:

```
                  ┌───────────────────────────────┐
                  │ Request for Code Change       │
                  └──────────────┬────────────────┘
                                 │
                                 ▼
               [1] Can this be solved with ZERO code?
                     │ (config, existing flag, OS CLI, package setting)
                     ├────────► YES ──► Implement via config/command; STOP.
                     ▼ NO
               [2] Does the codebase ALREADY have this?
                     │ (grep utilities, models, standard lib, existing helper)
                     ├────────► YES ──► Import & reuse existing code; STOP.
                     ▼ NO
               [3] Can we DELETE code to achieve this?
                     │ (dead branches, obsolete wrappers, duplicated logic)
                     ├────────► YES ──► Prune and simplify; STOP.
                     ▼ NO
               [4] What is the MINIMUM SURGICAL DIFF?
                     │ (prefer editing 3 lines over generating 100 new lines)
                     ├────────► Formulate targeted hunk
                     ▼
               [5] Token Economy Check:
                     │ (avoid rewriting entire file; replace only target)
                     └────────► Apply surgical edit
```

---

## Core Tenets of Ponytail

### 1. The Zero-Line Bias
- Always ask: *"What happens if we don't write this code?"*
- Check whether the framework or language runtime already provides the requested behavior natively (e.g., modern JavaScript `Array.prototype.at`, `structuredClone`, `Object.hasOwn`, Python `pathlib`, `itertools`, Go standard library).
- Reject unnecessary external packages if a 5-line native pattern does the job. Conversely, reject re-inventing an established utility that already exists in the project's dependencies.

### 2. Surgical Overhaul over Rewrites
- **Anti-pattern:** Replacing an entire 400-line file to change two conditionals.
- **Ponytail pattern:** Use targeted diffs (`edit_file`) targeting only the specific lines needing change.
- Never refactor unrelated surrounding code unless explicitly asked or strictly required to prevent a regression.

### 3. Radical YAGNI (You Aren't Gonna Need It)
- **Banned:** Speculative design patterns ("Just in case we need to support 10 different database engines later...").
- **Banned:** Generic factory factories, excessive interface layers with only one implementation, redundant DTO mappers.
- Write direct, clear, plain code. If one function suffices, do not write a class hierarchy.

### 4. Negative Line Count as a Feature
- Treat code as a liability, not an asset. Every line added must be read, tested, maintained, and paid for in LLM context tokens.
- When fixing a bug, first inspect whether the buggy feature is obsolete or can be removed entirely.
- Look for opportunities to consolidate duplicate helper functions into a single shared utility.

---

## Pre-Execution Justification Template

When Ponytail is invoked or when working on performance/token-constrained tasks, prepend your plan with a brief **Ponytail Justification**:

```markdown
### 🪮 Ponytail Efficiency Audit
- **Code Avoidance:** Can this be solved without new code? [No, feature requires new endpoint]
- **Reuse Opportunity:** Found existing helper `sanitizeInput` in `src/utils/security.ts`.
- **Targeted Diff:** Modifying 4 lines in `src/routes/api.ts` rather than recreating the route handler.
- **Net Line Delta:** +6 lines / -2 lines.
```

---

## Token Conservation Rules for Agents

1. **Never dump full file contents when inspecting:** Use `grep`, search, or targeted line ranges (`StartLine`/`EndLine`).
2. **Never re-emit unchanged files:** Use surgical search-and-replace tools.
3. **Keep plan descriptions concise:** Bullet points with exact paths and diff sizes, not narrative essays.
4. **Preserve comments only where meaningful:** Do not write obvious boilerplate comments (`// increments i by 1`).

---

## Verification

After applying code changes under Ponytail:
1. Verify tests pass.
2. Run `git diff --stat` to inspect the line delta.
3. If more lines were added than necessary, pause and ask: *"Can I compress this by 50% without sacrificing readability?"*
