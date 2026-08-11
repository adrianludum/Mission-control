# Mission Control — Synopsis
*Overwritten at every checkpoint. Written 2026-08-11 by the Mac mini session.*

**Where it stands:** v0.1 + Tier-2 live; hourly board refresh verified (:17 UTC, trig_014ZFiJn3X4EFTVFY5MvNpnf). The hub now exists **on the Mac mini** for the first time (`~/Projects/mission-control`) and the reporter is **installed and proven**: a real snapshot of 20 git repos was committed and pushed, so the board no longer shows "Mac mini has not reported".

**Open:** the reporter's *hourly schedule* is not running. Its LaunchAgent is installed but unloadable over SSH — no GUI login session exists on the mini (see LEARNINGS). Until that's cleared the snapshot only refreshes when someone runs the script by hand. Tier-3 (notifications, sharing, trust acceptance test) remains at beta.

**Only Adrian can unblock:** (1) log in at the mini's desktop or via Screen Sharing — or enable auto-login — then bootstrap the agent into `gui/501`; (2) run `/enrol` for wave one (3–5 repos, approve pairing table + analytics sources). Note for enrolment: only 20 of 35 folders in `~/Projects` are git repos, and several actively-edited ones (`rowing`, `fitness`, `wrr-worktrees`) aren't under git at all, so they're invisible to this pipeline.
