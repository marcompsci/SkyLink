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
| 9 | [Companion](09-companion.md) | The accessibility product |
| 10 | [Pricing](10-pricing.md) | Free / Garage / Industry, and what a "search" means |
| 11 | [Brand](11-brand.md) | Palette, type, illustration style, voice |
| 12 | [Safety & ethics](12-safety-and-ethics.md) | Hard-stop list, escalation, privacy, charter |
| 13 | [Roadmap](13-roadmap.md) | MVP cut, release order, open questions |
| 14 | [MindFlow](14-mindflow.md) | Personal tracking & voice assistant inside Ask Sky |
| 15 | [Parts Finder](15-parts-finder.md) | Cheapest parts nearby, live map, navigation |

Single-file version for reading offline or feeding to an LLM:
[`/spec/SkyLink-Master-Spec-v0.1.md`](../spec/SkyLink-Master-Spec-v0.1.md).

## Decision records

Significant architectural decisions and why they were made:
[`adr/`](adr/).

## If you only read three

1. [Product overview](01-product-overview.md) — the what and why
2. [Architecture](02-architecture.md) — the how
3. [Safety & ethics](12-safety-and-ethics.md) — the constraints that are not negotiable
