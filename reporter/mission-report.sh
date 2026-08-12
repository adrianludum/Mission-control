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
#   DRY_RUN        set to 1 to skip the pull/commit/push step (for testing)
#
# Never mutates any scanned repo. Read-only git plumbing only.

set -u

SCAN_ROOT="${SCAN_ROOT:-$HOME/Projects}"
HUB_REPO="${HUB_REPO:-$HOME/Projects/Mission-control}"
SNAPSHOT_FILE="${SNAPSHOT_FILE:-$HUB_REPO/snapshot/mac-mini.md}"
DRY_RUN="${DRY_RUN:-0}"

log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"; }

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
  local branch uncommitted untracked unpushed remote last_commit
  local refline ref upstream ahead url

  branch="$(git -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null)"
  if [ -z "$branch" ]; then
    branch="detached @ $(git -C "$dir" rev-parse --short HEAD 2>/dev/null || echo '?')"
  fi

  # status --porcelain: lines starting "??" are untracked; everything else
  # is modified/staged (uncommitted).
  uncommitted="$(git -C "$dir" status --porcelain 2>/dev/null | grep -c '^[^?]')"
  untracked="$(git -C "$dir" status --porcelain 2>/dev/null | grep -c '^??')"

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

  # Local branches with unpushed commits, or with no upstream at all.
  unpushed=""
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
    fi
  done <<EOF
$(git -C "$dir" for-each-ref --format='%(refname:short)|%(upstream:short)' refs/heads 2>/dev/null)
EOF
  if [ -z "$unpushed" ]; then
    unpushed="none"
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
| Untracked | ${untracked} |
| Unpushed | ${unpushed} |
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
