# Mission Control — Synopsis
*Overwritten at every checkpoint. Written 2026-08-11 by the Mac mini session.*

**Where it stands:** Mission Control is now tracking real projects. Wave one enrolled **7 repos** (Ludum v2, Trip HQ, imagesAi, World Rowing Results, Training Status, HRR 2026 Commentator Dossier, Learn a Language) — each with a back-filled ten-file `.mission/`, pushed, and indexed in INDEX.md. The reporter is installed and proven at the mini; a real snapshot of 20 git repos is committed. Build steps 1–4 plus both Adrian-owned install/enrol tasks are done. The break-in period (Decision 1.7) can now actually start.

**Open:** the reporter's **hourly schedule is still not running** — its LaunchAgent can't be loaded over SSH because no GUI login session exists on the mini (see LEARNINGS). Until then the snapshot only refreshes when the script is run by hand, and the board will age. Tier-3 (notifications, sharing, trust acceptance test) remains at beta.

**Only Adrian can unblock:** (1) log in at the mini's desktop / enable auto-login, then bootstrap the reporter into `gui/501`; (2) decide on the loose uncommitted work in HRR and language — the latter has an entire Flutter client and LiveKit server untracked on this machine only; (3) decide the fate of `drone-rowing-analysis`, which has no commits and no remote at all.
