# Auto — pixel sprites

Auto is 32×32 pixel art. One frame per state, plus an idle blink.

| File | What it is |
| --- | --- |
| `generate_auto_sprites.py` | The source of truth. Hand-authored pixel grid, run it to rebuild everything else. |
| `auto-sheet.png` | 1× strip, 8 frames of 32px — what the app ships |
| `auto-sheet@2x.png`, `@3x.png` | Nearest-neighbour upscales for Retina. **Never** resampled smoothly. |
| `states/` | Each frame alone, 1× (plus `auto-idle@6x.png` for listings and slides) |
| `auto-grid.json` | Palette + per-frame rows, so the art can be hand-edited without Python |

## Rebuilding

```
python3 generate_auto_sprites.py .
```

Needs Pillow. Everything in this folder except the script and this README is
generated — edit the script, not the PNGs.

## The rules that keep him consistent

- **The silhouette never changes between states except at the arms.** The lamp
  carries the meaning, so he reads the same at 32px as at 192px.
- **One dark outline, applied automatically.** The script's `outline()` pass
  draws a 1px edge around every lit pixel. That is what stops limbs reading as
  detached scratches — an earlier hand-outlined version had exactly that
  problem.
- **The lamp is the only element that changes colour**, and it maps 1:1 to the
  severity system in [docs/07](../../docs/07-obd-ii.md):

  | State | Lamp | Severity |
  | --- | --- | --- |
  | idle | dim olive | — |
  | listening | Shop Yellow + ring | — |
  | thinking | Shop Yellow, wrench raised | — |
  | foundIt | Safe Green | safe |
  | careful | Torque Orange, hands up | soon / limited |
  | stop | Stop Red, palm out | stop |
  | cantHelp | dead grey, shrug | — |

- **Colour is never the only signal.** Every appearance of `careful` or `stop`
  carries the word and the SF Symbol too. See
  [docs/14](../../docs/14-auto-the-mechanic.md).

## Rendering

Always nearest-neighbour. In SwiftUI that is `.interpolation(.none)` — see
`ios/SkyLinkKit/Auto/AutoSpriteView.swift`. Smoothing a 32px sprite turns it to
mush, and it is the single easiest way to ruin this.

Display sizes are integer multiples only: 32, 64, 96, 128, 192. A 50px Auto has
uneven pixels and looks broken.
