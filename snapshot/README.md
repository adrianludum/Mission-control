# snapshot/

Raw git-state snapshots from always-on machines land here (currently `mac-mini.md`).
Written hourly by the dumb reporter (`reporter/mission-report.sh` via launchd) — never by hand.
Contract: every snapshot carries its own `*Generated: <UTC ISO>*` timestamp in its header.
/mission trusts that timestamp, and when it is stale it degrades loudly — "Mac mini last reported N days ago, local state unknown" — never a confident answer from stale data (Decision 2.5).
