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
- **Checkpoint isolation can double-create external resources.** Two sessions each created the board-refresh Routine (01:13 and 01:17) because the first's checkpoint lived on an unmerged side branch — the second session, reading the default branch, saw "blocked" and acted. Files-as-truth only works across sessions once the files reach the default branch; for external side-effects (Routines, artifacts, deployed things), verify against the live system (`list_triggers` etc.) before creating, not just against .mission state. Duplicate deleted 02:4x UTC; board itself was fine (last writer wins on the standing URL).
- **The trigger-creation approval blocker didn't reproduce in a fresh remote session** (2026-08-11): `create_trigger` went straight through — the build session's stuck dialog was session-specific, not a platform rule. Two caveats learned from the creation response: (a) hourly cron at minute 0 is server-anchored to the creation minute (ours became `:17`), so the board's cadence is :17 past each hour; (b) Routine-fired sessions carry **no MCP connectors** — fine for /mission (repo files + Artifact tool only), but any future Routine needing Gmail/Slack/etc. must be created from a session holding those connectors, or via the claude.ai routines UI.

## Install (2026-08-11)
- **A LaunchAgent cannot be loaded over SSH — it needs an Aqua (GUI login) session.** Installing the reporter at the mini over SSH, `launchctl bootstrap gui/$(id -u)` fails `125: Domain does not support specified action`, `user/$(id -u)` fails `5: Input/output error`, and legacy `load -w` silently no-ops. Root cause: `stat -f %Su /dev/console` = `root` and no `loginwindow` process for uid 501 — nobody is logged in at the mini's desktop, so the GUI domain doesn't exist. INSTALL.md's "two minutes at the machine" means *at the console or via Screen Sharing*, not SSH'd in. The same limitation was independently silently killing an unrelated LaunchAgent on this machine (the `_dashboard` server), which had been assumed to be running since July. **Consequence for the reporter's reliability promise:** if the mini reboots and no one logs in at the desktop, the hourly heartbeat stops and the board correctly reports staleness — but the cause will be a login state, not the script. Auto-login is the durable fix; a LaunchDaemon is not, because osxkeychain git credentials aren't available to root.
## Operating (2026-08-12)
- **The reporter's hourly schedule resolved itself and nothing noticed.** `launchctl print gui/501/com.adrianludum.mission-reporter` shows the agent loaded, and the hub has an unbroken run of `reporter: snapshot …` commits every hour since 2026-08-11T22:32Z (a GUI login must have happened at the mini). But `SYNOPSIS.md` and `TASKS.md` still carried the blocker a day later, because **nothing in the system re-checks a blocker once written** — blockers are only cleared by a session being told. The board would have shown a stale Adrian-blocker aging toward "critical" while the underlying fact was fixed. This is the trust-decay failure mode (1.7) arriving from the opposite direction than expected: not a briefing that is 90% right about risk, but one that is confidently wrong about what is *still broken*. **Consequence:** /mission should verify cheap, machine-checkable blockers against live evidence before rendering them, rather than trusting TASKS.md alone.
- **Enrolment can strand a project's `.mission/` on a side branch, making it unreadable.** `training_status` was enrolled while checked out on `feat/resting-measurements`, so its seeded `.mission/` was committed to that branch and no other — not `main`, not the branch checked out now (`claude/ludum-sandbox-sync-issue-kts95w`). Every later session reads the working tree, finds no `.mission/`, and sees the project as unenrolled. This is the 2026-08-11 checkpoint-isolation learning recurring in a new place: **state that never reaches a shared branch is invisible to everyone**. `/enrol` seeds onto whatever branch happens to be checked out and never checks that it is the shared one. Fix: seed onto the default branch (or say plainly that it did not), and have `/roster` treat "indexed but no readable `.mission/`" as drift worth reporting.
- **A Claude session on the mini CAN create GitHub repos — Decision 4.2's premise was too narrow.** The spike behind 4.2 (Q17) tested the GitHub *app* installation token, which is repo-scoped and 403s on creation. But `gh` is installed and authenticated at the mini as `adrianludum` with scopes `gist, read:org, repo, workflow` — `gh repo create` works. 4.2's conclusion ("promotion needs manual repo birth") holds only for connector-only sessions; at the mini, promotion can be fully automated. Snapshot/promotion tooling should prefer `gh` when present and fall back to manual birth otherwise.
- **The reporter is blind to nested repos, and that hides real projects.** It scans direct children of `SCAN_ROOT` only (`mission-report.sh:115`), so it sees 20 repos — but `events/`, `fitness/`, `rowing/`, `make-alevels-easy/`, `Loom Video scraper/` and `_archive/` are plain container folders holding **16 further git repos** (boat-hub, race-timing-app, ai-gym-hub, rowing-analyser, …). Those are invisible to the board today. Depth-2 scanning would surface them; the cost is noise from archives.
- **The hub clone's directory name is load-bearing in two places.** The script defaults `HUB_REPO` to `$HOME/Projects/Mission-control`; this clone is `~/Projects/mission-control` and only resolves by accident of macOS's case-insensitive filesystem. The plist now sets `HUB_REPO`/`SCAN_ROOT` explicitly rather than relying on that. INSTALL.md also still says `git push origin main` in its auth check — there is no `main` branch in this repo; the script itself is correct (it pushes whatever branch is checked out).
- **First real scan is honest but coarse:** 20 of 35 folders in `~/Projects` are git repos; the other 15 (incl. actively-edited `rowing`, `fitness`, `wrr-worktrees`) are invisible to the reporter entirely, because it only scans direct children that contain `.git`. Worth knowing before enrolment wave one — an un-versioned project can't be tracked by this pipeline at all.

## An agent log entry is a claim, not a receipt (2026-08-17)

The hub's log records 2026-08-12 as "cloned, seeded and pushed ten-file `.mission/` to 7 repos". The
2026-08-17 render was the first to reach every checkout directly, and found that for `ai-gym-hub` and
`gym-hub` the seed is on **no branch at all** — both repos' last commit is still the June bulk-sync
commit. Whatever happened, it did not land, and the log has read as done for five days.

Three things follow. **A write is only proven by reading it back from the target** — the seeding session
reported what it attempted, not what existed afterwards. **The unlogged-commits cross-check of Decision
8.3 cannot catch this**, because it looks for commits with no log entry, and this is the mirror case: a
log entry with no commit. The healer's post-run audit (9.9) is the right shape — it diffs each repo's
HEAD before and after rather than trusting the run's own account of itself. And **`/mission-watch` missed
the louder finding sitting underneath it**: AI Gym Hub has three real specification documents untracked
since June, which is condition #1 (single-copy work) exactly, yet the only escalations ever raised were
two ULBC blockers. Worth checking whether the watch inspects untracked files at all, or only branches.

This is the third instance of the same class — the reporter blocker rendered for a day after it was
fixed (2026-08-12), the rename and DB-block that never reached `.mission/` (2026-08-14), and now a seed
that was logged but never landed. The pattern is not carelessness in any one session; it is that
**nothing re-reads the world to confirm what the files assert.** That is what §3a started and what the
healer's audit should finish.

## Full code / git / sync audit (2026-08-17, cloud session)

An end-to-end review of the reporter, the healer, the five skills, the git layout and the
snapshot↔index↔roster agreement. Four findings that were not previously recorded.

**The healer cannot succeed as written — two defects, both in the part nobody has run yet.**
(1) Its post-run audit reads every `~/`-prefixed path out of `INDEX.md`, and the hub is row one,
so the hub is audited like a project repo — against an allowlist of `.mission/**` and `CLAUDE.md`
only. Charter steps 1 and 3 *require* it to edit `INDEX.md` and `CANDIDATES.md`, so every run that
actually heals something ends `ERROR: the healer wrote outside .mission/` and `exit 1`. A quiet day
passes; a productive day looks like a violation. The hub needs its own allowlist
(`INDEX.md`, `CANDIDATES.md`, `snapshot/**`, `.mission/**`), or exclusion from the loop.
(2) `--permission-mode acceptEdits` auto-approves *edits*; every git operation is a Bash call, and
this repo carries no `.claude/settings.json` permission allowlist, so in headless `-p` mode those
calls are denied. The healer would edit files and be unable to commit or push them — its entire
purpose. The flag probe cannot catch this: it asks for a text reply, which needs no tool at all.
A probe that proves the premise has to run one harmless *command* (`git status`), not one sentence.

**Two of the watch's four escalation conditions are not computable from the data the reporter
produces.** Conditions #1 (single-copy work) and #3 (dirty/unpushed >7 days) both need file
identity or file age; the snapshot records `Uncommitted: N` and `Untracked: N` — counts, no names,
no ages. Nearly every repo on the mini shows exactly 3 untracked (house noise: `.claude/`,
`.DS_Store`), so AI Gym Hub's three real specification documents are, from the snapshot,
indistinguishable from that noise. That is the concrete answer to the 2026-08-17 question "does the
watch inspect untracked files at all" — it cannot; the data is not there. It also explains why the
only escalations ever raised are the two ULBC blockers, which come from `TASKS.md`, not the
snapshot. Reporting the first few untracked paths and an oldest-mtime would make both conditions
real. Related and already visible today: 13 no-upstream branches across 5 repos, one of them
enrolled (`training_status`, including the prepared `mission/seed-on-main` fix) — textbook
condition #1, never raised.

**The reporter reports local-refs truth, not git truth.** It never fetches, so "unpushed" is
measured against remote-tracking refs as stale as the last manual fetch, and *behind* is invisible
entirely — the enrolment wave found `familysite` 29 behind and `World Rowing Results` 279 behind,
and no snapshot would ever have said so. Two smaller ones from the same read: it sets no
`GIT_TERMINAL_PROMPT=0` (the healer does) and takes no lock (the healer does), so an expired
credential would hang a launchd run on a prompt with no terminal while the next hour starts anyway;
and `scan_repo` cannot return non-zero (its last statement is an assignment), so the "scan failed"
fallback is dead code and a broken repo reports plausible-looking values instead.

**The hub has no `main`.** The default branch is `claude/mission-control-setup-wnn4tr`, a session
branch, and the reporter, the healer and both INSTALL docs all push "whatever is checked out" —
correct today, one wrong checkout from a split-brain hub. Four further session branches sit on the
remote; all four were diffed and carry **no unique content** — only deletions and superseded
state-file text — so they are safe to delete, and they are the same class of stranded branch that
caused the duplicate-Routine incident. Separately, 45 of the 50 commits are reporter snapshots
(24/day and growing), so `git log` no longer shows the project's real history without a path filter.
