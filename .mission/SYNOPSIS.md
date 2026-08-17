# Mission Control — Synopsis
*Overwritten at every checkpoint. Written 2026-08-17 by a cloud session.*

**Where it stands:** Observing reliably and now, pending one install, repairing itself. Reporter snapshots unbroken (latest 2026-08-17T06:47Z, 34 repos), board Routine at :17, watch Routine at 07:12 — which raised its first real escalations on 08-16. The Campaign_CRM collision that blocked project #16 is resolved (9.8: `ludum-outreach` canonical; `ludum-campaigns` retires unmerged, its tip being a 92,947-line deletion the roster's "newest wins" framing would have adopted).

**Open:** `healer/` is built but not installed — a daily headless run at the mini that applies roster ticks, unstrands `.mission/` seeds and corrects INDEX rows, so mechanical repair stops queueing behind Adrian (9.9). `owner: Adrian` now means judgement, deploys and money only. Broadcast Timing App is still locked out of its own database. BoatHUB's merge blocker is unverified since 08-12 and may already be stale — the healer will settle it.

**Only Adrian can unblock:** (1) install the healer — `DRY_RUN=1 healer/mission-heal.sh` at the mini, then bootstrap the agent (`healer/INSTALL.md`); (2) publish the corrected Firebase rules so Broadcast Timing App can reach its data. That is the whole list — everything else now has a machine that will do it.
