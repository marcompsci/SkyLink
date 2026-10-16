#!/usr/bin/env python3
"""
Generates Auto's pixel sprites for SkyLink.

Auto is 32x32, hand-authored pixel by pixel. One frame per state plus an idle
blink, laid out in a horizontal strip.

    auto-sheet.png      1x — 32px cells, the master
    auto-sheet@2x.png   2x — nearest-neighbour, never smoothed
    auto-sheet@3x.png   3x
    states/             each frame alone, 1x and 6x
    auto-grid.json      palette + per-frame rows, so the art can be hand-edited
                        without running this again

Run:  python3 generate_auto_sprites.py [outdir]

Design: hex-nut head, chrome body, work-lamp eye, magnetic feet, a wrench
slightly too big for him. The silhouette never changes between states except
at the arms — the eye carries the meaning, so he reads the same at 32px as at
192px.
"""

import json
import sys
from pathlib import Path

from PIL import Image

W = H = 32

PALETTE = {
    ".": (0, 0, 0, 0),            # transparent
    "K": (14, 16, 20, 255),       # outline
    "D": (88, 98, 112, 255),      # chrome dark
    "M": (150, 162, 176, 255),    # chrome mid
    "L": (221, 227, 234, 255),    # Chrome light
    "O": (255, 107, 44, 255),     # Torque Orange
    "Y": (255, 197, 61, 255),     # Shop Yellow
    "W": (255, 246, 219, 255),    # lamp highlight
    "T": (25, 195, 178, 255),     # Oil Teal
    "R": (232, 64, 42, 255),      # Stop Red
    "G": (62, 207, 142, 255),     # Safe Green
    "A": (122, 106, 58, 255),     # lamp off
    "S": (70, 77, 87, 255),       # lamp dead
}

# ── The base: head, body, feet. 'E' is the lamp, filled per state. ───────────
BASE = [
    "................................",  # 0
    "................................",  # 1
    "............KKKKKKKK............",  # 2  hex nut, flat top
    "..........KKMMMMMMMMKK..........",  # 3
    ".........KMMMMMMMMMMMMK.........",  # 4
    "........KMLLMMMMMMMMMMMK........",  # 5
    "........KMLLKKKKKKKKMMMK........",  # 6
    "........KMMMKEEEEEEKMMMK........",  # 7
    "........KMMMKEEEEEEKMMMK........",  # 8
    "........KMMMKEEEEEEKMMMK........",  # 9
    ".........KMMKKKKKKKKMMK.........",  # 10
    "..........KKMMMMMMMMKK..........",  # 11
    "............KKKKKKKK............",  # 12  flat bottom
    ".............KDDDDK.............",  # 13  neck
    ".............KDDDDK.............",  # 14
    "...........KKKKKKKKKK...........",  # 15  body top
    "..........KLLMMMMMMDK...........",  # 16
    "..........KLLMMMMMMDK...........",  # 17
    "..........KLKOOOOOOKDK..........",  # 18
    "..........KLKOOOOOOKDK..........",  # 19
    "..........KLKOOOOOOKDK..........",  # 20
    "..........KLKKKKKKKKDK..........",  # 21
    "..........KLLMMMMMMDK...........",  # 22
    "..........KLLDDDDDDDK...........",  # 23  vent
    "..........KLLMMMMMMDK...........",  # 24
    "...........KKKKKKKKK............",  # 25  body bottom
    "............KDK..KDK............",  # 26  legs
    "..........KKMMKKKKMMKK..........",  # 27  magnetic feet
    "..........KKKKK..KKKKK..........",  # 28
    "................................",  # 29
    "................................",  # 30
    "................................",  # 31
]

# ── Arms, as explicit pixels so they attach to the body and read cleanly ─────
# Each entry: list of (x, y, char)
def limb(cells, hand=None):
    """A limb is solid fill; the outline pass draws its edge."""
    out = [(x, y, "M") for x, y in cells]
    if hand:
        out += [(x, y, "L") for x, y in hand]
    return out


ARMS = {
    "down": limb(
        [(8, 18), (9, 18), (8, 19), (9, 19), (8, 20), (9, 20),
         (21, 18), (22, 18), (21, 19), (22, 19), (21, 20), (22, 20)],
        hand=[(8, 21), (9, 21), (8, 22), (9, 22),
              (22, 21), (23, 21), (22, 22), (23, 22)],
    ),
    "up": limb(
        [(8, 16), (9, 16), (8, 15), (9, 15), (8, 14), (9, 14),
         (21, 16), (22, 16), (21, 15), (22, 15), (21, 14), (22, 14)],
        hand=[(8, 12), (9, 12), (8, 13), (9, 13),
              (21, 12), (22, 12), (21, 13), (22, 13)],
    ),
    "lean": limb(
        [(8, 18), (9, 18), (8, 19), (9, 19), (8, 20), (9, 20),
         (21, 17), (22, 17), (23, 17), (21, 18), (22, 18), (23, 18)],
        hand=[(8, 21), (9, 21), (8, 22), (9, 22),
              (24, 17), (25, 17), (24, 18), (25, 18)],
    ),
    "block": limb(
        [(8, 19), (9, 19), (8, 20), (9, 20), (8, 21), (9, 21),
         (21, 17), (22, 17), (21, 18), (22, 18)],
        hand=[(8, 22), (9, 22), (8, 23), (9, 23),
              (23, 15), (24, 15), (25, 15), (23, 16), (24, 16), (25, 16),
              (23, 17), (24, 17), (25, 17), (23, 18), (24, 18), (25, 18),
              (23, 19), (24, 19), (25, 19)],
    ),
    "shrug": limb(
        [(8, 17), (9, 17), (8, 16), (9, 16),
         (6, 16), (7, 16), (6, 15), (7, 15),
         (21, 16), (22, 16), (21, 17), (22, 17),
         (23, 16), (24, 16), (23, 15), (24, 15)],
        hand=[(5, 14), (6, 14), (5, 15), (6, 15),
              (24, 14), (25, 14), (24, 15), (25, 15)],
    ),
    "tap": limb(
        [(8, 18), (9, 18), (8, 19), (9, 19), (8, 20), (9, 20),
         (21, 16), (22, 16), (21, 15), (22, 15), (21, 14), (22, 14)],
        hand=[(8, 21), (9, 21), (8, 22), (9, 22),
              (20, 12), (21, 12), (20, 13), (21, 13)],
    ),
}

# Wrench, drawn as a held object so it never floats. (x, y, char)
WRENCH = {
    "down": [
        (22, 11, "M"), (24, 11, "M"),
        (22, 12, "M"), (23, 12, "M"), (24, 12, "M"),
        (23, 13, "M"), (23, 14, "D"), (23, 15, "D"), (23, 16, "D"),
        (23, 17, "D"), (23, 18, "D"), (23, 19, "D"), (23, 20, "D"),
    ],
    "lean": [
        (26, 14, "M"), (28, 14, "M"),
        (26, 15, "M"), (27, 15, "M"), (28, 15, "M"),
        (26, 16, "D"), (25, 16, "D"), (24, 16, "D"),
    ],
    "tap": [
        (20, 6, "M"), (22, 6, "M"),
        (20, 7, "M"), (21, 7, "M"), (22, 7, "M"),
        (21, 8, "M"), (21, 9, "D"), (21, 10, "D"), (21, 11, "D"),
    ],
}

STATES = {
    #           lamp  highlight  arms      wrench
    "idle":      ("A", False, "down",  "down"),
    "listening": ("Y", True,  "down",  "down"),
    "thinking":  ("Y", False, "tap",   "tap"),
    "foundIt":   ("G", True,  "lean",  "lean"),
    "careful":   ("O", True,  "up",    None),
    "stop":      ("R", True,  "block", None),
    "cantHelp":  ("S", False, "shrug", None),
}


def build(lamp, highlight, arms, wrench, blink=False, ring=False):
    g = [list(row) for row in BASE]

    for y, row in enumerate(g):
        for x, ch in enumerate(row):
            if ch == "E":
                g[y][x] = "D" if blink else lamp

    if blink:
        # lid drops: only the middle band of the lamp stays lit
        for x in range(13, 19):
            g[7][x] = "K"
            g[9][x] = "K"
    elif highlight:
        g[7][14] = "W"

    if ring:
        for x, y in ((12, 3), (19, 3), (9, 8), (22, 8), (12, 11), (19, 11)):
            g[y][x] = "Y"

    if wrench:
        for x, y, ch in WRENCH[wrench]:
            if 0 <= x < W and 0 <= y < H:
                g[y][x] = ch

    for x, y, ch in ARMS[arms]:
        if 0 <= x < W and 0 <= y < H:
            g[y][x] = ch

    return outline(g)


FILL = set("DMLOYWTRGAS")


def outline(g):
    """1px dark edge around every lit pixel. Cheaper and more reliable than
    hand-placing outline pixels, and it is what stops limbs reading as
    detached scratches."""
    out = [row[:] for row in g]
    for y in range(H):
        for x in range(W):
            if g[y][x] != ".":
                continue
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if 0 <= nx < W and 0 <= ny < H and g[ny][nx] in FILL:
                    out[y][x] = "K"
                    break
    return out


def to_image(grid):
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    for y, row in enumerate(grid):
        for x, ch in enumerate(row):
            img.putpixel((x, y), PALETTE[ch])
    return img


def main():
    outdir = Path(sys.argv[1] if len(sys.argv) > 1 else ".")
    outdir.mkdir(parents=True, exist_ok=True)

    frames = []
    for name, (lamp, hi, arms, wrench) in STATES.items():
        frames.append((name, build(lamp, hi, arms, wrench,
                                   ring=(name == "listening"))))
    frames.append(("idleBlink", build("A", False, "down", "down", blink=True)))

    sheet = Image.new("RGBA", (W * len(frames), H), (0, 0, 0, 0))
    for i, (_, g) in enumerate(frames):
        sheet.paste(to_image(g), (i * W, 0))

    sheet.save(outdir / "auto-sheet.png")
    for s in (2, 3):
        sheet.resize((sheet.width * s, sheet.height * s),
                     Image.NEAREST).save(outdir / f"auto-sheet@{s}x.png")

    single = outdir / "states"
    single.mkdir(exist_ok=True)
    for name, g in frames:
        img = to_image(g)
        img.save(single / f"auto-{name}.png")
        img.resize((W * 6, H * 6), Image.NEAREST).save(single / f"auto-{name}@6x.png")

    (outdir / "auto-grid.json").write_text(json.dumps({
        "name": "Auto",
        "size": {"width": W, "height": H},
        "palette": {k: ("transparent" if v[3] == 0 else "#%02X%02X%02X" % v[:3])
                    for k, v in PALETTE.items()},
        "frameOrder": [n for n, _ in frames],
        "frames": {n: ["".join(r) for r in g] for n, g in frames},
    }, indent=2) + "\n")

    print(f"{len(frames)} frames -> {outdir}")


if __name__ == "__main__":
    main()
