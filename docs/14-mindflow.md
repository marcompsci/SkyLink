# 14. MindFlow — Personal Tracking & Voice Assistant

[← Roadmap](13-roadmap.md) · [Index](README.md)

MindFlow extends **Ask Sky** from "ask about your car" to "ask about your life." Same
voice control, same agent spine, same approval model — a new domain.

> **Read first:** there is no codebase to inspect yet. SkyLink is at specification
> stage; this repo contains no application code. The instruction to "inspect the
> existing codebase and reuse its architecture" is therefore answered by the
> architecture in [section 2](02-architecture.md), which MindFlow is designed against.
> When code exists, this section gets revisited against it.

## What is buildable, and what is not

Honest assessment before anything else.

| Capability | Status | Needs |
| --- | --- | --- |
| Onboarding, manual tracking, dashboard | Buildable now | Nothing beyond the planned stack |
| Push-to-talk, transcript, propose–approve loop | Buildable now | Speech framework + LLM gateway (already in the spine) |
| Authenticated sync, offline queue, conflict handling | Buildable now | Backend work |
| Client-side encrypted vault | Buildable now | Crypto review before shipping |
| Apple Calendar (EventKit) | Native iOS only | Calendar permission |
| Google Calendar | Buildable | Google Cloud project, OAuth client, consent screen verification |
| HealthKit | Native iOS only | Apple health entitlement, permission |
| Siri, App Intents, Shortcuts | Native iOS only | App Intents implementation |
| Home Screen & Lock Screen widgets | Native iOS only | WidgetKit; see the widget section below |
| Live Activities / Dynamic Island | Native iOS only | ActivityKit |
| Bank connections | Buildable | A banking-data provider account (Plaid or equivalent), server-side token storage |
| Social-media metrics | Partial | Per-platform API access and app review; manual entry is the fallback |
| Push notifications | Buildable | APNs key, a scheduling service |

**Not possible on any platform, and not promised anywhere in the product:** arbitrary
screen tapping, reading other apps' private data, or "control of your entire phone."
Third-party actions go through authorized APIs, Shortcuts, or a user-mediated handoff.
There is no "access your entire phone" permission and the UI must never imply one.

## 1. Guided onboarding

Four steps, each with a progress indicator, back navigation, and a skip on every
optional connection.

**Step 1 — Your priorities.** Preferred name, timezone, and which of Habits, Money,
Health, Social Growth, and Goals to track. Saved to the account; changeable later.

**Step 2 — Permissions and connections.** Each permission is explained in plain language
*before* the OS dialog appears: what is accessed, why, where it goes, how to revoke it.
Requested individually, only when needed, and only after a user action. Notifications,
microphone, calendars, and eligible health integrations. Declining any of them leaves
manual entry and typed commands fully working. A permissions page lists every
integration with its status and a disconnect button.

**Step 3 — Private vault.** The user sets their own vault passphrase. The screen states
plainly that **account sign-in and vault decryption are different things**: signing in
does not unlock the vault, and the vault protects only what is marked private. Backup,
recovery, and the consequence of losing the passphrase — the data cannot be recovered —
are stated before the passphrase is set, not after.

**Step 4 — Voice and action tutorial.** The user dictates or types one request. The app
shows the transcript, shows the proposed action, waits for approval, executes, confirms,
and links to the record created. The tutorial uses the real loop, not a simulation.

## 2. Personal dashboard

- Daily habits, recurring routines, streaks, completion history
- Spending entries, categories, budgets, savings goals
- User-entered health metrics; optional supported health connections
- Social-media metrics from authorized APIs, manual entry as fallback
- Goals, milestones, deadlines, progress
- Today's tasks, upcoming calendar events, recent-activity feed

Every connected panel shows **its source and last-updated time**. Four visually distinct
states, never blurred together:

| State | Meaning | Treatment |
| --- | --- | --- |
| Live | Fetched from an authorized API within the freshness window | Normal |
| Manual | The user typed it | Marked "entered by you" |
| Stale | Connection alive, data older than the window | Timestamp in amber + refresh |
| Demo | Sample content, no real connection | Persistent "Sample data" badge |

**Sample data is never presented as live information.** Demo state carries its badge on
every surface it appears, widgets included.

Sync across web and mobile for authenticated users, with an offline queue, idempotency
keys on every mutation to survive retries, and last-write-wins with a visible conflict
prompt when two clients edited the same record.

## 3. Voice assistant and AI actions

A visible push-to-talk control with five states: listening, processing, review, success,
error.

Example requests: *"Add a habit to walk every morning." · "Log twelve dollars for
lunch." · "Show my progress this week." · "Schedule a thirty-minute workout tomorrow at
seven." · "Move my weekly review to Friday."*

**Transcription.** The UI states where it happens — on-device where the platform
supports it, otherwise named external provider. **Raw audio is not retained by default.**
Capture stops when the user stops, leaves the feature, or backgrounds the app.

**The loop.** Transcript (editable) → proposed action → approval → execution → result
with a link to the record. Detailed in [`agents/mindflow.md`](../agents/mindflow.md).

**Authorization.** Requests are routed through narrowly scoped, allowlisted tools with
validated arguments. The server checks the user's authorization before every action.
Imported content and model output are untrusted data, never authorization.

**Explicit approval required** for calendar changes, messages, purchases, financial
actions, deletions, and sharing private information. Each approval is bound to the exact
proposed action (hash of the tool call), and carries an idempotency key so a double-tap
or a retry cannot execute it twice.

Action history with undo where the underlying operation supports it.

**Initial release scope:** creating tasks, logging habits, recording expenses,
summarizing progress. Money transfers and purchases are not enabled.

## 4. Apple and phone integrations

**Native iOS.** Permission requests through supported Apple frameworks. Eligible
MindFlow actions exposed as App Intents so Siri and Shortcuts can invoke them. Calendar,
notification, and health APIs at minimum necessary scope. Device secrets in Keychain.

**Web.** Browser microphone and notification APIs. Unsupported features are detected and
the alternative is explained. The website never claims native Siri, HealthKit, or phone
control.

## 5. Live dashboard: widgets, Lock Screen, and Siri

This is the "live AI assistant on your phone" the product promises, built out of what
iOS actually offers.

| Surface | Framework | What it shows / does |
| --- | --- | --- |
| Home Screen widget | WidgetKit | Today's habits with streaks, spend vs. budget, next event. Small / medium / large. |
| Lock Screen widget | WidgetKit accessory families | One glanceable metric: streak, remaining budget, or next event |
| Interactive widget | WidgetKit + App Intents | Tick a habit or log a preset expense **from the widget**, no app launch |
| Live Activity / Dynamic Island | ActivityKit | An in-progress routine, workout, or focus block with a live timer |
| Siri / Shortcuts | App Intents | "Hey Siri, log my walk in SkyLink." Runs the same allowlisted tool |
| Control Center control | ControlWidget | One-tap push-to-talk into Ask Sky |
| Notifications | UserNotifications + APNs | Reminders, quiet hours, categories |

Constraints to design against, rather than discover later:

- Widgets are **timeline snapshots**, not live-streaming views. They refresh on a
  budgeted schedule plus on push. Design for "recently accurate," and stamp the time.
- Widget content must respect the vault: locked private data is **not** rendered in a
  widget. Show a locked placeholder instead.
- Lock Screen surfaces show no balances, transaction details, or health values by
  default.
- Interactive widgets can run App Intents, but anything requiring approval (calendar
  writes, deletions) opens the app for the approval step rather than executing inline.
- Siri invocations still run the propose–approve loop for anything on the explicit-
  approval list. Siri is an entry point, not a bypass.

## 6. Secure cloud and private data

- Authenticated access, strict per-user authorization on every read and write.
- **Each user controls their own vault credentials. There is no universal decryption
  password held by the app owner.**
- Private vault content is encrypted **on the client** before upload.
- Established crypto libraries and authenticated encryption. No custom cryptography.
- Vault passwords, keys, and plaintext vault content are never sent to the server and
  never logged.
- TLS everywhere, secrets in a managed store, rate limits, privacy-conscious logging.
- Automatic vault locking, encrypted backups, account export, account deletion.
- Documentation of what encryption does *not* protect: an unlocked device, a compromised
  device, and anything the user chose not to mark private.

### The tradeoff, stated rather than hidden

A server cannot process locked data without access to its decryption key. So background
automation and server-side AI cannot operate on end-to-end encrypted content. MindFlow
does not quietly weaken encryption to make background features work. Instead, each data
class is labeled:

| Class | Example | Where it lives |
| --- | --- | --- |
| End-to-end encrypted | Journal entries, anything marked private | Client-encrypted; server stores ciphertext only |
| Backend-processed | Habits, tasks, budgets, goals, metrics | Encrypted at rest, readable by the backend for sync, summaries, reminders |
| Shared with integrations | Calendar events, bank transactions, social metrics | Governed by that provider's scope |

Sending any decrypted content to a cloud AI provider requires separate, explicit consent
for that send.

## 7. Bank connections

Through a reputable banking-data provider's **official hosted authorization flow**.

- **The app never builds a form that collects bank passwords.** Not once, not anywhere.
- Request only account and transaction scope, and only what tracking needs.
- Provider secrets and long-lived tokens stay server-side, never in a browser or mobile
  bundle.
- Validate provider callbacks and webhooks (signature + replay protection).
- Users can disconnect an account and are told what is retained and what is deleted.
- Banking-provider access is separate from the private vault, and the UI says so.
- Manual expense entry is always available and is the default with no bank connected.

## 8. Notifications

Configurable reminders, quiet hours, timezone, and categories. Sensitive balances,
transaction details, and health information stay **off the Lock Screen by default**.

Permission is not delivery: APNs, a scheduling service, and retry handling are real
backend work and must be implemented and tested, not assumed.

## 9. Design

MindFlow fits inside SkyLink's shell. Where a distinct MindFlow identity is appropriate:

| Token | Hex |
| --- | --- |
| Cream | `#FBF4E4` |
| Tinted cream | `#F2E8D2` |
| Ink | `#17170F` |
| Electric blue | `#1B3BE0` |
| Orange | `#FF5A2B` |
| Yellow on blue surfaces | `#FFD34E` |

Type: **Anton** for display headings · **Instrument Serif italic** for expressive
heading accents · **Chivo** for body · **Chivo Mono** for labels and data.

Warm backgrounds, clear hierarchy, restrained accents, accessible contrast, responsive
layouts, keyboard support, visible focus states, reduced-motion support. Every screen
ships with loading, empty, permission-denied, offline, and error states.

Note the collision with SkyLink Auto's dark-first palette
([section 11](11-brand.md)): MindFlow is the warm, light surface inside a dark app. That
is a deliberate contrast, and the boundary between the two needs a designed transition
rather than an abrupt swap.

## 10. Phases and acceptance

| Phase | Scope |
| --- | --- |
| 1 | Onboarding, manual tracking, dashboard, permissions UI |
| 2 | Dictation, transcript editing, propose–approve loop, internal actions |
| 3 | Authenticated persistence, sync, offline queue, private vault |
| 4 | Calendar, notifications, banking, widgets, App Intents, Live Activities |

### Test matrix

- Permission states: granted, denied, revoked mid-session, unsupported platform
- Vault: correct passphrase decrypts; wrong passphrase and tampered ciphertext are
  rejected, distinctly
- Cross-user access denial on every endpoint
- Voice: review, edit, cancel, approve, and duplicate-execution prevention
- Calendar: timezone correctness, DST boundaries, recurrence, sync conflicts, expired
  permission
- Offline: queue, recovery, idempotent retry
- Logs: no vault passwords, keys, plaintext vault content, or tokens
- Widgets: locked-vault placeholder, stale timestamps, demo badge
- Mobile responsiveness and accessibility

### Definition of done

Working code, setup instructions, required environment variables listed **without
values**, tests, and a maintained list of implemented vs. unavailable features. The
product is not described as production-secure or fully integrated until that has been
verified by review.
