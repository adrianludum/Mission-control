---
name: roster
description: Show and apply Adrian's project roster — which projects are on the Mission Control board. Use when the user types /roster, says "enrol X", "retire X", "ignore X", "reconsider X", "add X to the board", "take X off the board", or asks what projects could be tracked. Reads and writes CANDIDATES.md in the Mission-control hub.
---

# Roster — the control surface for what is on the board

`CANDIDATES.md` in the hub is the single place that decides which projects the board renders.
A ticked box means "on the board"; an unticked one means "not". Your job is to keep that file
honest, apply whatever Adrian has changed, and never make him remember a step.

Decision 9.3: the roster supersedes the one-shot pairing-table approval as the enrolment
control surface. `/enrol` still does the mechanical work — this skill decides what it works on.

## Guardrails

- **Retiring is never deleting.** Removing a project from the board means removing its row from
  `INDEX.md` and unticking it here. Never delete a repo, a `.mission/` folder, a branch, or history.
  If Adrian says "delete", confirm he means "remove from the board" — and if he really means the
  files, make him say so explicitly, then still refuse to delete the remote.
- **Never guess a pairing.** No remote, an ambiguous match, or two folders sharing one remote →
  ask via AskUserQuestion, or leave the row in "Needs work" with the reason written down.
- **One project failing must not stop the run.** Record it, move on, report at the end.
- **Never silently drop a row.** A project that cannot be enrolled moves to "Needs work" with a
  stated blocker — it does not vanish.

## Flow

### 1. Read and reconcile

Read `CANDIDATES.md`, then `INDEX.md`, then `snapshot/mac-mini.md`.

Reconcile three ways, and report any drift rather than fixing it silently:
- **Ticked but not in `INDEX.md`** → this project is queued to enrol (step 3).
- **In `INDEX.md` but unticked** → this project is queued to retire (step 4).
- **In `INDEX.md` and ticked** → live, nothing to do.

Then rescan the disk for folders the roster has never seen. Scan direct children of `~/Projects`
**and** one level below them (container folders like `events/`, `fitness/`, `rowing/` hold real
repos — see LEARNINGS). Any git repo not already listed anywhere in `CANDIDATES.md` is appended
to **Candidates** (or **Needs work**, with the blocker) as an unticked row with a one-line
description read from its README or `package.json`. Never re-add something sitting in **Ignored** —
that list exists so each survey stops re-asking.

### 2. Show the roster

Present it grouped as the file is grouped — Enrolled / Candidates / Needs work / Nested / Ignored —
with anything queued to enrol or retire called out at the top. If nothing is queued and nothing new
was found, say so plainly in one line; do not manufacture work.

If Adrian is choosing interactively rather than having pre-ticked the file, offer the candidates via
AskUserQuestion (multiSelect) and tick what he picks.

### 3. Apply enrolments

For each queued project, follow `/enrol`'s wire-and-seed flow: fetch first, wire the remote, reconcile
histories without force-pushing, copy the ten `templates/mission-seed/` files and back-fill every
`{{PLACEHOLDER}}` from real repo evidence, commit `mission-control: enrol — seed .mission/`, push.
Then append its row to `INDEX.md` with an analytics source from the Decision 8.2 vocabulary.

Where the mini's shell is available, `gh` may create a missing repo (Decision 9.1) — name and
visibility are Adrian's call, so ask before creating.

Born-thin is honest: "Unknown — repo predates Mission Control" beats invention, and `SYNOPSIS.md`
must always be real (Decision 3.6).

### 4. Apply retirements

Remove the project's row from `INDEX.md`. Leave the repo and its `.mission/` folder exactly as they
are. Move the roster entry to whichever group fits — **Candidates** if it may come back, **Ignored**
with a stated reason if it will not — and leave it unticked. Note the retirement in the hub's
`.mission/CHANGELOG.md`.

### 5. Checkpoint

Commit `CANDIDATES.md` and `INDEX.md` together with a `checkpoint:` message naming what was enrolled
and retired, push, and append one line to the hub's `.mission/AGENT-LOG.md`. Then report: what was
enrolled, what was retired, what was newly discovered, what needs work and why.

## Tone

The roster is a menu, not a backlog. An unticked project is a choice Adrian has made, not a task he
is failing to do — describe it that way. Nothing in this file should imply he ought to enrol more.
