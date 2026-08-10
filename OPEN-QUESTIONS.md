# Mission Control — Open Questions

## Tier 1 — Blocks code
- Q3 (sharpened): What is the exact standard artefact set per project? File names, format, where they live in the repo (e.g. `.mission/` folder vs root-level .md files). → Phase 2/4
- Q5: How does the AI synopsis get generated — on demand, on a schedule, by which model/agent, at what cost?
- Q13: What *is* the trigger phrase, and what exactly does it write? One phrase for everything, or verbs ("log that" = decision, "park that" = question, "job for me" = blocker)? Also: is promotion (Decision 2.2) just the trigger phrase running against a project with no repo yet? (Unification suspected, unconfirmed.)
- ~~Q2: What counts as a "project"?~~ → **Answered**: a project = a repo (Decision 2.1); chat-only ideas are promoted manually — Claude creates and seeds the repo from the chat (Decision 2.2).
- Q17 (new): Can a Claude session — especially on mobile — actually create a GitHub repo and push seed files? Promotion (Decision 2.2) depends on it. Riskiest-assumption class alongside Q15; test early in Phase 4.
- ~~Q4: Where does this run?~~ → Answered in part: generated on demand by a /mission skill (Decision 1.9). Remaining half is Q16.
- Q16 (new): When /mission runs from a phone (cloud session, no device bridge), how does it read Mac mini local repo state — uncommitted files, unpushed branches, repos with no remote? Candidates: (a) a small cron on the Mac mini pushes a state snapshot (JSON/md) to a private GitHub repo on a schedule, (b) GitHub-only data when mobile + full data when desktop app is open, (c) require everything to have a remote. Likely Phase 4's first design task.

## Tier 2 — Can decide during build
- Q6: ~~How are projects registered~~ → Mostly answered: registration = repo creation (Decisions 2.1/2.2). Remaining sliver: does /mission auto-discover all repos, or read a curated list (some repos aren't projects)?
- Q7: User-count sources: Vercel analytics? Supabase? App telemetry? Per-product mapping needed. (Panel confirmed in v1, project view only.)
- Q8: How is "staleness" defined and displayed?
- Q9: Mobile access needed, or Mac-only?
- Q14 (new): Where does agent activity history come from? (Session logs, workflow journals, manual notes?) Read-only in v1 per Decision 1.4.
- Q15 (new): How reachable is Claude chat history programmatically? Reconstruction (Decision 1.6) and chat-only projects (Q2) both depend on it. Candidate: riskiest technical assumption — test early in Phase 4.

## Tier 3 — Can wait until beta
- Q10: Notifications/nudges ("Boat Hub has an unpushed branch for 3 weeks")?
- Q11: Sharing/team view, or strictly personal?

## Answered
- ~~Q1: Primary problem moment~~ → **Re-entry after days away** (Decision 1.1)
