# 13. Build Roadmap

[← Safety & ethics](12-safety-and-ethics.md) · [Index](README.md)

Build SkyLink Auto first. It is the sharper product, the clearer market, and the faster
path to revenue. Companion follows once the spine is proven.

## MVP — one product, one promise

The promise: *ask a question about your car, get a correct illustrated answer.*
Everything not serving that is cut.

**In scope:**

- iOS only. One vehicle per user.
- Home, drawer, category browse, guide renderer, Ask Sky.
- **25 guides**, not 200. The most-searched jobs: oil, battery, flat tire, wipers, brake
  noise, dead start, overheating, coolant, air filter, jump start, tire pressure,
  warning lights.
- **Every one of those 25 fully illustrated.** Depth over breadth. A beautiful guide
  with a great diagram beats fifty text stubs, and the diagrams are the moat.
- Mechanic agent with the guide-retrieval and diagram tools.
- Roadside SOS — the full flow. Free, offline-capable. This ships in the MVP because it
  is the reason people download and the reason they tell someone else.
- Free and Garage tiers.

**Out of scope for MVP:** OBD-II, Companion, Android, photo diagnosis, dispatch
integration (SOS shows saved numbers and 911 instead), Industry tier.

## After MVP

| Release | What lands | Why then |
| --- | --- | --- |
| v1.1 | OBD-II pairing, code reading, live data | The strongest differentiator; needs real users to tune |
| v1.2 | Dispatch partner integration | Requires partner contracts and volume to negotiate |
| v1.3 | Photo diagnosis, guide library to ~150 | Content scales once the ingestion pipeline works |
| v1.4 | Parts Finder + map (MapKit), hardware-store coverage | Needs partner price feeds signed first |
| v2.0 | Industry tier, multi-vehicle fleet, shop seats | Sell to shops only once the consumer product is proven |
| v2.1 | SkyLink Companion | The accessibility product on the proven spine |
| v2.2 | Android | After iOS economics are known |

## What to hand a developer first

In this order:

1. **The data model** — [section 2](02-architecture.md)'s schema. Everything else
   depends on the shape of `guides`, `guide_steps`, `diagrams`, and `vehicle_fitment`.
2. **The guide renderer and DiagramKit** — the hardest UI in the app and the thing the
   whole product is judged on. Build it against two hand-authored guides before writing
   any content pipeline.
3. **The agent layer** — [section 8](08-ai-agents.md)'s prompts and the shared tool
   definitions.
4. **Entitlements and the meter** — server-side from day one; retrofitting metering is
   painful.
5. **SOS** — last to build, but it must be in the first ship.

## The real risk

It is not the AI and it is not the app. It is **content**. Twenty-five genuinely good
illustrated guides, each vehicle-accurate, is weeks of work by someone who knows cars
and someone who can draw. Start that in parallel with engineering on day one, not after.
An app with a brilliant agent and no diagrams is a chatbot, and there are plenty of
those.

## Open questions

- [ ] Who authors and reviews the guide content — a hired mechanic, a partnership, or
      licensed data?
- [ ] Which roadside-assistance API partner, and what do the economics look like?
- [ ] Does the Industry tier get sold self-serve, or does it need a sales motion?
- [ ] Is SkyLink Link (branded dongle) a v1.1 bundle or a separate hardware effort?
- [ ] Final pricing — the numbers in [section 10](10-pricing.md) are a recommendation.
