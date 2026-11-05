---
name: zoo-code
description: "Multi-model orchestration and intelligent quota failover system. Dynamically routes tasks to optimal model tiers (Fast, Reasoning, Heavy Context, Local) and automatically fails over to alternative providers when rate limits, token exhaustion, or provider outages occur."
metadata:
  version: 1.0.0
  category: developer-tools-and-infra
---

# Zoo Code: Multi-Model Orchestrator & Quota Failover

Development grinds to a halt when an API provider hits a 429 Rate Limit, exhausts token quotas, or experiences transient latency spikes. **Zoo Code** provides an architectural blueprint and operating protocol to dispatch tasks across a multi-model zoo (Google Gemini, Anthropic Claude, OpenAI, and local Ollama/vLLM engines) with automatic quota failover and cost-optimized model tiering.

---

## Model Tier Matrix

```
┌───────────────┬───────────────────────────────┬──────────────────────────────────┐
│ Tier          │ Primary Models                │ Ideal Tasks                      │
├───────────────┼───────────────────────────────┼──────────────────────────────────┤
│ ⚡ Fast        │ Gemini 3 Flash / 2.5 Flash,   │ Quick edits, grep, unit test     │
│               │ Claude 3.5 Haiku, GPT-4o-mini │ runs, file reads, formatting     │
├───────────────┼───────────────────────────────┼──────────────────────────────────┤
│ 🧠 Reasoning  │ Claude 3.7 Sonnet (Thinking), │ Complex bug diagnosis, system    │
│               │ Gemini 3 Pro, o3-mini         │ architecture, security review    │
├───────────────┼───────────────────────────────┼──────────────────────────────────┤
│ 📚 Massive    │ Gemini 1.5/2.5 Pro (2M ctx),  │ Full-codebase ingestion, large   │
│    Context    │ Claude 3.5 Sonnet             │ video/media logs, giant diffs    │
├───────────────┼───────────────────────────────┼──────────────────────────────────┤
│ 🏠 Local /    │ Qwen 2.5 Coder 32B,           │ Air-gapped, zero-cost, offline,  │
│    Offline    │ DeepSeek-R1-Distill, Llama 3  │ secret-heavy audits              │
└───────────────┴───────────────────────────────┴──────────────────────────────────┘
```

---

## Failover Sequence & Error Interception

When an agent encounters a quota or API failure, execute the Zoo Code Failover Protocol:

```
[Tool/API Call Fails: HTTP 429 / RESOURCE_EXHAUSTED / Timeout / 503]
                               │
                               ▼
               ┌───────────────────────────────┐
               │ 1. Snapshot Execution State   │
               │    - Dirty files on disk      │
               │    - Current task objective   │
               │    - Last successful command  │
               └───────────────┬───────────────┘
                               │
                               ▼
               ┌───────────────────────────────┐
               │ 2. Classify Failure Cause     │
               │    - Quota / Rate limit?      │
               │    - Context overflow?        │
               │    - Provider outage?         │
               └───────────────┬───────────────┘
                               │
                               ▼
               ┌───────────────────────────────┐
               │ 3. Select Failover Route      │
               │    Primary ──► Secondary      │
               │    Sonnet  ──► Gemini 3 Pro   │
               │    Gemini  ──► Claude Sonnet  │
               │    Cloud   ──► Local Ollama   │
               └───────────────┬───────────────┘
                               │
                               ▼
               ┌───────────────────────────────┐
               │ 4. Resume Task Transparently  │
               │    Inform user of switch      │
               │    Continue without restart   │
               └───────────────────────────────┘
```

---

## Model Selection Guidelines

### 1. Cost & Token Optimization
- Never use a heavy reasoning model for simple tasks like renaming variables, reading configuration files, or running standard git commands.
- Use subagent delegation with lighter models (`flash` or `flash_lite`) for parallel tasks that do not require complex reasoning.

### 2. Multi-Model Collaboration Patterns
- **Divergent Review:** Let Model A (e.g. Gemini) write code and Model B (e.g. Claude) review it via `code-review-agents` to eliminate blind spots common to a single model architecture.
- **Context Distillation:** Use large-context models to ingest 50+ documentation files and output a compact, 100-line summary for faster interactive models.

---

## Configuration & Environment Variables

Zoo Code expects standard environment keys configured in `~/.gemini/config/` or project `.env`:

```env
# Primary Providers
GEMINI_API_KEY=...
ANTHROPIC_API_KEY=...
OPENAI_API_KEY=...

# Local Fallback (Ollama / LocalAI)
OLLAMA_HOST=http://127.0.0.1:11434
DEFAULT_LOCAL_MODEL=qwen2.5-coder:32b
```

---

## Failover Notification Template
When switching models mid-workflow, emit a clean notification:

> 🔄 **Zoo Code Failover Triggered:** Primary provider encountered `RESOURCE_EXHAUSTED (429)`. Seamlessly failing over to `Gemini 3 Pro`. Active state and file modifications preserved. Continuing execution...
