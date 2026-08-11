# mission-seed — the ten-file `.mission/` seed set
*How these templates are used. This file is documentation for the templates folder — it is NOT part of the seed set and is never copied into a target repo.*

These are the skeletons for the `.mission/` standard (Decision 2.6, amended to ten files by 2.7): README, DECISIONS, OPEN-QUESTIONS, LEARNINGS, CHANGELOG, FEEDBACK-LOG, PRD, TASKS, AGENT-LOG, SYNOPSIS. Copy all ten into a target repo's `.mission/` folder, then replace every `{{PLACEHOLDER}}` token.

## Two flows consume this set

1. **Enrolment back-fill** (`/enrol` skill, PLAYBOOK "Enrol existing projects"): a Claude Code session enrolling an existing repo copies the set, then back-fills each file from what the repo itself reveals — README, code, commit history, TODOs. `{{SEED_MODE}}` = "enrolment back-fill".
2. **Promotion seeding** ("sync with git X", Decision 4.2): a session promoting a chat idea seeds the set from the conversation so far. `{{SEED_MODE}}` = "promotion from chat".

## Filling rules

- **Replace every token.** No `{{...}}` may survive into a committed file. Where the repo genuinely reveals nothing, write an honest thin value ("Unknown — repo predates Mission Control; nothing recorded.") rather than inventing content.
- **Born-thin is honest** (Decision 3.6): an empty-shell file is fine. The planning-incompleteness signal (3.3) exists precisely to nag thin projects toward meat. Never pad a file to look complete.
- **SYNOPSIS.md must always be real**: even at birth it states "where this stands" as best the seeding session can tell — it is the one file that may never be a stub, because /mission assembles briefings from it (Decision 2.7).
- **Prune placeholder lines that don't apply** (e.g. the Tier-1 question line, the Learnings topic block) rather than leaving filler.
- **Respect each file's contract**, stated in the italic line at the top of each: DECISIONS and AGENT-LOG are append-only newest-last; SYNOPSIS is overwritten at every checkpoint; TASKS blockers are entries tagged **owner: Adrian**; FEEDBACK-LOG rides empty until there is feedback.

## Token glossary

| Token | Meaning |
|---|---|
| `{{PROJECT_NAME}}` | Display name of the project |
| `{{DATE}}` | Seeding date, YYYY-MM-DD |
| `{{ONE_LINER}}` | The project in one breath |
| `{{SEEDED_BY}}` | Who wrote the seed (e.g. "enrolment session (Claude Code, Mac mini)") |
| `{{SEED_MODE}}` | "enrolment back-fill" or "promotion from chat" |
| Everything else | Self-describing; `..._OR_UNKNOWN` / `..._OR_REMOVE_LINE` suffixes state the fallback |
