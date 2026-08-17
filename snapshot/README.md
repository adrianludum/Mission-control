# snapshot/

Raw git-state snapshots from always-on machines land here (currently `mac-mini.md`).
Written hourly by the dumb reporter (`reporter/mission-report.sh` via launchd) — never by hand.
Contract: every snapshot carries its own `*Generated: <UTC ISO>*` timestamp in its header.

**Per-repo rows** (2026-08-17 — the counts came first, the rest was added when it turned out the
counts alone could not answer the questions the watch is built on):

| Row | What it is |
|---|---|
| `Uncommitted` / `Untracked` | counts |
| `Uncommitted files` / `Untracked files` | the first few **names**, `(+N more)` beyond that. Judge by these, never by the count — nearly every repo carries 2–3 ephemeral untracked files, so a count of 3 is noise while `GymHub-Core-Capabilities-Spec.md` is single-copy work |
| `Oldest dirty file` | age in days of the oldest dirty/untracked file, and which one. This is the age the "dirty for over 7 days" rule needs; last-commit date does not answer it |
| `Unpushed` / `Behind` | per-branch ahead / behind counts |
| `Last fetch` | how old that clone's last fetch is. The reporter **never fetches** — it is read-only and 34 network calls an hour is not that — so ahead/behind are only as fresh as this row says |
/mission trusts that timestamp, and when it is stale it degrades loudly — "Mac mini last reported N days ago, local state unknown" — never a confident answer from stale data (Decision 2.5).

`analytics.md` also lives here (Decision 8.2): a self-timestamped cache of per-product user counts,
overwritten by /mission whenever it renders *with* connector access (Vercel/Supabase tools in reach).
Connector-less renders — the hourly refresh Routine — read it and label its age instead of fetching.
Same contract: `*Generated: <UTC ISO>*` header, stale (>7 days) or missing → "analytics unreported",
never a cached count presented as current.
