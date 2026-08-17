#!/bin/bash
#
# mission-heal.sh — the daily self-healer (Decision 9.9).
#
# The reporter (mission-report.sh) is deliberately dumb and read-only: it
# observes. This script is its write-side twin. It runs one headless Claude
# session a day at the machine where credentials already live, and lets it do
# the MECHANICAL repairs that were previously queueing behind Adrian:
# applying roster ticks, and getting stranded `.mission/` seeds onto default
# branches. Judgement calls are never delegated here — those stay owner: Adrian.
#
# Design rule inherited from the reporter: be too simple to break, and fail
# loudly rather than silently. Two extra rules of its own, because unlike the
# reporter this thing WRITES:
#   1. Flags are probed before the real run, so a CLI change fails on the
#      cheap call with a clear message instead of half-way through a repair.
#   2. Every enrolled repo's HEAD is recorded before and after. Anything the
#      run touched outside the allowlist is reported as ERROR. The script
#      cannot prevent a bad edit, but it guarantees you hear about it.
#
# Config (env vars, all optional):
#   HUB_REPO      the Mission-control clone     (default: $HOME/Projects/mission-control)
#   SCAN_ROOT     where project repos live      (default: $HOME/Projects)
#   CLAUDE_BIN    claude executable             (default: first on PATH)
#   CLAUDE_FLAGS  headless flags — see NOTE     (default: below)
#   MAX_SECONDS   wall-clock kill switch        (default: 1800)
#   DRY_RUN       1 = probe + report only, no healing run
#
# NOTE on CLAUDE_FLAGS: flag names move between Claude Code versions. These are
# the conservative set. Deliberately NOT used:
#   --bare                  would skip loading .claude/skills, so /roster would
#                           not exist — that is the whole point of this script.
#   --dangerously-skip-permissions   too broad for an unattended writer.
# If the probe fails, read the log, fix CLAUDE_FLAGS in the plist, re-run. Do
# not "fix" it by widening permissions beyond the git/gh allowlist below.
#
# WHY --allowedTools IS NOT OPTIONAL (verified 2026-08-17, not assumed):
#   --permission-mode acceptEdits auto-approves *file edits* only. Every git
#   operation is a Bash call, and in headless -p mode a Bash call needing
#   approval is DENIED outright — there is no terminal to ask. Measured:
#     acceptEdits alone           → "git add -A, git commit" require approval → denied
#     + --allowedTools Bash(git:*) → commit succeeds
#   Read-only git (status/log/diff) is auto-approved either way, which is why a
#   probe that only *reads* proves nothing. Without this allowlist the healer
#   would edit files it could never commit — silently doing half its job.
#   A project .claude/settings.json allowlist does NOT substitute: it is ignored
#   unless the workspace has been trusted interactively, and it fails silently.

set -u

HUB_REPO="${HUB_REPO:-$HOME/Projects/mission-control}"
SCAN_ROOT="${SCAN_ROOT:-$HOME/Projects}"
CLAUDE_BIN="${CLAUDE_BIN:-$(command -v claude 2>/dev/null || echo '')}"
CLAUDE_FLAGS="${CLAUDE_FLAGS:---permission-mode acceptEdits --allowedTools Bash(git:*) Bash(gh:*) --max-turns 60}"
MAX_SECONDS="${MAX_SECONDS:-1800}"
DRY_RUN="${DRY_RUN:-0}"

LOCKDIR="/tmp/mission-heal.lock"

log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"; }

NOW_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

log "mission-heal starting (hub: $HUB_REPO)"

# ------------------------------------------------------------------ pre-flight
# Every check here is a reason NOT to start writing. Bail before, not during.

if ! mkdir "$LOCKDIR" 2>/dev/null; then
  log "ERROR: $LOCKDIR exists — a previous run is still going or died hard."
  log "       If no heal process is running, remove it: rmdir $LOCKDIR"
  exit 1
fi
trap 'rmdir "$LOCKDIR" 2>/dev/null' EXIT

if [ -z "$CLAUDE_BIN" ] || [ ! -x "$CLAUDE_BIN" ]; then
  log "ERROR: claude CLI not found. launchd does not read your shell profile —"
  log "       set CLAUDE_BIN or add its dir to PATH in the plist."
  log "       Common homes: ~/.local/bin/claude, /opt/homebrew/bin/claude"
  exit 1
fi
log "claude: $CLAUDE_BIN"

if [ ! -d "$HUB_REPO/.git" ]; then
  log "ERROR: HUB_REPO $HUB_REPO is not a git repo; aborting"
  exit 1
fi

HUB_BRANCH="$(git -C "$HUB_REPO" symbolic-ref --short -q HEAD)"
if [ -z "$HUB_BRANCH" ]; then
  log "ERROR: hub is in detached HEAD; aborting"
  exit 1
fi

# Push rights are the whole premise of this script. Prove them cheaply, and
# prove them non-interactively: a prompt here would hang forever under launchd.
export GIT_TERMINAL_PROMPT=0
if ! git -C "$HUB_REPO" ls-remote --exit-code origin >/dev/null 2>&1; then
  log "ERROR: cannot reach origin non-interactively (network down, or auth wants a prompt)."
  log "       Fix with: gh auth login   (or load an SSH key / credential helper)"
  exit 1
fi
log "origin reachable, auth non-interactive"

# ------------------------------------------------------------- record the before
# One line per enrolled repo: path and current HEAD. Used for the audit at the
# end. Paths come from INDEX.md's "Local path" column — the registry is the
# only list of what is actually tracked.

BEFORE="$(mktemp)"; AFTER="$(mktemp)"
trap 'rmdir "$LOCKDIR" 2>/dev/null; rm -f "$BEFORE" "$AFTER"' EXIT

snapshot_heads() {
  # $1 = output file
  : > "$1"
  while IFS= read -r path; do
    [ -z "$path" ] && continue
    expanded="${path/#\~/$HOME}"
    [ -d "$expanded/.git" ] || continue
    printf '%s\t%s\n' "$expanded" "$(git -C "$expanded" rev-parse HEAD 2>/dev/null || echo '?')" >> "$1"
  done <<EOF
$(awk -F'|' '/^\| / { gsub(/^ +| +$/, "", $5); if ($5 ~ /^~/ && !seen[$5]++) print $5 }' "$HUB_REPO/INDEX.md" 2>/dev/null)
EOF
}

snapshot_heads "$BEFORE"
log "recorded HEADs for $(wc -l < "$BEFORE" | tr -d ' ') enrolled repos"

# ------------------------------------------------------------------- flag probe
# The cheapest possible real call. If the CLI has moved on, this is where we
# find out — before anything has been written.
#
# The probe must exercise a *write*, in a throwaway repo, and then verify the
# result by reading it back off disk — never by believing the run's own report.
# That is this project's own hardest-won lesson (LEARNINGS, 2026-08-17: "a write
# is only proven by reading it back from the target"). A probe that asks for a
# sentence proves only that the model can talk; read-only git is auto-approved
# even when every write would be denied, so it would pass while the real run
# silently failed to commit anything.

PROBE_DIR="$(mktemp -d)"
trap 'rmdir "$LOCKDIR" 2>/dev/null; rm -f "$BEFORE" "$AFTER"; rm -rf "$PROBE_DIR"' EXIT

git -C "$PROBE_DIR" init -q 2>/dev/null
git -C "$PROBE_DIR" config user.email "healer@localhost"
git -C "$PROBE_DIR" config user.name "mission healer probe"
printf 'probe\n' > "$PROBE_DIR/probe.txt"

log "probing headless flags: $CLAUDE_FLAGS"
# set -f: CLAUDE_FLAGS is expanded unquoted on purpose (it carries several
# words), which would otherwise let a stray file name glob-match "Bash(git:*)".
set -f
PROBE_RC=0
PROBE="$(cd "$PROBE_DIR" && "$CLAUDE_BIN" -p "Run this bash command: git add -A && git commit -m PROBE_OK. Then stop." $CLAUDE_FLAGS 2>&1)" || PROBE_RC=$?
set +f

if [ "$PROBE_RC" -ne 0 ]; then
  log "ERROR: probe call failed (rc=$PROBE_RC). Output follows — likely a bad flag or expired auth:"
  printf '%s\n' "$PROBE" | sed 's/^/       /'
  exit 1
fi

# The verification that matters: did a commit actually land?
if [ "$(git -C "$PROBE_DIR" log -1 --format='%s' 2>/dev/null)" != "PROBE_OK" ]; then
  log "ERROR: the probe session could not commit. The healer can edit files but not"
  log "       save them, which would leave every repair half-done and unpushed."
  log "       Almost always this means --allowedTools no longer covers git:"
  log "       current flags: $CLAUDE_FLAGS"
  log "       Fix CLAUDE_FLAGS in the plist. Do NOT widen to --dangerously-skip-permissions."
  log "       Probe session output follows:"
  printf '%s\n' "$PROBE" | sed 's/^/       /'
  exit 1
fi
log "probe OK — headless session can commit"

if [ "$DRY_RUN" = "1" ]; then
  log "DRY_RUN=1 — pre-flight and probe passed, skipping the healing run"
  exit 0
fi

# ------------------------------------------------------------------- the charter
# Bounded on purpose. Everything here is mechanical: no product decisions, no
# judgement about what a project should be. If the session finds itself wanting
# to decide something, the correct outcome is an OPEN-QUESTIONS entry, not a fix.

read -r -d '' PROMPT <<'PROMPT_EOF'
You are the Mission Control daily healer, running unattended at the machine
with no human present. Nobody can answer a question, so do not ask one — if a
job needs judgement, record it and move on.

Do these, in order, and only these:

1. Read CANDIDATES.md and run /roster to apply its ticks: enrol newly ticked
   projects, retire newly unticked ones. If a project cannot be enrolled, leave
   its row alone and note why — never guess past a blocker.

2. For every project in INDEX.md, check that its `.mission/` folder exists on
   its repo's DEFAULT branch. Where it exists only on some other branch, get it
   onto the default branch (cherry-pick the seed commit if the rest of that
   branch is unrelated work) and push. This is the drift that makes the board
   unable to read a project it believes is enrolled.

3. Update INDEX.md so its rows match what you actually found.

4. Checkpoint per .claude/skills/mission-discipline/SKILL.md: classify what
   happened into the .mission/ files, overwrite SYNOPSIS.md, append ONE line to
   AGENT-LOG.md naming yourself as the healer, then commit and push the hub.

Hard limits. These are not negotiable and there is no case where exceeding them
is the helpful choice:
- In a project repo, write NOTHING except `.mission/**` and `CLAUDE.md`.
- Never force-push. Never rewrite history. Never delete or rename a branch.
- Never commit a file that was already dirty in a project repo — someone's
  uncommitted work is theirs. Leave it, and say so.
- Never resolve an `owner: Adrian` task. Those are judgement, deploys, or money.
  You may correct one that evidence proves is already done, per /mission §3a.
- If a repair needs a decision, append it to the hub's OPEN-QUESTIONS.md and
  leave the repair undone.

If there is nothing to heal, change nothing, say so, and stop. A quiet day is
the expected result, not a failure.
PROMPT_EOF

log "starting healing run (max ${MAX_SECONDS}s)"
RUN_LOG="$(mktemp)"
(
  cd "$HUB_REPO" || exit 1
  set -f   # see the probe: CLAUDE_FLAGS is expanded unquoted by design
  "$CLAUDE_BIN" -p "$PROMPT" $CLAUDE_FLAGS
) > "$RUN_LOG" 2>&1 &
RUN_PID=$!

# Poor man's timeout — coreutils `timeout` is not on a stock mac.
elapsed=0
while kill -0 "$RUN_PID" 2>/dev/null; do
  sleep 5
  elapsed=$((elapsed + 5))
  if [ "$elapsed" -ge "$MAX_SECONDS" ]; then
    log "ERROR: run exceeded ${MAX_SECONDS}s — killing it"
    kill -TERM "$RUN_PID" 2>/dev/null
    sleep 5
    kill -KILL "$RUN_PID" 2>/dev/null
    break
  fi
done
wait "$RUN_PID"; RUN_RC=$?

log "run finished rc=$RUN_RC after ${elapsed}s; output:"
sed 's/^/       /' "$RUN_LOG"
rm -f "$RUN_LOG"

# ----------------------------------------------------------------- after audit
# The script cannot stop a bad edit. It can make sure one is never quiet.

# Two allowlists, because the hub and a project repo are not the same thing.
# In a PROJECT repo the healer owns only the mission namespace.
# In the HUB it is *required* to edit the registry — charter steps 1 and 3 are
# "apply the roster ticks" and "update INDEX.md" — so auditing the hub against
# the project allowlist flagged the healer for doing exactly what it was told.
# That made a successful run indistinguishable from a rogue one: a quiet day
# passed and a productive day exited 1. (Found by the 2026-08-17 audit.)
ALLOW_RE='^(\.mission/|CLAUDE\.md$)'
HUB_ALLOW_RE='^(\.mission/|CLAUDE\.md$|INDEX\.md$|CANDIDATES\.md$|BOARD\.md$|snapshot/)'
HUB_CANON="$(cd "$HUB_REPO" 2>/dev/null && pwd -P || echo "$HUB_REPO")"

snapshot_heads "$AFTER"
VIOLATIONS=0
CHANGED=0

while IFS=$'\t' read -r repo old; do
  new="$(grep -F "$repo	" "$AFTER" | head -1 | cut -f2)"
  [ -z "$new" ] && continue
  [ "$old" = "$new" ] && continue
  CHANGED=$((CHANGED + 1))

  repo_canon="$(cd "$repo" 2>/dev/null && pwd -P || echo "$repo")"
  if [ "$repo_canon" = "$HUB_CANON" ]; then
    this_allow="$HUB_ALLOW_RE"
    log "changed: $repo (hub)  $old -> $new"
  else
    this_allow="$ALLOW_RE"
    log "changed: $repo  $old -> $new"
  fi

  while IFS= read -r f; do
    [ -z "$f" ] && continue
    if ! printf '%s' "$f" | grep -Eq "$this_allow"; then
      log "  ERROR: touched outside the allowlist: $f"
      VIOLATIONS=$((VIOLATIONS + 1))
    fi
  done <<EOF
$(git -C "$repo" diff --name-only "$old".."$new" 2>/dev/null)
EOF
done < "$BEFORE"

# A repo enrolled DURING the run has no before-HEAD, so the loop above never
# sees it — and enrolment is the path that writes most. Silence there would be
# the audit's blind spot, so name them explicitly rather than imply "all clear".
while IFS=$'\t' read -r repo new; do
  [ -z "$repo" ] && continue
  if ! grep -Fq "$repo	" "$BEFORE"; then
    log "NOTE: $repo appeared in INDEX.md during this run (newly enrolled) — no"
    log "      before-HEAD existed, so its contents were NOT audited. Check by hand:"
    log "      git -C \"$repo\" show --stat $new"
  fi
done < "$AFTER"

log "audit: $CHANGED repos changed, $VIOLATIONS allowlist violations"

if [ "$VIOLATIONS" -gt 0 ]; then
  log "ERROR: the healer wrote outside .mission/ — review the commits above by hand."
  log "       Nothing was force-pushed, so every change is revertable."
  exit 1
fi

if [ "$RUN_RC" -ne 0 ]; then
  log "ERROR: healing run exited $RUN_RC — see output above"
  exit 1
fi

log "mission-heal done"
exit 0
