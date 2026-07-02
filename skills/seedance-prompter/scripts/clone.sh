#!/usr/bin/env bash
# clone.sh — fire a Seedance 2.0 reel from a written prompt package + your model's refs.
# Draft @480p by default; --final does 720p (then upscale to 1080x1920 with Topaz — never gen at 1080p/4k).
# Calls wavespeed/ws-video.sh (settings-lock baked in).
#
# Usage:
#   clone.sh --name <model> --package reels/<slug>/prompt.txt [--voice <real-human-sample.mp3>] [--dur 15] [--final]
#   (refs are auto-loaded from characters/<model>/refs/*.png)
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; WSVID="$DIR/../../../wavespeed/ws-video.sh"
NAME="" PKG="" VOICE="" DUR="15" RES="480p" CHARS="characters"; TAG="draft"
while [ $# -gt 0 ]; do case "$1" in
  --name) NAME="$2"; shift 2;; --package) PKG="$2"; shift 2;; --voice) VOICE="$2"; shift 2;;
  --dur) DUR="$2"; shift 2;; --chars) CHARS="$2"; shift 2;; --final) RES="720p"; TAG="final"; shift;;
  *) echo "unknown: $1">&2; exit 1;; esac; done
[ -n "$NAME" ] && [ -f "$PKG" ] || { echo "need --name and --package <prompt file>" >&2; exit 1; }

REFDIR="$CHARS/$NAME/refs"
# portable (macOS ships bash 3.2 — no mapfile, no ${var^^})
REFS=()
while IFS= read -r f; do REFS+=("$f"); done < <(ls "$REFDIR"/*.png "$REFDIR"/*.jpg 2>/dev/null | head -6)
[ "${#REFS[@]}" -ge 1 ] || { echo "no reference images in $REFDIR — put your model's 4–6 refs there first (no consistent model yet? that's the Character Builder — link in the video description)" >&2; exit 1; }
TAG_UP="$(printf '%s' "$TAG" | tr '[:lower:]' '[:upper:]')"
echo "→ $TAG_UP @ $RES · model=$NAME · ${#REFS[@]} refs$([ -n "$VOICE" ] && echo " · voice ref")" >&2

OUTDIR="$(dirname "$PKG")"; OUT="$OUTDIR/clip-$TAG.mp4"
ARGS=(--prompt-file "$PKG" --out "$OUT" --res "$RES" --dur "$DUR")
[ -n "$VOICE" ] && ARGS+=(--voice "$VOICE")
"$WSVID" "${ARGS[@]}" "${REFS[@]}"
echo "✓ $OUT"
[ "$TAG" = draft ] && echo "  → watch clip-draft.mp4 (identity/pacing/pose/tone). Good? re-run with --final."
[ "$TAG" = final ] && echo "  → last step: upscale clip-final.mp4 to 1080x1920 with Topaz Video AI."
