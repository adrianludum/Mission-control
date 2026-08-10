# Mission Control — Product Requirements Document
*Status: In Progress — Phases 1–3 complete*
*Last synthesised: 2026-08-10*

## 1. Overview
Mission Control is a personal dashboard that lets Adrian re-enter any of his projects after days away and be fully briefed in minutes. Summoned by typing `/mission` in any Claude chat on any device, it reads project state — git status, decisions, open questions, tasks, agent activity — and presents a briefing per project: where things stand, what's still open, and what only Adrian can unblock.

**Architecture in one sentence:** everything is a markdown file in a repo — project state, the project index, the Mac mini's heartbeat, even the briefing itself — and every writer is an agent, never Adrian's memory.

## 2. Problem Statement
Adrian runs many concurrent projects in different phases. After a few days away he loses track of where each got to and what was decided. Re-entry costs archaeology time. Git records actions, not intent — the "what was I deciding?" layer is lost or scattered across Claude chats.

## 3. Target Audience
### Primary
Adrian — solo builder working across a Mac mini (always-on), GitHub, and Claude sessions on desktop and phone.
### Secondary
None in v1 (strictly personal; sharing is Tier-3).

## 4. Goals & Success Metrics
- Re-entry to a cold project takes minutes, not an hour of archaeology.
- Zero "lost decisions" — anything decided in a session is findable later.
- Trust: after a few weeks of co-tuning, briefings are actionable without verification (Decision 1.7). The product dies by trust-decay if it stays ~90% right.

## 5. Scope
### In Scope (v1) — "The Briefing"
- **Access**: `/mission` skill in any Claude chat, any device — the sole v1 door (1.9)
- **Home Screen**: compact project tiles — status, staleness, git risk, open-loop counts (1.3)
- **Project view**: Q&A state, Adrian's blockers, decisions record, git detail (branches, unpushed, uncommitted, which machine), task ledger, user counts for live products, read-only agent activity log (1.2, 1.4)
- **Re-entry synopsis** per project, pre-computed at source (2.7)
- **Capture**: auto-checkpoint at session end (primary) + "update log" trigger phrase (mid-session save) + AI reconstruction from git diffs/chat history (safety net); staleness detection internal (1.5, 1.6, 2.4)
- **Registration**: project = repo (2.1); chat ideas promoted on Adrian's word — Claude creates, seeds, and indexes the repo (2.2, 2.3)
- **Local truth**: Mac mini snapshot reporter (2.5)

### Explicitly Out of Scope (v1)
- Agent management — starting, steering, grading (v2)
- Team/sharing features
- Notifications/nudges (Tier 3)
- Hosted web app, scheduled delivery, pinned artifacts (other "doors" — addable later without rework)

## 6. Features & Mechanisms

### 6.1 The `/mission` skill (the door)
Reads, in order: project index (this repo) → each project's `.mission/` folder → Mac mini snapshot → analytics sources. Assembles stored synopses; thinks live only for the cross-project layer and any project whose git snapshot contradicts its stored synopsis. Degrades loudly when the Mac mini snapshot is stale: "Mac mini last reported N days ago — local state unknown," never a confident stale answer (2.5).

### 6.2 The `.mission/` standard (the contract) — ten files per tracked repo
README (mission overview), DECISIONS, OPEN-QUESTIONS, LEARNINGS, CHANGELOG, FEEDBACK-LOG, PRD, TASKS (blockers = entries tagged "owner: Adrian"), AGENT-LOG (append-only), SYNOPSIS (overwritten at every checkpoint) (2.6, 2.7). Existing repos are enrolled by back-fill: a Claude session reads the repo and seeds what it can.

### 6.3 Capture (how state stays true)
1. **Continuous checkpoint** (primary) — mission-disciplined sessions write to `.mission/` *as things happen*; a decision made mid-conversation is committed mid-conversation. "Session end" does not exist as a save moment (3.4, amending 1.6).
2. **"update log"** — comfort word forcing a save right now; per-chat by nature; never a required ritual (2.4, 3.4).
3. **Reconstruction** — for work done outside disciplined sessions, an agent rebuilds state from git diffs + whatever chat history is reachable (safety net; 1.6, Q15).

### 6.4 Promotion (how projects are born)
Adrian says "track this" in any session → no ceremony: the session picks a name, creates the repo private, seeds `.mission/` from the chat so far, appends to the index, reports afterwards (2.2, 2.3, 3.6). Thin ideas promote immediately — empty-shell files are honest ("just born, planning 5%"); the incompleteness signal nags them toward meat (3.3, 3.6). The same chat keeps checkpointing into the new repo; moving to a fresh repo-connected window later costs nothing because the files are the memory. Retirement: "retire X" → index edited.

### 6.5 Mac mini state reporter
launchd/cron job on the always-on Mac mini scans local repos, pushes a self-timestamped snapshot (uncommitted files, unpushed branches, no-remote repos) to this repo (2.5). Cadence/format: Phase 4.

## 7. User Journeys

### J1 — The morning briefing (phone, coffee)
Adrian types `/mission`. First screen: every tracked project in two bands — *Active* (last ~14 days) ordered by risk + planning incompleteness, *Dormant* ordered by time parked, risk still visible (3.1). He taps a project → detailed briefing: where it stands, what's open, what only he can do, git detail, tasks. The briefing's last element is a launch pad: top next action + open a context-loaded work chat on that repo (3.2). He either starts working or goes back up. Ninety seconds, briefed.

### J2 — The work session (capture is invisible)
Two hours in a session on a project. Decisions, discoveries, and task movement are written to `.mission/` as they happen (3.4). He closes the laptop at 11pm without saying anything — nothing is lost, because nothing was waiting to be saved. "update log" exists for forcing a save before chaos, not as duty.

### J3 — The wrong briefing (break-in repair)
A briefing confidently describes last week. Adrian opens a chat connected to the affected project's repo and corrects the files there; system-level errors get fixed in a chat on the Mission-control repo (3.5). Every correction appends a FEEDBACK-LOG line with the cause when diagnosable. The record of misses is the tuning curriculum (1.7).

### J4 — The birth (sofa, phone)
Ten minutes into riffing on a new idea: "track this." The session creates a private repo, seeds `.mission/` from the chat, indexes it, and says so — no questions asked (3.6). The tile appears honestly thin. The riff continues, checkpointing into the new repo; when the chat gets long, a fresh Claude Code window connected to the repo picks up with clean context and full state.

## 8. Data Model (Sketch)
- **Hub (this repo)**: project index (registry + per-project metadata: display name, host machine, analytics source, chat-heritage links) + Mac mini snapshot + this project's own `.mission/`.
- **Per project repo**: `.mission/` ten-file set.
- **External**: GitHub API (remote git state), analytics per product (Q7 mapping TBD), Claude chat history (reachability = Q15).

## 9. Technical Architecture
Serverless in the literal sense: no hosted app. GitHub is the database, Claude sessions are the compute, the skill is the UI, the Mac mini cron job is the only daemon. Phase 4 details open: snapshot cadence/format, skill implementation, spikes Q15/Q17.

## 10. Visual Direction & Tone
(Phase 5. Prototype v0 is a placeholder, not a direction decision.)

## 11. Risks & Dependencies
- **Trust-decay** (named killer): briefings that stay ~90% right after the tuning window kill the product (1.7). Mitigations: capture at source, loud degradation, reconstruction backstop.
- **Silent reporter death**: mitigated by self-timestamped snapshots + loud staleness (2.5).
- **Q17**: promotion assumes a phone Claude session can create a repo and push files — untested, Phase 4 spike.
- **Q15**: reconstruction and chat-seeded promotion assume chat history is reachable — untested, Phase 4 spike.
- **Unpromoted ideas die invisible** — accepted cost of manual curation (2.2).

## 12. Open Questions
See OPEN-QUESTIONS.md. Remaining: Q7 (analytics mapping), Q8 (staleness definition), Q14 (agent-log sourcing) — Tier 2; Q10/Q11 — Tier 3; spikes Q15/Q17.
