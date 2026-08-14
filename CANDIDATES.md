# Mission Control — Project Roster

**This is the control surface for what appears on the board.** Tick a box to enrol a project;
untick one to retire it. Nothing else is required — say `/roster` in any Claude session and the
ticks are applied: newly ticked projects get wired, seeded and indexed; newly unticked ones are
removed from `INDEX.md` and drop off the board.

Editing the ticks by hand is fine (it is just a markdown file, editable on a phone). Telling a
session in plain English — "enrol pdf-editor", "retire HRR", "ignore the events scaffolds" —
does the same thing and keeps this file in sync.

**Retiring is not deleting.** A retired project keeps its repo, its `.mission/` folder and its
history; it simply stops being rendered. Re-tick it any time.

*Roster surveyed 2026-08-12. Facts (branch, dirt, last commit) come from `snapshot/mac-mini.md`
and are refreshed by `/roster`; this file records decisions, not live state. Ticks applied by
`/roster` 2026-08-12 (cloud session): 7 enrolled, Campaign CRM ticked but held on its blocker.*

---

## Enrolled — on the board

- [x] **Mission Control** — `~/Projects/mission-control` — `adrianludum/Mission-control`
- [x] **Ludum v2** — `~/Projects/app.ludum` — `adrianludum/appludumv4`
- [x] **Trip HQ** — `~/Projects/familysite` — `adrianludum/familysite`
- [x] **imagesAi** — `~/Projects/imagesAi` — `adrianludum/ImageAI`
- [x] **World Rowing Results** — `~/Projects/World Rowing Results` — `adrianludum/WorldRowingResults`
- [x] **Training Status** — `~/Projects/training_status` — `adrianludum/training-status`
- [x] **HRR 2026 Commentator Dossier** — `~/Projects/HRR-Commentator-2026` — `adrianludum/hrr`
- [x] **Learn a Language** — `~/Projects/language` — `adrianludum/language`
- [x] **ULBC-salesforce** — `~/Projects/ULBC-salesforce` — `adrianludum/ULBC-Salesforce`
- [x] **Drone Rowing Analysis** — `~/Projects/drone-rowing-analysis` — `adrianludum/drone-rowing-analysis`
- [x] **BoatHUB** — `~/Projects/rowing/boat-hub` — `adrianludum/BoatHUB`
- [x] **Race Timing** — `~/Projects/events/race-timing-app` — `adrianludum/race-timing-app`
      *For coaches timing their own crews. Shares the Firebase project `timerapp-31f63` with Broadcast Timing App but is a separate product — do not retire either as the other's prototype (its Decision 0.5).*
- [x] **AI Gym Hub** — `~/Projects/fitness/ai-gym-hub` — `adrianludum/ai-gym-hub`
- [x] **Gym Hub** — `~/Projects/fitness/gym-hub` — `adrianludum/gym-hub`
- [x] **Broadcast Timing App** — `~/Projects/events/broadcast-timing-app` — `adrianludum/broadcast-timing-app`
      *Renamed throughout on 2026-08-14 (was "Timer App" / `timer-app`); board, folder and repo now agree. Times races being filmed live — distinct product from Race Timing (coaches timing crews), not its prototype.*

## Candidates — ready to enrol, tick to add

Clean trees with real remotes. Nothing needs fixing first.

- [ ] **Regatta Stream** — `~/Projects/live-video-streaming` — `adrianludum/regatta-stream`
      White-label live + on-demand event streaming (Next.js). 1 modified, 2 untracked.
- [ ] **The Team Builder** — `~/Projects/the-team-builder` — `adrianludum/the-team-builder`
      Astro site, live at theteambuilder.co.uk. Clean tree.
- [ ] **Chief of Staff** — `~/Projects/Chief of Staff` — `adrianludum/the-chief`
      Next.js app, deployed via Vercel. Clean tree.
- [ ] **Ludum Events marketing** — `~/Projects/ludumevents-marketing` — `adrianludum/ludumeventWeb`
      ludumevents.com marketing page — single static HTML, no build step. Clean.
- [ ] **PDF Editor** — `~/Projects/pdf-editor` — `adrianludum/pdf-editor`
      Python (uv) local PDF-in/PDF-out editor — edit text as markdown, keep images. Clean.

## Needs work before enrolling

Ticking these is allowed — `/roster` will tell you what it hit and stop that project rather than guess.

- [ ] **Ludum Event** — `~/Projects/ludum-event` — `adrianludum/ludum-event`
      Next.js 16 + Supabase regatta organiser. **14 branches with no upstream** (claude/phase3-8, design/01-20) — triage branches first or the board reads as chaos.
- [ ] **Ludum Website** — `~/Projects/new-ludum-website 2` — `adrianludum/ludum-website`
      Next.js marketing site, clean tree, 944M. **Folder name is a Finder duplicate** (" 2") — rename before enrolling so `INDEX.md` does not carry it.
- [ ] **new-ludum** — `~/Projects/new-ludum` — `adrianludum/new-ludum`
      Monorepo skeleton (`apps/`, `packages/`, `discovery/`). **Confirm it is not superseded by Ludum v2** before enrolling.
- [x] **Campaign CRM** — `~/Projects/ludum-campaigns` *or* `~/Projects/ludum-outreach` — `adrianludum/Campaign_CRM`
      **Both folders are working copies of the same remote**, on different feature branches 3 months apart. Pick which is canonical, merge or retire the other, then enrol once. **owner: Adrian**
      *Ticked 2026-08-12; `/roster` stopped it here rather than guess — enrolment (seed + index) runs automatically once the canonical folder is decided.*

## Nested repos — surveyed, undecided

Sixteen repos live inside container folders (`events/`, `fitness/`, `rowing/`, …) that the reporter's
depth-1 scan never sees. Almost all carry a single bulk `Initial commit` / `Sync: commit local changes`
from `sync-repos.sh` on 2026-06-12 — one artificial commit, not development history. Listed so the
decision is recorded rather than forgotten. *Four of the sixteen (Race Timing, AI Gym Hub, Gym Hub,
Timer App) were enrolled 2026-08-12 and moved to Enrolled above.*

- [ ] **Rowing Analyser** — `~/Projects/rowing/rowing-analyser` — `adrianludum/PacingChart` — Python pacing/stroke analysis
- [ ] **Rowing HR Hub (Pi)** — `~/Projects/rowing/rowing-hr-hub-pi` — `adrianludum/rowing-hr-hub-pi` — Raspberry Pi heart-rate hub for boats
- [ ] **Coach Dashboard** — `~/Projects/rowing/coach-dashboard` — `adrianludum/coach-dashboard` — React real-time athlete monitoring
- [ ] **NSR Analysis** — `~/Projects/rowing/data/nsr-analysis` — `adrianludum/nsr-analysis` — NSR results analysis; oldest repo on the box (last real work 2025-06-03)
- [ ] **My Event App** — `~/Projects/events/my-event-app` — `adrianludum/my-event-app` — React Native event app
- [ ] **Make A-Levels Easy** — `~/Projects/make-alevels-easy/makealevelseasy` — `adrianludum/makealevelseasy` — A-levels revision site
- [ ] **Loom Scraper** — `~/Projects/Loom Video scraper/ludum-loom-package` — `adrianludum/ludum-loom-package` — `ludum-loom-cli`, 1 unpushed commit
- [ ] **Modern Event App** — `~/Projects/events/modern-event-app` — `adrianludum/ModernEventApp` — event app, no description
- [ ] **Female Health App** — `~/Projects/fitness/female-health-app` — `adrianludum/female-health-app` — has `discovery/` + CLAUDE.md, no README
- [ ] **Event Sphere** — `~/Projects/events/event-sphere` — `adrianludum/event-sphere` — Expo starter, barely past scaffold

## Ignored — not projects

Recorded so each survey does not re-ask. Say "reconsider &lt;name&gt;" to move one back to candidates.

| Folder | Why ignored |
|---|---|
| `_dashboard` | The hand-rolled ancestor of Mission Control itself (`scan.py` + `server.py`). Superseded by this repo — its `SKIP_DIRS`/`NOISE_PARTS` lists are worth stealing for the reporter's exclusions before retiring it |
| `wrr-worktrees` | **9.7G** of dead git worktrees of World Rowing Results; every `.git` file points at the old `/Users/adriancassidy` home path and all four report `prunable`. Reclaimable space, not a project |
| `_archive` | Self-declared archive (`boat-hub-v1`, `mako-analyzer-v1`) of zips and Finder duplicates. Contains `boathub-web (old)` — no remote, 5 modified, 2 unpushed commits — and **two Firebase service-account private keys** (verified never committed to any remote; they are loose files) |
| `ludum-app` | 4K stub holding only `.claude/settings.local.json`. Name collides with the enrolled `app.ludum` |
| `UK Domestic Results` | 4K stub holding only `.claude/settings.local.json` |
| `ludum-website` (folder) | 169M of brand assets and demo pages, no code, no git. Not the same thing as the `ludum-website` *repo* checked out at `new-ludum-website 2` |
| `ULBC` | 57M of US college rowing documents, no code |
| `Active tools telem` | One-off analysis: FIT/oarlock data → figures, CSVs and a PDF writeup |
| `Claude` | A skill file plus a zip of itself |
| `NSR DOCS` | A single generic `AGENTS-TEMPLATE.md` |
| `OpenClaw` | Two .docx files, one a stale Word lock file |
| `supabase-functions` | Effectively empty — two dirs containing only a `.DS_Store` |
| `calendlycopy`, `untitled folder` | Empty (0B) |
| `events`, `fitness`, `rowing`, `make-alevels-easy`, `Loom Video scraper` | Container folders, not projects. Their *nested repos* are listed above |
