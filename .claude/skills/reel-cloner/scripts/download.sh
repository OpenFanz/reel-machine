#!/usr/bin/env bash
# download.sh — reel-intake step 1: try to download the reel straight from its link (yt-dlp).
# Works for TikTok / YouTube Shorts / most public Instagram reels. If it fails (private / login-walled),
# fall back to a reel-downloader site and drop the .mp4 in manually.
# Usage: download.sh --url <reel-link> --slug <YYYY-MM-DD-slug> [--out intake]
set -euo pipefail
URL="" SLUG="" OUT="intake"
while [ $# -gt 0 ]; do case "$1" in
  --url) URL="$2"; shift 2;; --slug) SLUG="$2"; shift 2;; --out) OUT="$2"; shift 2;;
  *) echo "unknown arg: $1" >&2; exit 1;; esac; done
[ -n "$URL" ] || { echo "missing --url <reel-link>"; exit 1; }
[ -n "$SLUG" ] || { echo "missing --slug (e.g. 2026-07-01-elevator-reveal)"; exit 1; }

if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "→ installing yt-dlp (one-time)…"
  pip install -q yt-dlp || pip3 install -q yt-dlp || brew install yt-dlp 2>/dev/null \
    || { echo "couldn't install yt-dlp — install manually (pip install yt-dlp) OR download the reel via a reel-downloader site and pass the .mp4 to extract-frames.sh"; exit 1; }
fi

DEST="$OUT/$SLUG"; mkdir -p "$DEST"
echo "→ downloading reel…"
if yt-dlp -q --no-warnings -f "mp4/bestvideo*+bestaudio/best" --merge-output-format mp4 \
     -o "$DEST/reference.mp4" "$URL"; then
  echo "$URL" > "$DEST/source-link.txt"
  echo "✓ $DEST/reference.mp4 (+ source-link.txt)"
  echo "  Next: scripts/extract-frames.sh --mp4 $DEST/reference.mp4 --slug $SLUG"
else
  echo "✗ direct download blocked (private account / login wall — Instagram often does this)."
  echo "  Fallback: save the reel via any reel-downloader website, then:"
  echo "  scripts/extract-frames.sh --mp4 <your-downloaded.mp4> --slug $SLUG"
  exit 2
fi
