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

A dark, cinematic base with a single warm "recording light" accent (amber/
gold) and a muted teal secondary accent used for the bridge/connection
motif and links. Deliberately desaturated and warm rather than neon — this
is a creator tool, not a gaming HUD.

### Dark (default)

| Token       | Hex       | Use |
|-------------|-----------|-----|
| `--bg`      | `#0C0A08` | Page background. Near-black with a warm brown undertone (not pure #000) so large fields feel cinematic rather than flat/OLED-harsh. |
| `--surface` | `#17130F` | Cards, the header bar, elevated panels, code-style badges. One step up from `--bg` for layering without a hard border. |
| `--ink`     | `#F5EFE6` | Primary text. Warm off-white/cream, never pure white — easier on the eyes against the warm-black background and ties back to "film" tonality. |
| `--ink-dim` | `#A69A8C` | Secondary text, captions, nav links. A warm greige with enough contrast for AA body text on `--bg` and `--surface`. |
| `--accent`  | `#E3A855` | Primary accent — the "recording light" amber/gold. CTAs, active states, the lens ring in the logo, eyebrow labels. |
| `--accent-2`| `#6FA8A0` | Secondary accent — a soft muted teal. The "bridge" motif, links, connection lines, secondary badges. Never competes with `--accent` for primary attention. |

### Light

| Token       | Hex       | Use |
|-------------|-----------|-----|
| `--bg`      | `#FBF7F0` | Page background. Warm ivory, not stark white — keeps continuity with the dark theme's warmth instead of just inverting to cold white. |
| `--surface` | `#FFFFFF` | Cards and elevated panels sit on true white against the ivory page background, giving real (not just tonal) elevation. |
| `--ink`     | `#211B14` | Primary text. Warm near-black. |
| `--ink-dim` | `#6B6255` | Secondary text — warm taupe, AA-compliant on both `--bg` and `--surface`. |
| `--accent`  | `#C9821F` | Primary accent, darkened/desaturated from the dark-mode amber so it holds contrast on light backgrounds (the dark-mode value fails AA on white). |
| `--accent-2`| `#3F7A72` | Secondary accent, deepened teal for the same reason. |

Both palettes share the same *role* for each token, which is what makes the
light mode feel like a deliberate reflection of the dark mode rather than a
naive inversion: surfaces still sit one step lighter than the page, ink is
always warm rather than neutral gray, and the accent pair keeps its
amber/teal relationship at a different luminance.

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
