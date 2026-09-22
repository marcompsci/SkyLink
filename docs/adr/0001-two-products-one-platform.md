# ADR 0001 — Two products, one platform

**Status:** Accepted · **Date:** 2026-09-18

## Context

SkyLink began as two separate ideas: a screen-aware accessibility assistant (the
HaloFlow spec) and an AI car-maintenance app. They serve different audiences and would
market differently.

## Decision

Build them as two product surfaces on one shared platform: one account, one backend, one
voice stack, one agent spine, one permission model. Ship **SkyLink Auto** first;
**SkyLink Companion** follows once the spine is proven.

## Why

Both products need a hands-free voice loop, an agent that can see what the user sees,
and a permission model the user trusts. Building that twice is waste. The audiences also
overlap: a blind user still needs the dashboard light explained, and SkyLink Auto in
voice mode is an accessibility product whether or not it is sold as one.

## Consequences

- The shared layer must not take a dependency on car-specific concepts.
- Two App Store listings, two onboarding flows, one subscription ladder.
- Companion is deferred to v2.1, which is a real cost: the accessibility audience waits.
