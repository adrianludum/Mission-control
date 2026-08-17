---
name: mission-watch
description: Escalation-only watch over Mission Control — decide whether anything crossed a threshold worth interrupting Adrian for, and stay silent otherwise. Use when the user types /mission-watch, asks "is anything on fire", "anything need me", or when a scheduled watch Routine fires. Reads the hub's INDEX, snapshot and each repo's .mission/TASKS.md; writes only snapshot/watch-state.md.
---

# Mission watch — the door that stays shut

Almost every run of this skill should end in silence. That is success, not a failed run.

The board (`/mission`) is the pull door: Adrian looks when he wants to. This is the push door,
and a push door that opens on a green day trains him to ignore it — the exact failure Decision 5.2
names ("a daily-read briefing that punishes every glance trains avoidance"). Decision 9.4 therefore
gives this skill one job: **detect the small number of states that are genuinely worth an
interruption, and say nothing at all the rest of the time.**

You are not summarising the board. You are not reporting progress. You are not reminding Adrian of
anything he already knows.

## What counts as an escalation

Exactly these. Nothing else escalates, however interesting it looks.

1. **Work that exists in only one place.** A tracked repo with no remote; a branch listed under
   `Unpushed` as `no upstream` or `N ahead`; or **real files sitting untracked** — the snapshot's
   `Untracked files` / `Uncommitted files` rows name them. This is the one true emergency: a disk
   failure loses it permanently.

   Judge by the **names**, not the count. Almost every repo carries two or three ephemeral
   untracked files — `.DS_Store`, `.claude/`, editor and lock files — and those are never an
   escalation. A specification document, a script, a dataset, anything that reads like work is.
   AI Gym Hub's three spec documents sat untracked since June and were never raised because the
   snapshot only reported *how many*, and three was what every repo showed.
2. **The reporter has gone silent for more than 24 hours.** `snapshot/mac-mini.md`'s `*Generated:*`
   timestamp is more than 24h old. The board degrades honestly on its own, but a silent reporter
   means every git fact on the board is unknown, and the cause is usually a mini that rebooted
   without a GUI login. Threshold is 24h, not the board's 3h — a laptop lid closed overnight is not news.
3. **Uncommitted or unpushed work older than 7 days** in a repo that is otherwise active. Long
   enough that it is not work-in-flight; long enough that Adrian has forgotten it is there.
   The age comes from the snapshot's **`Oldest dirty file`** row (days, plus the file it belongs
   to) — do not infer it from the last-commit date, which says nothing about when the loose work
   was touched. Apply the same names-not-counts judgement as #1: a 90-day-old `.DS_Store` is not
   news.
4. **An `owner: Adrian` blocker that has passed 14 days** — and only after verifying it per
   Decision 9.2. A blocker the world has already resolved must never be escalated.

Deliberately **not** escalations: dormancy (parked cleanly is a fine state), low planning
completeness, a project going quiet, untracked scratch files, anything under 7 days old, and the
mere existence of open questions.

## Never escalate the same thing twice

`snapshot/watch-state.md` in the hub records what has already been raised: one row per escalation
with a short stable key (e.g. `no-remote:drone-rowing-analysis`), the date first raised, and the
date last raised. This is the only file this skill writes.

- A key already in the file → **stay silent**, unless it has been more than **14 days** since it was
  last raised *and* the condition is still true. Then raise once more and update the date.
- A key whose condition has cleared → remove the row silently. Never announce that something is
  fixed; that is still an interruption.
- Never re-raise inside 14 days, even across sessions. If in doubt, stay silent.

Cleared-then-returned counts as new. Same key, condition went false and came true again → raise it.

## Flow

1. Read `INDEX.md`, `snapshot/mac-mini.md`, `snapshot/watch-state.md`, and each tracked repo's
   `.mission/TASKS.md`.
2. Evaluate the four rules above. Verify any blocker before it counts (§3a of the `/mission` skill).
3. Subtract everything already in `watch-state.md` that is inside its 14-day cooling period.
4. **If nothing survives: stop. Send nothing.** Update `watch-state.md` only if rows needed clearing,
   commit quietly if so, and end. Do not report that all is well.
5. If something survives, write the message (below), update and commit `watch-state.md`, and send.

## The message, if there is one

Short enough to read on a lock screen. Lead with the thing, not with the system.

> **Drone Rowing Analysis has never been pushed** — 59 commits exist on the mini only.
> One command fixes it: `git push -u origin main`.
>
> *Mission Control watch · nothing else needs you.*

Rules for it:
- Name the project and the fact. No preamble, no "just a friendly reminder".
- Give the fix if it is one command; say what the decision is if it is a decision.
- At most **three** items. If more qualify, send the three worst and say "and N more on the board".
- Close with the reassurance that nothing else needs him. The point of an escalation-only door is
  that its silence is trustworthy — say so.
- Never use urgency theatre, streaks, counts of days wasted, or any phrasing that implies fault.
  A blocker is a fact with an owner, not a nag.
