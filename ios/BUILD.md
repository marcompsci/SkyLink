# Building SkyLink

M0: the app runs on a phone, the widget renders, and `skylink://sos` opens
triage. Nothing else is claimed.

## Fast path — generated project

```bash
brew install xcodegen
cd ios
xcodegen generate
open SkyLink.xcodeproj
```

That wires both targets, the App Group, the entitlements, the URL scheme and
the permission strings. Then:

1. Open `project.yml`, set `DEVELOPMENT_TEAM` to your Team ID
   (Xcode → Settings → Accounts), and run `xcodegen generate` again.
   **The simulator works without this** — you only need it for a real phone.
2. In Xcode, select the **SkyLink** scheme and run.

## The App Group

Both targets must share one App Group or the widget shows an empty state
forever. It is the most common thing to get wrong.

The identifier is `group.com.phoronomics.skylink.shared`, in three places that
must agree:

- `ios/SkyLinkApp/SkyLink.entitlements`
- `ios/SkyLinkWidgets/SkyLinkWidgets.entitlements`
- `AppGroup.identifier` in `SkyLinkKit/Store/AppGroup.swift`

Change it in all three or none. On a paid developer account you also register
it at developer.apple.com → Identifiers → App Groups.

## Auto's sprite sheet

`design/auto/auto-sheet.png` and its @2x/@3x are added as resources by the
spec above. In the asset catalog they must be **Single Scale** — the three
files already are the three scales, so letting Xcode generate them produces a
blurry Auto.

## Manual setup, if you'd rather not use XcodeGen

1. New → App, SwiftUI, name `SkyLink`, deployment target **iOS 17**.
2. File → New → Target → Widget Extension, name `SkyLinkWidgets`. Delete the
   template file it creates.
3. Signing & Capabilities → + Capability → **App Groups** on *both* targets,
   with the identifier above.
4. Drag `SkyLinkKit/` in with membership on **both** targets. `SkyLinkApp/` is
   app-only; `SkyLinkWidgets/` is widget-only. This is the other thing people
   get wrong — if the widget can't see `SharedStore`, this is why.
5. App target → Info → URL Types → add scheme `skylink`.
6. Add the five usage strings from `project.yml` to the app's Info.plist.

## Testing the deep link

With the app running in the simulator:

```bash
xcrun simctl openurl booted skylink://sos
```

It should land on triage with the safety script, not on the Garage.

## What is not built

Guides, Ask Auto and the category screens show an honest "Not built yet"
screen. Onboarding is not wired, so the app seeds a sample vehicle marked
`.demo` and badges it. See `docs/12-roadmap.md`.
