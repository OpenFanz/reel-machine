---
name: reel-intake
description: Turn a viral short-form reel into a precise teardown that an AI agent can rebuild — download it from the link, extract every frame + a contact sheet, pull the word-timed transcript, and "watch" it beat by beat. Step 1 of the Reel Machine (do this first — you need the reel you want to clone). Triggers: "clone this reel", "here's a viral reel", "analyze this reel/short", "intake", "rebuild this video".
---

# reel-intake

Goal: understand EXACTLY how a viral reel is built, so `seedance-prompter` can rebuild the *format* with your
own model. You clone the mechanic — never the person, their face, handle, exact lines, or their file.

## Input → Output
- **Input:** the reel's link (and/or its `.mp4` if you already saved it).
- **Output (in `intake/<slug>/`):** `reference.mp4` + `frames/` + `contact-sheet.jpg` + `teardown.md` (how it's built, beat by beat) + `transcript.txt` / `words.json` with word timing.

## Steps

1. **Download the reel.** Try the link first:
   ```
   scripts/download.sh --url <reel-link> --slug <YYYY-MM-DD-slug>
   ```
   (Uses yt-dlp — works for TikTok, YouTube Shorts, most public Instagram reels.) If the platform blocks it
   (private / login wall), save the reel via any reel-downloader website instead, drop the `.mp4` in, and keep
   the original link — it goes in the teardown as the source.
2. **Extract frames + contact sheet:**
   ```
   scripts/extract-frames.sh --mp4 <ref.mp4> --slug <YYYY-MM-DD-slug> [--out intake]
   ```
   This writes 1-fps frames + a 4×4 contact sheet (the whole reel on one image).
3. **Watch it (agent vision).** READ the contact sheet + frames and write `teardown.md`:
   - **Hook (first ~1s):** what stops the scroll.
   - **Beats + timing:** what happens each second; the turn/twist; the ending.
   - **On-screen (burned) captions** in order (read them off the frames).
   - **Camera/style:** selfie/handheld, setting, mood, pacing (fast/sparse).
   - **Why it went viral:** the *mechanic* (e.g. series+timer hook → micro-dialogue → withhold → debatable twist → expectation-breaking reaction → comment bait).
4. **Exact word timing** — transcribe with word timestamps:
   ```
   scripts/transcribe.sh --mp4 <ref.mp4> --out intake/<slug>
   ```
   (Installs `openai-whisper` if missing.) The word-level gaps ARE the pacing recipe the cloner needs.
5. **WHO speaks each word (speaker attribution) — do NOT guess this.** Whisper gives words + timing but NOT the speaker; guessing she-vs-off-cam-man from context gets it wrong and ruins the clone (wrong voice on a line, or an invented two-person back-and-forth that's actually a one-person monologue). Nail it with **two signals**:
   - **Diarization (voice-based):** run `scripts/diarize-speakers.sh` with the ref mp4 + `words.json` → labels every word by voice (SPEAKER_00/01…). One dominant speaker = it's a monologue (one voice — best for Seedance lip-sync); two balanced speakers = a real duet.
   - **Lip-check (visual):** dense frames (`ffmpeg -vf "fps=2,crop=iw:ih*0.5:0:ih*0.05"`) — HER mouth moving = she speaks; mouth closed = off-camera. Use it to map which SPEAKER label is on-camera, and to catch silent beats (she looks away, someone else talks).
   Setup once: `pip install --user --break-system-packages pyannote.audio`; on huggingface.co accept the gated `pyannote/speaker-diarization-community-1`; HF token in the env. **Feed the correct attribution into the seedance prompt — single voice vs two voices changes the whole package.**

## No-bash fallback (any AI agent, any OS)
The scripts are thin wrappers — if you can't run bash (Windows without WSL, a different agent), run the
equivalents directly; the output contract is the same (`intake/<slug>/` with the files above):
- Download: `yt-dlp -f "mp4/bestvideo*+bestaudio/best" --merge-output-format mp4 -o intake/<slug>/reference.mp4 <link>`
- Frames: `ffmpeg -i reference.mp4 -vf fps=1 intake/<slug>/frames/frame-%03d.png`
- Contact sheet: `ffmpeg -i reference.mp4 -vf "fps=1,scale=320:-1,tile=4x4" intake/<slug>/contact-sheet.jpg`
- Transcript: `whisper reference.mp4 --model small --word_timestamps True --output_format json --output_dir intake/<slug>`

## The teardown is the handoff
`seedance-prompter` reads `teardown.md` (+ word timing) to set the reel's word budget, pause structure,
and beat map. Keep the FORM, change the content: your niche/angle, your model, your own or licensed audio.

## Anti-patterns
- Do NOT skip the contact sheet and "analyze" the reel from the transcript alone — the visual beats (pose, camera, captions, the twist) live in the frames.
- Do NOT guess speaker attribution from context — diarize + lip-check (step 5). This is the #1 clone-killer.
- Do NOT copy the person: no face, no handle, no exact lines, never republish their file. Format only.
- Do NOT write the teardown as a vibe summary — every beat needs a timestamp; the cloner works per second.
- Do NOT dump 100 frames into context — the contact sheet first; open single frames only where detail matters.

## QA — before handing off to seedance-prompter
- `intake/<slug>/` has: reference.mp4, frames/, contact-sheet.jpg, teardown.md, transcript.txt + words.json.
- teardown.md has a per-second beat table, the burned captions in order, and the viral mechanic in one sentence.
- Speaker attribution is verified (diarization or lip-check), not guessed.
- The source link is recorded in the teardown.

## Legal / brand-safe
See `references/legal-and-teardown.md`. Short version: use the reference for FORMAT analysis only — mute the
original audio, don't republish the source file, don't copy the person's face/handle/exact lines.
