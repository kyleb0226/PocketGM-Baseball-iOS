# Pocket GM — Soccer (iOS)

A native iOS wrapper (SwiftUI + `WKWebView`) around a single-file web football
manager game. The game (`Web/index.html`) plus its React / Babel / Tailwind
libraries are **bundled offline** under `PocketGMSoccer/Web/`, so the app runs
with no internet connection and saves persist in the app's storage across
launches. It's a sibling of the baseball app in the repo root — same engineering,
different sport.

## Build & install on your iPhone
1. `open PocketGMSoccer.xcodeproj`
2. Plug in your iPhone (tap **Trust** if asked).
3. Target → **Signing & Capabilities** → check *Automatically manage signing*,
   set **Team** to your Apple ID (change the Bundle Identifier if it's taken).
4. Pick your iPhone in the device dropdown, press **▶ Run**.
5. On the phone: **Settings → General → VPN & Device Management** → trust your
   Apple ID, then reopen the app.

> A free Apple ID works but the app expires after 7 days (just Run again to
> refresh). A paid Apple Developer account makes it permanent.

## The game
You're the manager of one club across two divisions. Pick your XI from a squad
of multi-position players, set a formation and tactics, sim the double
round-robin season, chase the league title (and promotion if you start in the
second tier), run in the domestic cup, work the transfer market and free agency,
develop youth-academy prospects, and build a dynasty over many seasons.

### Highlights
- **Multi-position players + formations.** Each player lists every position he
  can play; the pitch view flags out-of-position picks (orange) with a rating
  penalty. Auto-pick finds your best XI for the chosen shape.
- **Two divisions, promotion & relegation**, points-based tables (3/1/0),
  goal-difference tiebreakers.
- **Match engine** producing realistic scorelines, scorers, assists, clean
  sheets, cards, ratings and a man of the match.
- **Transfers** (fees + incoming AI bids), **free agency**, **youth intake**,
  finances/wages, season **awards**, and a **Hall of Fame**.
- Offline play; multi-slot saves with JSON **export / import** backups.

## Files
- `PocketGMSoccerApp.swift` — SwiftUI app entry point.
- `ContentView.swift` — loads `Web/index.html` in a full-screen `WKWebView`.
- `Web/index.html` — the entire game (single-file React, JSX transpiled in-page
  by the vendored Babel). `Web/vendor/` holds the offline React/Babel/Tailwind.
