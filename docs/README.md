# SkyLink Specification

The full spec, one file per section. Read in order, or jump to what you need.

| # | Section | What's in it |
| --- | --- | --- |
| 1 | [Product overview](01-product-overview.md) | What SkyLink is, who it's for, the core bet |
| 2 | [Architecture](02-architecture.md) | System diagram, iOS modules, backend split, database schema |
| 3 | [Navigation](03-navigation.md) | Home screen, the hamburger drawer, entry points, a11y baseline |
| 4 | [Category tree](04-category-tree.md) | All 10 maintenance categories and their jobs |
| 5 | [Guides & diagrams](05-guides-and-diagrams.md) | Guide anatomy, diagram standards, the web-search fallback |
| 6 | [Roadside SOS](06-roadside-sos.md) | The stranded flow, end to end |
| 7 | [OBD-II](07-obd-ii.md) | Dongle pairing, code translation, tier gating |
| 8 | [AI agents](08-ai-agents.md) | Routing, tool layer; prompts live in [`/agents`](../agents/) |
| 9 | [Pricing](09-pricing.md) | Free / Garage / Industry, and what a "search" means |
| 10 | [Brand](10-brand.md) | Palette, type, illustration style, voice |
| 11 | [Safety & ethics](11-safety-and-ethics.md) | Hard-stop list, escalation, privacy, charter |
| 12 | [Roadmap](12-roadmap.md) | The road to 1.0, release order, open questions |
| 13 | [Parts Finder](13-parts-finder.md) | Cheapest parts nearby, live map, navigation |
| 14 | [Auto](14-auto-the-mechanic.md) | The pocket mechanic — character, Apple Intelligence split, Maps handoff |
| 15 | [Pocket Garage](15-pocket-garage.md) | Onboarding, the garage home screen, reminders |

Single-file version for reading offline or feeding to an LLM:
[`/spec/SkyLink-Master-Spec-v0.2.md`](../spec/SkyLink-Master-Spec-v0.2.md).

## Decision records

Significant architectural decisions and why they were made: [`adr/`](adr/).
[ADR 0004](adr/0004-scope-cut-car-app-only.md) is the most recent and supersedes
two earlier ones — read it before proposing anything cross-product.

## If you only read three

1. [Product overview](01-product-overview.md) — the what and why
2. [Architecture](02-architecture.md) — the how
3. [Safety & ethics](11-safety-and-ethics.md) — the constraints that are not negotiable
