# 1. Product Overview

[← Index](README.md) · Next: [Architecture →](02-architecture.md)

SkyLink is one platform carrying two products on a shared spine.

**SkyLink Auto** — a mechanic in your pocket. A voice-first AI that walks a complete
beginner through car maintenance and roadside emergencies using labeled diagrams and
numbered steps. It assumes the user has never opened a hood, and may be standing on a
shoulder in the dark right now.

**SkyLink Companion** — a screen-aware, voice-first accessibility assistant. Reads the
screen aloud, describes photos like a friend would, navigates apps by voice, announces
calls and texts with tone.

## Why one platform

Both products need the same three things: a hands-free voice loop, an AI agent that can
see what the user sees, and a permission model the user trusts. Build that spine once.
Two app surfaces, two stories to market, one account and one backend.

The audiences also overlap more than they look. A blind driver's passenger still needs
the dashboard light explained. A user with limited mobility stranded on a shoulder needs
dispatch, not a jack. SkyLink Auto in voice mode is an accessibility product whether or
not it is sold as one.

## Who SkyLink Auto is for

| Segment | What they need | Likely tier |
| --- | --- | --- |
| Knows nothing about cars | Plain language, diagrams, "is this safe for me to do?" | Free → Garage |
| Weekend DIYer | Torque specs, job sequence, part numbers | Garage |
| Rideshare / delivery driver | Uptime — fast triage, cheap fixes, no shop downtime | Garage |
| Independent shop or fleet | Multi-vehicle records, unlimited diagnostics, no ceiling | Industry |

## The core bet

Every answer a beginner needs about their car already exists online. It is scattered
across forums, PDFs, and 14-minute videos where the useful part starts at 9:20. The
problem is not information, it is interface. SkyLink collapses "what is that noise and
am I in danger" into one spoken question and one correct, illustrated answer.

## What makes it different

- **Voice-first, not voice bolted on.** Hands dirty, hands on a lug wrench, or eyes that
  cannot read the screen. The whole flow works spoken.
- **Diagrams are the product.** Text steps are useless to someone who does not know what
  a serpentine belt looks like. Every step that names a part shows that part, highlighted.
- **It reads the car, not just the driver.** OBD-II codes arrive as structured data, so
  the agent diagnoses from the car's own signal instead of "it's making a weird sound."
- **It knows when to stop.** The agent refuses jobs that are unsafe for an untrained
  person and routes to a professional. That refusal is what makes the rest trustworthy.

## Naming

- Platform: **SkyLink** · shared account: **SkyLink ID**
- Auto product: **SkyLink Auto**, agent persona **Sky**
- Accessibility product: **SkyLink Companion**, agent persona **Halo**
