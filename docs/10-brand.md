# 10. Brand System

[← Pricing](09-pricing.md) · [Index](README.md) · Next: [Safety & ethics →](11-safety-and-ethics.md)

Machine-readable tokens: [`/design/tokens.json`](../design/tokens.json).

## Name and mark

**SkyLink.** The link is the point: between a driver and a mechanic's knowledge,
between a phone and a car's computer, between someone stranded and someone who can
help.

Mark: a single unbroken link form that also reads as a road curving to a horizon. Clean,
geometric, legible at 20pt on a dashboard mount. Two lockups — mark alone for the app
icon, mark plus wordmark for everything else. No sub-brands: there is one product.

## Palette — pocket garage

The feel is a tool chest, not a dashboard: deep charcoal, chrome, hazard stripes, and
one hot accent that carries every action. Dark-first, because this gets used in engine
bays, parking garages, and on shoulders at night.

| Token | Hex | Use |
| --- | --- | --- |
| Garage Black | `#121419` | Ground |
| Steel | `#1C2028` | Cards, raised surfaces |
| Chrome | `#DDE3EA` | Primary text, diagram line work |
| **Torque Orange** | `#FF6B2C` | Primary action, Auto's accent — the hot one |
| **Shop Yellow** | `#FFC53D` | Hazard stripes, caution, "get it checked soon" |
| Oil Teal | `#19C3B2` | Secondary action, "safe to drive", completed steps |
| Stop Red | `#E8402A` | SOS, "stop driving now" |
| Safe Green | `#3ECF8E` | Confirmations, passed checks |
| Grease | `#6B7480` | Secondary text, dimmed diagram layers |

**The hazard stripe** — 45 degrees, Shop Yellow on Garage Black — is the signature
motif. It appears as a thin band at the top of a screen and around the SOS button, and
nowhere else. Used sparingly it reads as a workshop; used everywhere it reads as a
construction site.

**Torque Orange is the only primary action colour.** If two things on a screen are
orange, one of them is wrong.

Severity colour is never the only signal. Every state carries an icon and a word, and
Auto's face is the fourth channel — see [section 14](14-auto-the-mechanic.md).

### Type

Archivo for everything: Archivo Black weights for display, Archivo Narrow for the
small-caps labels and data. It is a grotesque with industrial bones — closer to a shop
sign than a tech startup.

## Typography

Archivo for the wordmark and display. In-app, SF Pro (system) wherever Dynamic Type
must scale cleanly at accessibility sizes. Step instructions set at a minimum of 20pt, and SOS text at
28pt minimum. Tabular figures for torque specs, capacities, and pressures.

## Illustration style for diagrams

This matters more than the logo, because the diagrams are what the product actually is.

- **Technical-clean line art**, not photorealism and not cartoon. Think a well-drawn
  service manual, redrawn for a phone.
- **Two-weight line system.** Heavy outline on the part in focus, light outline on
  everything else.
- **One accent color per diagram** (Signal Teal) for the part currently under
  discussion. Everything else is greyscale. Attention is the whole job.
- **Labels outside the art** with leader lines, so they never cover the thing they name.
- **Consistent viewpoint** across a category: every engine-bay diagram drawn from the
  same standing position, so the user builds a mental map instead of re-orienting each
  time.
- **Hand for scale** where size matters, and a visible orientation marker on every
  diagram.

## Voice and tone

Calm, direct, competent. The tone of a good mechanic who is not trying to sell you
anything.

- Never condescending. Not knowing how a car works is the normal condition, not a
  deficiency.
- Never alarmist, but never soft about real danger either. "Stop driving" means stop
  driving.
- Never salesy inside a task. The paywall is honest and appears at boundaries, never
  mid-repair and never in SOS.
- Short sentences. Plain words. Specifics over adjectives.

## Founder note

> Everyone has a car. Almost nobody has someone to ask about it. That's not a knowledge
> problem, it's an access problem. SkyLink is built so that the person with no money, no
> tools, and no uncle who's good with cars gets the same answer as everyone else.
