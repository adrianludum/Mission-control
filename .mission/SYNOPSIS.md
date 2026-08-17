# Mission Control — Synopsis
*Overwritten at every checkpoint. Written 2026-08-17 by a cloud session.*

**Where it stands:** Feature-complete and running unattended: the reporter has pushed hourly snapshots without a gap (latest 2026-08-17T06:47Z, 34 repos), the board Routine fires at :17 and the watch Routine at 07:12. The watch has now earned its keep — on 2026-08-16 it raised its first two escalations, both stale ULBC-salesforce `owner: Adrian` blockers. 15 projects on the board.

**Open:** Broadcast Timing App (renamed from Timer App on 2026-08-14) is **blocked** — the deployed Firebase rules lock the app out of its own `events/` tree; corrected rules exist unpublished. Campaign CRM is ticked but held on the canonical-folder decision. BoatHUB's `.mission/` seed is recorded as still on `claude/mission-control-roster-update-abe98y` — unverified since 2026-08-12, so check before trusting it. training_status's seed is still on `feat/resting-measurements` only. Break-in period runs until `TRUST-TEST.md` passes.

**Only Adrian can unblock:** (1) publish the corrected database rules so Broadcast Timing App can reach its own data; (2) decide which of `ludum-campaigns` / `ludum-outreach` is canonical so Campaign CRM enrols; (3) merge BoatHUB's seed branch (and training_status's) to the default branch — no cloud session can push to `adrianludum/*`, so these need a session on his machine.
