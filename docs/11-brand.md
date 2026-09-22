# 11. Brand System

[← Pricing](10-pricing.md) · [Index](README.md) · Next: [Safety & ethics →](12-safety-and-ethics.md)

Machine-readable tokens: [`/design/tokens.json`](../design/tokens.json).

## Name and mark

**SkyLink.** The link is the point: between a driver and a mechanic's knowledge,
between a phone and a car's computer, between someone stranded and someone who can
help.

Mark: a single unbroken link form that also reads as a road curving to a horizon. Clean,
geometric, legible at 20pt on a dashboard mount. Two lockups — mark alone for the app
icon, mark plus wordmark for everything else. Sub-brands are the wordmark plus a
lighter-weight "Auto" or "Companion."

## Palette

Carried from the HaloFlow palette, extended for the states a car app needs.

| Token | Hex | Use |
| --- | --- | --- |
| Signal Teal | `#3CE0C9` | Primary action, active state, brand accent |
| Midnight | `#0A0F1A` | Dark-mode ground, text on light |
| Silver | `#DDE5E8` | Light-mode ground, dividers, dimmed diagram layers |
| Coral | `#FF7A6A` | Warnings, "get it checked soon" |
| Stop Red | `#E03C3C` | SOS button, "stop driving now" |
| Caution Amber | `#F2B138` | "Don't drive far", pending codes |
| Safe Green | `#3CCB7F` | "Safe to drive", completed steps |

Dark mode is the default. People use this app in engine bays, in parking garages, and on
shoulders at night, and a white screen at 2am is hostile.

Severity color is never the only signal. Every state carries an icon and a word.

## Typography

Geometric sans for the wordmark. In-app, SF Pro (system) so Dynamic Type works properly
at every accessibility size. Step instructions set at a minimum of 20pt, and SOS text at
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
