# Mission Control — Open Questions

## Tier 1 — Blocks code
- ~~Q3: What is the exact standard artefact set per project?~~ → **Answered**: nine .md files in `.mission/` — README, DECISIONS, OPEN-QUESTIONS, LEARNINGS, CHANGELOG, FEEDBACK-LOG, PRD, TASKS (blockers tagged "owner: Adrian"), AGENT-LOG (Decision 2.6). Existing repos enrolled by back-fill.
- ~~Q5: How does the AI synopsis get generated?~~ → **Answered**: pre-computed at source — sessions write `.mission/SYNOPSIS.md` at every checkpoint; /mission assembles, thinks live only cross-project and where the git snapshot contradicts a stored synopsis (Decision 2.7).
- ~~Q13: What is the trigger phrase and what does it write?~~ → **Answered**: "update log" — universal checkpoint, session classifies, plain-English routing hints allowed (Decision 2.4). Promotion stays a distinct verb ("track this").
- ~~Q2: What counts as a "project"?~~ → **Answered**: a project = a repo (Decision 2.1); chat-only ideas are promoted manually — Claude creates and seeds the repo from the chat (Decision 2.2).
- Q17 (new): Can a Claude session — especially on mobile — actually create a GitHub repo and push seed files? Promotion (Decision 2.2) depends on it. Riskiest-assumption class alongside Q15; test early in Phase 4.
- ~~Q4: Where does this run?~~ → Answered in part: generated on demand by a /mission skill (Decision 1.9). Remaining half is Q16.
- ~~Q16: How does /mission read Mac mini local state from a cloud/phone session?~~ → **Answered**: launchd/cron snapshot pushed to the Mission-control repo; self-timestamped; briefing degrades loudly when stale (Decision 2.5). Cadence/format are Phase 4 details.

## Tier 2 — Can decide during build
- ~~Q6: How are projects registered?~~ → **Answered**: repo creation registers the project in a curated index in the Mission-control repo, maintained by Claude at promotion/retirement (Decisions 2.1–2.3).
- Q7: User-count sources: Vercel analytics? Supabase? App telemetry? Per-product mapping needed. (Panel confirmed in v1, project view only.)
- Q8 (widened): How are "staleness", "git risk", and "planning incompleteness" (Decision 3.3) each defined and scored for tile ordering/status?
- Q9: Mobile access needed, or Mac-only?
- Q14 (new): Where does agent activity history come from? (Session logs, workflow journals, manual notes?) Read-only in v1 per Decision 1.4.
- Q15 (new): How reachable is Claude chat history programmatically? Reconstruction (Decision 1.6) and chat-only projects (Q2) both depend on it. Candidate: riskiest technical assumption — test early in Phase 4.

## Tier 3 — Can wait until beta
- Q10: Notifications/nudges ("Boat Hub has an unpushed branch for 3 weeks")?
- Q11: Sharing/team view, or strictly personal?

## Answered
- ~~Q1: Primary problem moment~~ → **Re-entry after days away** (Decision 1.1)
