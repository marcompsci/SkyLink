# ADR 0004 — SkyLink is a car app only

**Status:** Accepted · **Date:** 2026-10-14
**Supersedes:** [ADR 0001](0001-two-products-one-platform.md), [ADR 0003](0003-mindflow-inside-ask-sky.md)

## Context

SkyLink began as an accessibility assistant (the HaloFlow spec), became a car app, then
absorbed two more products inside three weeks:

- **SkyLink Companion** — a screen-aware voice assistant (ADR 0001)
- **MindFlow** — personal tracking for habits, spending, health, goals, and calendar,
  with widgets and a voice assistant (ADR 0003)

Both already existed elsewhere in the same portfolio. MindFlow is the same product as
**Cadence** (Phoronomics' first product) and **Morning HUD** — a live personal dashboard
with home-screen widgets, lanes for money and habits, and a voice assistant. Companion
is the same product as **Echo**, an iOS screen-aware assistant.

So the same two ideas had been specified three and two times respectively, under
different names, and SkyLink was carrying copies of both. Meanwhile the car app had
fifteen spec sections, zero compiled code, and zero users.

## Decision

**SkyLink is a voice-first AI car assistant. Nothing else.**

Removed from this repo entirely:

- `docs/09-companion.md`, `agents/companion.md`
- `docs/14-mindflow.md`, `agents/mindflow.md`
- The habits widget, habit models, and habit App Intents under `ios/`
- MindFlow tables in `schema/schema.sql` and the MindFlow palette in `design/tokens.json`

Sections renumbered to a contiguous 1–13.

## Why

A shared "spine" is an engineering convenience, not a user need. No one wants a car app
that tracks their habits. The spine was the mechanism by which scope grew: it made every
unrelated idea feel adjacent and cheap.

The cost of carrying both was concrete. Every spec section, every design decision, and
every hour went three ways instead of one, on a project with no users and a single
part-time builder.

## Consequences

- Accessibility stays, as *how the app is operated* — VoiceOver, full voice control,
  diagram long-descriptions — not as a second product. This is a real reduction in
  ambition and it is accepted deliberately.
- MindFlow's content belongs to Cadence; Companion's belongs to Echo. Neither is lost:
  both live in this repo's git history at commit `b9444f1` and can be lifted from there.
- The widget story is now the vehicle widget plus the SOS deep link. Coherent for a car
  app, smaller than what was drawn.
- ADRs 0001 and 0003 stay in place as the record of what was decided and reversed. Do
  not delete them.

## What would reverse this

Evidence from real users that they want personal tracking *inside* a car app. Not a
hunch that it would be neat.
