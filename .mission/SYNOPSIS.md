# Mission Control — Synopsis
*Overwritten at every checkpoint. Written 2026-08-17 by a cloud session.*

**Where it stands:** Running unattended and reliably — hourly reporter snapshots unbroken (latest 2026-08-17T06:47Z, 34 repos), board Routine at :17, watch Routine at 07:12. The watch has earned its keep: 2026-08-16 it raised its first two escalations, both stale ULBC blockers. 15 projects on the board, and the Campaign_CRM collision that held #16 is resolved (9.8 — `ludum-outreach` canonical; `ludum-campaigns` retires unmerged, its tip being a 92,947-line deletion).

**Open:** The system's real bottleneck is now visible and structural: **no cloud session can push to `adrianludum/*`**, so every mechanical repair — Campaign CRM's cutover, BoatHUB's and training_status's stranded seeds, every future enrolment — queues behind Adrian instead of self-healing. Broadcast Timing App is blocked on its own database rules. BoatHUB's merge blocker is unverified since 2026-08-12 and may already be stale.

**Only Adrian can unblock:** (1) choose how sessions get push rights — GitHub app access for cloud sessions, or a scheduled Claude Code run at the mini where `gh` already has `repo` scope (9.1); (2) connect `/Volumes/Projects` once instead of per-project folders, so no session needs another folder dialog; (3) publish the corrected Firebase rules so Broadcast Timing App can reach its own data. Everything else on the list is mechanical once (1) exists.
