#!/bin/bash
#
# mission-report.sh — the deliberately dumb hourly reporter (Decision 2.5 / 4.3).
#
# Scans every direct child of SCAN_ROOT that is a git repo, writes a
# self-timestamped snapshot of raw git facts into the Mission-control hub
# repo, commits and pushes. No filtering, no thinking — /mission does the
# thinking. This script's only job is to be too simple to break.
#
# Config (env vars, all optional):
#   SCAN_ROOT      dir whose direct children are scanned  (default: $HOME/Projects)
#   HUB_REPO       the Mission-control clone — the ONLY repo this script
#                  ever writes/commits/pushes                (default: $HOME/Projects/Mission-control)
#   SNAPSHOT_FILE  where the snapshot markdown lands     (default: $HUB_REPO/snapshot/mac-mini.md)
#   NAME_LIMIT     how many dirty/untracked names to list (default: 5)
#   DRY_RUN        set to 1 to skip the pull/commit/push step (for testing)
#
# Never mutates any scanned repo. Read-only git plumbing only.
#
# WHY IT REPORTS NAMES AND AGES, NOT JUST COUNTS (2026-08-17):
#   /mission-watch escalates on "work that exists in only one place" and on
#   "dirty or unpushed for more than 7 days". Neither is computable from a
#   count. Nearly every repo on the mini shows exactly 3 untracked files —
#   .DS_Store and friends — so AI Gym Hub's three real specification documents,
#   uncommitted since June and existing nowhere else, were indistinguishable
#   from that noise and were never raised. Names make the difference visible;
#   the oldest mtime supplies the age the 7-day rule needs. The reporter stays
#   dumb: it reports what it sees and never decides what matters.

set -u

# launchd runs have no terminal. Without this, an expired credential turns
# `git pull`/`git push` into a prompt that blocks forever while the next hourly
# run starts anyway — a silent pile-up rather than a visible failure.
export GIT_TERMINAL_PROMPT=0

SCAN_ROOT="${SCAN_ROOT:-$HOME/Projects}"
HUB_REPO="${HUB_REPO:-$HOME/Projects/Mission-control}"
SNAPSHOT_FILE="${SNAPSHOT_FILE:-$HUB_REPO/snapshot/mac-mini.md}"
NAME_LIMIT="${NAME_LIMIT:-5}"
DRY_RUN="${DRY_RUN:-0}"

LOCKDIR="${LOCKDIR:-/tmp/mission-report.lock}"

log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"; }

# One run at a time. Hourly scheduling assumes the previous run finished; a
# hung network call would otherwise have two runs committing to the hub at once.
if ! mkdir "$LOCKDIR" 2>/dev/null; then
  log "ERROR: $LOCKDIR exists — a previous run is still going or died hard."
  log "       If no reporter process is running, remove it: rmdir $LOCKDIR"
  exit 1
fi
trap 'rmdir "$LOCKDIR" 2>/dev/null' EXIT

# Portable file mtime in epoch seconds: BSD/macOS form first, GNU second.
# Both results are checked for being an integer rather than trusted to fail:
# GNU `stat -f` does not error, it reports *filesystem* status instead, so the
# `||` fallback never fires and multi-line junk flows downstream. (That is
# exactly what happened on the first test run of this change.)
file_mtime() {
  local m
  m="$(stat -f %m "$1" 2>/dev/null)"
  case "$m" in ''|*[!0-9]*) m="$(stat -c %Y "$1" 2>/dev/null)" ;; esac
  case "$m" in ''|*[!0-9]*) m="" ;; esac
  printf '%s' "$m"
}

# Whole days between an epoch timestamp and now. Anything not a plain integer
# yields empty — never a bogus age, and never an arithmetic error.
age_days() {
  case "${1:-}" in ''|*[!0-9]*) echo ""; return ;; esac
  echo $(( ( $(date +%s) - $1 ) / 86400 ))
}

NOW_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
HOST="$(hostname -s 2>/dev/null || hostname)"

log "mission-report starting (scan root: $SCAN_ROOT)"

if [ ! -d "$SCAN_ROOT" ]; then
  log "ERROR: scan root $SCAN_ROOT does not exist; aborting"
  exit 1
fi

# ---------------------------------------------------------------- scan phase

TMP_SNAPSHOT="${SNAPSHOT_FILE}.tmp"
mkdir -p "$(dirname "$SNAPSHOT_FILE")"

REPO_COUNT=0
SECTIONS=""   # accumulated markdown for all repo sections

# Emit the facts section for one repo. Fail-soft: any git hiccup inside
# degrades to "?" values rather than killing the scan.
scan_repo() {
  # $1 = absolute repo path, $2 = folder name
  local dir="$1" name="$2"
  local branch uncommitted untracked unpushed behind remote last_commit
  local ref upstream ahead bcount url gitdir
  local line code path m
  local dirty_names untracked_names oldest_epoch oldest_path oldest_age fetch_age

  # A repo that cannot be read is a scan failure, not a row of honest zeroes.
  # (Before 2026-08-17 this function could not fail at all — its last statement
  # was an assignment — so the "scan failed" fallback below was dead code and a
  # broken repo reported plausible-looking values.)
  gitdir="$(git -C "$dir" rev-parse --absolute-git-dir 2>/dev/null)" || return 1
  [ -n "$gitdir" ] || return 1

  branch="$(git -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null)"
  if [ -z "$branch" ]; then
    branch="detached @ $(git -C "$dir" rev-parse --short HEAD 2>/dev/null || echo '?')"
  fi

  # One pass over status --porcelain: lines starting "??" are untracked,
  # everything else is modified/staged. Collect counts, the first NAME_LIMIT
  # names of each, and the oldest mtime across the lot — that age is what the
  # watch's 7-day rule needs and could never previously get.
  uncommitted=0; untracked=0
  dirty_names=""; untracked_names=""
  oldest_epoch=""; oldest_path=""
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    code="${line:0:2}"
    path="${line:3}"
    case "$path" in *' -> '*) path="${path##* -> }" ;; esac   # renames
    path="${path%\"}"; path="${path#\"}"                       # quoted paths
    if [ "$code" = "??" ]; then
      untracked=$((untracked + 1))
      if [ "$untracked" -le "$NAME_LIMIT" ]; then
        [ -n "$untracked_names" ] && untracked_names="${untracked_names}, "
        untracked_names="${untracked_names}${path}"
      fi
    else
      uncommitted=$((uncommitted + 1))
      if [ "$uncommitted" -le "$NAME_LIMIT" ]; then
        [ -n "$dirty_names" ] && dirty_names="${dirty_names}, "
        dirty_names="${dirty_names}${path}"
      fi
    fi
    m="$(file_mtime "$dir/$path")"
    if [ -n "$m" ]; then
      if [ -z "$oldest_epoch" ] || [ "$m" -lt "$oldest_epoch" ]; then
        oldest_epoch="$m"; oldest_path="$path"
      fi
    fi
  done <<EOF
$(git -C "$dir" status --porcelain 2>/dev/null)
EOF

  [ "$untracked" -gt "$NAME_LIMIT" ] && untracked_names="${untracked_names} (+$((untracked - NAME_LIMIT)) more)"
  [ "$uncommitted" -gt "$NAME_LIMIT" ] && dirty_names="${dirty_names} (+$((uncommitted - NAME_LIMIT)) more)"
  [ -z "$untracked_names" ] && untracked_names="—"
  [ -z "$dirty_names" ] && dirty_names="—"

  oldest_age="$(age_days "$oldest_epoch")"
  if [ -n "$oldest_age" ]; then
    oldest_age="${oldest_age} days — ${oldest_path}"
  else
    oldest_age="—"
  fi

  # How stale the ahead/behind comparison is. The reporter never fetches (34
  # repos hourly is not a read-only promise worth keeping), so these numbers are
  # only as fresh as the last fetch anyone did by hand. Say so rather than let
  # the board read them as live.
  fetch_age="$(age_days "$(file_mtime "$gitdir/FETCH_HEAD")")"
  if [ -n "$fetch_age" ]; then
    fetch_age="${fetch_age} days ago"
  else
    fetch_age="never fetched in this clone"
  fi

  # Remote(s).
  remote=""
  local rname
  for rname in $(git -C "$dir" remote 2>/dev/null); do
    url="$(git -C "$dir" remote get-url "$rname" 2>/dev/null || echo '?')"
    if [ -n "$remote" ]; then remote="$remote; "; fi
    remote="${remote}${rname} (${url})"
  done
  if [ -z "$remote" ]; then
    remote="NONE CONFIGURED"
  fi

  # Local branches with unpushed commits, or with no upstream at all — and, in
  # the same pass, branches that are behind. Behind-ness was invisible before:
  # enrolment found familysite 29 behind and World Rowing Results 279 behind,
  # and no snapshot would ever have said so.
  unpushed=""; behind=""
  while IFS='|' read -r ref upstream; do
    [ -z "$ref" ] && continue
    if [ -z "$upstream" ]; then
      if [ -n "$unpushed" ]; then unpushed="$unpushed; "; fi
      unpushed="${unpushed}${ref}: no upstream"
    else
      ahead="$(git -C "$dir" rev-list --count "${upstream}..${ref}" 2>/dev/null || echo '?')"
      if [ "$ahead" != "0" ]; then
        if [ -n "$unpushed" ]; then unpushed="$unpushed; "; fi
        unpushed="${unpushed}${ref}: ${ahead} ahead"
      fi
      bcount="$(git -C "$dir" rev-list --count "${ref}..${upstream}" 2>/dev/null || echo '0')"
      if [ "$bcount" != "0" ]; then
        if [ -n "$behind" ]; then behind="$behind; "; fi
        behind="${behind}${ref}: ${bcount} behind"
      fi
    fi
  done <<EOF
$(git -C "$dir" for-each-ref --format='%(refname:short)|%(upstream:short)' refs/heads 2>/dev/null)
EOF
  if [ -z "$unpushed" ]; then
    unpushed="none"
  fi
  if [ -z "$behind" ]; then
    behind="none"
  fi

  # Last commit: ISO committer date + subject.
  last_commit="$(git -C "$dir" log -1 --format='%cI — %s' 2>/dev/null || echo 'no commits')"
  [ -z "$last_commit" ] && last_commit="no commits"

  SECTIONS="${SECTIONS}
## ${name}

| Fact | Value |
| --- | --- |
| Branch | ${branch} |
| Uncommitted | ${uncommitted} |
| Uncommitted files | ${dirty_names} |
| Untracked | ${untracked} |
| Untracked files | ${untracked_names} |
| Oldest dirty file | ${oldest_age} |
| Unpushed | ${unpushed} |
| Behind | ${behind} |
| Last fetch | ${fetch_age} |
| Remote | ${remote} |
| Last commit | ${last_commit} |
"
}

# Scan one repo and append its section, or a scan-failed stub. Still dumb: no judgement.
handle_repo() {
  h_dir="$1"
  h_name="$2"
  REPO_COUNT=$((REPO_COUNT + 1))
  if scan_repo "$h_dir" "$h_name"; then
    log "scanned: $h_name"
  else
    log "WARNING: scan failed for $h_name (continuing)"
    SECTIONS="${SECTIONS}
## ${h_name}

| Fact | Value |
| --- | --- |
| Branch | ? (scan failed) |
"
  fi
}

# Depth 2: a direct child that is a repo is scanned as itself; a direct child that is NOT a
# repo is treated as a container and its own children are checked. Container folders
# (events/, fitness/, rowing/, ...) hold real projects that a depth-1 scan never sees.
# Nested repos are named "<container>/<repo>" so their INDEX.md path stays unambiguous.
# Never descend INTO a repo — a repo's subdirectories are its own business.
for dir in "$SCAN_ROOT"/*/; do
  [ -d "$dir" ] || continue
  dir="${dir%/}"
  name="${dir##*/}"

  if [ -d "$dir/.git" ]; then
    handle_repo "$dir" "$name"
    continue
  fi

  # Not a repo — look one level in for repos it contains.
  found_nested=0
  for sub in "$dir"/*/; do
    [ -d "$sub" ] || continue
    sub="${sub%/}"
    [ -d "$sub/.git" ] || continue
    found_nested=1
    handle_repo "$sub" "${name}/${sub##*/}"
  done

  [ "$found_nested" -eq 0 ] && log "skip (not a git repo): $name"
done

{
  printf '# Mac mini snapshot\n'
  printf '*Generated: %s*\n' "$NOW_UTC"
  printf '*Host: %s*\n' "$HOST"
  printf '*Scan root: %s*\n' "$SCAN_ROOT"
  printf '*Repos found: %s*\n' "$REPO_COUNT"
  printf '\n'
  printf '> **Ahead/Behind are as fresh as each clone'"'"'s last fetch** — this scan never fetches, so\n'
  printf '> read them alongside that repo'"'"'s `Last fetch` row. `Uncommitted files` / `Untracked files`\n'
  printf '> list the first %s names; `Oldest dirty file` is the age of the oldest of them, which is what\n' "$NAME_LIMIT"
  printf '> a "single-copy work" or "dirty for over a week" judgement needs.\n'
  printf '%s' "$SECTIONS"
} > "$TMP_SNAPSHOT"
mv "$TMP_SNAPSHOT" "$SNAPSHOT_FILE"

log "snapshot written: $SNAPSHOT_FILE ($REPO_COUNT repos)"

# ------------------------------------------------------- commit & push phase
# The ONLY repo this script ever writes/commits/pushes is HUB_REPO.

if [ "$DRY_RUN" = "1" ]; then
  log "DRY_RUN=1 — skipping pull/commit/push"
  exit 0
fi

if [ ! -d "$HUB_REPO/.git" ]; then
  log "ERROR: HUB_REPO $HUB_REPO is not a git repo; snapshot written but not pushed"
  exit 1
fi

cd "$HUB_REPO" || exit 1

# Push to whatever branch the hub clone has checked out — the repo's default
# branch is not necessarily "main".
HUB_BRANCH="$(git symbolic-ref --short -q HEAD)"
if [ -z "$HUB_BRANCH" ]; then
  log "ERROR: HUB_REPO is in detached HEAD; snapshot written but not pushed"
  exit 1
fi

# --autostash: the freshly written snapshot makes the tree dirty, and a plain
# pull --rebase refuses to run with unstaged changes. On failure, abort any
# half-done rebase so the repo can never stay wedged for future runs.
if ! git pull --rebase --autostash origin "$HUB_BRANCH"; then
  git rebase --abort >/dev/null 2>&1
  log "WARNING: git pull --rebase failed; continuing with local state"
fi

git add snapshot/

if git diff --cached --quiet; then
  log "no snapshot changes to commit"
  exit 0
fi

if ! git commit -m "reporter: snapshot $NOW_UTC"; then
  log "ERROR: git commit failed"
  exit 1
fi

# Push with up to 4 retries, exponential backoff: 2s 4s 8s 16s.
if git push origin "$HUB_BRANCH"; then
  log "pushed"
  exit 0
fi
for delay in 2 4 8 16; do
  log "push failed; retrying in ${delay}s"
  sleep "$delay"
  if git push origin "$HUB_BRANCH"; then
    log "pushed"
    exit 0
  fi
done

log "ERROR: push failed after 4 retries; snapshot committed locally, will ride along next hour"
exit 1
