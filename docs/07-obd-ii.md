# 7. OBD-II Diagnostics

[← Roadside SOS](06-roadside-sos.md) · [Index](README.md) · Next: [AI agents →](08-ai-agents.md)

Every car sold in the US since 1996 has an OBD-II port, usually under the dash on the
driver's side. A Bluetooth dongle that reads it costs $20 to $40. This is the single
highest-leverage feature in the app: it turns "it's making a weird noise" into
structured data the agent can actually reason about.

## Hardware

SkyLink does not sell hardware at launch. It supports standard ELM327-compatible BLE
dongles and recommends two or three known-reliable models in-app. Later, a branded
**SkyLink Link** dongle is an obvious hardware play and a strong Garage-tier bundle.

## Pairing flow

1. "Find your port" — a diagram of the driver's footwell for the user's specific
   vehicle, with the port location marked.
2. Plug in, turn the key to accessory.
3. App scans for BLE devices, pairs, handshakes with the ECU.
4. Reads the VIN off the bus and auto-fills the vehicle profile — no typing
   year/make/model.
5. Confirmation screen: "Connected to your 2016 Honda Civic."

The whole thing should take under two minutes and never show a raw Bluetooth device
list.

## What it reads

| Data | What SkyLink does with it |
| --- | --- |
| Stored trouble codes (DTCs) | Plain-language meaning, severity, likely causes, matching guides |
| Pending codes | "This is about to turn your light on" — early warning |
| Freeze-frame data | Conditions when the fault happened: speed, load, temp |
| Readiness monitors | "Will this pass emissions?" — a real, common user question |
| Live PIDs | RPM, coolant temp, intake temp, fuel trims, O2 sensors, battery voltage, load |
| Mode 06 test results | Advanced; Industry tier |

## Translating a code

The user never sees a bare code as the answer. `dtc_codes` maps each one to a plain
title, a plain meaning, a severity, and common causes ordered cheapest-first. A P0301
renders as:

> **Cylinder 1 is misfiring.** One of your engine's cylinders isn't firing properly.
> You may feel shaking, or notice less power.
>
> **How urgent:** Drive gently and get this looked at soon. If your check-engine light
> is *flashing*, stop driving — a flashing light with a misfire can destroy your
> catalytic converter, which is an expensive part.
>
> **Most likely causes, cheapest first:** worn spark plug · failed ignition coil ·
> clogged fuel injector · vacuum leak · low compression
>
> **What you can check yourself:** [Replace spark plugs — 🟠 1.5 hr] [Replace ignition
> coils — 🟠 1 hr]

Severity drives the whole tone of the screen. Four levels: **Safe to drive** · **Get it
checked soon** · **Don't drive far** · **Stop driving now**.

## How codes reach the agent

A scan writes an `obd_sessions` row, and the agent's context for that conversation
carries a compact summary: vehicle, mileage, active codes with freeze-frame, and any
anomalous live values. So the user can ask "why is my car shaking" and Sky already knows
there is a P0301 with a misfire count on cylinder 1 at 2,100 RPM under load. That is the
difference between a chatbot and a diagnostic tool.

Live data is polled only while a diagnostic screen is open, and is never streamed
continuously in the background — battery, privacy, and the CAN bus all object.

## Clearing codes — handled carefully

The app can clear codes, but it argues with you first. Clearing does not fix anything;
it erases the evidence a mechanic needs and resets emissions readiness monitors, which
means failing an inspection for days afterward. So clearing sits behind a confirmation
that explains both, and the app snapshots the codes to history before wiping them. It
refuses to clear a **Stop driving now** code at all.

## Tier gating

| Capability | Free | Garage | Industry |
| --- | --- | --- | --- |
| Read + clear codes | Yes | Yes | Yes |
| Plain-language explanation | Yes | Yes | Yes |
| Live data dashboard | No | Yes | Yes |
| Freeze-frame + readiness | No | Yes | Yes |
| Scan history & trends | Last 1 | Unlimited | Unlimited |
| Mode 06, multi-vehicle fleet view | No | No | Yes |

Reading a code is free on every tier, because a person with a lit check-engine light and
no money is exactly who this app is for. The AI *conversation* about that code is what
the meter counts.
