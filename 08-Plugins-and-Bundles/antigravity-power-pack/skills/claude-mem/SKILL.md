---
name: claude-mem
description: "Persistent cross-session memory engine that automatically captures, checkpoints, and recalls architectural decisions, user preferences, project conventions, and ongoing task progress across distinct coding sessions."
metadata:
  version: 1.0.0
  category: memory-and-knowledge
---

# Claude-Mem: Cross-Session Persistent Memory Engine

LLM coding sessions lose context when a conversation ends or when a session window is compacted. **Claude-Mem** creates a durable, cross-session memory layer that persists project context, technical decisions, user preferences, and implementation status across restarts, branches, and multi-day workflows.

---

## Memory Architecture

Claude-Mem stores state in a dedicated, version-controllable directory at the workspace root or global home:

```text
<workspace>/.agents/memory/   (or ~/.gemini/memory/<project-name>/)
├── MEMORY.md                 # Master active context index (< 150 lines)
├── DECISIONS.md              # Architectural Decision Records (ADRs)
├── PREFERENCES.md            # User-specific coding styles, patterns, habits
└── PROGRESS.md               # Milestones, completed phases, and next steps
```

---

## Lifecycle Protocols

### 1. Session Wakeup (Auto-Recall Protocol)
At the very beginning of any session or conversation turn:
1. Check if `.agents/memory/MEMORY.md` (or workspace memory file) exists.
2. Read `MEMORY.md` immediately to prime your context with:
   - Current architecture stack and runtime constraints.
   - User preferences (e.g., "prefer functional components", "never use pnpm", "strict TypeScript").
   - Current active task state and blockers from previous sessions.
3. If files do not exist yet, initialize them during the first significant decision.

### 2. Decision Checkpoint Protocol (Save-on-Decision)
Whenever an important architectural choice is made (e.g., choosing a state management library, designing a database schema, establishing an API contract, or selecting an auth mechanism):
- Append an entry to `DECISIONS.md`:
  ```markdown
  ### ADR-[Index]: [Short Title]
  - **Date:** YYYY-MM-DD
  - **Status:** [Accepted | Superseded | Deprecated]
  - **Context:** Why was this decision needed?
  - **Decision:** What was chosen?
  - **Consequences:** What are the trade-offs or rules to follow going forward?
  ```

### 3. Checkpoint Before Turn Completion
Before completing a major task or phase:
- Update `PROGRESS.md`:
  - Move completed items to `[x] Done`.
  - Record the exact file paths modified.
  - Document the exact next step for the next agent or session.

---

## High-Density Memory Rules (Anti-Bloat)

1. **Strict Context Budget:** `MEMORY.md` MUST remain under 150 lines. When it exceeds 150 lines, compress older items into bulleted summaries.
2. **Never store raw code in memory files:** Store references: `src/auth/jwt.ts (handles token signing and refresh)`.
3. **Record negative knowledge:** Document what **failed** and what NOT to do (e.g., *"Do not use v2 of library X due to native ESM mismatch on Node 18"*). This prevents future sessions from repeating failed experiments.
4. **Distinguish Facts from Preferences:**
   - **Facts:** "Database is PostgreSQL 16 using Prisma ORM."
   - **Preferences:** "User prefers explicit return types on all functions."

---

## Standard Memory Schema

### `MEMORY.md`
```markdown
# Active Project Memory

## Project Overview
- **Name:** [Project Name]
- **Stack:** [Frontend / Backend / DB / Testing]
- **Key Constraints:** [Node version, deployment target, etc.]

## User Directives & Preferences
- [Explicit user rules, style guides, preferred CLI flags]

## Active Phase
- **Current Goal:** [What is being built right now]
- **Last Verified Step:** [What passed verification]
- **Next Action:** [Exact command or file to touch next]

## Critical Gotchas & Don'ts
- [Known edge cases, tricky configs, lessons learned]
```

---

## Commands & Triggers
- `/mem recall` - Force read and summarize all current memories.
- `/mem checkpoint` - Write current progress and decisions to disk.
- `/mem clear` - Reset memory for a fresh start.
