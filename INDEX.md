# Mission Control — Project Index

The curated registry of tracked projects (Decision 2.3). This file is **machine-maintained**:
promotion ("sync with git X") appends a row; retirement ("retire X") removes one. It is
hand-editable too — but no workflow requires Adrian to remember to. `/mission` reads this
file first; only repos listed here appear on the board.

**Analytics source vocabulary** (Decision 8.2): `vercel:<project-name>` · `supabase:<project-ref>`
(counts `auth.users` unless Notes names another query) · `manual:<where the number lives>` · `—`
(no live users to count). /mission resolves these live when it has connector access and caches to
`snapshot/analytics.md`; connector-less renders (the hourly Routine) read the cache and label its age.

| Project | Repo (owner/name) | Host machine | Local path | Analytics source | Status | Born | Notes |
|---|---|---|---|---|---|---|---|
| Mission Control | adrianludum/Mission-control | mac-mini | ~/Projects/Mission-control | — | active | 2026-08-10 | Tracks itself (dogfood, project #1) |
