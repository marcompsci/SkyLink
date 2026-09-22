# 12. Safety, Liability & Ethics

[← Brand](11-brand.md) · [Index](README.md) · Next: [Roadmap →](13-roadmap.md)

> **Read this before writing agent or guide code.** An app that tells people how to work
> on brakes carries real risk. This section is a build requirement, not boilerplate.

## The hard-stop list

The agent never walks an untrained user through:

- Airbag or SRS components
- High-voltage hybrid or EV systems (orange cables)
- Fuel system work under pressure
- Brake hydraulic line or master cylinder replacement
- Suspension spring compression
- Anything requiring the car to be lifted without jack stands
- Steering component removal
- Welding, cutting, or anything involving fuel and heat together

For each of these the app still gives a guide — what is wrong, why it is dangerous, what
a shop will do, and the rough cost range. Informed, not abandoned.

## Forced escalation

The agent stops and says "call a professional" when the user describes brake failure or
a sinking pedal, steering loss or a heavy pull, smoke or a burning smell, fuel smell, a
flashing check-engine light, overheating that returns after cooling, or any airbag or
SRS light. These are pattern-matched on the user's own words before any diagnosis
begins.

## Data accuracy

| Data type | Source of truth | If unavailable |
| --- | --- | --- |
| Torque specs | Fitment database, cited | Say so, point to the manual |
| Fluid capacities & types | Fitment database, cited | Point to the cap or manual |
| Part numbers | Fitment database | Point to the parts counter with the VIN |
| Service intervals | Manufacturer schedule | Point to the manual |
| Repair costs | Regional averages, given as a range | Say costs vary |

Never generated, never estimated, never inferred from a similar model. A wrong torque
spec strips a bolt or drops a wheel.

## Disclaimers that actually work

One clear disclaimer at onboarding, in plain language, that the user reads once and
understands: SkyLink gives information and guidance, not a professional inspection; the
user is responsible for deciding what they attempt; if anything feels wrong or beyond
them, stop and call a mechanic.

Then job-specific safety gates at the point of risk, where they are actually read —
rather than a wall of legal text nobody sees. Legal counsel should review the terms, the
safety gates, and the dispatch partner agreements before launch.

## Privacy

- **Location** is captured for SOS and dispatch only, never tracked in the background,
  and deleted after the incident unless the user saves it.
- **Vehicle data** including the VIN belongs to the user, is exportable, and is never
  sold or shared with insurers, lenders, or advertisers. Write that commitment into the
  privacy policy — it is a real and valuable line to hold, and competitors will not hold
  it.
- **Screen capture** in Companion is processed per turn and not retained.
- **Photos** are processed and discarded unless attached to a saved service record.
- **Conversations** are retained for the user's history and deleted on request.

## Ethics charter

- No hacking, bypassing security, or defeating immobilizers, anti-theft, or odometers.
- No scraping private data; no unauthorized payments.
- Defensive security only.
- No guidance that defeats an emissions control or safety system.
- Humanitarian bias: the free tier must be genuinely useful, and safety features are
  never metered.
- Transparency: cite sources, mark AI-generated diagrams, never present a guess as a
  fact.
- No dark patterns in the paywall. No fake urgency, no hidden cancellation.
- No upselling repairs. The app has no financial interest in the user needing work done,
  and that independence is the whole basis of its credibility.
