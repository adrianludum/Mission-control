# Handoff — continuing this project in any Claude session

## State as of 2026-08-11
**Build steps 1–4 are complete and merged to the default branch.** Discovery (29 decisions) closed 2026-08-10; the build shipped the next day: /mission skill + worm dashboard template, reporter code (script + plist + INSTALL.md), enrolment tooling (mission-seed templates + /enrol skill), mission-discipline skill + CLAUDE.md. First live /mission render proven end-to-end. The board has a standing URL — see `BOARD.md` (Decision 7.1); every /mission run republishes it.

Read `.mission/SYNOPSIS.md` first, then `TASKS.md`. Full reasoning trail: `.mission/DECISIONS.md` (now 30 decisions). Ops cheat sheet: `PLAYBOOK.md`.

## What's next (in order)
1. **Install the reporter at the Mac mini** — `reporter/INSTALL.md`, ~2 min at the machine. Until then every board honestly shows "Mac mini has not reported".
2. **Enrolment wave one** — `/enrol` in a Claude Code session at the Mac mini; Adrian picks 3–5 repos and approves the pairing table.
3. Then: break-in period (Decision 1.7) — use /mission daily, correct via repo chats, FEEDBACK-LOG is the tuning record. Tier-2 questions are all closed (Decisions 8.1–8.3, 2026-08-11); only Tier-3 (beta) remains open.

The hourly board-refresh Routine (Decision 7.1) is **live** as of 2026-08-11: "Mission Control board refresh", hourly at :17 UTC, fresh session per fire, republishes the standing URL in `BOARD.md`. First-firing verification is an open task in `.mission/TASKS.md`.

## To resume in a new session
Paste:

> Read .mission/SYNOPSIS.md, .mission/TASKS.md and HANDOFF.md in this repo.
> We are building/operating, not discovering. Take the next unchecked task in TASKS.md.
> Follow the mission discipline (CLAUDE.md): checkpoint .mission/ and push as things happen.

At the Mac mini specifically: follow `reporter/INSTALL.md`, then run `/enrol`.
To see the board from anywhere: type `/mission` (republishes the standing URL in BOARD.md).

## To resume discovery (if something reopens)
> Read the files in .mission/. You are "Black Swan", a rigorous discovery interrogator.
> Discovery closed 2026-08-10 — reopen only the specific question at hand, challenge hard,
> log to DECISIONS.md (append-only), and push at every capture point.
