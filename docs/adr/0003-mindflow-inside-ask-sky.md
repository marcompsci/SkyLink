# ADR 0003 — MindFlow lives inside Ask Sky, not as a third app

**Status:** Accepted · **Date:** 2026-09-18

## Context

MindFlow (habits, spending, health, goals, calendar) is a personal-tracking product with
little conceptual overlap with car maintenance. It could be a third product surface.

## Decision

MindFlow is a **domain inside Ask Sky**, reached by the same voice control and handled
by a specialist agent behind the same orchestrator. It is not a separate app.

## Why

The expensive parts are already built for Auto: the voice loop, the agent spine, the
propose–approve pattern, the permission ledger, entitlements. MindFlow reuses all of
them and adds a data model and a dashboard. Splitting it out would duplicate the spine
for a third time and fragment the user's voice entry point.

## Consequences

- The orchestrator's routing surface grows; ambiguous requests ("log my walk") need
  disambiguation between a service record and a habit.
- MindFlow's warm light palette collides with Auto's dark-first one. The boundary needs
  a designed transition. See [docs/14](../14-mindflow.md).
- The vault is a MindFlow concept but sits in the shared layer, since Auto's service
  history may want it later.
