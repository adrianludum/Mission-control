# Mission Control — Synopsis
*Overwritten at every checkpoint. Written 2026-08-12 by a Mac mini session.*

**Where it stands:** The system is built and running unattended. The reporter's hourly schedule is **live** — the LaunchAgent is loaded in `gui/501` and has pushed an unbroken hourly snapshot since 2026-08-11T22:32Z; the board-refresh Routine fires at :17. Eight projects are enrolled. Today cleared all three loose-work blockers: `language`'s Flutter client and LiveKit server and `drone-rowing-analysis`'s entire codebase were untracked on one disk and are now committed (drone had *zero* commits), and HRR's in-flight work is pushed.

**Open:** enrolment wave two — 8 clean candidates surveyed, pairing table awaits approval. Tier-3 (notifications, sharing, trust acceptance test) is the last unbuilt work. The wave-two survey also found 16 git repos nested inside container folders that the reporter's depth-1 scan cannot see.

**Only Adrian can unblock:** (1) a name + visibility for `drone-rowing-analysis`'s new remote — `gh` at the mini has `repo` scope, so creation is now automatable; (2) which of `ludum-campaigns` / `ludum-outreach` is canonical — they are two divergent checkouts of the same `Campaign_CRM.git`; (3) approval of the wave-two pairing table.

**Trust finding worth keeping:** the reporter blocker was fixed for a day while TASKS.md and this file still reported it broken. Nothing re-checks a blocker once written — /mission should verify cheap machine-checkable blockers against live evidence before rendering them.
