# 9. SkyLink Companion

[← AI agents](08-ai-agents.md) · [Index](README.md) · Next: [Pricing →](10-pricing.md)

The accessibility product, carried over from the HaloFlow spec and rebuilt on the shared
spine.

## Principles

- Accessibility is first-class, not a settings screen.
- Narration is human, not robotic. It describes; it does not enumerate.
- No screen control without explicit permission, every time the scope widens.

## Screen-takeover assistant

Reads the screen aloud in natural sentences. Describes photos the way a friend would,
not as an alt-text generator: who is in it, where it looks like, what is happening, what
the mood of it is. Navigates apps on spoken instruction. Announces incoming calls,
texts, and notifications with the tone of the message, not just its words.

## Who it serves

| Group | What Companion does |
| --- | --- |
| Blind and low-vision | Full photo description, tone-aware message reading, real-time announcements |
| Limited mobility | Complete hands-free navigation; every action reachable by voice |
| Neurodivergent | Reduced cognitive load mode: fewer elements, one thing at a time, no timed interactions |
| Situationally limited | Driving, cooking, carrying a child, or under a car |

## Architecture

Companion uses `ScreenCaptureService` (ReplayKit broadcast extension),
`VisionInterpreter`, `VoiceIO`, `AgentEngine`, and `PrivacyManager` from the shared
layer. The Halo persona and the overlay guidance view are the only Companion-specific
pieces above the spine.

## Permission flow

Four states, and the user can see and revoke the current one at any moment:

1. **Off** — nothing captured.
2. **Ask each time** — Halo requests a look at the screen and waits.
3. **Session** — granted until the user says stop or the app backgrounds.
4. **Always for this app** — scoped to named apps only, never blanket.

Halo announces what it is about to do before doing it, and stops instantly on "stop."
Screen content is processed for the turn and not retained unless the user asks to save
something.

## Onboarding

Four flows, carried from the HaloFlow spec: welcome and identity, permissions setup,
meet your companion, and a first task the user actually completes so the thing proves
itself in the first two minutes.

## Where the two products meet

Companion is how a blind user runs SkyLink Auto. The diagram long-descriptions written
for the guide library are exactly what Halo reads aloud. A user who cannot see the
dashboard can point the camera at it and be told which light is lit and what it means.
Neither product needed a special case for this; it falls out of sharing the spine.
