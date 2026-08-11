---
name: mission
description: Render Adrian's Mission Control briefing — the project board. Trigger when the user types /mission, or asks for their mission control, briefing, project board, project status wall, or "where are my projects at". Reads the project index, each tracked repo's .mission/ state, and the Mac mini snapshot, then renders a single self-contained HTML dashboard artifact.
---

# /mission — render the briefing board

You are the reading room. You never write project state here; you read, assemble, and render.

## 1. Read path (in order)

1. `INDEX.md` at the repo root — the registry. Only rows listed there are tracked. Note per-row metadata: display name, repo, host machine, local path, analytics source, status, born date.
2. For **each** tracked project, its repo's `.mission/` folder — all ten files, `SYNOPSIS.md` first, then: README, DECISIONS, OPEN-QUESTIONS, LEARNINGS, CHANGELOG, FEEDBACK-LOG, PRD, TASKS (blockers = entries tagged `owner: Adrian`), AGENT-LOG.
3. `snapshot/mac-mini.md` in this repo — the Mac mini reporter's self-timestamped snapshot (local git truth: uncommitted/untracked files, unpushed branches, missing remotes, last-commit times).
4. Analytics sources per the index's "Analytics source" column. **v0: none mapped** — render user counts as "—".

**v0 scope note:** today the index holds only Mission-control itself (n=1). This read path is written generally — never assume n=1; loop over whatever the index contains.

## 2. Staleness rule (Decision 2.5) — non-negotiable

The snapshot carries its own generation timestamp. The reporter runs hourly.

- Snapshot older than **3 hours** → the rendered board MUST carry a loud banner: **"Mac mini last reported N hours/days ago — local state unknown."**
- Snapshot file **missing** → same loud degradation ("Mac mini has not reported — local state unknown").
- Never present stale local git facts as current. Anything sourced from a stale snapshot is labelled unknown/stale, not asserted.

## 3. Contradiction rule (Decision 2.7)

Mostly **assemble** the stored `SYNOPSIS.md` texts — do not re-derive what a checkpoint already wrote. Think live only for:
- the **cross-project layer** (ordering, headline, portfolio-level observations), and
- any project whose git/snapshot evidence **contradicts** its stored synopsis (commits after the last checkpoint, unexplained dirty state). Re-synthesise that project on the spot from its files + git evidence, and say the synopsis was stale.

## 4. Output (Decision 4.4)

One **self-contained HTML artifact**, rendered from the template at `.claude/skills/mission/template.html`:
read the template, replace the sample data at the `<!-- DATA:... -->` injection points with real data, publish/present it. No external requests; everything ships in the one render.

**Standing URL (Decision 7.1):** read `BOARD.md` at the repo root and pass its artifact URL as the
Artifact tool's `url` parameter, so every render — from any chat or the hourly refresh Routine —
updates the same pinned link. If `BOARD.md` is missing or the URL is gone, publish fresh and
rewrite `BOARD.md` with the new URL (the one exception to "you never write here").

Structure (Decision 3.1 — nothing tracked is ever hidden):
- **ACTIVE band** — projects touched ≤14 days, ordered by risk + planning incompleteness (worst first).
- **DORMANT band** — everything else, ordered by time parked (longest first), risk still visible on every tile.
- Tiles carry: status dot, staleness, git risk chips, open-loop counts, planning-incompleteness %.
- **Tap a tile → in-page drill-down** to that project's detail section (all detail ships in the single render; a back control returns).

Each project detail view must answer Decision 1.2's seven items:
1. Open questions & answered questions
2. Adrian's blockers — TASKS entries tagged `owner: Adrian`
3. What has been designed & decided (decisions record)
4. Git detail — branch, machine, unpushed, uncommitted (from the snapshot; honour §2)
5. User counts for live products (v0: "—")
6. Tasks completed vs remaining
7. Read-only agent activity log

The detail view **ends in a launch pad** (Decision 3.2): the top next action, plus the exact prompt to paste to open a context-loaded work chat on that repo (e.g. "Open a chat connected to <repo>. Read .mission/ — SYNOPSIS first — then: <top next action>.").

## 5. Emotional contract (Decision 5.2)

When nothing needs Adrian, the board's headline says so plainly — the "Systems nominal — go enjoy your coffee" register. Calm dismissal is the default; loudness is earned only by genuine need (a genuinely screaming tile, a stale snapshot). Never render a guilt machine: a green board is permission to leave.

## 6. Interim risk scoring (Q8 open — this heuristic is interim, say so in output)

- **critical** — unpushed/uncommitted work older than 7 days, OR a blocker tagged `owner: Adrian` older than 14 days
- **serious** — unpushed/uncommitted work 2–7 days old, or a stale/missing snapshot
- **warning** — open Tier-1 questions / planning incompleteness (thin PRD, undecided decisions)
- **good** — none of the above

Planning incompleteness is shown as a % on the tile — a rough judgement from PRD/OPEN-QUESTIONS fullness (thin PRD + many open Tier-1s = low completeness). Mark it as judgement, not measurement.

## 7. Fallback

Text fallback only where artifacts can't render: same content order (headline → active → dormant → per-project detail on request), same staleness banner first if applicable.
