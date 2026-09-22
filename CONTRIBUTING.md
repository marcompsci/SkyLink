# Contributing to SkyLink

Thanks for looking. This repo is at **specification stage** — there is no application
code yet. Right now the most valuable contributions are review, corrections, and guide
content.

## Before you start

1. Read [docs/01](docs/01-product-overview.md) and [docs/13](docs/13-roadmap.md). Fifteen
   minutes.
2. Read [docs/12](docs/12-safety-and-ethics.md) before touching anything agent-related
   or content-related. It is a build requirement, not boilerplate.
3. Open an issue before a large PR so we can agree on the shape first.

## Where help is most needed

| Area | Who | Why |
| --- | --- | --- |
| **Guide content** | Anyone who knows cars | The real bottleneck. See the [guide content issue template](.github/ISSUE_TEMPLATE/guide-content.md). |
| **Diagrams** | Illustrators | Layered SVG per [docs/05](docs/05-guides-and-diagrams.md). The diagrams are the product. |
| **iOS** | Swift | `GuideRenderer` and `DiagramKit` first — the hardest UI in the app |
| **Backend** | Node / Python | Schema, entitlements, agent tool layer |
| **Accessibility review** | Anyone who uses AT | We claim a lot in [docs/03](docs/03-navigation.md). Hold us to it. |

## Rules of the road

- **The spec and the code stay in sync.** A PR that changes behavior updates the
  relevant `docs/` file in the same PR.
- **Non-negotiables are listed in the [README](README.md#non-negotiables).** If you
  think one is wrong, open an issue arguing for it. Don't change it quietly in a diff.
- **No tier check may appear in the SOS code path.** See
  [ADR 0002](docs/adr/0002-sos-is-never-metered.md).
- **Agent prompt changes** (`/agents/*.md`) are reviewed changes. The safety kernel
  requires two approvals.
- **Never commit a real torque spec, capacity, or part number without its source.**
  Every factual automotive value carries a citation.
- **No secrets, ever.** Environment variables are documented by name only.

## Decisions

Significant architectural choices go in [`docs/adr/`](docs/adr/) as a short record:
context, decision, why, consequences. Copy the shape of an existing one.

## Commit messages

Plain and descriptive. Prefix with the area: `docs:`, `schema:`, `agents:`, `ios:`,
`api:`, `design:`.

## Code of conduct

Be decent. This project exists so that someone with no money, no tools, and no uncle
who's good with cars gets the same answer as everyone else. Act like that matters.
