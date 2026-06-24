# Pocket GM — Baseball (iOS)

A native iOS wrapper (SwiftUI + `WKWebView`) around the single-file web game
[`baseball-gm`](https://github.com/kyleb0226/baseball-gm). The game (`index.html`)
plus its React / Babel / Tailwind libraries are **bundled offline** under
`PocketGMBaseball/Web/`, so the app runs with no internet connection and saves
persist in the app's storage across launches.

## Build & install on your iPhone
1. `open PocketGMBaseball.xcodeproj`
2. Plug in your iPhone (tap **Trust** if asked).
3. Target → **Signing & Capabilities** → check *Automatically manage signing*,
   set **Team** to your Apple ID (change the Bundle Identifier if it's taken).
4. Pick your iPhone in the device dropdown, press **▶ Run**.
5. On the phone: **Settings → General → VPN & Device Management** → trust your
   Apple ID, then reopen the app.

> A free Apple ID works but the app expires after 7 days (just Run again to
> refresh). A paid Apple Developer account makes it permanent.

## Updating the game in the app
The bundled copy is a snapshot — it does **not** auto-update like the web version.
To pull the latest game in, run:

```sh
python3 sync-game.py
```

This re-copies `~/baseball-gm/index.html` and swaps its CDN `<head>` for the
locally vendored libraries (`Web/vendor/`) + mobile viewport/safe-area styling.
Then rebuild/reinstall from Xcode. The original game file is never modified.

## Notes
- The **web/home-screen** version (GitHub Pages of `baseball-gm`) auto-updates on
  every push — that's the "always latest" option. This native app is the
  "works offline" option you refresh on your own schedule.
- `ContentView.swift` loads `Web/index.html` in a full-screen `WKWebView`; the
  HTML handles its own safe-area insets.
