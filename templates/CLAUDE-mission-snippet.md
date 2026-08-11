<!-- This is a template, not a CLAUDE.md itself. Paste the block below into the
     CLAUDE.md at the root of any mission-tracked repo (create the file if absent). -->

## Mission Control discipline

This repo is mission-tracked: `.mission/` holds the project's memory, and this session keeps it true **as things happen** — there is no session end, so nothing waits to be saved.

- The moment a decision is made, append it to `.mission/DECISIONS.md` (**What/Why/Date/Supersedes**). Questions opened/answered go to `OPEN-QUESTIONS.md`; task movement to `TASKS.md` (blockers only Adrian can clear are tagged `**owner: Adrian**`); learnings to `LEARNINGS.md`; scope changes to `CHANGELOG.md`; feedback on the system to `FEEDBACK-LOG.md`.
- End every checkpoint by overwriting `.mission/SYNOPSIS.md`: where this stands / what's open / what only Adrian can unblock — ≤8 lines, dated.
- Append one line per session to `.mission/AGENT-LOG.md` (date, actor, what was done, why it stopped). Append-only.
- Commit and push immediately after each checkpoint — small commits, message prefix `checkpoint:` plus what was captured. Retry failed pushes (up to 4x, backing off).
- **"update log"** = save everything known right now, classifying items yourself. Idempotent, never a required ritual.
- When Adrian corrects wrong state: fix the file where the error lives, and append the miss (with cause, if diagnosable) to `FEEDBACK-LOG.md`.
- Capture quietly — no narration beyond a brief note. State files stay calm and factual, never guilt-inducing.
