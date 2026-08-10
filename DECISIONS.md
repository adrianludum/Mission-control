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
