# Watch state

*Machine-maintained by `/mission-watch` (Decision 9.4). Do not hand-edit unless you want an
escalation re-raised — deleting a row makes it eligible again immediately.*

One row per escalation that has been raised. A row here means "Adrian has already been told";
its presence is what keeps the watch silent. Rows are removed silently once the condition clears.
Cooling period before re-raising a still-true condition: **14 days**.

| Key | Project | First raised | Last raised | Condition |
|---|---|---|---|---|
| blocker-14d:ulbc-oq051 | ULBC-salesforce | 2026-08-16 | 2026-08-31 | owner:Adrian, open since 2026-04-29 — OQ-051, new email account/hosting decision, gates resuming OQ-039..045 |
| blocker-14d:ulbc-martin-peel-stripe-xero | ULBC-salesforce | 2026-08-16 | 2026-08-31 | owner:Adrian, open since 2026-07-08 (Decision 7.9) — confirm with Martin Peel how Stripe money lands in Xero, decides if payout-splitting is needed |
| unpushed-branches:training-status | Training Status | 2026-08-21 | 2026-08-21 | 3 local branches exist only on the mac mini, no matching ref on origin: fix/build-26-release-guard (current checkout, dirty), merge/resting-measurements, mission/seed-on-main |
| unpushed-commits:ulbc-salesforce | ULBC-salesforce | 2026-08-22 | 2026-08-22 | main is 3 commits ahead of origin, unpushed since last commit 2026-08-14 — no remote copy of that work |
| uncommitted:language | Learn a Language | 2026-08-22 | 2026-08-22 | 10 uncommitted files, sitting since last commit 2026-08-12 — no commit or push activity since |
| unpushed-commits:familysite | Trip HQ | 2026-08-26 | 2026-08-26 | mac mini's main 1 commit ahead of origin since 2026-08-17 (never pushed); origin has since advanced with different commits (verified live), so this is a genuine divergence, not a stale scan |
| blocker-14d:imagesai-real-library | imagesAi | 2026-08-27 | 2026-08-27 | owner:Adrian, open since 2026-08-11 — needs a real photo library to test against before deciding whether it beats the PhotoShelter/Canto incumbent |
| blocker-14d:language-m0-apikeys | Learn a Language | 2026-08-27 | 2026-08-27 | owner:Adrian, open since 2026-08-12 — M0 needs API keys supplied and the in-car test run before it can proceed |
| blocker-14d:drone-phase0-shoot | Drone Rowing Analysis | 2026-08-27 | 2026-08-27 | owner:Adrian, open since 2026-08-12 — Phase-0 shoot (eight + 8-seat Peach + Mini 5 Pro) needs booking; it's the kill-or-continue gate for the project |
| blocker-14d:broadcast-timing-db-rules | Broadcast Timing App | 2026-08-29 | 2026-08-29 | owner:Adrian, open since 2026-08-14 (probed) — deployed Firebase rules deny events/ read+write; corrected ruleset committed in race-timing-app and wired into firebase.json, not yet deployed |
| blocker-14d:wrr-failure-alerting | World Rowing Results | 2026-08-30 | 2026-08-30 | owner:Adrian, open since 2026-08-14 (Decision 0.3) — no failure alerting on the live-publish pipeline; verdict was to stand "until the Worlds (2026-08-24–08-30) exercises it" — that window is now, no commits since 2026-08-14 to indicate it has |
| blocker-14d:boathub-mission-seed-merge | BoatHUB | 2026-08-31 | 2026-08-31 | owner:Adrian, open since 2026-08-12 — `.mission/` seed sits on `claude/mission-control-roster-update-abe98y`, never merged to `main`; verified live (git access) — `main` has no `.mission/` directory at all, seed branch still exists unmerged on origin |
| single-copy:ai-gym-hub-specs | AI Gym Hub | 2026-09-01 | 2026-09-01 | 3 real spec docs (`GymHub-Core-Capabilities-Spec.md`, `GymHub-Customer-Guide.md`, `GymHub-Remediation-Plan.md`) exist untracked on the mac mini only, since before 2026-06-12; confirmed still untracked in the 2026-09-01 snapshot (fitness/ai-gym-hub: 0 uncommitted, 4 untracked) — no other copy exists. Outside the healer's charter (project repos: `.mission/**` and `CLAUDE.md` only), so it will not self-heal |
| blocker-14d:healer-not-installed | Mission Control | 2026-09-02 | 2026-09-02 | owner:Adrian, open since 2026-08-17 (Decision 9.9) — the daily healer at the mini was built but never installed; verified via git history (no `healer:`-authored commits exist since the feature landed, only `reporter:` and `mission-watch:` ones), and the mechanical backlog it exists to clear (seed drift, AI Gym Hub's untracked specs, stale INDEX.md rows) is still open |
