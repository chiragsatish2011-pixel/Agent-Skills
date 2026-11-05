---
name: awesome-design-md
description: Curated library of 70+ production-grade DESIGN.md design system specifications reverse-engineered from world-class products (Linear, Vercel, Apple, Stripe, Supabase, Notion, Figma, x.ai, Raycast, Resend, etc.). Use when bootstrapping a new design system, seeking high-aesthetic design tokens, or matching an industry-leading visual language for a project.
---

# Awesome DESIGN.md Library

This skill provides immediate access to 70+ reverse-engineered `DESIGN.md` token specifications and visual systems from top design-forward tech companies and consumer brands.

## Available Design Systems in `resources/`

- **Tech & Productivity**: `linear.app`, `vercel`, `stripe`, `supabase`, `notion`, `figma`, `framer`, `raycast`, `resend`, `posthog`, `sentry`, `slack`, `superhuman`, `airtable`, `intercom`, `warp`, `webflow`, `x.ai`, `cursor`, `replicate`, `together.ai`
- **Consumer, Media & Lifestyle**: `apple`, `airbnb`, `spotify`, `playstation`, `oura`, `starbucks`, `nike`, `aljazeera`, `theverge`, `wired`, `pinterest`
- **Fintech & Crypto**: `coinbase`, `binance`, `kraken`, `mercury`, `revolut`, `wise`, `mastercard`, `1win`
- **Automotive**: `tesla`, `bmw`, `bmw-m`, `ferrari`, `lamborghini`, `bugatti`, `spacex`
- **Enterprise & Infrastructure**: `hashicorp`, `clickhouse`, `ibm`, `hp`, `dell-1996`, `oracle`, `sap`, `shopify`

## How to Apply a System

1. Browse or select the target system from `./resources/<name>/DESIGN.md`.
2. Copy the token definitions (colors, typography, spacing, elevation, components) to the project root `DESIGN.md`.
3. Adapt brand-specific tokens to your own project while retaining the token hierarchy and harmonic scales.
4. Validate with `npx @google/design.md lint DESIGN.md`.
5. Export Tailwind/CSS tokens:
   ```bash
   npx @google/design.md export --format css-tailwind DESIGN.md > theme.css
   ```
