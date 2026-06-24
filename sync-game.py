#!/usr/bin/env python3
"""
Refresh the bundled game from the live web version.

The native app ships a COPY of ~/baseball-gm/index.html inside Web/ so it runs
fully offline. This script re-copies the current game and swaps its CDN <head>
(React/Babel/Tailwind from the internet) for the locally vendored copies under
Web/vendor/, plus the mobile viewport + safe-area styling. The original game
file is never modified.

Usage:  python3 sync-game.py
Then rebuild/reinstall from Xcode (the bundled HTML is a build resource).
"""
import os, sys

SRC = os.path.expanduser("~/baseball-gm/index.html")
DST = os.path.join(os.path.dirname(os.path.abspath(__file__)), "PocketGMBaseball", "Web", "index.html")

CDN_HEAD = '''<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Pocket GM — Baseball</title>
<script src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
<script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
<script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<style>
  body { background:#0b1220; color:#e5e7eb; }
  ::-webkit-scrollbar{width:10px;height:10px}
  ::-webkit-scrollbar-thumb{background:#27324a;border-radius:6px}
  ::-webkit-scrollbar-track{background:#0b1220}
  .tnum{font-variant-numeric:tabular-nums}
</style>'''

OFFLINE_HEAD = '''<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover, maximum-scale=1, user-scalable=no" />
<title>Pocket GM — Baseball</title>
<script src="vendor/react.production.min.js"></script>
<script src="vendor/react-dom.production.min.js"></script>
<script src="vendor/babel.min.js"></script>
<script src="vendor/tailwind.js"></script>
<style>
  html { background:#0b1220; }
  body { background:#0b1220; color:#e5e7eb;
    padding: env(safe-area-inset-top) env(safe-area-inset-right) env(safe-area-inset-bottom) env(safe-area-inset-left);
    -webkit-text-size-adjust:100%; -webkit-tap-highlight-color:transparent; }
  ::-webkit-scrollbar{width:10px;height:10px}
  ::-webkit-scrollbar-thumb{background:#27324a;border-radius:6px}
  ::-webkit-scrollbar-track{background:#0b1220}
  .tnum{font-variant-numeric:tabular-nums}
</style>'''

def main():
    if not os.path.exists(SRC):
        sys.exit("Source game not found at " + SRC)
    html = open(SRC, encoding="utf-8").read()
    if CDN_HEAD not in html:
        sys.exit("Could not find the expected CDN <head> block in the source game — "
                 "the head must have changed. Update CDN_HEAD in this script.")
    html = html.replace(CDN_HEAD, OFFLINE_HEAD, 1)
    open(DST, "w", encoding="utf-8").write(html)
    print("Synced %d bytes -> %s" % (len(html), DST))
    print("Now rebuild/reinstall from Xcode (Run ▶).")

if __name__ == "__main__":
    main()
