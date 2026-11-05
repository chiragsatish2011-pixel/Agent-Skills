---
name: wrap-loop
description: "Autonomous goal completion engine and crash-resistant execution loop (Ralph Loop / Wrap Loop pattern). Iteratively executes tasks until deterministic verification succeeds, automatically recovering from crashes, shell interruptions, tool timeouts, and process reboots."
metadata:
  version: 1.0.0
  category: productivity-and-planning
---

# Wrap Loop: Autonomous Goal Completion & Crash-Resistant Engine

In standard AI assistant interactions, an agent stops after generating an initial response or hitting a single shell error, waiting for the human to prompt it again. **Wrap Loop** transforms the agent into an autonomous, self-healing loop that persists across tool errors, restarts, and unexpected interruptions until the user's objective is completely verified.

---

## The Wrap Loop Execution Cycle

```
                      ┌───────────────────────────────┐
                      │    INITIALIZE GOAL & CRITERIA │
                      └──────────────┬────────────────┘
                                     │
                     ┌───────────────▼───────────────┐
                     │ Save State:                   │◄───────────────────┐
                     │ .wrap/checkpoint.json         │                    │
                     └───────────────┬───────────────┘                    │
                                     │                                    │
                                     ▼                                    │
                     ┌───────────────────────────────┐                    │
                     │  Execute Next Work Unit       │                    │
                     └───────────────┬───────────────┘                    │
                                     │                                    │
                     ┌───────────────▼───────────────┐                    │
                     │ Verification Gate:            │                    │
                     │ (Test / Build / Curl / Check) │                    │
                     └───────────────┬───────────────┘                    │
                                     │                                    │
                               Does it pass?                              │
                                ├── YES ──► Are ALL criteria met?         │
                                │              ├── YES ──► Clean Exit!    │
                                │              └── NO  ──► Next Unit ─────┤
                                └── NO                                    │
                                     │                                    │
                     ┌───────────────▼───────────────┐                    │
                     │ Error Interception & Repair   │                    │
                     │ (Increment iteration count)   │                    │
                     └───────────────┬───────────────┘                    │
                                     │                                    │
                             Iterations < Limit?                          │
                                ├── YES ──────────────────────────────────┘
                                └── NO ──► Circuit Breaker Triggered (Halt & Ask)
```

---

## State Persistence & Crash Recovery

Wrap Loop maintains a lightweight, local state file at `.wrap/checkpoint.json` (or inside the project root):

```json
{
  "goal": "Implement Stripe webhook handler and test with Stripe CLI",
  "criteria": [
    "Handle payment_intent.succeeded",
    "Handle payment_intent.payment_failed",
    "Verify HMAC signature with webhook secret",
    "Pass test suite: npm test tests/stripe.test.ts"
  ],
  "iteration": 3,
  "max_iterations": 15,
  "last_status": "RUNNING",
  "completed_criteria": [
    "Handle payment_intent.succeeded",
    "Verify HMAC signature with webhook secret"
  ],
  "active_step": "Fix signature verification error on empty payload",
  "dirty_files": [
    "src/routes/webhooks.ts"
  ]
}
```

### Crash Recovery Procedure
When the agent starts or resumes:
1. Check for `.wrap/checkpoint.json`.
2. If `last_status == "RUNNING"`:
   - Announce: *"Resuming Wrap Loop from checkpoint (Iteration N)..."*
   - Inspect files in `dirty_files` to verify disk consistency.
   - Run the immediate verification test to check current reality.
   - Continue without restarting from scratch.

---

## Loop Guardrails & Circuit Breakers

To avoid infinite loops, runaway token costs, or cyclic edits:

1. **Hard Iteration Cap:** Default maximum iterations: **15 cycles**. If 15 iterations pass without meeting criteria, break the loop and present an executive summary of progress and remaining blockers to the human.
2. **Oscillation Detector:** If the agent modifies File A, then File B, then reverts File A to its original state within 3 iterations, pause immediately. This detects oscillating fix-break loops.
3. **No Phantom Progress:** An iteration counts as forward progress **only** if:
   - A previously failing test now passes.
   - A tangible artifact or file was created or validated.
   - The error signature changed to a strictly downstream error.

---

## Slash Command & Activation
- `/wrap <goal>`: Engage Wrap Loop mode on a specified goal.
- Example: `/wrap Migrate database from SQLite to PostgreSQL and verify all migration scripts pass cleanly`
