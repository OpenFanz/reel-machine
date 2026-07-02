# Reel Machine — clone any viral AI reel with YOUR own consistent model

Take a reel that's **already going viral**, rebuild it in **Seedance 2.0** with **your own AI model** — same
face, same body, every time. Runs inside **Claude Code**; you type English, Claude fires the generations.

## What you get — ONE skill, start to finish
**`reel-cloner`** — drop in a reel (file or link) and name your model. Claude downloads it, extracts every
frame, *watches* it, writes the full per-second Seedance 2.0 prompt, fires the generation on WaveSpeed,
self-checks the draft, and finalizes at 720p. One sentence in, one reel out.

**You bring your model's reference images** (4–6 consistent shots, in `characters/<name>/refs/`). Don't have a
consistent model yet? Building one is the `_skool/character-builder` bonus (that's the "owned asset" part).

## The one rule that makes it work
**Identity comes ONLY from reference images — never from words.** You never describe your model's face/hair/body
in a prompt (that causes drift). You describe the *outfit* and the *scene*; her identity is carried by the refs.

## Setup (once, ~2 min)
```bash
./setup.sh          # installs the WaveSpeed CLI, checks jq + ffmpeg, logs you in
```
You need: Claude Code, a [WaveSpeed](https://wavespeed.ai) account + API key (pay-per-generation, no subscription).
**One key does both the images (Nano Banana Pro) and the videos (Seedance 2.0).**

## Cost (WaveSpeed, pay per generation)
- Character images: ~$0.14 each (Nano Banana Pro).
- Reel clip: ~$1.50 per 480p draft → ~$3 for ONE 720p final (Seedance 2.0, 15s).
- **The trick:** never generate at 1080p/4k — finalize at 720p and upscale to 1080×1920 with Topaz Video AI.
  Same look, a fraction of the price, even posting every day.

## The flow
```
[setup]    put your model's 4–6 reference images in  characters/<name>/refs/
[per reel] here's a viral reel   + the link          → reel-intake → seedance-prompter → your reel
```

## No-install fallback
Don't want to install anything? Let Claude write the prompts and paste them into the WaveSpeed website
(wavespeed.ai) yourself. Slower, but zero setup.

> Tools you don't own the rights to (a creator's face/voice, copyrighted audio) are for FORMAT study only —
> rebuild the *structure* with your own model and your own/licensed audio. Never republish someone else's file.
