# CamBridge Brand Kit

## Concept

**Logomark:** a camera aperture ring "bridging" down into a signal arc that
lands on two rounded nodes — one for the iPhone, one for the Mac. The ring
reads as a lens (the product's raw material: your iPhone's camera). The arc
underneath reads as a bridge or a Wi‑Fi handshake (the product's actual job:
connecting the two devices). At 16px the ring + arc silhouette still reads
as a distinct badge; at 1024px the two device nodes and the aperture center
dot are clearly legible as intentional details, not a generic camera icon.

Files:
- `logo/logomark.svg` — mark only, on a dark circular field
- `logo/logo-lockup.svg` — mark + "CamBridge" wordmark, transparent background
- `logo/logomark-1024.png` — rasterized reference render
- `generate_app_icons.swift` — CoreGraphics re-implementation of the same
  geometry, used to generate the full app icon set (run with
  `swift brand/generate_app_icons.swift`)
- `appicons/macos/*.png`, `appicons/ios/*.png` — generated icon set

**Wordmark:** "CamBridge" set in the system font stack (`-apple-system,
"SF Pro Display", "Helvetica Neue", Arial, sans-serif`), weight 800,
negative letter-spacing (~-0.02 to -0.04em) for a tight, confident
headline feel. No custom font files — the weight and tracking alone carry
the identity, consistent with the rest of the site's system-font approach.

## Palette

**Updated 2026-10-08: "Studio navy + blue"** replaces the earlier amber/brown palette.
A deep navy base with an electric-blue accent (buttons, active states, eyebrows)
and a teal secondary accent used for the bridge/connection motif, links and
"Shipped" tags. The camera-UI yellow (`#FFD60A`/`--ui-yellow`: focus reticle,
active lens chip, AE/AF LOCK) and the REC red (`--ui-red`) are app-UI colours
inside the mockups only and are unchanged; `--live` green marks the beta dot.

### Dark (default)

| Token        | Hex       | Use |
|--------------|-----------|-----|
| `--bg`       | `#0B1020` | Page background. Deep navy. |
| `--surface`  | `#141B2E` | Cards, header bar, elevated panels. |
| `--surface-2`| `#1A2238` | A further step up for nested panels. |
| `--ink`      | `#E8ECF4` | Primary text. |
| `--ink-dim`  | `#8A94A8` | Secondary text, captions, nav links. |
| `--accent`   | `#4C8DFF` | Primary accent: active states, eyebrows, links-as-text. |
| `--accent-btn`| `#2F6BE8` | Filled button background (white text reaches AA 4.5:1; white on `#4C8DFF` does not). |
| `--accent-2` | `#34D1BF` | Secondary accent: teal bridge motif, links, "Shipped" tags. |
| `--on-accent`| `#FFFFFF` | Text on filled accent buttons. |

### Light

| Token        | Hex       | Use |
|--------------|-----------|-----|
| `--bg`       | `#F6F8FC` | Page background. |
| `--surface`  | `#FFFFFF` | Cards and elevated panels. |
| `--surface-2`| `#EEF2F9` | Nested panels. |
| `--ink`      | `#0E1526` | Primary text. |
| `--ink-dim`  | `#4B5568` | Secondary text. |
| `--accent`   | `#2563EB` | Primary accent. |
| `--accent-btn`| `#1D4ED8` | Filled button background. |
| `--accent-text`| `#1D4ED8` | Accent used as text. |
| `--accent-2` | `#0E9F8E` | Secondary accent (fills, borders). |
| `--accent-2-text`| `#0B766A` | Teal used as text/links (AA on white and `--bg`). |
| `--on-accent`| `#FFFFFF` | Text on filled accent buttons. |

Both palettes share the same *role* for each token: surfaces sit one step
lighter than the page, and the accent pair keeps its blue/teal relationship at
a different luminance. Lines are cool alphas of `--ink`.

## Usage in the codebase

All six tokens are defined once, at the top of `css/style.css`, inside
`:root` (dark, default) and mirrored inside
`@media (prefers-color-scheme: light)`. Every color reference elsewhere in
the stylesheet uses `var(--token)` — there is a single source of truth, no
hard-coded hex values scattered through component rules.

## Logo usage & clearspace

- Minimum clearspace around the mark: half the mark's height on all sides
  (i.e. at a 100px-tall mark, keep ≥50px of breathing room before any other
  element or the canvas edge).
- Minimum display size: 16px for the mark alone (favicon), 24px when paired
  with the wordmark in a lockup.
- Do not recolor the ring/arc independently of the documented palette, do
  not add drop shadows or outer glows to the mark itself (the surrounding
  UI may glow; the mark stays flat and precise), and do not stretch it off
  its 1:1 aspect ratio.
- On dark surfaces use the mark as-is. On light surfaces, prefer the
  lockup/mark on a `--surface` (white) card rather than directly on `--bg`
  (ivory) when it needs to pop, though it remains legible on both.
