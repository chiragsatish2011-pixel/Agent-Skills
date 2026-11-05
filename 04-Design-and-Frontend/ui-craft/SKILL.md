---
name: ui-craft
description: Use when building, redesigning, critiquing or polishing any frontend UI (pages, dashboards, components, forms, motion). Enforces a DESIGN.md token contract, type/color/elevation systems, spring-based micro-interactions, anti-slop bans, and a screenshot audit in a real browser before finishing. Not for backend-only work.
---

# UI Craft

## 0. Context (before any edit)
1. Read PRODUCT.md and DESIGN.md (repo root, then docs/). If DESIGN.md is missing, write it in step 2 before any component.
2. Pick the register: **brand** (marketing, portfolio; the design is the product) or **product** (app, dashboard; the design serves a task). Order of evidence: the brief's wording, then the file in focus, then PRODUCT.md.
3. Write one line: "Reading this as: <product> for <audience>, <visual language>, <stack>."
4. State three dials (1-10): VARIANCE, MOTION, DENSITY. Starting points: marketing 8/7/3, SaaS app 5/4/6, dense dashboard 3/2/8. If the brief is ambiguous, ask exactly one question; otherwise state assumptions and proceed.

## 1. Plan, then attack the plan
Draft: 4-6 named colors, type roles, a layout concept (ASCII wireframe), 3 principles. Then run the reflex check: could someone guess the palette from the product category alone? Could they guess the aesthetic family from category plus "not the obvious one"? If yes to either, revise and say what changed. Spend boldness in ONE memorable element; keep everything else quiet. Brief's explicit words always override these defaults.

## 2. Token contract
- Every value lives in DESIGN.md front matter: colors, typography, spacing, rounded, elevation, motion, components (extra categories are allowed).
- Components reference tokens with `{colors.x}`, `{rounded.sm}`. Hover/focus are sibling keys (`button-primary-hover`). Hex values are quoted.
- A raw hex, px, ms or cubic-bezier in component code is a defect. Export CSS vars: `npx @google/design.md export --format css-tailwind DESIGN.md > theme.css`.
- After editing DESIGN.md run `npx @google/design.md lint DESIGN.md`; fix broken refs and contrast failures.

## 3. Typography
- Scale ratio >= 1.25 per step from 1rem: 0.8 / 1 / 1.25 / 1.563 / 1.953 / 2.441 / 3.052rem. Hero display uses `clamp()`.
- One family or two; if two, make them clearly different. Choose deliberately and record why in DESIGN.md. Do not default to Inter/Roboto/system fonts unless the brand mandates it (whitelist it in DESIGN.md).
- Body line length 65-75ch. Body leading 1.5-1.6 (serif slightly more). Display leading 1.05-1.15, tracking -0.02em.
- Numbers in tables/metrics: `font-variant-numeric: tabular-nums`; monospace when DENSITY > 7.
- No single accented word in a headline. No all-caps eyebrow labels by default. Numbered markers only for real sequences.

## 4. Color
- OKLCH. Lower chroma near lightness 0 and 100. Never `#000` or `#fff`; tint neutrals toward the brand hue (chroma 0.005-0.01). One neutral family, no warm/cool drift.
- Name a strategy: Restrained (accent <= 10%), Committed (one color 30-60%), Full palette (3-4 named roles), Drenched.
- Choose dark vs light from one sentence about who uses it, where, in what light. Never by default.
- Contrast: 4.5:1 body, 3:1 large text and UI. No purple-to-blue gradient default, no gradient text, no neon glow.

## 5. Spacing and layout
- 4px base: 4 8 12 16 24 32 48 64 96. Tight inside groups, loose between groups. The same padding everywhere (e.g. `p-4` on every card) is a defect.
- Cards only when the container carries meaning. Never nest. No row of identical icon+heading+text cards. No hero-metric template (big number, label, stats, gradient).
- Full-height: `min-h-[100dvh]`, never `h-screen`. CSS Grid over flex percentage math. Max-width container.
- VARIANCE > 4: no default centered hero; collapse to a single column below `md`.
- Modals are the last resort; try inline or progressive disclosure first.

## 6. Elevation
- Tokens `elevation.0..3`. Separate surfaces by tone or a full 1px hairline first, shadow second.
- Shadows are tinted from the neutral hue and two-layered (tight + soft). Never one identical gray shadow under every card.
- Backdrop blur only on transient overlays with a reason. No side-stripe borders (`border-left/right` > 1px as accent); use a tint, full border, or icon.

## 7. Motion
- Tokens: durations press 120ms, hover 150ms, popover 160ms, modal 280ms; exit = ~70% of enter. Easing out `cubic-bezier(0.23,1,0.32,1)`, in-out `cubic-bezier(0.77,0,0.175,1)`, drawer `cubic-bezier(0.32,0.72,0,1)`, exit `cubic-bezier(0.4,0,1,1)`.
- Springs (Motion, `motion/react`): ui `{stiffness:500, damping:40, mass:0.8}` (critically damped, default); soft `{300, 30, 1}`; playful `{400, 18, 1}` only for gestures/delight when MOTION >= 7.
- Pressables: `:active { transform: scale(0.97) }`. Entrances start at scale 0.95 + opacity 0, never `scale(0)`. Popovers set `transform-origin` from the trigger; modals stay centered.
- Animate only `transform` and `opacity`. Never `transition: all`; list properties. Never use built-in `ease`, `ease-in` or `ease-in-out`.
- Do not animate keyboard-initiated actions. Non-user-triggered motion: ONE orchestrated page-load moment; no fade-up on every section, no hover lift on every card.
- Honor `prefers-reduced-motion` (replace movement with opacity or 0ms). Animated components are isolated `'use client'` leaves.

## 8. Copy
Every word earns its place. Active voice, sentence case, CTAs name the action ("Save changes"), the same name through the whole flow. Errors say what happened and how to fix it. No emojis. Avoid em dashes (drop this if the brand uses them).

## 9. Ban list (match, then rewrite the element)
Side-stripe borders; gradient text; default glassmorphism; neon/colored glows; purple-blue gradient washes; pure black; identical card grids; nested cards; hero-metric template; `h-screen`; `transition: all`; scale(0) entrances; emojis as icons; custom cursors; decorative sparklines; unexplained numbered markers; mid-dot meta strings and `->` on every link.

## 10. Verify in a browser (mandatory before finishing)
1. Dev server running. For 390x844, 768x1024, 1440x900: `browser_resize`, `browser_navigate`, `browser_take_screenshot`, `browser_console_messages`.
2. Look at each screenshot against DESIGN.md. Check horizontal overflow, tap targets >= 44px, text >= 12px, contrast, focus visibility, truncated or clipped text.
3. Run `npx impeccable detect <url>` if available, and the DESIGN.md lint.
4. Triage: P0 blocks use, P1 breaks hierarchy/a11y, P2 inconsistency, P3 polish. Fix P0-P1, re-shoot, max 3 passes.
5. Final reply: what was built, assumptions made, and any open P0-P2 items.
