---
name: mission-discipline
description: Continuous-checkpoint discipline for Mission Control. Use whenever a session is doing project work in a repo containing a .mission/ folder, whenever the user says "update log", or on /mission-discipline. Keeps .mission/ state files true as things happen — decisions, questions, tasks, learnings — committed and pushed mid-conversation, not at any session end.
---

# Mission Discipline

You are working in a mission-tracked repo. The `.mission/` folder is the project's memory. Your job: keep it true **as things happen**. There is no "session end" — you just stop getting replies, and nothing runs afterwards. Anything not written down is lost.

## Continuous checkpoint (the core rule — Decision 3.4)

The moment something checkpoint-worthy happens, write it to `.mission/` and commit+push **immediately** — mid-conversation, not later, not at any wrap-up. Checkpoint-worthy:

| Event | Write to |
|---|---|
| A decision is made | Append to `DECISIONS.md` — house format: `**What**` / `**Why**` / `**Date**` / `**Supersedes**` |
| A question is opened or answered | `OPEN-QUESTIONS.md` |
| A task starts, finishes, or moves | `TASKS.md` |
| A new blocker only Adrian can clear | `TASKS.md`, entry tagged `**owner: Adrian**` (no separate blockers file) |
| Something is learned (technical or product) | `LEARNINGS.md` |
| Scope changes | `CHANGELOG.md` |
| The user gives feedback on the system itself | `FEEDBACK-LOG.md` |

## Every checkpoint ends with the synopsis (Decision 2.7)

After writing the state files, **overwrite** `.mission/SYNOPSIS.md`: where this stands / what's open / what only Adrian can unblock. It is the re-entry briefing — ≤8 lines, dated. Never skip it; a checkpoint without a fresh synopsis is incomplete.

## AGENT-LOG.md

Append **one line** per working session or agent run: date, actor, what was done, why it stopped. Append-only — never edit or delete existing lines.

## "update log" (Decision 2.4)

A comfort word, not a command grammar. On hearing it: save everything known right now — decisions since last save, new/answered questions, blockers, task movement — classifying items yourself. Plain-English routing hints are allowed ("update log — that last one's a blocker"). Idempotent: if everything is already captured, say so briefly and move on. It is never a required ritual; continuous checkpointing means it usually finds nothing waiting.

## Corrections (Decision 3.5)

When the user corrects wrong state ("that's not where this is", "we decided X, not Y"): fix the file where the error lives, **and** append a line to `FEEDBACK-LOG.md` recording the miss — with the cause when diagnosable (undisciplined chat vs broken checkpoint). The record of misses is the tuning curriculum.

## Commit mechanics

- Small, frequent commits — one per checkpoint is fine.
- Message prefix `checkpoint:` plus what was captured, e.g. `checkpoint: decision on reporter cadence + synopsis`.
- Push after every checkpoint. If the push fails, retry up to 4 times with exponential backoff; if it still fails, tell the user once, plainly.
- Never let checkpoint mechanics interrupt the user's flow. Capture quietly — no narration beyond a brief note ("checkpointed"), then continue the actual work.

## Tone (Decision 5.2)

State files are calm and factual. Record what is, never accusation or urgency theatre. A blocker is a fact with an owner, not a nag.
