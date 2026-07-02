---
name: reel-cloner
description: Clone any viral reel with your own consistent AI model — ONE skill, start to finish. Drop in a reel (file or link) + your model's reference images; the skill watches the reel, writes the full per-second Seedance 2.0 prompt package, fires the generation on WaveSpeed, checks the draft, and finalizes at 720p. Triggers: "clone this reel", "rebuild this reel with my model", "make my model do this reel", "clone the reel with <name>", a reel file/link plus a model name.
---

# reel-cloner

Input: a reel (`.mp4` file or link) + your model's refs in `characters/<name>/refs/` (4–6 consistent images,
face first). Output: the same reel FORMAT with YOUR model — `clip-final.mp4`, ready for Topaz.

You clone the **mechanic** — never the person, their face, handle, exact lines, or their file
(`references/legal-and-teardown.md`). **The default path needs nothing but ffmpeg — no Python, no Whisper.**

## Workflow — 6 steps, one conversation

### 1 · Get the reel
- **File given?** Use it directly.
- **Link given?** run `scripts/download.sh` with `--url <link> --slug <YYYY-MM-DD-slug>` (yt-dlp). If the
  platform blocks it (private IG): tell the user to save it via any reel-downloader site and drop the file in.

### 2 · Extract frames
```
scripts/extract-frames.sh --mp4 <reel.mp4> --slug <YYYY-MM-DD-slug> --out reels
```
→ `reels/<slug>/frames/` (1 per second) + `contact-sheet.jpg` (the whole reel on one image).

### 3 · WATCH it (agent vision — the magic step)
Read the contact sheet (open single frames where detail matters) and note, right in the conversation:
- **Hook** (first ~1s): what stops the scroll.
- **Beats + timing:** frame-07 = second 7. Read the burned captions IN ORDER — caption changes between
  frames give the line timing at ~1s resolution. That IS the transcript + pacing for most reels.
- **Who speaks (lip-check):** her mouth moving on a frame = she says that line; mouth closed while a caption
  shows = off-camera voice. Mark each line S (on-cam) or O (off-cam).
- **Camera/style/LENS:** selfie or POV (whose arm is in frame?), setting, light, fisheye/vignette look.
- No burned captions? Ask the user to type what's being said (they can hear it), map it onto the frame timing.
- *Pro precision (optional, never required):* `scripts/transcribe.sh` for word-level timing (Whisper, needs
  Python) · `scripts/diarize-speakers.sh` for voice-based speaker labels (advanced).

### 4 · Write the per-second package → `reels/<slug>/prompt.txt`
Mirror `references/examples.md` (shape A: hero dialogue with real pauses · shape B: CTA one flowing sentence).
Blocks: SETUP · RULE · IMAGE REFERENCE MAP · PROMPT (scene + outfit + LENS + camera, ONE continuous take) ·
PACING · DIALOGUE + PER-SECOND TIMELINE (S/O, pauses as intentional silence) · SECTIONS 1–4 · scene-locks · NEGATIVE.

**Hard rules (bake into every package):**
1. **Never describe the person** — identity comes ONLY from the reference images ("the woman from the
   reference images… keep her face and identity exactly as in the reference images").
2. **Outfit from the PROMPT** (+ 1–2 dedicated outfit refs) — never rely on outfits inside face refs.
3. **Describe the LENS** — fisheye selfie distortion, vignette if the reference has it. The lens is part of the look.
4. **ONE camera POV** — decide who holds the phone (whose arm is in frame); ambiguity renders doubled arms.
5. **Pose lock** — one stable selfie pose, phone in hand; no walk-ins, no pose change, no walking out.
6. **PACING:** match the original's word budget + pause structure. Fewer words = slower = human. Hero keeps
   pauses; CTA is one flowing sentence. Connect short fragments ("…but you didn't") — isolated lines sound AI.
7. Direct selfie, NO mirror (+ negative it). Overlays/captions go in the EDIT, never in the generation.

### 5 · Draft → check → fix
```
scripts/clone.sh --name <model> --package reels/<slug>/prompt.txt        # 480p draft (~$1.50)
```
WATCH the draft (extract a contact sheet from it if needed) and QA:
identity holds all 15s? · mouth timing matches the timeline? · S/O voices on the right lines? · one continuous
shot? · pose held, no mirror? · pacing has the real pauses? · tone right?
Something off → fix via the bug→fix table in `references/settings-lock.md`, re-draft (2–4 runs max).

### 6 · Final
```
scripts/clone.sh --name <model> --package reels/<slug>/prompt.txt --final   # ONE 720p final (~$3)
```
Then upscale to 1080×1920 with Topaz Video AI. **Never generate at 1080p/4k** — 720p + Topaz looks the same
for a fraction of the price.

## Anti-patterns
- Do NOT require Whisper/Python/extra accounts — frames + captions are the default analysis path.
- Do NOT describe the model's face/hair/body in the prompt — that's how identity drifts.
- Do NOT iterate at 1080p/4k — drafts at 480p, ONE final at 720p, Topaz does the rest.
- Do NOT feed dialogue chopped word-by-word — flowing sentences with timed pauses.
- Do NOT use reference audios "for voice consistency" — dub in the edit instead; never TTS as a voice ref.
- Do NOT skip watching the draft before firing the final.
- Do NOT copy the person from the reference reel — format only; never republish their file.

## QA — before you call it done
- `reels/<slug>/` has: frames/, contact-sheet.jpg, prompt.txt, clip-draft.mp4, clip-final.mp4.
- The final passed the step-5 checklist and the user was told: Topaz → 1080×1920.
- The package never describes the person; refs carried the identity.
