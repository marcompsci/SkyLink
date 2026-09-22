# SkyLink — iOS

Swift sources for the widget extension and the small shared layer it
depends on. **Not yet compiled.** These files were written against the
spec in [`/docs`](../docs/) and Apple's current APIs, but nothing here has
been through a build. Expect to fix a few things on first compile — that
is the point of building it.

## What's here

```
ios/
├── SkyLinkKit/          shared between app and widget extension
│   ├── Models/          Habit, VehicleStatus, DashboardSnapshot, DataFreshness
│   ├── Store/           App Group container read/write
│   └── Design/          colour tokens from /design/tokens.json
└── SkyLinkWidgets/      the widget extension
    ├── Habits/          small · large (interactive) · circular · rectangular
    ├── Vehicle/         medium · rectangular, with SOS deep link
    ├── Intents/         App Intents for widget taps and Siri
    └── Shared/          freshness stamp, vault placeholder, empty state
```

## Setup in Xcode

1. **Create the project.** New → App, SwiftUI, name it `SkyLink`. Minimum
   deployment target **iOS 17** — interactive widgets and
   `containerBackground` need it.

2. **Add the widget extension.** File → New → Target → Widget Extension,
   name it `SkyLinkWidgets`. Uncheck "Include Live Activity" for now.
   Delete the template file it generates; `SkyLinkWidgetBundle.swift`
   here replaces it.

3. **Add the App Group.** Signing & Capabilities → + Capability → App
   Groups, on **both** the app target and the widget target. Create one
   group and put its identifier in
   [`SkyLinkKit/Store/AppGroup.swift`](SkyLinkKit/Store/AppGroup.swift).
   Nothing works until these match.

4. **Set target membership.** Everything under `SkyLinkKit/` must belong
   to **both** targets. Everything under `SkyLinkWidgets/` belongs to the
   widget target only. This is the most common thing to get wrong — if
   the widget can't see `SharedStore`, this is why.

5. **Register the URL scheme** for the SOS deep link: app target → Info →
   URL Types → add `skylink`.

6. **Run it.** Select the widget scheme, run, and pick a family. The
   previews in the `#Preview` blocks work without running the app.

## Publishing data to the widgets

The widget extension never touches the network and holds no vault key. The
app decides what is safe to show and writes it:

```swift
SharedStore.save(snapshot)   // also reloads all timelines
```

Call it after any change the widgets should reflect. The 15- and 30-minute
refresh policies in the providers are a floor, not the mechanism.

## Rules the code enforces

These come from the spec and are deliberate, not incidental:

- **Nothing invented.** No published snapshot means an empty state, never
  sample data. `DashboardSnapshot.placeholder` is marked `.demo` and the
  views badge it as such.
- **Every value carries its provenance.** `FreshnessStampView` is required
  on connected data, and unmissable on demo data.
- **The vault stays locked.** Private habits render as
  `VaultLockedRowView`, not a blurred number. The widget has no key.
- **Lock Screen shows no balances**, transactions, or health values.
- **Interactive widgets run only low-risk intents.** Ticking a habit runs
  inline; anything on the explicit-approval list opens the app.
- **No tier check in the SOS path.** See
  [ADR 0002](../docs/adr/0002-sos-is-never-metered.md).

## What's missing

- The app target itself — this is the widget slice only
- Live Activities / Dynamic Island (needs ActivityKit and a running activity)
- Any real data source; `SharedStore` is the seam where that plugs in
- Tests

## Reviewing

The [`swiftui-pro`](../.claude/skills/swiftui-pro/) skill is vendored into
this repo, so Claude Code applies Paul Hudson's SwiftUI review rules
automatically when working in here.
