# 15. Pocket Garage — Onboarding & the Garage

[← Auto](14-auto-the-mechanic.md) · [Index](README.md)

Research into what people actually use car apps for changed this section. Guides and SOS
are **episodic** — needed a few times a year. The features users rate highest and return
to weekly are **reminders and service history**. That is the retention loop, and the spec
didn't have it.

It also answers the fair objection that nobody subscribes to something they need three
times a year. They do subscribe to the thing that remembers for them.

## What the research said

From reviews and feature comparisons across CARFAX Car Care, FIXD, Drivvo, Simply Auto,
Fuelly, MyAutoLog and others — most-valued features first:

| Users want | SkyLink's answer |
| --- | --- |
| Reminders by **date and mileage** | Core, free tier |
| Service history covering **DIY and shop** work, itemized | Core, free tier |
| **Recall alerts** | Free — NHTSA publishes this openly |
| Fuel / charging log with cost per mile | Garage tier |
| Renewal alerts: registration, insurance, inspection | Core |
| **Resale-ready PDF** of full history | Garage tier |
| Plain-English fault codes | [Section 7](07-obd-ii.md) |
| Multi-vehicle | Garage tier |
| **No required hardware** | OBD-II is optional, always |
| Parts tracking with what each part cost | Garage tier |

And the complaints, which are mostly about pricing and polish:

- **Paywalling reminders** is the single most-cited grievance across the category.
  So reminders, history, and recalls are **free in SkyLink, permanently.** The meter
  counts AI conversations, not memory.
- **"A service log with a fuel tab bolted on"** — narrow apps that do one thing.
- **Required OBD hardware** ($20–200) as a barrier to entry.
- **Dated interfaces and learning curves.**

## Onboarding — four steps, Auto does the talking

Auto introduces himself and asks about the car. The whole thing is a conversation with a
character, not a form. Target: **under 90 seconds**, skippable at every step except the
vehicle.

### Step 1 — Auto wakes up

Auto's lamp eye comes on. "Hey — I'm Auto. I'm your mechanic. What are we working on?"

One button: **Let's go.** No account, no email, no permissions. Nothing is asked for
before the user has seen something work.

### Step 2 — What do you drive?

The only required step, because every guide, diagram, and part number is filtered by it.
Three ways in, and the user picks:

| Method | How | Speed |
| --- | --- | --- |
| **Scan the VIN** | Camera on the windshield plate or door jamb sticker; VisionKit text recognition; decode free via NHTSA vPIC | ~5 sec, exact trim |
| **Plate lookup** | State + plate | ~5 sec, where available |
| **Pick it** | Year → Make → Model → Engine, big tappable tiles | ~20 sec |

VIN scanning is the hero path: it gets the **exact engine and trim**, which is what makes
"the right guide for your car" true rather than approximate. NHTSA's vPIC VIN decoder is
free and public, so this costs nothing.

Then Auto reacts to the actual car — "2016 Civic, 1.5 turbo. Good motor. Watch the oil
level on these." A canned-but-real line per engine family. This is the moment the app
stops feeling generic.

### Step 3 — How many miles, and what do you want watched?

Odometer, typed or scanned from the dash with the camera. Then chips, multi-select:

**Oil changes · Tire rotation · Brakes · Registration · Insurance · Inspection · Recalls**

Recalls are pre-checked, because they're free, automatic, and occasionally the most
important thing the app will ever tell someone.

Auto confirms what he'll do: "I'll tell you when your oil's due — around 89,200 miles or
next March, whichever lands first."

### Step 4 — One thing that works, right now

Not a tutorial. Auto does something real before asking for anything:

> "Let me check for open recalls on your car."

Free NHTSA lookup, two seconds, real answer. Either "you're clear" or "there's one open
— here's what it is and that it's free to fix at any dealer."

**Then, and only then**, the first permission ask: notifications, so he can actually
remind you. Explained in Auto's voice before the system dialog appears. Decline and
everything still works — reminders just live in the app.

Location and camera are asked for later, at the moment they're needed, never here.

## The Garage — the home screen

"Pocket Garage" is the organizing metaphor: your car on a lift, Auto standing next to it,
everything about it in one place.

**Top:** the vehicle card — nickname, photo (user's own or a silhouette), mileage, and
Auto's one-line read on the car's state right now.

**Health strip:** four tiles with a status dot each — Oil · Tires · Brakes · Papers.
Green / amber / red, each with its icon and word. Tapping one opens what it's based on.

**Next up:** the reminder closest to due, with both numbers. "Oil change — 290 miles or
5 weeks."

**Auto's bay:** a persistent ask bar with Auto in it. Tap to talk, type, or pick a
suggested question tuned to this car's mileage.

**Service log:** reverse-chronological, DIY and shop work in one list, cost on each
entry, photo of the receipt if there is one, and a running total this year. The total is
the line people screenshot.

**Recalls:** silent when clear, loud when not.

## Reminders that actually work

The research is specific that **date-only reminders are the main failure** of existing
apps. A 5,000-mile oil change is six weeks for a delivery driver and ten months for
someone who works from home.

So every reminder carries **both**, and fires on whichever lands first:

```
Oil & filter    every 5,000 mi  or  6 months
Tire rotation   every 6,000 mi  or  6 months
Registration    annual, by date
Brake check     every 12,000 mi or 12 months
```

Mileage comes from: the user updating it, an OBD-II read when connected, or — the lazy
path that actually works — **an estimate from their own driving pattern**, confirmed with
one tap. "Looks like you're at about 86,400. Right?"

For a driver logging 300 miles a day, mileage-based reminders are the only kind that mean
anything, which is exactly the wedge audience from [section 1](01-product-overview.md).

## Tier changes this forces

[Section 9](09-pricing.md) is updated: **reminders, service history, and recalls move to
the free tier and stay there.** Paywalling them is the category's most-hated move, and
they are what makes someone open the app in a month when nothing is wrong.

What Garage buys: multiple vehicles, fuel and cost analytics, PDF export, parts tracking,
unlimited AI conversations, live OBD data.

## Open questions

- [ ] Plate-to-VIN lookup requires a paid provider in most states. Ship VIN scan +
      manual pick first?
- [ ] Mileage estimation from driving pattern needs location or motion data — worth the
      permission, or just ask?
- [ ] Does the service log need receipt OCR in 1.0, or is a photo enough?
