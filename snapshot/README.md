# snapshot/

Raw git-state snapshots from always-on machines land here (currently `mac-mini.md`).
Written hourly by the dumb reporter (`reporter/mission-report.sh` via launchd) — never by hand.
Contract: every snapshot carries its own `*Generated: <UTC ISO>*` timestamp in its header.
/mission trusts that timestamp, and when it is stale it degrades loudly — "Mac mini last reported N days ago, local state unknown" — never a confident answer from stale data (Decision 2.5).

`analytics.md` also lives here (Decision 8.2): a self-timestamped cache of per-product user counts,
overwritten by /mission whenever it renders *with* connector access (Vercel/Supabase tools in reach).
Connector-less renders — the hourly refresh Routine — read it and label its age instead of fetching.
Same contract: `*Generated: <UTC ISO>*` header, stale (>7 days) or missing → "analytics unreported",
never a cached count presented as current.
