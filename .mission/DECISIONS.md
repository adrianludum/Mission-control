# Mission Control — Decisions Log
*Append-only. Newest at the bottom.*

### Decision 0.1 — Project name: "mission-control"
- **What**: The project is named Mission Control.
- **Why**: NASA framing — one screen showing the status of every mission. Chosen by Adrian from options.
- **Date**: 2026-08-10
- **Supersedes**: —

### Decision 0.2 — Prototype-first, discovery in parallel
- **What**: Build a fake-data visual prototype (v0) purely as a visualisation aid, while running full structured discovery. The prototype is disposable and does not constrain the PRD.
- **Why**: Adrian thinks visually; seeing the concept accelerates discovery answers.
- **Date**: 2026-08-10
- **Supersedes**: —

### Decision 1.1 — The problem is re-entry; v1 spine is the briefing
- **What**: The core pain is losing track of "where I got to and what decisions I made" after a few days away from a project. v1 is a **self-briefing tool** (read-only state reader). Agent *management* (starting, steering, grading autonomous agents) is explicitly v2.
- **Why**: Adrian's described pain is memory loss on re-entry. The "CEO overseeing agent staff" framing is the aspiration layered on top; building oversight first would balloon scope and assumes autonomous background work that doesn't exist yet.
- **Date**: 2026-08-10
- **Supersedes**: —

### Decision 1.2 — Briefing content spec (what a project view must answer)
- **What**: Per project, the briefing must show: (1) open questions & answered questions, (2) Adrian's blockers — jobs only he can do to proceed, (3) what has been designed & decided, (4) git state — sync/commit status and *where* work lies (machine, branch, pushed/unpushed), (5) user counts for live products, (6) tasks completed vs remaining, (7) read-only agent activity log (what agents are doing / have done).
- **Why**: Adrian's own list, confirmed after two flags (see 1.3 and 1.4 context).
- **Date**: 2026-08-10
- **Supersedes**: —

### Decision 1.3 — Two-level hierarchy: compact home tiles, rich project view
- **What**: The Home Screen shows compact project tiles (status, staleness, git risk, headline open-loop counts). Agent activity history and user counts live **inside the project detail view only**, not on home tiles.
- **Why**: Keeps the at-a-glance layer scannable; analytics and agent history are drill-down material.
- **Date**: 2026-08-10
- **Supersedes**: —

### Decision 1.4 — Agent presence in v1 is a read-only activity log
- **What**: v1 may show which agents exist and what they did ("agent X ran Tuesday, produced Y, stopped because Z") but offers no control surface — no starting, steering, or grading agents from the dashboard.
- **Why**: Fits the briefing spine (it's history, not management) without dragging v2 scope into v1.
- **Date**: 2026-08-10
- **Supersedes**: —

### Decision 1.5 — Capture mechanism direction: per-project .md state files + trigger phrase
- **What**: Each project carries standard machine-readable .md state files (decisions, open questions, tasks — exact set TBD). Adrian will sometimes type entries directly, but the primary mechanism is a **trigger phrase** he types to a working session/agent (e.g. in Claude) that causes it to write/update the state files, which the dashboard then reads.
- **Why**: Intent data (decisions, blockers, tasks) does not exist in git; relying on Adrian's unprompted end-of-session diligence is not credible (his agreement, implicitly). Delegating the writing to the session he's already talking to lowers the burden to one phrase.
- **Date**: 2026-08-10
- **Supersedes**: —
- **Note**: Failure mode (forgetting the trigger) resolved by Decision 1.6.

### Decision 1.6 — Capture safety architecture: auto-checkpoint primary, AI reconstruction as safety net
- **What**: Working sessions/agents automatically update the project's state files at session end (no trigger required); the trigger phrase becomes a bonus mid-session save. When state files still lag reality (missed checkpoint, work outside a session), an agent reconstructs the briefing from git diffs + reachable chat history. Staleness detection runs internally to decide when to reconstruct, but is not surfaced as a user-facing warning.
- **Why**: The agent in the session knows intent *now* — capturing at source is cheap and accurate. Reconstruction alone makes detective work the whole system instead of the backstop. Adrian initially chose reconstruction-only, reversed on challenge.
- **Date**: 2026-08-10
- **Supersedes**: —

### Decision 1.7 — Reliability bar: tune for weeks, then it must just work
- **What**: Adrian will actively engage in fine-tuning during an initial break-in period (a few weeks). After that, briefings must be trustworthy without his involvement — accepted pre-mortem: the product dies by trust-decay if it keeps being ~90% right after the tuning window.
- **Why**: A briefing tool that must be verified is worse than none. The tuning window is the budget for reaching trustworthy; it is not a permanent mode.
- **Date**: 2026-08-10
- **Supersedes**: —

### Decision 1.8 — Access requirement: near-zero friction from inside Claude, on any device
- **What**: Mission Control must be easy to load — or auto-load — whenever Adrian opens Claude, anywhere (desktop, mobile). Answers Q9: mobile access is required. Exact mechanism (skill command, scheduled delivery, persisted artifact, hosted URL) open — see Q4/Q16.
- **Why**: The re-entry moment happens wherever Adrian is; if the briefing takes effort to reach, it won't be used.
- **Date**: 2026-08-10
- **Supersedes**: —

### Decision 1.9 — The door is a skill command: /mission
- **What**: v1's sole access mechanism is a Claude skill — Adrian types /mission (name TBD) in any Claude chat on any device and the dashboard generates fresh. No hosted web app, no scheduled push, no pinned artifact in v1.
- **Why**: Zero infrastructure, works everywhere Claude works, and matches the summon-a-briefing mental model. Other doors can be added later without rework — the skill is the engine either way.
- **Date**: 2026-08-10
- **Supersedes**: —
- **Consequence**: Q4 sharpens into a data-reachability question — when /mission runs (possibly from a phone, in the cloud), how does it see Mac mini local repo state? See Q16.

### Decision 2.1 — A project = a repo
- **What**: Mission Control tracks repos, full stop. A chat-only idea is invisible to Mission Control until it is promoted to a repo. State files live in the project's repo — one code path, one place state lives, no separate registry.
- **Why**: Considered a registry model (repos as one source among several) and pure discovery (scan everything); both create a second home for state or make the reconstruction safety net the foundation. Repo-as-project keeps /mission's read path uniform.
- **Date**: 2026-08-10
- **Supersedes**: —

### Decision 2.2 — Promotion is manual, executed by Claude
- **What**: Adrian decides the promotion moment and says so in the session ("track this" or similar). The Claude session he's already in creates the GitHub repo and seeds it from the conversation: decision docs and the standard .md state files. No deferred "set it up at the Mac mini" step.
- **Why**: Keeps promotion at near-zero friction from any device (Decision 1.8) without auto-registration noise. Accepted cost: ideas never promoted die invisible — deliberate curation chosen over automatic capture.
- **Date**: 2026-08-10
- **Supersedes**: —
- **Consequence**: New Tier-1 technical assumption Q17 — a Claude session (including mobile) must be able to create a repo and push seed files. Possible unification of promotion with the trigger phrase parked in Q13.

### Decision 2.3 — Project registry: curated index in the Mission-control repo, machine-maintained
- **What**: /mission reads a curated index file living in the Mission-control repo itself — no auto-scan of all repos. Claude maintains the index: promotion (Decision 2.2) appends the entry when it creates the repo; retirement is Adrian telling a session "retire X" and it edits the index. Hand-editable, but no workflow requires Adrian to remember to. Index rows may carry metadata state files can't (display name, host machine, analytics source mapping, chat-heritage links).
- **Why**: Adrian wants an explicit list over marker-file discovery (rejects every-repo scanning). Staleness risk of a curated list is neutralised by making the same automated hand that creates projects register them. Makes Mission-control the hub /mission fetches first.
- **Date**: 2026-08-10
- **Supersedes**: —
- **Note**: No index-entry-only exception repo (one Adrian can't drop state files into) was named; if one appears, its tile can only promise git state.

### Decision 2.4 — Trigger phrase: "update log", universal checkpoint semantics
- **What**: The mid-session save trigger (Decision 1.6's bonus save) is the single phrase **"update log"**. On hearing it, the working session writes everything it currently knows to the project's state files — decisions since last save, new/answered open questions, Adrian's blockers, task movement — classifying items itself. No verb vocabulary; plain English may add routing hints ("update log — that last one's a blocker") but no grammar is required.
- **Why**: Per-item verbs ("log that" / "park that" / "job for me") solve a classification problem the session must already solve for auto-checkpoint to work; a command grammar remembered for years is friction. One word, identical in every project. Accidental utterance is harmless — a checkpoint is idempotent.
- **Date**: 2026-08-10
- **Supersedes**: —
- **Note**: Resolves Q13. Promotion ("track this", Decision 2.2) remains a distinct verb: it creates and registers a repo; "update log" saves state into an existing one.

### Decision 2.5 — Mac mini state reporter: scheduled snapshot pushed to the hub, loud staleness degradation
- **What**: A small launchd/cron job on the Mac mini (always-on machine) periodically scans local repos and pushes a state snapshot (uncommitted files, unpushed branches, no-remote repos, per-repo timestamps) to the Mission-control repo. /mission reads the snapshot like any other file. **Hard requirement**: the snapshot carries its own generation timestamp, and when it is stale the briefing degrades loudly — "Mac mini last reported N days ago, local state unknown" — never a confident answer from stale data.
- **Why**: Local git truth (the "git risk" tiles promise, Decision 1.3) exists only on that disk; a pushed snapshot needs zero servers and fits the files-as-truth architecture. Adrian: "no system is perfect" — the failure mode (silent job death, sleep) is handled by honest degradation rather than pretending the reporter is reliable, per the trust bar in Decision 1.7.
- **Date**: 2026-08-10
- **Supersedes**: —
- **Note**: Resolves Q16. Reporter cadence, snapshot format, and which folders it scans are Phase 4 build details.

### Decision 2.6 — Standard artefact set: nine .md files in a `.mission/` folder per repo
- **What**: Every tracked project carries a `.mission/` folder containing: README.md (mission overview/doc map), DECISIONS.md, OPEN-QUESTIONS.md, LEARNINGS.md, CHANGELOG.md, FEEDBACK-LOG.md, PRD.md, TASKS.md (task ledger; blockers are entries marked "owner: Adrian" — no separate blockers file), AGENT-LOG.md (append-only, one line per agent run; read-only surface per Decision 1.4). This is the contract: "update log" writes it, promotion seeds it, /mission parses it.
- **Why**: `.mission/` gives Mission Control a clean namespace — root README/CHANGELOG belong to the product, not the dashboard — and makes discovery logic trivial (look for `.mission/`). Blockers-as-tagged-tasks avoids two half-maintained lists. Existing repos mostly lack this structure (Adrian confirmed); they are enrolled by back-fill — a Claude session reads the repo and seeds what it can.
- **Date**: 2026-08-10
- **Supersedes**: —
- **Note**: Resolves Q3. Mission-control itself is dogfooded as tracked project #1 — its files migrate to `.mission/`. FEEDBACK-LOG carried empty until a product has users.

### Decision 2.7 — Synopsis pre-computed at the source; /mission assembles
- **What**: The re-entry synopsis is part of the state files: every auto-checkpoint and "update log" ends with the session writing/overwriting `.mission/SYNOPSIS.md` — where this stands, what's open, what only Adrian can unblock. /mission mostly assembles stored synopses (fast), does live thinking only for the cross-project layer, and re-synthesises a project on the spot when the git snapshot contradicts its stored synopsis (activity after the last checkpoint).
- **Why**: Decision 1.6's logic applied to the synopsis — the session knows intent now; capture at source. Fully-live synthesis across ~10 projects costs 30–90s on the phone; a scheduled synthesiser adds silently-dying infrastructure. The git snapshot gives /mission the means to detect stale synopses and re-think only those.
- **Date**: 2026-08-10
- **Supersedes**: — (amends 2.6: standard set becomes **ten** files, adding SYNOPSIS.md)
- **Note**: Resolves Q5. Model/cost of the assembly pass: whatever model the /mission session runs on — no separate pipeline.
