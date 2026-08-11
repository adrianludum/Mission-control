# Mission Control — Learnings

## Prior art research (2026-08-10)

**Git-state aggregation is a solved problem.**
- multi-git-status / mgitstatus, git-scope: CLI scan of all local repos → uncommitted / untracked / unpushed flags.
- GitKraken Workspaces: polished GUI, grouped repos, branch + PR status across all of them.
- git-standup: "what did I do recently" from commit history across repos.
- Backstage-style portals: team-scale project health, far too heavy for a solo builder.

**AI summarisation of repo activity exists but is backward-looking.**
- GitHub Copilot recipes and small CLI tools summarise commits/activity — *what happened*, not *what's unresolved*.

**The identified gap (the product):**
No tool combines live git state with *open loops* — undecided questions, unimplemented features, the intent behind the current state — and produces a re-entry briefing. Git can't know intent; it must come from artefacts (DECISIONS.md, OPEN-QUESTIONS.md, PRDs, TODOs) or from AI reading the project.

**Adrian-specific advantage:** the project-discovery workflow already produces DECISIONS.md / OPEN-QUESTIONS.md / PRD.md per project — a ready-made structured source for the "open loops" half, if those files live in each repo.

## Context facts
- Projects live on: a Mac mini (local repos), GitHub, and some only inside old Claude chats (no repo yet).
- Connected services available in Cowork: GitHub-adjacent tooling via shell, Vercel, Supabase.

## Build (2026-08-11)
- **First live /mission render worked end-to-end from a remote session** (Adrian on a plane, no Mac mini): read path (INDEX → .mission/ → snapshot), loud missing-snapshot degradation, and artifact render all behaved as designed. The board is usable before the reporter exists — honest degradation is doing its job.
- **Routine-fired sessions carry no MCP connectors** (the creating session held none to pass through) — fine for /mission, which only needs the repo, the in-repo snapshot, and the built-in Artifact tool; if a future routine needs a connector (Gmail, Slack…), create it from a session holding that connector or from the claude.ai routines UI.
