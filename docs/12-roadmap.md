# 12. The Road to 1.0

[← Safety & ethics](11-safety-and-ethics.md) · [Index](README.md) · Next: [Parts Finder →](13-parts-finder.md)

**Status: M0 written, not yet compiled.** The app target exists, the shell runs the
Garage, the drawer and the SOS flow, and `xcodegen generate` builds the project in one
command. Nothing has been through a compiler and nobody outside this repo has used it. Progress is measured from here in *people who used it*,
not in features specified.

## What "done" means

1.0 is done when **a stranger can download it, get a real answer about their own car,
and come back.** Not when the category tree is full.

| Milestone | Definition of done |
| --- | --- |
| **M0 — It runs** | App builds, widget renders on a real phone |
| **M1 — It answers** | 3 complete illustrated guides; a beginner finishes one unaided |
| **M2 — It helps when it matters** | Roadside SOS works end to end, offline, on a real shoulder |
| **M3 — It's in hands** | 20 TestFlight users, 10 of them drivers |
| **M4 — It's trusted** | A licensed mechanic has reviewed and signed the content |
| **M5 — 1.0** | App Store, Free + Garage tiers, 25 guides |

## M0 — It runs

- [x] Xcode project via `xcodegen generate`, iOS 17 target, App Group on both targets
- [x] App shell: Garage home, category drawer, SOS flow, service log
- [x] `skylink://sos` deep link routing — SOS replaces the stack, nothing sits between
      a stranded user and triage
- [x] Auto on screen, blinking, in the Ask bar
- [ ] **Compiles and runs on a device** — the only box that counts

Everything above is written and unverified. Expect a handful of fixes on first build;
that is the point of building it. See [`ios/BUILD.md`](../ios/BUILD.md).

No networking, no agent, no OBD, no onboarding. Guides and Ask Auto show an honest
"Not built yet" screen rather than a fake one.

## M1 — It answers (2 weeks)

- [ ] **Three** guides, complete and illustrated, for **one** vehicle:
      oil & filter change · jump-start a dead battery · change a flat to the spare
- [ ] Guide renderer with the step anatomy from [section 5](05-guides-and-diagrams.md)
- [ ] DiagramKit: layered SVG, one highlighted part per step, pinch-zoom
- [ ] Written long-description on every diagram
- [ ] **The test:** 5 people who have never done the job try it. Count how many finish.

Three guides done properly beats twenty-five stubs. If people can't finish one guide,
more guides will not fix it.

## M2 — It helps when it matters (1 week)

- [ ] Triage tree, safety script, location capture — all offline
- [ ] Low-battery mode (black, 28pt, voice-first)
- [ ] Saved coverage numbers (AAA, insurance, manufacturer) shown before any paid option
- [ ] No entitlement check anywhere in the path — enforce in review
- [ ] **The test:** run it in a parking lot at night with the phone at 10%

## M3 — It's in hands (2 weeks)

- [ ] TestFlight build
- [ ] 20 testers, at least 10 rideshare or delivery drivers
- [ ] One feedback question in-app: "did this answer your question?" yes/no + free text
- [ ] **The metric that matters:** how many open it a second time, unprompted

## M4 — It's trusted (parallel, start now)

- [ ] A licensed mechanic reviewing guide content, named in the app
- [ ] LLC formed, liability waiver drafted, insurance quoted
- [ ] One paid hour with a lawyer on the hard-stop list in [section 11](11-safety-and-ethics.md)

This runs alongside everything above and gates public release, not TestFlight.

## M5 — 1.0

- [ ] 25 guides across the top categories
- [ ] Free + Garage tiers live, StoreKit 2, server-side verification
- [ ] Ask Sky with the agent layer from [section 8](08-ai-agents.md)
- [ ] App Store submission

## After 1.0

| Release | What lands | Why then |
| --- | --- | --- |
| v1.1 | OBD-II pairing, code reading, live data | Strongest differentiator; needs real users to tune |
| v1.2 | Parts Finder, run by hand first | Needs partner price feeds signed ([section 13](13-parts-finder.md)) |
| v1.3 | Photo diagnosis, library to ~150 guides | Content scales once the pipeline works |
| v2.0 | Industry tier, fleet view, shop seats | Sell to shops once the consumer product is proven |
| v2.1 | Android | After iOS economics are known |

## The real risk

It is not the AI and it is not the app. It is **content**, and second to that, **focus**.
Three illustrated guides is weeks of work for one person. Start that now, in parallel
with M0 — not after.

## Open questions

- [ ] Who authors and reviews guide content — a hired mechanic, a partnership, or
      licensed data?
- [ ] Is the real job-to-be-done instruction, or anti-overcharge decision support?
      Twenty driver conversations answer this, and it may redraw sections 1 and 5.
- [ ] Which roadside-assistance API partner, and what are the economics?
- [ ] Does SkyLink take affiliate revenue on parts? If so it must be disclosed, and the
      ranking must stay honest.
- [ ] Final pricing — the numbers in [section 9](09-pricing.md) are a recommendation.
