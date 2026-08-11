---
name: enrol
description: Enrol existing local projects into Mission Control. Use when the user types /enrol, says "enrol my projects" or "enrolment wave", or asks to wire local project folders to GitHub and seed .mission/ folders. Intended for a Claude Code session on the Mac mini with the Mission-control repo available.
---

# Enrol — bulk enrolment of existing projects

You are running an enrolment wave (build step 3, Decision 6.1): survey local project folders, pair them with GitHub repos, wire and reconcile, seed the ten-file `.mission/` standard, and index each project in the Mission-control hub. Adrian is at the machine; he picks and approves.

## Guardrails (read first, apply throughout)

- **Never force-push. Never delete** files, branches, repos, or history. No `--force`, no `push --mirror`, no branch deletion.
- **Nothing destructive before the pairing table is approved** (Decision 4.3). Until approval, everything is read-only.
- **One repo failing must not stop the wave.** Catch the failure, record it for the report, move on.
- **App access**: each repo needs the Claude GitHub App granted. A repo that 403s on push/API is not an error to debug — list it in the report as **"needs app access"** (fix: grant the app at github.com → Settings → Applications) and continue.
- **Ambiguity goes to Adrian**, via AskUserQuestion — never guess a pairing or a merge direction.

## Flow

### 1. Survey
Survey the **direct child folders** of `~/Projects` (or a different root if Adrian names one — ask only if he hinted at one). For each folder note: is it a git repo (`.git` present); its remotes (`git remote -v`); current branch; last commit date; uncommitted/unpushed state. Non-repo folders are candidates too (they may need `git init`) — include them, marked as such.

### 2. Pairing table — present BEFORE acting
List the GitHub repos Adrian mentions or that the remotes reveal (`gh repo list` if available). Build a PAIRING TABLE:

| Local folder | GitHub repo | Proposed action |
|---|---|---|

Proposed action is one of: **wire remote** (repo exists both sides, no remote set / no GitHub twin yet — may include create-on-GitHub *by Adrian*), **reconcile histories** (both sides have commits that diverge), **already linked** (remote set, in sync or fast-forwardable), **skip** (not a project, or Adrian says so).

Where a mapping is ambiguous (name mismatch, two plausible twins, folder with no obvious repo), use AskUserQuestion. Then present the whole table and **wait for explicit approval**. Adrian may strike rows — only approved rows proceed.

### 3. Wire and reconcile (per approved repo)
- Wire the remote if missing (`git remote add origin ...`).
- `git fetch` first, always.
- Divergent history: prefer a clean merge or rebase; if the right resolution is genuinely ambiguous (real conflicts, unclear which side is truth), ask via AskUserQuestion. Never resolve by force-push; if only a force-push would work, stop that repo, mark it for the report, and move on.
- Push (`git push -u origin <branch>`).

### 4. Seed `.mission/`
Copy the ten templates from Mission-control's `templates/mission-seed/` (not README-TEMPLATES.md) into the repo's `.mission/`, then back-fill every `{{PLACEHOLDER}}` from what the repo itself reveals — README, code, commit history, TODOs — per the filling rules in `templates/mission-seed/README-TEMPLATES.md`. Honest about thinness: "Unknown — repo predates Mission Control" beats invention (Decision 3.6). **SYNOPSIS.md must be real**: where this stands, what's open, what only Adrian can unblock — as best the repo shows. `{{SEED_MODE}}` = "enrolment back-fill". If `.mission/` already exists, fill gaps only — never overwrite existing state files. Commit (`mission-control: enrol — seed .mission/`) and push to that repo.

### 5. Index in the hub
Append one row per enrolled repo to Mission-control's `INDEX.md` (create it with the header row if it doesn't exist yet):

| Project | Repo | Host machine | Local path | Analytics source | Status | Born | Notes |
|---|---|---|---|---|---|---|---|

Status e.g. "active"/"dormant" from last-commit recency; Analytics source "—" unless known; Born = enrolment date with "(enrolled)". Commit and push the hub.

### 6. Report
End with: a table of what was enrolled (repo, action taken, seed thinness note); anything skipped and why; repos marked "needs app access"; repos halted mid-reconcile and what Adrian must decide. Also append one line to the hub's `.mission/AGENT-LOG.md` for this run.
