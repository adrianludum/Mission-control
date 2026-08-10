# Mission Control — Product Requirements Document
*Status: Draft — Phase 1 (Problem & Purpose) complete pending confirmation*
*Last synthesised: 2026-08-10*

## 1. Overview
Mission Control is a personal dashboard that lets Adrian re-enter any of his projects after days away and be fully briefed in minutes. It reads project state — git status, decisions made, open questions, tasks, agent activity — and presents a synopsis per project: where things stand, what's still to be decided, and what only Adrian can unblock.

## 2. Problem Statement
Adrian runs many concurrent projects in different phases (final testing, planning, mid-development, design-only in Claude). After a few days away he loses track of where each project got to and what decisions were made. Re-entry costs archaeology time and mental load. Git records actions, not intent — the "what was I deciding?" layer is currently lost or scattered across Claude chats.

## 3. Target Audience
### Primary
Adrian — solo builder / "CEO of his own projects", working across a Mac mini, GitHub, and Claude sessions.
### Secondary
None in v1 (strictly personal; sharing is a Tier-3 question).

## 4. Goals & Success Metrics
- Re-entry to a cold project takes minutes, not an hour of archaeology.
- Zero "lost decisions" — anything decided in a session is findable later.
- (Draft — success metrics to be firmed in later phases.)

## 5. Scope
### In Scope (v1) — "The Briefing"
- **Access**: /mission skill command in any Claude chat, any device — the sole v1 door (Decision 1.9)
- Home Screen: compact project tiles (status, staleness, git risk, open-loop counts)
- Project view: Q&A state, Adrian's blockers, design/decision record, git detail (branches, unpushed, uncommitted, which machine), task ledger, user counts (live products), read-only agent activity log
- AI re-entry synopsis per project
- Capture: auto-checkpoint by working sessions at session end (primary) + trigger phrase (mid-session save) + AI reconstruction from git diffs/chat history when state lags (safety net); staleness detection internal, not user-facing (Decisions 1.5, 1.6)
- Reliability bar: co-tuning for the first few weeks, then briefings must be trustworthy unaided (Decision 1.7)

### Explicitly Out of Scope (v1)
- Agent management: starting, steering, or grading agents from the dashboard (v2)
- Team/sharing features
- Notifications/nudges (Tier 3, revisit at beta)

## 6. Features & Screens
(To be detailed in Phase 2/3. Prototype v0 exists as a visual reference only — `prototype-v0.html`.)

## 7. User Journeys
(Phase 3.)

## 8. Data Model (Sketch)
Sources per project:
- Git: local repos on Mac mini + GitHub remotes
- Intent artefacts: standard .md state files in each repo (exact set TBD — Q3)
- Chat-only projects: registration + capture path TBD (Q2)
- Usage: per-product analytics source mapping TBD (Q7)
- Agent activity: source TBD (Q14)

## 9. Technical Architecture
(Phase 4. Open: where it runs — Q4.)

## 10. Visual Direction & Tone
(Phase 5. Prototype v0 is a placeholder, not a direction decision.)

## 11. Risks & Dependencies
- **Capture discipline**: the product dies if intent files go stale. Mitigation design open (Q12).
- Chat-only projects have no filesystem to read — capture path unclear (Q2).

## 12. Open Questions
See OPEN-QUESTIONS.md — 6 Tier-1, 5 Tier-2, 2 Tier-3 as of this synthesis.
