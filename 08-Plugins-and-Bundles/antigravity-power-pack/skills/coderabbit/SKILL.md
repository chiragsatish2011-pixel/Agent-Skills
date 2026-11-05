---
name: coderabbit
description: "Real-time pre-commit code reviewer and security gate inspired by CodeRabbit. Audits staged git diffs and unstaged working directories for logic flaws, security vulnerabilities, N+1 performance bottlenecks, and style drift before you commit code."
metadata:
  version: 1.0.0
  category: code-quality-and-review
---

# CodeRabbit: Real-Time Pre-Commit Code Reviewer & Security Gate

Before committing code to git or pushing to remote repositories, **CodeRabbit** acts as an automated, immediate peer reviewer. It sweeps modified code, catches subtle regressions, flags security vulnerabilities, identifies performance anti-patterns, and generates surgical diff recommendations before problems enter version control.

---

## Pre-Commit Audit Checklist

CodeRabbit runs staged/unstaged diffs against five rigorous review dimensions:

```
┌───────────────────────────────────────────────────────────────┐
│                     CodeRabbit Review Gate                    │
├───────────────────────────────┬───────────────────────────────┤
│ 1. Logic & Correctness        │ - Off-by-one errors           │
│                               │ - Unhandled edge cases (null) │
│                               │ - Broken error cascades       │
├───────────────────────────────┼───────────────────────────────┤
│ 2. Security & Secrets         │ - Accidental hardcoded keys   │
│                               │ - PII leakage in logger calls │
│                               │ - Injection / sanitization    │
├───────────────────────────────┼───────────────────────────────┤
│ 3. Performance & DB           │ - N+1 query patterns          │
│                               │ - Unindexed filter columns    │
│                               │ - Unnecessary memory cloning  │
├───────────────────────────────┼───────────────────────────────┤
│ 4. Test Coverage              │ - Untested new public paths   │
│                               │ - Fragile assertions          │
│                               │ - Missing boundary tests      │
├───────────────────────────────┼───────────────────────────────┤
│ 5. Clean Code & Standards     │ - Lingering debugging flags   │
│                               │ - Dead / commented-out code   │
│                               │ - Inconsistent error formats  │
└───────────────────────────────┴───────────────────────────────┘
```

---

## Review Output Specification

When reviewing code, generate a structured, actionable review with high-signal comments:

```markdown
## 🐇 CodeRabbit Pre-Commit Review

### 📋 Overview
- **Files Audited:** 3 files (+45, -12 lines)
- **Status:** ⚠️ Action Required (1 High, 1 Medium issue found)

---

### ⚠️ Identified Issues

#### 🔴 [HIGH] Potential SQL / Query Injection Vulnerability
- **Location:** `src/controllers/userController.ts#L64`
- **Issue:** User-supplied `req.query.role` is interpolated directly into the query string rather than using parameterized inputs.
- **Remediation:**
```diff
- const query = `SELECT * FROM users WHERE role = '${req.query.role}'`;
+ const query = 'SELECT * FROM users WHERE role = $1';
+ const params = [req.query.role];
```

#### 🟡 [MEDIUM] Unbounded Async Mapping
- **Location:** `src/services/notification.ts#L88`
- **Issue:** `users.map(async (u) => sendEmail(u))` with `Promise.all` can flood SMTP servers or exhaust connection pools on large user sets.
- **Remediation:** Use batching, `p-limit`, or sequential chunks.

---

### ✅ Commendations & Clean Patterns
- Clean type definitions in `src/types/user.ts`.
- Proper error boundaries wrapped around third-party API calls.

---

### 🏁 Final Pre-Commit Verdict
- [ ] **Ready to Commit**
- [x] **Fix Critical Issues Before Commit**
```

---

## Integration with Git & Workflow
Run CodeRabbit whenever:
1. You are about to run `git commit`.
2. The user asks: *"Review my changes"*, *"Is this ready to commit?"*, or *"Check for bugs before I push"*.
3. Use `git diff HEAD` or `git status` to gather changed hunks before evaluating.
