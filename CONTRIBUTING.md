# Contributing to Antigravity & AI Agent Skills

Thank you for your interest in contributing to this ecosystem! This repository is dedicated to maintaining high-craft, deterministic, production-grade skills and plugins for AI pair programming assistants.

---

## 📐 Anatomy of a Production Skill

Every skill resides in its own directory under the appropriate domain category (`01-Productivity-and-Planning`, `04-Design-and-Frontend`, etc.) and MUST contain a `SKILL.md` with standard YAML frontmatter:

```markdown
---
name: your-skill-name
description: "Concise summary of what the skill does and when the agent should trigger it."
metadata:
  version: 1.0.0
  category: productivity-and-planning
---

# Title of Skill

## Workflow Overview
[Clear explanation of the procedure]

## Trigger Conditions
[When the agent must activate this skill]

## Step-by-Step Instructions
1. Step 1...
2. Step 2...

## Verification Gate
[Command to prove success]
```

### Frontmatter Contract Rules
- `name`: Lowercase kebab-case string (`my-cool-skill`). Must match directory name.
- `description`: 1-3 sentences outlining capability and triggers.

---

## 🔌 Authoring a Plugin Bundle

If your contribution includes custom MCP servers, hooks, or a multi-skill suite, bundle it inside `08-Plugins-and-Bundles/<plugin-name>/` with a valid `plugin.json`:

```json
{
  "name": "my-plugin",
  "displayName": "My Custom Plugin",
  "version": "1.0.0",
  "description": "What this plugin provides to agents.",
  "suggestedPrompts": [
    "Run my-plugin feature A",
    "Audit system with my-plugin"
  ]
}
```

---

## 🧪 Pull Request Checklist

Before submitting a Pull Request:
1. Ensure your skill is in the correct category folder.
2. Verify YAML frontmatter is valid and parses without errors.
3. Update `INDEX.json` by adding your skill entry.
4. Add your skill to the reference tables in `README.md`.
5. Check that line endings are normalized (`git status`).
