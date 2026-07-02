---
name: seedance-prompter
description: Turn a reel teardown + your model's reference images into a finished Seedance 2.0 clip — write the full per-second prompt package, fire the generation on WaveSpeed (reference mode, native audio), self-check the draft, finalize at 720p and upscale with Topaz. Step 2 of the Reel Machine. Triggers: "clone the reel now", "write the seedance prompt", "generate the reel", "make my model do this reel", after reel-intake. Uses your pre-made model reference images in characters/<name>/refs/.
---

# seedance-prompter

Input: the `teardown.md` from `reel-intake` + your model's `characters/<name>/refs/`. Output: a finished reel clip
with YOUR model. The agent writes the package, `scripts/clone.sh` fires it, the agent checks the draft.

## Mode & settings — LOCKED (the wrapper hardcodes these; you can't misconfigure)
- Model: **`bytedance/seedance-2.0/text-to-video`** — reference mode, **NO start image** (Seedance makes the handheld opening itself → looks authentically UGC; identity held by the refs).
- **9:16 · Generate Audio ON · reference_audios empty · reference_videos empty · web search off.**
- **Reference images = your 4–6 character refs** (face first). Don't exceed ~6 — extra/near-dup refs dilute identity.
- **The cost ladder: 480p draft (~$1.50) → ONE 720p final (~$3) → Topaz-upscale to 1080×1920.** Never iterate at 1080p/4k — a 720p+Topaz final looks the same for a fraction of the price.

## Voice (important, tested)
- **Default = native Seedance audio.** Steer it in the prompt ("her voice is sweet and cute" / "cold, confident").
- **Cross-reel voice consistency:** dub the locked voice in the EDIT over the best visual take — do NOT chase it with reference audios (they make the voice come out different every run, and worse).
- **NEVER use an ElevenLabs / TTS clip as a voice reference** — TTS makes the native audio sound plastic/fake.

## Workflow
1. Read `teardown.md` (+ `words.json` word timing) from the intake.
2. Write the package (below) into `reels/<slug>/prompt.txt` — mirror `references/examples.md`.
3. Draft (480p): run `scripts/clone.sh` with `--name <model> --package reels/<slug>/prompt.txt`.
4. WATCH the draft (agent vision) → QA checklist below; fix bugs via the bug→fix table in `references/settings-lock.md`; re-draft (2–4 runs max).
5. Locked? re-run with `--final` (720p, same package) → upscale to 1080×1920 with Topaz Video AI.

## The package (into `reels/<slug>/prompt.txt`)
Mirror `references/examples.md` (two proven shapes: **A) hero dialogue body** with real pauses, **B) CTA talking-head** as one flowing sentence):
```
PROMPT           one paragraph: scene + outfit + LENS + camera + "ONE continuous take, no cuts, start mid-action". NEVER describe the person.
PACING           the key block (below)
DIALOGUE + PER-SECOND TIMELINE   S = on-cam (lip-sync) · O = off-cam voice; exact times + the PAUSES as intentional silence
SECTION 1 Effects Timeline · 2 Master Inventory · 3 Density Map · 4 Motion Flow
scene-lock lines ([POSE]/[CAMERA]/[WALLS]/…) · NEGATIVE
```

## PACING — the trick that makes it human, not AI
From the teardown's timing (frame-based ~1s beats by default; word-level if Whisper was run): match the
**word budget + pause structure** of the original.
- **Fewer words = SLOWER** (the model stretches the rest). Too many words → it rushes to cram them; cut words.
- **Hero dialogue** keeps pauses between lines ("each line lands, then a beat of silence"). ~half the clip can be silence.
- **CTA / one person** = the opposite: ONE flowing sentence, no gaps, normal conversational pace.
- Short isolated fragments ("you didn't") sound the most AI — connect them into the sentence ("…but you didn't") + a soft delivery note.

## Hard rules (bake into every package)
1. **Never describe the person** — identity from refs; "the woman from the reference images" + "keep her face and identity exactly as in the reference images".
2. **Outfit comes from the PROMPT** (+ 1–2 dedicated outfit refs if needed) — never bake outfits into the face refs; mixed-outfit refs fight each other.
3. **Describe the LENS, not just the scene** — viral UGC reels have an ultra-wide fisheye look with a dark rounded vignette border. Skip it and the clone looks flat/wrong.
4. **ONE camera POV** — decide from the reference who holds the phone (whose arm is in frame) and name only that holder; ambiguity renders doubled arms.
5. **Pose lock:** one stable selfie pose, phone always in hand; no leaning, no pose change, no walking out, no walk-in openings. (Fast body motion makes the face go AI — add the dynamic hook as a glitch intro in the EDIT.)
6. **Direct selfie, not a mirror** (+ negative the mirror). Endings: doors/exits open to the SIDE; she stays facing the lens; hold the last frame for the CTA.
7. **Kill model junk** (invented displays/text on walls) in prompt + negative. Overlays/captions are added in EDIT, never generated.

## Anti-patterns
- Do NOT describe her face/hair/body in the prompt — that's how identity drifts. Refs carry the identity.
- Do NOT iterate at 1080p/4k — drafts are 480p, the final is 720p + Topaz. Money burns fast otherwise.
- Do NOT feed the dialogue chopped word-by-word — write flowing sentences with timed pauses.
- Do NOT use reference audios "for consistency" — dub in the edit instead.
- Do NOT generate text/captions/overlays inside the clip — they're edit-layer.
- Do NOT skip watching the draft before firing the final.

## QA — every 480p draft, before the 720p final
- Identity holds the full clip (no drift, no face morph)?
- Mouth timing matches the per-second script; on-cam vs off-cam voices on the right lines?
- One continuous shot, no invented cuts; pose held, phone in hand; no mirror?
- Pacing has the REAL pauses (hero) / no dead gaps (CTA); tone right (no warm smile on a cold reveal)?
- Lens look present (fisheye + vignette) if the reference had it?
All pass → `--final` → Topaz upscale to 1080×1920. Lip-sync slurs? keep the best visual, dub in edit.
