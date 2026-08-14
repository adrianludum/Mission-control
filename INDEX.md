# Mission Control — Project Index

The curated registry of tracked projects (Decision 2.3). This file is **machine-maintained**:
promotion ("sync with git X") appends a row; retirement ("retire X") removes one. It is
hand-editable too — but no workflow requires Adrian to remember to. `/mission` reads this
file first; only repos listed here appear on the board.

**To change what is tracked, edit [`CANDIDATES.md`](CANDIDATES.md), not this file** (Decision 9.3).
The roster is the control surface — tick to enrol, untick to retire — and `/roster` writes the
resulting rows here. This file is the output of that decision, not the place to make it.

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
| ULBC-salesforce | adrianludum/ULBC-Salesforce | mac-mini | ~/Projects/ULBC-salesforce | — | active | 2026-08-12 (enrolled) | Phase 7 (Gift Aid claims, Stripe-as-rail) in production since 2026-07-09. Root doc set (PRD/DECISIONS/OPEN-QUESTIONS) is authoritative; `.mission/` defers to it |
| Drone Rowing Analysis | adrianludum/drone-rowing-analysis | mac-mini | ~/Projects/drone-rowing-analysis | — | active | 2026-08-12 (enrolled) | Track-A synthetic CV engine passing (A0–A6); Phase-0 shoot is the kill-or-continue gate. `docs/` set authoritative |
| BoatHUB | adrianludum/BoatHUB | mac-mini | ~/Projects/rowing/boat-hub | — | dormant | 2026-08-12 (enrolled) | Last real work 2026-02-19. **Seed drift**: `.mission/` is on branch `claude/mission-control-roster-update-abe98y`, not main — merge needed before the board can read it. Nested path |
| Race Timing | adrianludum/race-timing-app | mac-mini | ~/Projects/events/race-timing-app | — | dormant | 2026-08-14 | Flutter + Firebase RTDB timer **for coaches timing crews**: N crews × N timing points, undo, OBS overlays. Shares Firebase project with Broadcast Timing App but is a separate product — do not retire either as the other's prototype. Nested path |
| AI Gym Hub | adrianludum/ai-gym-hub | mac-mini | ~/Projects/fitness/ai-gym-hub | — | dormant | 2026-08-12 (enrolled) | ESP32 scanners → coordinator → Pi bridge → Firebase gym BLE capture. Overlaps Gym Hub — supersession undecided. Nested path |
| Gym Hub | adrianludum/gym-hub | mac-mini | ~/Projects/fitness/gym-hub | — | dormant | 2026-08-12 (enrolled) | Later iteration: "No Pi" ESP32 firmware + SwiftUI AthleteApp; likely supersedes AI Gym Hub — undecided. Nested path |
| Broadcast Timing App | adrianludum/broadcast-timing-app | mac-mini | ~/Projects/events/broadcast-timing-app | — | active | 2026-08-14 | Single-file React + Firebase timer for **live-filmed** racing: event codes, role links, OBS overlay, CSV. Renamed throughout from "Timer App" 2026-08-14. Server time + atomic split advance landed; first test added. Adrian's active track. Not Race Timing's prototype — separate product. Nested path |
