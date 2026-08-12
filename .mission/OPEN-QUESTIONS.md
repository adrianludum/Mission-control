# Mission Control — Open Questions

## Tier 1 — Blocks code
- ~~Q3: What is the exact standard artefact set per project?~~ → **Answered**: nine .md files in `.mission/` — README, DECISIONS, OPEN-QUESTIONS, LEARNINGS, CHANGELOG, FEEDBACK-LOG, PRD, TASKS (blockers tagged "owner: Adrian"), AGENT-LOG (Decision 2.6). Existing repos enrolled by back-fill.
- ~~Q5: How does the AI synopsis get generated?~~ → **Answered**: pre-computed at source — sessions write `.mission/SYNOPSIS.md` at every checkpoint; /mission assembles, thinks live only cross-project and where the git snapshot contradicts a stored synopsis (Decision 2.7).
- ~~Q13: What is the trigger phrase and what does it write?~~ → **Answered**: "update log" — universal checkpoint, session classifies, plain-English routing hints allowed (Decision 2.4). Promotion stays a distinct verb ("track this").
- ~~Q2: What counts as a "project"?~~ → **Answered**: a project = a repo (Decision 2.1); chat-only ideas are promoted manually — Claude creates and seeds the repo from the chat (Decision 2.2).
- ~~Q17: Can a Claude session create a GitHub repo?~~ → **Answered by spike: no** (403, installation tokens are repo-scoped). Promotion redesigned: Adrian creates the repo + grants app access, then "sync with git X" automates the rest (Decision 4.2).
- ~~Q4: Where does this run?~~ → Answered in part: generated on demand by a /mission skill (Decision 1.9). Remaining half is Q16.
- ~~Q16: How does /mission read Mac mini local state from a cloud/phone session?~~ → **Answered**: launchd/cron snapshot pushed to the Mission-control repo; self-timestamped; briefing degrades loudly when stale (Decision 2.5). Cadence/format are Phase 4 details.

## Tier 2 — Can decide during build
- ~~Q6: How are projects registered?~~ → **Answered**: repo creation registers the project in a curated index in the Mission-control repo, maintained by Claude at promotion/retirement (Decisions 2.1–2.3).
- ~~Q7: User-count sources?~~ → **Answered**: typed "Analytics source" column (`vercel:` / `supabase:` / `manual:` / `—`), resolved live when connectors are in reach, cached self-timestamped in `snapshot/analytics.md` for connector-less renders; mapped per product at enrolment (Decision 8.2).
- ~~Q8 (widened): How are staleness / git risk / planning incompleteness scored?~~ → **Answered**: rubric in /mission SKILL.md §6 — staleness bands from last-touch, git risk levels with unknown-sorts-as-serious, blocker-pressure ages, completeness checklist out of 100 (Decision 8.1).
- ~~Q9: Mobile access needed, or Mac-only?~~ → **Answered by shipped reality**: /mission is a skill on every surface (1.9, 4.4) and the first live render was from a phone on a plane. Mobile is in, no new decision needed.
- ~~Q14 (new): Where does agent activity history come from?~~ → **Answered**: solely each repo's AGENT-LOG.md, cross-checked against commits ("unlogged activity" gap lines); transcripts stay reconstruction-only (Decision 8.3).
- ~~Q15: How reachable is Claude chat history programmatically?~~ → **Answered**: Claude Code transcripts on the Mac mini are readable (`~/.claude`); claude.ai chats have no API — unreachable except manual export. Reconstruction coverage narrowed accordingly (Decision 4.1).

## Tier 3 — Can wait until beta
- ~~Q10: Notifications/nudges ("Boat Hub has an unpushed branch for 3 weeks")?~~ → **Answered**: escalation-only and silent by default — `/mission-watch` + a scheduled Routine, firing on exactly four conditions (single-copy work, reporter silent >24h, dirty/unpushed >7d, verified blocker >14d), with a 14-day cooling period in `snapshot/watch-state.md` so nothing is raised twice (Decision 9.4).
- ~~Q11: Sharing/team view, or strictly personal?~~ → **Answered**: strictly personal, closed by decision rather than build. The standing artifact URL stays private and can be shared ad hoc if a specific need arises; reopen only if a collaborator actually appears (Decision 9.6).
- ~~Trust acceptance test (parked with this tier by the note to Decision 3.5)~~ → **Answered**: four clauses over a 14-day window — zero material corrections, ≥10 renders read, ≥1 escalation the system saw first, no already-resolved blocker rendered. Spec in `TRUST-TEST.md`, run on demand from existing FEEDBACK-LOG data (Decision 9.5).

**Tier 3 is closed.** No open questions remain at any tier.

## Answered
- ~~Q1: Primary problem moment~~ → **Re-entry after days away** (Decision 1.1)
