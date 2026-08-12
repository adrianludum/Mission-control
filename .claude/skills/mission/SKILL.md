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
4. Analytics per the index's "Analytics source" column (Decision 8.2). Column vocabulary: `vercel:<project-name>`, `supabase:<project-ref>` (count from `auth.users` unless the Notes column names another query), `manual:<where the number lives>`, or `—` (no live users to count).
   - **With connector access** (interactive sessions): resolve each source live — Vercel via its analytics tool, Supabase via a count query — then overwrite `snapshot/analytics.md` with the fetched numbers and a `*Generated: <UTC ISO>*` timestamp (machine-maintained cache; the second permitted write, alongside BOARD.md recovery).
   - **Without connector access** (the hourly Routine fires connector-less): read `snapshot/analytics.md` and label the age — "412 users · as of 9h ago". Cache older than 7 days or missing → render "—" with "analytics unreported", per the loud-degradation register (2.5). Never present a cached count as current.

**Scope note:** the index held only Mission-control at v0 (n=1); since enrolment wave one it holds several projects, and the roster (`CANDIDATES.md`, Decision 9.3) can change that count between any two renders. Never assume a count — loop over whatever the index contains.

## 2. Staleness rule (Decision 2.5) — non-negotiable

The snapshot carries its own generation timestamp. The reporter runs hourly.

- Snapshot older than **3 hours** → the rendered board MUST carry a loud banner: **"Mac mini last reported N hours/days ago — local state unknown."**
- Snapshot file **missing** → same loud degradation ("Mac mini has not reported — local state unknown").
- Never present stale local git facts as current. Anything sourced from a stale snapshot is labelled unknown/stale, not asserted.

## 3. Contradiction rule (Decision 2.7)

Mostly **assemble** the stored `SYNOPSIS.md` texts — do not re-derive what a checkpoint already wrote. Think live only for:
- the **cross-project layer** (ordering, headline, portfolio-level observations), and
- any project whose git/snapshot evidence **contradicts** its stored synopsis (commits after the last checkpoint, unexplained dirty state). Re-synthesise that project on the spot from its files + git evidence, and say the synopsis was stale.

### 3a. Verify machine-checkable blockers before rendering them (Decision 9.2)

A blocker in `TASKS.md` is a claim about the world that was true when it was written. Nothing re-checks it. Before rendering any `owner: Adrian` blocker, ask whether the snapshot — or, when you have shell access, one cheap command — can falsify it:

- "repo has no remote" → the snapshot's Remote row, or `git remote -v`
- "work is uncommitted / unpushed" → the snapshot's Uncommitted / Untracked / Unpushed rows
- "the reporter/schedule is not running" → the snapshot's own age, or `launchctl print gui/$(id -u)/<label>`
- "repo has no commits" → the snapshot's Last commit row

Where the evidence contradicts the file, **render the corrected state**, drop the blocker from the pressure score, and add one line naming the stale entry — *"TASKS.md still lists this as blocked; the snapshot shows it resolved."* Do not silently rewrite `TASKS.md` from a render; /mission is the reading room. Flagging it is enough — the next disciplined session in that repo fixes the file.

Judgement blockers ("decide what happens to X", "pick which copy is canonical") are **not** machine-checkable. Leave them exactly as written; only Adrian closes those.

This exists because the reporter's schedule was fixed for a full day while `SYNOPSIS.md` and `TASKS.md` still reported it broken and its blocker aged toward critical. A board that is confidently wrong about what is still broken sends Adrian to fix what already works — a faster route to trust-decay (1.7) than being vague ever was.

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
7. Read-only agent activity log — sourced **solely from that repo's `.mission/AGENT-LOG.md`** (Decision 8.3). Cross-check it against recent commits: commits since the newest log entry are rendered as one honest gap line — "unlogged activity: N commits since last log entry" — which also trips the contradiction rule (§3). Never scrape transcripts at render time; Mac mini `~/.claude` transcripts are reconstruction-only inputs (4.1).

### The roster band (Decision 9.3)

Below the two status bands, render a **Roster** section from `CANDIDATES.md` — the picker Adrian uses to choose what is tracked, at the `<!-- DATA:ROSTER -->` injection point.

- One `label.row` per project, **grouped exactly as `CANDIDATES.md` groups them** (On the board / Ready to enrol / Needs work first / Nested / Ignored). Carry each group's explanatory note across; for "Needs work first" rows put the blocker in `.row-why.blocked` so the reason is visible before Adrian ticks it.
- A project currently on the board gets `checked` **and** `data-on="1"`. One not on the board gets neither. These must agree at render time — the page diffs against `data-on`, so any mismatch makes the board open already showing phantom changes.
- Set `data-name` to the display name exactly as `INDEX.md` and `CANDIDATES.md` spell it; the generated instruction quotes it back, and a session applies it by matching that name.
- Put **Ignored** rows inside a collapsed `<details>` — they are decisions already made, and they are the longest group. They stay tickable so a change of mind costs nothing.

The page is static and sandboxed: it cannot write `CANDIDATES.md`, and must never imply it can. Ticking produces a paste-ready instruction, nothing more. Never render a "Save" or "Apply" control.

The detail view **ends in a launch pad** (Decision 3.2): the top next action, plus the exact prompt to paste to open a context-loaded work chat on that repo (e.g. "Open a chat connected to <repo>. Read .mission/ — SYNOPSIS first — then: <top next action>.").

## 5. Emotional contract (Decision 5.2)

When nothing needs Adrian, the board's headline says so plainly — the "Systems nominal — go enjoy your coffee" register. Calm dismissal is the default; loudness is earned only by genuine need (a genuinely screaming tile, a stale snapshot). Never render a guilt machine: a green board is permission to leave.

## 6. Scoring (Decision 8.1 — closes Q8)

Three measures per project, each computed from files. Where a step needs judgement it is named as judgement — but the checklist below is the rubric, applied the same way every render.

### 6.1 Staleness (drives band placement)
**Last touched** = the most recent of: last commit on any branch (snapshot or GitHub), newest dated `AGENT-LOG.md` entry, `SYNOPSIS.md` date.
- ≤ 14 days → **ACTIVE** band; otherwise **DORMANT** (Decision 3.1's cutoff).
- Tiles show "last touched N d ago". Dormancy is not itself risk — parked-cleanly is a fine state.

### 6.2 Git risk (chips; from the snapshot and GitHub)
Computed **only from a fresh snapshot** (§2). Levels, worst first:
- **critical** — uncommitted or unpushed work older than 7 days, or a local repo with no remote
- **serious** — uncommitted/unpushed work 2–7 days old
- **notice** — uncommitted/unpushed work under 2 days (normal work-in-flight, not alarming)
- **clean** — none of the above
- **unknown** — snapshot stale or missing, or repo not in it. Displayed as "unknown", **sorts as serious** (honest uncertainty ranks high), never asserted as a fact.

### 6.3 Blocker pressure (from TASKS entries tagged `owner: Adrian`)
Age from the entry's date (or first appearance in git history if undated):
- **critical** — an open Adrian-blocker older than 14 days
- **serious** — 7–14 days · **notice** — younger than 7 days · **clean** — none open

### 6.4 Planning completeness % (Decision 3.3's incompleteness signal)
Score out of 100, shown on the tile; the checklist is the rubric:
- **PRD (0–40)**: 40 = marked complete/ready-to-build · 20 = substantive but partial · 0 = missing or a stub of placeholders
- **Tier-1 questions (0–30)**: 30 if no open Tier-1 questions; −10 per open Tier-1 (floor 0)
- **Decisions (0–15)**: 15 if ≥3 substantive decisions logged, else 0
- **Tasks (0–15)**: 15 if TASKS.md has a concrete To-do list beyond seed placeholders, else 0
"Substantive"/"partial" are judgement calls — make them consistently and don't relitigate between renders.

### 6.5 Tile status and ordering
- **Status dot** = worst of (git risk, blocker pressure); unknown counts as serious.
- **ACTIVE ordering**: severity desc (critical > serious/unknown > notice > clean), then lower completeness first, then most-recently-touched first.
- **DORMANT ordering**: time parked desc (longest first), risk chips still visible (3.1).

## 7. Fallback

Text fallback only where artifacts can't render: same content order (headline → active → dormant → per-project detail on request), same staleness banner first if applicable.
