<div align="center">

# SkyLink

**A mechanic in your pocket, and a companion on your screen.**

An iOS platform carrying two products on one shared spine: a voice-first AI that walks
complete beginners through car maintenance and roadside emergencies with labeled
diagrams, and a screen-aware accessibility assistant.

`Status: specification — v0.1` · `Platform: iOS` · `No code yet`

</div>

---

## What this repository is

This repo currently holds **the specification**, not an implementation. It is the
reference a developer picks up to understand what SkyLink is, how it is meant to be
built, and where to start. Code lands here as the MVP is built.

If you are reading this to decide whether to help: start with
[docs/01-product-overview.md](docs/01-product-overview.md), then
[docs/13-roadmap.md](docs/13-roadmap.md). Fifteen minutes gets you the whole picture.

## The two products

| Product | What it does | Persona |
| --- | --- | --- |
| **SkyLink Auto** | Voice-first AI mechanic. Maintenance guides with labeled diagrams, OBD-II diagnostics, roadside SOS. Built for someone who has never opened a hood. | Sky |
| **SkyLink Companion** | Screen-aware accessibility assistant. Reads the screen aloud, describes photos like a friend, navigates apps by voice. | Halo |

They share one account, one backend, one voice stack, and one permission model.
SkyLink Auto ships first.

## The core bet

Every answer a beginner needs about their car already exists online. It is scattered
across forums, PDFs, and 14-minute videos where the useful part starts at 9:20. The
problem is not information, it is **interface**. SkyLink collapses "what is that noise
and am I in danger" into one spoken question and one correct, illustrated answer.

## Repository layout

```
SkyLink/
├── README.md               ← you are here
├── CONTRIBUTING.md         how to work in this repo
├── docs/                   the specification, one file per section
│   ├── 01-product-overview.md
│   ├── 02-architecture.md
│   ├── 03-navigation.md
│   ├── 04-category-tree.md
│   ├── 05-guides-and-diagrams.md
│   ├── 06-roadside-sos.md
│   ├── 07-obd-ii.md
│   ├── 08-ai-agents.md
│   ├── 09-companion.md
│   ├── 10-pricing.md
│   ├── 11-brand.md
│   ├── 12-safety-and-ethics.md
│   ├── 13-roadmap.md
│   └── adr/                architecture decision records
├── spec/                   the whole spec as one file, for reading or feeding to an LLM
├── agents/                 agent system prompts, one per file, ready to load
├── schema/                 database schema and seed data
├── design/                 brand tokens and diagram standards
├── ios/                    Swift sources — widget extension + shared layer
└── .github/                issue and PR templates
```

## Start here, in this order

1. **[Product overview](docs/01-product-overview.md)** — what it is and who it is for.
2. **[Architecture](docs/02-architecture.md)** — system diagram, iOS module layout, backend split, database schema.
3. **[Roadmap](docs/13-roadmap.md)** — the MVP cut and what to build first.
4. **[Safety & ethics](docs/12-safety-and-ethics.md)** — read before writing a single line of agent or guide code. It is a build requirement, not boilerplate.

## Non-negotiables

These are decided. Please do not quietly change them in a PR.

- **Roadside SOS is free on every tier, forever, and works offline.** Metering someone
  stranded on a shoulder is indefensible.
- **The agent never invents a torque spec, fluid capacity, part number, or service
  interval.** Cited source or an honest "I don't have that."
- **The agent refuses to walk untrained users through the hard-stop list** (airbags,
  high-voltage EV, fuel under pressure, brake hydraulics, spring compression, lifting
  without stands). See [docs/12](docs/12-safety-and-ethics.md).
- **Every step that names a part shows that part, highlighted.** Text-only steps are
  useless to a beginner.
- **Severity is never communicated by color alone.** Icon and word, always.
- **Metering is enforced server-side.** The client never decides what counts.

## The hard part

It is not the AI and it is not the app. It is **content**. Twenty-five genuinely good
illustrated guides, each vehicle-accurate, is weeks of work by someone who knows cars
and someone who can draw. An app with a brilliant agent and no diagrams is a chatbot,
and there are plenty of those.

If you want to help and you know cars, [guide content](.github/ISSUE_TEMPLATE/guide-content.md)
is where you are most useful.

## Code

[`ios/`](ios/) holds the widget extension and the shared model layer it reads
from — the first slice of real code. It has not been compiled yet; see
[`ios/README.md`](ios/README.md) for Xcode setup.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Short version: open an issue before a large PR,
keep the spec and the code in sync, and read the safety section first.

## Status of this spec

`v0.1` — first complete draft. Open questions are tracked at the end of
[docs/13-roadmap.md](docs/13-roadmap.md).
