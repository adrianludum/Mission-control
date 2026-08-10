# Mission Control — Project Overview

**What:** An interactive dashboard giving Adrian a synopsis of every personal/Ludum side project — git state (branches, uncommitted, unpushed), open decisions, unimplemented features — so a project untouched for weeks can be re-entered in minutes, not hours.

**Why:** Git records what you *did*, never what you *meant to do*. Existing tools (multi-git-status, GitKraken Workspaces, git-standup) cover repo state; none combine it with "what's still open" or generate a re-entry briefing. That gap is the product.

## Document Map

| File | Purpose |
|---|---|
| DECISIONS.md | Append-only log of every decision made |
| OPEN-QUESTIONS.md | Unresolved questions, triaged by urgency |
| LEARNINGS.md | Research insights and competitor findings |
| CHANGELOG.md | Scope changes, pivots, dropped features |
| FEEDBACK-LOG.md | Raw feedback with triage status |
| PRD.md | The synthesised Product Requirements Document |
| prototype-v0.html | Fake-data visual prototype (concept aid, not spec) |

## Key Principles (working)

- The dashboard's job is **re-entry**, not monitoring. Optimise for "I haven't touched this in 6 weeks."
- Surface *open loops* (undecided, unimplemented), not just activity.
- Sources of truth: Mac mini local repos, GitHub, and project artefacts (DECISIONS.md / OPEN-QUESTIONS.md / PRDs) — including projects that only exist in old Claude chats.
