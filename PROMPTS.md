# The 3 prompts — copy & paste into Claude Code

> Open a terminal → `cd reel-machine` → `claude` → paste the prompts in order.
> The skills load automatically (they live in `.claude/skills/`). Nothing to install, nothing to import.

## Prompt 1 — analyze the reel (skill: reel-intake · free)

```
Clone this reel: <REEL-LINK>
Download it, extract every frame and the word-timed transcript, then watch it and write the teardown.
```

If the download is blocked (private IG accounts): save the reel via any reel-downloader site, then:

```
Clone this reel — the file is at <path/to/reel.mp4>, original link: <REEL-LINK>.
Extract every frame and the word-timed transcript, then watch it and write the teardown.
```

→ Output: `intake/<slug>/` with reference.mp4, frames/, contact-sheet.jpg, teardown.md, transcript + words.json

## Prompt 2 — generate the clone (skill: seedance-prompter · 480p draft ≈ $1.50)

```
Now clone the reel with my model <name>. Write the full per-second Seedance prompt package,
then fire the 480p draft on WaveSpeed and check it.
```

→ Output: `reels/<slug>/prompt.txt` + `clip-draft.mp4` (Claude reviews its own draft)

## Prompt 3 — the final (≈ $3)

```
The draft looks good — generate the 720p final with the same package.
```

→ Output: `clip-final.mp4` → upscale to 1080×1920 with Topaz Video AI. Done.
