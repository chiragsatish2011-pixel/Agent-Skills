---
name: obsidian-brain
description: "Connects your local notes, project history, architecture decisions, and code patterns into a structured second brain / Obsidian vault. Utilizes bidirectional wikilinks, Maps of Content (MOC), frontmatter metadata, and knowledge graph conventions to adapt AI to your custom workflow."
metadata:
  version: 1.0.0
  category: memory-and-knowledge
---

# Obsidian Skill: Second Brain & Knowledge Graph Integration

The **Obsidian Skill** turns raw codebases, scattered notes, design docs, and architectural decisions into an interconnected, graph-linked **Second Brain**. It enables AI agents to read, query, synthesize, and create Obsidian-compatible markdown notes with bidirectional wikilinks (`[[Note Name]]`), YAML frontmatter, and Maps of Content (MOCs).

---

## The Knowledge Vault Structure

Whether connecting to an existing Obsidian Vault or generating a local `.vault/` within a project, organize knowledge along these pillars:

```text
vault/
├── 00-Meta/
│   ├── MOC-Index.md              # Master Map of Content
│   └── Tags.md                   # Controlled vocabulary
├── 01-Architecture/
│   ├── System-Overview.md        # High-level component topology
│   └── Database-Schema.md        # Entity relationships and indexing rules
├── 02-Patterns/
│   ├── Error-Handling.md         # Standard error classes and retry rules
│   └── State-Management.md       # Store conventions and update flows
├── 03-Decisions/
│   └── ADR-001-Choose-Auth.md    # Architectural Decision Records
├── 04-Daily-Logs/
│   └── 2026-11-05.md             # Work session logs, discoveries, blockers
└── 05-References/
    └── External-APIs.md          # 3rd party endpoints, rate limits, quirks
```

---

## Note Conventions & Formatting

### 1. Frontmatter Contract
Every note in the Obsidian Second Brain must include standardized YAML frontmatter:

```yaml
---
title: "JWT Authentication Flow"
type: architecture | pattern | adr | log | concept
created: 2026-11-05
updated: 2026-11-05
tags:
  - auth
  - security
  - backend
aliases:
  - AuthFlow
  - TokenService
related:
  - "[[User-Model]]"
  - "[[API-Security-Audit]]"
---
```

### 2. Bidirectional Linking (Wikilinks)
- Use `[[Note Name]]` to establish connections between concepts.
- Use `[[Note Name#Header]]` to anchor into specific sections.
- Use `[[Note Name|Display Label]]` for readable inline flows.
- Example:
  > When a request arrives, the `AuthMiddleware` verifies the token according to [[Security-Basics#Token-Verification]] before dispatching to [[User-Service]].

### 3. Bidirectional Code Anchors
Link notes back to source files using explicit relative paths and line anchors:
```markdown
- Implementation: [auth.ts](../../src/services/auth.ts#L45)
- Test Suite: [auth.test.ts](../../tests/services/auth.test.ts)
```

---

## Core Workflows

### Workflow A: Querying the Second Brain
When given a complex task:
1. Search the vault for existing notes matching the topic (`grep` or `read_file` on `00-Meta/MOC-Index.md`).
2. Read related ADRs in `03-Decisions/` to understand why constraints exist.
3. Formulate code changes strictly respecting patterns documented in `02-Patterns/`.

### Workflow B: Capturing New Knowledge (Auto-Brain Sync)
When a novel pattern, bugfix with high learning value, or architectural shift occurs:
1. Create or update the note in the appropriate folder.
2. Add relevant wikilinks connecting it to existing nodes in the graph.
3. Update the corresponding Map of Content (`MOC-*.md`).

### Workflow C: Daily Session Log
When logging a development session:
1. Create or append to `04-Daily-Logs/YYYY-MM-DD.md`.
2. Document:
   - What was accomplished (with code links).
   - What blocked or caused friction.
   - Key decisions made, with links to [[ADRs]].
   - Next priority for tomorrow.
