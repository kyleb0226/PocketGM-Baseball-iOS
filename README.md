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

---

# Pocket GM — Soccer (sibling app)

A soccer reimagining of this game lives alongside the baseball app in
`PocketGMSoccer/` with its own Xcode project (`PocketGMSoccer.xcodeproj`). Same
tech: a single-file React game (`PocketGMSoccer/Web/index.html`) bundled offline
inside a SwiftUI `WKWebView`. Build & install exactly like the baseball app —
just open `PocketGMSoccer.xcodeproj` instead. See `PocketGMSoccer/README.md`.

What's different from baseball (it's its own full GM sim, not a skin):
- **Multi-position players.** Every player has a primary position plus the
  related positions he can also fill (e.g. `RW (RM, ST)`), so lots of formations
  are viable. The tactics screen draws a top-down pitch; fielding a player out of
  position is allowed but flagged in orange with a rating penalty.
- **Formations & tactics.** 9 formations (4-4-2, 4-3-3, 4-2-3-1, 3-5-2, …) with
  an auto-pick-best-XI helper and defensive/balanced/attacking tactics.
- **Two divisions + promotion/relegation.** A 20-team Premier and 20-team
  Championship, double round-robin (38 games), bottom 3 / top 3 swap each year.
- **Domestic knockout cup**, points-based tables (3/1/0), stat leaders
  (goals/assists/clean sheets/ratings), a **transfer market** (fees + AI bids),
  **free agency**, a **youth academy** intake, season **awards**
  (Player of the Season, Golden Boot, Golden Glove), a **Hall of Fame**, club
  finances/wages, and a multi-season franchise loop. Saves use the same
  offline-localStorage slots + JSON export/import.

---

# Run it on your MacBook AND your phone

Both games are plain offline web apps, so you have three ways to play — pick
whichever you like:

## 1. In any browser, via GitHub Pages (works on Mac *and* phone — recommended)
This repo has a workflow (`.github/workflows/deploy-pages.yml`) that publishes
both games to GitHub Pages.

**One-time setup:** on GitHub go to **Settings → Pages → Build and deployment →
Source = GitHub Actions**. (The workflow also tries to enable this automatically
on its first run.) Then push to `main` or run the workflow manually from the
**Actions** tab.

Once it's deployed, the **Actions → Deploy games to GitHub Pages** run shows the
URL (it'll look like `https://kyleb0226.github.io/PocketGM-Baseball-iOS/`):
- **MacBook:** open that URL in Safari/Chrome.
- **Phone:** open the same URL in Safari, then tap **Share → Add to Home
  Screen** to get an app icon that launches straight into the game. Saves live
  on the device.

The landing page lets you choose ⚽ Soccer or ⚾ Baseball.

## 2. On your MacBook with no hosting at all
Everything (React/Babel/Tailwind) is bundled, so you can just open the file:
```sh
open PocketGMSoccer/Web/index.html      # soccer
open PocketGMBaseball/Web/index.html    # baseball
```
It runs offline in your browser and saves persist in that browser's storage.

## 3. As a native iOS app on your phone (Xcode)
Open `PocketGMSoccer.xcodeproj` (or `PocketGMBaseball.xcodeproj`) and Run to your
iPhone — see the build/install steps above. This is the "real app icon, fully
offline" option.

> Note: each method keeps its **own** saves (browser storage vs. Pages-site
> storage vs. the native app's container). Use **Save File / Load File** inside a
> game to move a franchise between them.
