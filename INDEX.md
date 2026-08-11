# Mission Control — Project Index

The curated registry of tracked projects (Decision 2.3). This file is **machine-maintained**:
promotion ("sync with git X") appends a row; retirement ("retire X") removes one. It is
hand-editable too — but no workflow requires Adrian to remember to. `/mission` reads this
file first; only repos listed here appear on the board.

**Analytics source vocabulary** (Decision 8.2): `vercel:<project-name>` · `supabase:<project-ref>`
(counts `auth.users` unless Notes names another query) · `manual:<where the number lives>` · `—`
(no live users to count). /mission resolves these live when it has connector access and caches to
`snapshot/analytics.md`; connector-less renders (the hourly Routine) read the cache and label its age.

| Project | Repo (owner/name) | Host machine | Local path | Analytics source | Status | Born | Notes |
|---|---|---|---|---|---|---|---|
| Mission Control | adrianludum/Mission-control | mac-mini | ~/Projects/mission-control | — | active | 2026-08-10 | Tracks itself (dogfood, project #1). Local dir is lowercase |
| Ludum v2 | adrianludum/appludumv4 | mac-mini | ~/Projects/app.ludum | — | active | 2026-08-11 (enrolled) | Discovery/design only, no code yet. Real decision log is `ludum-decisions.md`, PRD is `ludum-prd.md` |
| Trip HQ | adrianludum/familysite | mac-mini | ~/Projects/familysite | supabase:ehytfctuapbfflkluaxx | active | 2026-08-11 (enrolled) | Live on Vercel. Auth is a name-switcher, not real auth. Mini was 29 commits behind at enrolment |
| imagesAi | adrianludum/ImageAI | mac-mini | ~/Projects/imagesAi | — | active | 2026-08-11 (enrolled) | PoC only — local CLIP + OCR search; not yet tested against a real library |
| World Rowing Results | adrianludum/WorldRowingResults | mac-mini | ~/Projects/World Rowing Results | — | active | 2026-08-11 (enrolled) | Publishes live to results.ludumevents.com; `data(live):` auto-commits every ~8 min during racing. Mini was 279 behind at enrolment |
| Training Status | adrianludum/training-status | mac-mini | ~/Projects/training_status | — | active | 2026-08-11 (enrolled) | Flutter + BLE. On unmerged branch `feat/resting-measurements`; on-device hardware test outstanding |
| HRR 2026 Commentator Dossier | adrianludum/hrr | mac-mini | ~/Projects/HRR-Commentator-2026 | vercel:hrr-qualifiers-2026 | dormant | 2026-08-11 (enrolled) | 2026 event has passed. 5 uncommitted files left untouched at enrolment; 2027 decision open |
| Learn a Language | adrianludum/language | mac-mini | ~/Projects/language | — | active | 2026-08-11 (enrolled) | M0 blocked on API keys + in-car test. `app/` and `server/` exist on disk but are **untracked** |
