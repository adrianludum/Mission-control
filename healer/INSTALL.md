# Installing the daily healer

The reporter observes; this writes. Same launchd pattern, three differences worth
knowing before you install: it does **not** run at load, it probes its own CLI
flags before touching anything, and it audits what it changed afterwards.

Install once and Mission Control stops queueing mechanical repairs behind you.

## Assumptions

- Clone at `/Users/adriancassidyhome/Projects/mission-control` (lowercase dir,
  `adriancassidyhome` home). The plist hardcodes this — launchd expands nothing.
- `claude` is on disk and **already logged in as you**. The script does not use an
  API key and does not want one; it runs as your user with `HOME` set so it picks
  up your existing Claude Code auth.
- `git push` works non-interactively from the mini (it does — `gh` has `repo`
  scope per Decision 9.1). The script proves this in pre-flight and refuses to
  start if a prompt would be needed.

## Install

```sh
cd /Users/adriancassidyhome/Projects/mission-control
git pull

chmod +x healer/mission-heal.sh

# 1. Pre-flight and flag probe only — writes nothing. Do this first.
DRY_RUN=1 healer/mission-heal.sh
```

That dry run is the whole risk, front-loaded. It checks the clone, checks push
auth non-interactively, finds `claude`, and then — in a throwaway git repo it
creates and deletes — makes a real headless session **commit something**, and
verifies that commit by reading it back off disk rather than believing the
session's own report. **If it fails, it tells you which of those it was.**
Flag names move between Claude Code versions; fix `CLAUDE_FLAGS` in the plist if
the probe rejects them, and do not widen permissions to make an error go away.

The probe is deliberately a *write*. Until 2026-08-17 it asked the session to
reply with a word, which it always could — while every git command it needed was
being denied. `--permission-mode acceptEdits` covers file edits only; a Bash call
that needs approval in headless mode is refused outright, with no terminal to ask.
So `CLAUDE_FLAGS` now carries `--allowedTools Bash(git:*) Bash(gh:*)`, and the
probe proves it. A project `.claude/settings.json` allowlist is **not** a
substitute — it is ignored unless the workspace has been trusted interactively,
and it fails silently when it is not.

```sh
# 2. One real run, watched, with you present
healer/mission-heal.sh

# 3. Install the agent (does NOT fire on load — next run is 07:40 tomorrow)
cp healer/com.adrianludum.mission-healer.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.adrianludum.mission-healer.plist
```

Legacy macOS: `launchctl load -w ~/Library/LaunchAgents/com.adrianludum.mission-healer.plist`

## Verify

```sh
tail -40 ~/Library/Logs/mission-healer.log
launchctl print gui/$(id -u)/com.adrianludum.mission-healer | head -20
```

A healthy quiet day looks like `audit: 0 repos changed, 0 allowlist violations`
followed by `mission-heal done`. Nothing to heal is the expected result, not a
failure.

## What it is allowed to do

Mechanical repairs only:

- Apply `CANDIDATES.md` ticks via `/roster` — enrol and retire.
- Get stranded `.mission/` seeds onto default branches (the BoatHUB and
  training_status drift class).
- Correct `INDEX.md` rows to match reality.
- Checkpoint and push the hub.

Hard limits, enforced in the prompt and then **audited in the script**: in a
project repo it writes nothing but `.mission/**` and `CLAUDE.md`; never
force-pushes, rewrites history, or deletes branches; never commits work that was
already dirty; never resolves an `owner: Adrian` task. After every run it diffs
each enrolled repo's HEAD from before to after and logs `ERROR` for any path
outside that allowlist. It cannot prevent a bad edit — it guarantees a bad edit
is never quiet. Nothing is ever force-pushed, so anything it did is revertable.

The **hub** is audited against its own, wider allowlist — `INDEX.md`,
`CANDIDATES.md`, `BOARD.md`, `snapshot/**`, `.mission/**` — because updating the
registry is a charter step, not a transgression. Until 2026-08-17 the hub was
audited as though it were a project repo, so any run that actually healed
something ended `ERROR ... exit 1` for doing what it was told; only a run that
changed nothing could pass. And a repo enrolled *during* a run has no
before-HEAD to diff, so the audit now names it as **not audited** rather than
folding it into a clean total.

## Stop / uninstall

```sh
launchctl bootout gui/$(id -u)/com.adrianludum.mission-healer
rm ~/Library/LaunchAgents/com.adrianludum.mission-healer.plist
```

## Config

Env vars, override in the plist: `HUB_REPO`, `SCAN_ROOT`, `CLAUDE_BIN`,
`CLAUDE_FLAGS`, `MAX_SECONDS` (default 1800, hard kill), `DRY_RUN=1`.

## Known trap, inherited

`reporter/com.adrianludum.mission-reporter.plist` in this repo still points at
`/Users/adrian/Projects/Mission-control` — a path that does not exist on the
mini. The *installed* reporter plist was corrected by hand at install time
(2026-08-11) and is fine; the committed copy was never updated. Reinstalling the
reporter from this repo would silently install a broken agent. This healer's
plist carries the real paths.
