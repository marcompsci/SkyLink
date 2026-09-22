# ADR 0002 — Roadside SOS is free on every tier, forever

**Status:** Accepted · **Date:** 2026-09-18

## Context

SkyLink is a subscription product with three tiers and a metered AI search count. The
roadside emergency flow is one of the most valuable features and an obvious candidate
for the paid tier.

## Decision

Roadside SOS — the full flow, including AI-guided walkthroughs and dispatch — is free on
every tier, is never metered, and works offline.

## Why

Charging someone stranded on a highway shoulder at night is indefensible, and a single
story about a paywall appearing in that moment would end the product. It is also the
strongest acquisition channel the app has: people install it because of SOS and tell
others because of SOS.

## Consequences

- SOS costs money to run and produces no direct revenue. Budget for it.
- The offline cache and the low-battery mode are required, not optional.
- No tier check may appear anywhere in the SOS code path. This is enforced in review.
