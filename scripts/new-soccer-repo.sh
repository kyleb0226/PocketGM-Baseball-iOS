#!/usr/bin/env bash
#
# Extract Pocket GM — Soccer into its OWN standalone git repository.
#
# Run this on your Mac. It copies the soccer app out of this (baseball) repo,
# lays it out at the root of a fresh directory with its own README, .gitignore
# and GitHub Pages workflow, runs `git init`, and prints the steps to push it to
# a brand-new GitHub repo. Nothing in this repo is modified.
#
# Usage:
#   ./scripts/new-soccer-repo.sh [target-dir] [git-remote-url]
#
#   target-dir      where to build the new repo (default: ../PocketGM-Soccer-iOS)
#   git-remote-url  OPTIONAL. If given (e.g. git@github.com:you/PocketGM-Soccer-iOS.git),
#                   the script also adds it as origin and pushes main for you.
#                   Create the EMPTY repo on GitHub first, then pass its URL here.
#
set -euo pipefail

SRC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-$SRC_ROOT/../PocketGM-Soccer-iOS}"
REMOTE_URL="${2:-}"

if [ -e "$TARGET" ]; then
  echo "✋ Target already exists: $TARGET"
  echo "   Pass a different path, or remove it first."
  exit 1
fi

echo "→ Source repo : $SRC_ROOT"
echo "→ New repo dir : $TARGET"
mkdir -p "$TARGET/.github/workflows"

# 1) the app itself (Swift wrapper, Web game + vendored libs, assets) and its Xcode project
cp -R "$SRC_ROOT/PocketGMSoccer"          "$TARGET/PocketGMSoccer"
cp -R "$SRC_ROOT/PocketGMSoccer.xcodeproj" "$TARGET/PocketGMSoccer.xcodeproj"

# 2) .gitignore
cat > "$TARGET/.gitignore" <<'GITIGNORE'
# Xcode
build/
DerivedData/
*.xcuserstate
*.xcuserdatad
xcuserdata/
.DS_Store
*.ipa
*.dSYM.zip
*.dSYM
GITIGNORE

# 3) root README (soccer only)
cat > "$TARGET/README.md" <<'README'
# Pocket GM — Soccer (iOS)

A native iOS wrapper (SwiftUI + `WKWebView`) around a single-file web football
manager game. The game (`PocketGMSoccer/Web/index.html`) plus its React / Babel
/ Tailwind libraries are **bundled offline** under `PocketGMSoccer/Web/`, so the
app runs with no internet connection and saves persist on the device.

## The game
Manage one club across two divisions: pick your XI from a squad of
**multi-position players**, set a formation and tactics, sim a double
round-robin season, chase the league title (and promotion if you start in the
second tier), run in the domestic cup, work the transfer market and free agency,
develop youth-academy prospects, and build a dynasty over many seasons —
complete with goals/assists/clean-sheet leaders, season awards and a Hall of Fame.

## Run it on your MacBook AND your phone

### 1. In any browser via GitHub Pages (works on Mac *and* phone — recommended)
This repo ships a workflow (`.github/workflows/deploy-pages.yml`) that publishes
the game to GitHub Pages.

**One-time setup:** GitHub → **Settings → Pages → Build and deployment →
Source = GitHub Actions** (the workflow also tries to enable this on its first
run). Then push to `main` or run the workflow from the **Actions** tab. The run
prints the URL (like `https://<you>.github.io/PocketGM-Soccer-iOS/`).
- **MacBook:** open that URL in Safari/Chrome.
- **Phone:** open it in Safari → **Share → Add to Home Screen** for an offline
  app icon. Saves live on the device.

### 2. On your MacBook with no hosting
Everything is bundled, so just open the file:
```sh
open PocketGMSoccer/Web/index.html
```

### 3. As a native iOS app (Xcode)
1. `open PocketGMSoccer.xcodeproj`
2. Plug in your iPhone (tap **Trust** if asked).
3. Target → **Signing & Capabilities** → check *Automatically manage signing*,
   set **Team** to your Apple ID (change the Bundle Identifier if it's taken).
4. Pick your iPhone in the device dropdown, press **▶ Run**.
5. On the phone: **Settings → General → VPN & Device Management** → trust your
   Apple ID, then reopen the app.

> A free Apple ID works but the app expires after 7 days (just Run again).
> A paid Apple Developer account makes it permanent.

## Files
- `PocketGMSoccerApp.swift` — SwiftUI app entry point.
- `ContentView.swift` — loads `Web/index.html` in a full-screen `WKWebView`.
- `PocketGMSoccer/Web/index.html` — the entire game (single-file React, JSX
  transpiled in-page by the vendored Babel). `Web/vendor/` holds the offline
  React/Babel/Tailwind.
README

# 4) GitHub Pages workflow (serves the game at the site root)
cat > "$TARGET/.github/workflows/deploy-pages.yml" <<'WORKFLOW'
name: Deploy game to GitHub Pages

# Publishes the offline web game to GitHub Pages so it can be opened from any
# browser — Mac or phone — at one URL. The native iOS app is unaffected.

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Assemble site
        run: |
          mkdir -p _site
          cp -R PocketGMSoccer/Web/. _site/
          cp _site/index.html _site/404.html
      - name: Setup Pages
        uses: actions/configure-pages@v5
        with:
          enablement: true
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: _site
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
WORKFLOW

# 5) init the new repo
cd "$TARGET"
git init -q -b main
git add -A
git commit -q -m "Pocket GM — Soccer: standalone iOS app + offline web game"

if [ -n "$REMOTE_URL" ]; then
  echo "→ Pushing to $REMOTE_URL"
  git remote add origin "$REMOTE_URL"
  git push -u origin main
  cat <<DONE

✅ Standalone repo created and pushed:
   local : $TARGET
   remote: $REMOTE_URL

Optional — enable the web version so it runs in any browser (Mac + phone):
   GitHub → Settings → Pages → Source = GitHub Actions.
   The included workflow then deploys on each push to main and prints the URL.
DONE
else
  cat <<DONE

✅ Standalone repo created and committed at:
   $TARGET

Next steps:
  1. Create a new EMPTY repo on GitHub named, e.g., PocketGM-Soccer-iOS
     (no README/license — keep it empty).
  2. Re-run this script with the repo URL to push automatically:
       ./scripts/new-soccer-repo.sh "$TARGET" git@github.com:<your-username>/PocketGM-Soccer-iOS.git
     ...or wire it up by hand:
       cd "$TARGET"
       git remote add origin git@github.com:<your-username>/PocketGM-Soccer-iOS.git
       git push -u origin main
  3. (Optional) Enable the web version: GitHub → Settings → Pages →
     Source = GitHub Actions. The workflow then deploys on each push to main.
DONE
fi

echo ""
echo "The original repo at $SRC_ROOT was not touched."
