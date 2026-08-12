# Mission Control

Personal re-entry briefing dashboard — one board answering "where is everything at" after days away.

**The board:** type `/mission` in any Claude chat, or open the standing URL in [`BOARD.md`](BOARD.md).
It re-renders hourly on its own.

**What to touch:**
- [`CANDIDATES.md`](CANDIDATES.md) — the roster. Tick a project to put it on the board, untick to take
  it off. This is the only file you need to edit by hand, and `/roster` applies whatever you change.
- [`BOARD.md`](BOARD.md) — the standing artifact URL. Bookmark it.
- [`PLAYBOOK.md`](PLAYBOOK.md) — paste-ready commands and prompts.

**How it works:** every tracked project carries a `.mission/` folder — the ten-file standard
(Decision 2.6) that sessions keep true as they work. An hourly reporter on the Mac mini pushes local
git truth to [`snapshot/`](snapshot/). `/mission` reads the roster, each project's `.mission/`, and the
snapshot, then renders the board. GitHub is the database; Claude sessions are the compute; one dumb
hourly script is the only daemon.

**The doors:**

| Door | What it does |
|---|---|
| `/mission` | Render the board now |
| `/roster` | Show the roster; apply enrolments and retirements |
| `/enrol` | Wire and seed a chosen project |
| `/mission-watch` | Escalation-only check. Silent unless something genuinely needs you (Decision 9.4) |
| "update log" | Force a checkpoint in whatever repo you are in |

Two Routines run unattended: the board refreshes hourly at :17 UTC, and the watch runs daily at
07:12 UTC — and says nothing at all on a good day.

**Trust:** [`TRUST-TEST.md`](TRUST-TEST.md) defines when the break-in period ends. Run it by asking any
session to "run the trust test".

Project memory lives in [`.mission/`](.mission/) — start at [`.mission/README.md`](.mission/README.md)
for the document map, or [`HANDOFF.md`](HANDOFF.md) to resume work in a new session.
