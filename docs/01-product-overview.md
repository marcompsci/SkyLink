# 1. Product Overview

[Index](README.md) · Next: [Architecture →](02-architecture.md)

**SkyLink is a voice-first AI car assistant for iPhone — a mechanic in your pocket.**

It walks someone who has never opened a hood through car maintenance and roadside
emergencies, using labeled diagrams and one short instruction at a time. It reads the
car's own fault codes. It finds the part you need at the cheapest nearby store. And it
refuses the jobs that are genuinely unsafe for an untrained person instead of walking
them into one.

That is the whole product. It is not a platform.

## Who it's for

The wedge is **drivers whose income depends on the car running**: rideshare and
delivery drivers, trades, anyone for whom a day in the shop is a day unpaid. They are
cost-obsessed by necessity, they measure downtime in lost wages, and they talk to each
other constantly.

| Segment | What they need | Likely tier |
| --- | --- | --- |
| **Rideshare / delivery driver** (wedge) | Uptime. Fast triage, cheap fixes, no shop downtime | Garage |
| Knows nothing about cars | Plain language, diagrams, "is this safe for me to do?" | Free → Garage |
| Weekend DIYer | Torque specs, job sequence, part numbers | Garage |
| Small fleet / independent shop | Multi-vehicle records, unlimited diagnostics | Industry |

"Everyone with a car" is not a market. Start with the people who lose money when the
car stops.

## The core bet

Every answer a beginner needs already exists online, scattered across forums, PDFs, and
14-minute videos where the useful part starts at 9:20. The problem is not information,
it is interface.

But the sharper version of the bet, and the one worth testing first: **most people don't
want to become mechanics — they want to stop being overcharged.** "Is $600 fair for
this?" and "can I drive it home?" are asked far more often than "how do I replace it."
Decision support may be the product and instruction the supporting act. Section 12 says
how to find out.

## What makes it different

- **Voice-first, not voice bolted on.** Hands dirty, or on a lug wrench, or eyes that
  can't read the screen. The whole flow works spoken.
- **Diagrams are the product.** Text steps are useless to someone who doesn't know what
  a serpentine belt looks like. Every step that names a part shows that part,
  highlighted.
- **It reads the car, not just the driver.** OBD-II codes arrive as structured data, so
  the agent diagnoses from the car's own signal.
- **It knows when to stop.** The refusals in [section 11](11-safety-and-ethics.md) are
  what make the rest trustworthy.
- **Roadside SOS is free forever, offline, and never metered.** Nothing else in the
  category does this.

## Naming

- App: **SkyLink** · agent persona: **Sky** · account: **SkyLink ID**

## What SkyLink is not

Two things were specified here and have been cut — see
[ADR 0004](adr/0004-scope-cut-car-app-only.md):

- **No personal tracking.** Habits, spending, goals, and calendar belong to Cadence.
- **No general screen-reading assistant.** That is Echo.

Accessibility stays, but as *how this app is operated* — full VoiceOver support, voice
control of every screen, and a written long-description on every diagram — not as a
second product.
