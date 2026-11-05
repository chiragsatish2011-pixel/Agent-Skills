---
name: code-review-agents
description: "Simulates or deploys five specialized AI review agents on Pull Requests and diffs: Bug Hunter, Security Auditor, Git History & Context Reviewer, Comment & Doc Verifier, and Confidence Synthesizer. Only findings with high confidence (≥85%) pass through, eliminating nitpicks and false positives."
metadata:
  version: 1.0.0
  category: code-quality-and-review
---

# Multi-Agent Code Review Swarm (5-Agent PR Reviewer)

When evaluating code changes, PRs, or git diffs, this skill deploys a 5-perspective review swarm. Instead of a generic pass that generates trivial formatting nitpicks, the swarm executes five distinct lenses and filters all output through a strict **Confidence Scoring Gate**.

```
                   ┌─────────────────────────────────────────┐
                   │           Pull Request / Diff           │
                   └────────────────────┬────────────────────┘
                                        │
      ┌─────────────────┬───────────────┴───────────────┬─────────────────┐
      ▼                 ▼                               ▼                 ▼
 ┌──────────┐    ┌─────────────┐                 ┌─────────────┐    ┌────────────┐
 │ Agent 1  │    │   Agent 2   │                 │   Agent 3   │    │  Agent 4   │
 │   BUG    │    │  SECURITY   │                 │ GIT HISTORY │    │  COMMENTS  │
 │  HUNTER  │    │   AUDITOR   │                 │  & CONTEXT  │    │   & DOCS   │
 └────┬─────┘    └──────┬──────┘                 └──────┬──────┘    └─────┬──────┘
      │                 │                               │                 │
      └─────────────────┴───────────────┬───────────────┴─────────────────┘
                                        │ (Raw Findings)
                                        ▼
                                 ┌─────────────┐
                                 │   Agent 5   │
                                 │ CONFIDENCE  │ ── Filter out items < 85%
                                 │ SYNTHESIZER │
                                 └──────┬──────┘
                                        │
                                        ▼
                        High-Confidence Actionable Report
```

---

## The Five Review Agents

### Agent 1: Bug Hunter 🐞
- **Focus:** Logic flaws, off-by-one errors, state mutation side effects, null/undefined dereferences, unhandled Promise rejections, race conditions, memory/socket leaks, and improper error handling.
- **Rules:**
  - Trace every conditional branch and early return.
  - Test boundary inputs: `null`, `undefined`, empty string `""`, `0`, `-1`, `MAX_INT`, empty array `[]`, huge payload.
  - Verify async/await concurrency: are parallel promises caught with `Promise.allSettled` or leaking unhandled rejections?

### Agent 2: Security Auditor 🛡️
- **Focus:** Vulnerabilities, data leaks, and attack vectors (OWASP Top 10).
- **Rules:**
  - Search for SQL injection, command injection, XSS, SSRF, path traversal, and prototype pollution.
  - Identify hardcoded API keys, tokens, passwords, private keys, or internal IPs.
  - Verify authorization checks on every modified endpoint or route: does the caller own the resource (`IDOR`)?
  - Check input sanitization, safe deserialization, and cryptographic soundness (e.g., constant-time string comparison for secrets).

### Agent 3: Git History & Context Reviewer 📜
- **Focus:** Contextual regressions, architectural continuity, and historical pitfalls.
- **Rules:**
  - Inspect `git log -p -S <symbol>` or commit history to see why this code was originally written this way.
  - Check if previous PRs reverted this exact change due to an unforeseen edge case.
  - Ensure the change conforms to the repository's architectural patterns and doesn't break public contracts or semver expectations.

### Agent 4: Comment & Documentation Verifier 📝
- **Focus:** Truthfulness, drift, and accuracy of documentation vs. implementation.
- **Rules:**
  - Check if updated code makes existing comments lie. Stale comments are worse than no comments.
  - Ensure new public APIs, exported types, and environment variables have accurate docstrings and README updates.
  - Reject superficial comments (e.g., `// constructor` or `// sets name`).

### Agent 5: Confidence Scorer & Synthesizer ⚖️
- **Focus:** Noise reduction, deduplication, and confidence calibration.
- **Confidence Formula:**
  $$\text{Confidence Score} = \frac{\text{Severity} \times 0.4 + \text{Reproducibility} \times 0.4 + \text{Context Match} \times 0.2}{1.0}$$
- **Threshold Rule:** Any finding with a confidence score **below 85% is discarded**. Do not pollute the review with speculative warnings or style opinions handled by linters.
- Output high-confidence findings with exact line references and runnable code suggestions.

---

## Review Output Format

```markdown
## 🔍 Multi-Agent PR Review Report

### 🎯 Summary
- **Files Inspected:** [count]
- **Raw Swarm Findings:** [count]
- **Passed Confidence Threshold (≥85%):** [count]
- **Verdict:** [APPROVE | REQUEST_CHANGES | BLOCKING_SECURITY_ALERT]

---

### 🚨 Critical / High-Confidence Findings

#### [Severity: CRITICAL | HIGH | MEDIUM] [Agent Name] - Title of Issue
- **File:** `path/to/file.ext#L42-L48`
- **Confidence:** `95%`
- **Vulnerability/Bug Mechanism:** Explanation of how the flaw triggers in practice.
- **Reproducing Scenario:** Exact input or state sequence that breaks the code.
- **Suggested Fix:**
```diff
- problematic line
+ corrected line
```

---

### 📋 Architectural & Context Notes (Agent 3 & 4)
- [Any historical insights, breaking changes, or doc drift]
```

---

## How to Trigger

1. On a PR or diff: Run `git diff origin/main...HEAD` or inspect the modified files.
2. Run through all 4 discovery agents.
3. Apply Agent 5's scoring filter.
4. Deliver the synthesized report.
