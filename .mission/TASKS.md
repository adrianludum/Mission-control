# Mission Control — Tasks
*Blockers are entries marked **owner: Adrian** — jobs only he can do.*

## To do
- [ ] Create the hourly board-refresh Routine (Decision 7.1) — the create-trigger call needs in-session approval — **owner: Adrian** (say "create the board refresh routine" in any session and approve the tool call)
- [ ] Install the reporter at the Mac mini — follow `reporter/INSTALL.md` (~2 min: adjust paths, chmod, launchctl bootstrap) — **owner: Adrian** (must be at the machine)
- [ ] Run enrolment wave one — `/enrol` in a Claude Code session at the Mac mini, 3–5 real repos — **owner: Adrian** (picks the repos, approves pairing table)
- [ ] During build (Tier 2): Q7 analytics mapping, Q8 risk scoring (interim heuristic in /mission SKILL.md), Q14 agent-log sourcing
- [ ] At beta (Tier 3): notifications, sharing, trust acceptance test

## Done
- [x] 2026-08-11 — Build branch merged into the default branch (fast-forward, on Adrian's word from the plane); /mission + all skills now live on the default branch
- [x] 2026-08-11 — First live /mission render published as an artifact — read path + loud degradation proven end-to-end
- [x] 2026-08-11 — Build step 1: /mission skill v0 — INDEX.md registry, SKILL.md read path + rules, self-contained dashboard template (worm SVG wordmark, two bands, drill-down, launch pad; render-verified light/dark/mobile)
- [x] 2026-08-11 — Build step 2 (code): reporter script + launchd plist + INSTALL.md, tested end-to-end against fake repos incl. failure paths; only installation remains (see To do)
- [x] 2026-08-11 — Build step 3 (tooling): ten-file mission-seed templates + /enrol skill (pairing-table approval gate); only the wave run remains (see To do)
- [x] 2026-08-11 — Build step 4: mission-discipline skill + CLAUDE.md snippet for enrolled repos + this repo's own CLAUDE.md; break-in period (1.7) can begin
- [x] 2026-08-10 — Repo pushed to GitHub; files-as-truth architecture live
- [x] 2026-08-10 — Discovery Phases 1–6 complete: 29 decisions, PRD stamped ready-to-build
- [x] 2026-08-10 — Dogfood migration to `.mission/` standard; PLAYBOOK.md ops cheat sheet
- [x] 2026-08-10 — Spikes closed: Q17 (sessions can't create repos → manual birth), Q15 (chat history unreachable → net narrowed)
