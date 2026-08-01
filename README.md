# CamBridge — Marketing Site

A single-page marketing site for CamBridge, a two-app system for content creators:

- **CamBridge Camera** (iPhone) turns your iPhone into a pro camera.
- **CamBridge Studio** (Mac) shows the live feed big on your Mac and gives you full remote control over Wi-Fi — in either portrait or landscape orientation.

## Preview

No build step, no dependencies. Just open the file directly:

```
open index.html
```

Or serve it locally if you prefer:

```
python3 -m http.server 8000
```

then visit `http://localhost:8000`.

## Structure

- `index.html` — page markup
- `css/style.css` — all styling (light/dark via `prefers-color-scheme`, no external fonts/CDNs)
- `js/main.js` — mobile nav toggle only
