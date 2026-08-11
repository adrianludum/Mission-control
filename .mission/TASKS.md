# Mission Control — Tasks
*Blockers are entries marked **owner: Adrian** — jobs only he can do.*

## To do
- [ ] **Log in at the Mac mini's desktop (or enable auto-login)** so a GUI/Aqua session exists — without one, launchd refuses to load *any* LaunchAgent, so the reporter's hourly schedule cannot start. Then: `launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.adrianludum.mission-reporter.plist` — **owner: Adrian** (needs console/Screen Sharing access, not SSH)
- [ ] Run enrolment wave one — `/enrol` in a Claude Code session at the Mac mini, 3–5 real repos — **owner: Adrian** (picks the repos, approves pairing table)
- [ ] At beta (Tier 3): notifications, sharing, trust acceptance test

## Done
- [x] 2026-08-11 — Reporter **installed and proven at the Mac mini** (partial — schedule not yet live): repo cloned to `~/Projects/mission-control` (note: lowercase, and the hub is *not* named `Mission-control` locally), script chmod'd, DRY_RUN pass then a real run scanning 20 git repos of 35 folders, snapshot committed and pushed as `reporter: snapshot 2026-08-11T11:13:06Z`. Non-interactive push confirmed working via osxkeychain. Plist installed to `~/Library/LaunchAgents/` with this machine's paths (`adriancassidyhome`, lowercase clone dir) plus explicit `SCAN_ROOT`/`HUB_REPO`. **Not loaded** — no GUI session on the mini; see the new To-do blocker
- [x] 2026-08-11 — Board-refresh Routine's first firing **verified**: board republished at 02:19 UTC to the standing URL, scored per 8.1, connector-less as designed. Found and deleted an accidental duplicate Routine (:13 UTC, created by a parallel session whose checkpoint sat on an unmerged branch — see FEEDBACK-LOG); the :17 UTC Routine (trig_014ZFiJn3X4EFTVFY5MvNpnf) is the single survivor
- [x] 2026-08-11 — Tier-2 work merged to the default branch (fast-forward, on Adrian's word) — Decisions 8.1–8.3 now live for every /mission render, including the hourly Routine
- [x] 2026-08-11 — Tier-2 questions closed and built (Decisions 8.1–8.3): Q8 scoring rubric replaces the interim heuristic in /mission; Q7 analytics vocabulary + snapshot/analytics.md cache wired into /mission, INDEX.md and /enrol; Q14 agent-log sourcing + unlogged-commits cross-check; Q9 closed by shipped reality (mobile in)
- [x] 2026-08-11 — Hourly board-refresh Routine created (Decision 7.1): trigger `trig_014ZFiJn3X4EFTVFY5MvNpnf`, "Mission Control board refresh", hourly at :17 UTC, fresh session per fire, notifications off; creation succeeded from a fresh remote session with no approval gate
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
