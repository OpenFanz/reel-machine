---
name: reel-intake
description: Turn a viral short-form reel into a precise teardown that an AI agent can rebuild — download it, extract every frame + a contact sheet, and "watch" it beat by beat. Step 1 of the Reel Machine (do this first — you need the reel you want to clone). Triggers: "clone this reel", "here's a viral reel", "analyze this reel/short", "intake", "rebuild this video".
---

# reel-intake

Goal: understand EXACTLY how a viral reel is built, so `seedance-prompter` can rebuild the *format* with your
own model. You clone the mechanic — never the person, their face, handle, exact lines, or their file.

**Keep it simple: the default path needs NOTHING but ffmpeg (setup.sh checks it). No Python, no Whisper, no
extra accounts.** The optional Pro tools at the bottom only add precision — never require them from the user.

## Input → Output
- **Input:** the reel's link (and/or its `.mp4` if the user already saved it).
- **Output (in `intake/<slug>/`):** `reference.mp4` + `frames/` + `contact-sheet.jpg` + `teardown.md` (how it's built, beat by beat).

## Steps (default — zero extra installs)

1. **Download the reel.** Try the link first:
   ```
   scripts/download.sh --url <reel-link> --slug <YYYY-MM-DD-slug>
   ```
   If that fails (private / login wall — Instagram often blocks it): tell the user to save the reel via any
   reel-downloader website and drop the `.mp4` in — then continue with that file. Keep the original link for
   the teardown.
2. **Extract frames + contact sheet:**
   ```
   scripts/extract-frames.sh --mp4 <ref.mp4> --slug <YYYY-MM-DD-slug> [--out intake]
   ```
   1-fps frames + a 4×4 contact sheet (the whole reel on one image).
3. **Watch it (agent vision) — this is where the magic happens.** READ the contact sheet, open single frames
   where detail matters, and write `teardown.md`:
   - **Hook (first ~1s):** what stops the scroll.
   - **Beats + timing:** the frames are 1 per second — frame-07 = second 7. Read the burned captions off the
     frames IN ORDER: caption changes between frames give you the line timing at ~1s resolution. That IS the
     transcript + pacing for most reels.
   - **Who speaks (lip-check):** HER mouth open/moving on a frame = she says that line; mouth closed while a
     caption shows = an off-camera voice. Note it per line (S = on-cam, O = off-cam).
   - **Camera/style/LENS:** selfie or POV (whose arm is in frame?), setting, light, fisheye/vignette look.
   - **Why it went viral:** the *mechanic* in one sentence (e.g. call-out hook → withhold → debatable twist → comment bait).
4. **No burned captions and dialogue matters?** Ask the user to type what's being said (they can hear it —
   30 seconds of work), then map their lines onto the frame timing. Only suggest the Pro tools if they want
   exact word-level pauses.

## The teardown is the handoff
`seedance-prompter` reads `teardown.md` to set the reel's word budget, pause structure, and beat map.
Keep the FORM, change the content: your niche/angle, your model, your own or licensed audio.

## Pro precision (OPTIONAL — never required)
For exact word-level pause timing (instead of the ~1s caption timing):
```
scripts/transcribe.sh --mp4 <ref.mp4> --out intake/<slug>     # Whisper, auto-installs (needs Python)
```
For voice-based speaker labels on tricky multi-voice reels: `scripts/diarize-speakers.sh` (pyannote; needs a
HuggingFace token — advanced users only). The frame lip-check in step 3 covers 95% of reels without either.

## Anti-patterns
- Do NOT make the user install Whisper/Python/anything to get started — the frame-based path is the default.
- Do NOT skip the contact sheet and "analyze" from memory — the beats, captions and the twist live in the frames.
- Do NOT guess who speaks — lip-check the frames (mouth open vs closed per caption).
- Do NOT copy the person: no face, no handle, no exact lines, never republish their file. Format only.
- Do NOT write the teardown as a vibe summary — every beat gets its second (frame number = second).
- Do NOT dump 100 frames into context — contact sheet first; open single frames only where detail matters.

## QA — before handing off to seedance-prompter
- `intake/<slug>/` has: reference.mp4, frames/, contact-sheet.jpg, teardown.md.
- teardown.md has a per-second beat table (frame-derived), the captions/lines in order, speaker per line, and
  the viral mechanic in one sentence.
- The source link is recorded in the teardown.

## Legal / brand-safe
See `references/legal-and-teardown.md`. Short version: use the reference for FORMAT analysis only — mute the
original audio, don't republish the source file, don't copy the person's face/handle/exact lines.
