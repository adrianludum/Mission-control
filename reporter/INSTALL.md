# Installing the Mac mini reporter

Paste-ready steps for a Claude Code session running **at the Mac mini**. Two minutes.

## Assumptions (check these first)

- The Mission-control clone lives at `/Users/adrian/Projects/Mission-control`. The plist hardcodes
  this path and the log path, because **launchd does not expand `$HOME`** in `ProgramArguments`
  or `StandardOutPath`. If the username or clone location differs, edit the two `/Users/adrian/...`
  paths in `com.adrianludum.mission-reporter.plist` before installing.
- The mini can push to this repo **non-interactively** — i.e. `git -C ~/Projects/Mission-control push origin main`
  works without prompting (SSH key loaded, or credential helper / `gh auth` configured).
  If it prompts, fix auth first; launchd runs have no terminal to answer prompts.

## Install

```sh
# 1. Verify the clone is where the plist expects
ls /Users/adrian/Projects/Mission-control/reporter/mission-report.sh

# 2. Make the script executable
chmod +x /Users/adrian/Projects/Mission-control/reporter/mission-report.sh

# 3. One manual test run (watch stdout; it should scan, write snapshot/mac-mini.md, commit, push)
/Users/adrian/Projects/Mission-control/reporter/mission-report.sh

# 4. Install the launchd user agent
cp /Users/adrian/Projects/Mission-control/reporter/com.adrianludum.mission-reporter.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.adrianludum.mission-reporter.plist
```

If `launchctl bootstrap` errors on an older macOS, use the legacy form:
`launchctl load -w ~/Library/LaunchAgents/com.adrianludum.mission-reporter.plist`

`RunAtLoad` is true, so it fires immediately on bootstrap, then every hour (`StartInterval` 3600).

## Verify

```sh
# It ran and logged
tail -20 ~/Library/Logs/mission-reporter.log

# It's loaded
launchctl print gui/$(id -u)/com.adrianludum.mission-reporter | head -20
```

Then check GitHub: the Mission-control repo should show a fresh commit
`reporter: snapshot <timestamp>` touching `snapshot/mac-mini.md`. That commit
appearing hourly is the heartbeat; /mission complains loudly when it stops.

## Stop / uninstall

```sh
launchctl bootout gui/$(id -u)/com.adrianludum.mission-reporter
# (legacy: launchctl unload -w ~/Library/LaunchAgents/com.adrianludum.mission-reporter.plist)
rm ~/Library/LaunchAgents/com.adrianludum.mission-reporter.plist
```

## Notes

- The script only ever writes/commits/pushes the Mission-control repo; scanned repos are read-only.
- Config overrides via env vars if ever needed: `SCAN_ROOT`, `HUB_REPO`, `SNAPSHOT_FILE`, `DRY_RUN=1` (test without commit/push).
