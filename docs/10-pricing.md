# 10. Pricing & Entitlements

[← Companion](09-companion.md) · [Index](README.md) · Next: [Brand →](11-brand.md)

Three tiers. Prices below are a recommendation, not a decision.

| | **Free** | **Garage** | **Industry** |
| --- | --- | --- | --- |
| Price | $0 | $9.99 / mo | $39.99 / mo |
| Annual | — | $79 (save 34%) | $349 (save 27%) |
| AI searches | 20 total | 150 / month | Unlimited |
| Vehicles | 1 | 3 | Unlimited |
| Guide library | Preview — ~15 starter guides | Full library | Full library |
| Diagrams | Generic only | Vehicle-specific | Vehicle-specific + exploded views |
| Roadside SOS | **Full access** | **Full access** | **Full access** |
| OBD-II code read | Yes | Yes | Yes |
| Live OBD data | No | Yes | Yes |
| Scan history | Last 1 | Unlimited | Unlimited + fleet trends |
| Service history log | No | Yes | Yes + export |
| Offline guide cache | 3 guides | 30 days of opened guides | Everything |
| Voice mode | Yes | Yes | Yes |
| Photo diagnosis | 3 total | Unlimited | Unlimited |
| Web-search fallback | No | Yes | Yes |
| Human escalation | No | No | Yes |
| Multi-user / shop seats | No | No | Up to 10 |
| Future updates | Core only | Core only | Everything, included |

## Two things that are free forever

**Roadside SOS**, on every tier, with no meter. Someone stranded on a shoulder must
never see a paywall. It is also the best marketing the app will ever have.

**Reading a check-engine code.** The scan and the plain-language explanation are free.
What the meter counts is the open-ended conversation about it.

## What counts as an "AI search"

One metered unit = one question answered by an agent, including all its tool calls and
follow-up turns within that thread for 10 minutes. Asking three clarifying questions
about the same problem is one search, not four — anything else punishes exactly the
beginner this app is for.

**Not metered:** browsing categories, opening a guide, stepping through a guide, reading
a stored code, roadside SOS in any form, and anything the agent got wrong (a thumbs-down
refunds the search).

The meter is enforced server-side on `agent_turns.metered`. Free tier's 20 are lifetime,
not monthly, and the count is always visible: "14 of 20 left" in the header, never a
surprise.

## The upgrade moments

Four places where a free user hits the wall and the upgrade is obviously worth it,
designed rather than accidental:

1. **The 5th search.** A banner, not a block: "15 left. Garage gives you 150 a month."
2. **A vehicle-specific diagram.** Free shows the generic version with the specific one
   blurred behind an upgrade tap. This is the single strongest converter — the value gap
   is visible in one glance.
3. **The second car.** Adding a spouse's or kid's car.
4. **The last search.** Full-screen, honest: "That was your last free search. You've
   asked about your Civic 20 times — Garage is $9.99."

## Billing notes

Apple in-app purchase with StoreKit 2 (Apple takes 15–30%; price accordingly).
Subscription state is verified server-side via App Store Server Notifications, never
trusted from the client. Seven-day free trial on Garage. Industry offers annual
invoicing for shops that will not put a business subscription on a personal Apple ID.
