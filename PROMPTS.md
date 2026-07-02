# The 2 prompts — copy & paste into Claude Code

> Open a terminal → `cd reel-machine` → `claude` → paste. ONE skill does everything: `reel-cloner`
> (loads automatically from `.claude/skills/`). Nothing to install, nothing to import.

## Prompt 1 — reel in, draft out (480p ≈ $1.50)

```
Clone this reel with my model <name>: <REEL-LINK or /path/to/reel.mp4>
Watch it, write the full per-second Seedance prompt package, then fire the 480p draft on WaveSpeed and check it.
```

→ Claude downloads (if a link), extracts the frames, watches the reel, writes `reels/<slug>/prompt.txt`,
fires the draft and reviews it itself.

## Prompt 2 — the final (720p ≈ $3)

```
The draft looks good — generate the 720p final with the same package.
```

→ `clip-final.mp4` → upscale to 1080×1920 with Topaz Video AI. Done.

---
If the draft has an issue, just say what ("she rushes the lines" / "loses the phone") — the skill fixes it
via its bug→fix table and re-drafts.
