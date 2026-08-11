# Mission Control — Playbook
*Paste-ready commands and prompts. This is the ops cheat sheet — grab, paste, go.*

## Link an existing local folder to its GitHub repo

Folder is already a git repo (has `.git` inside):
```bash
cd ~/Projects/<folder>
git remote add origin https://github.com/adrianludum/<repo-name>.git
git push -u origin main
```

Folder is not a git repo yet — initialise first, then link:
```bash
cd ~/Projects/<folder>
git init && git add -A && git commit -m "initial"
git remote add origin https://github.com/adrianludum/<repo-name>.git
git push -u origin main
```

If both sides have content (local files AND commits on GitHub), don't reconcile by hand — use the enrolment prompt below.

## Enrol existing projects (bulk)

**Primary path** — in a Claude Code session at the Mac mini (with this repo available), type:
```
/enrol
```
The `enrol` skill (`.claude/skills/enrol/`) runs the whole wave: surveys `~/Projects`, shows a pairing table for approval before acting, wires remotes, reconciles histories (never force-pushes), seeds `.mission/` from `templates/mission-seed/` back-filled from each repo, indexes each project in INDEX.md, and reports — repos missing the Claude GitHub App grant are listed as "needs app access", not failed.

**Fallback** — session without the skill: paste this into Claude Code on the Mac mini:
> Survey the subfolders of my Projects folder, match each to my GitHub repos by name, and for each match: wire the remote, reconcile any history differences, and push. Show me the pairing table before you act. Then seed a `.mission/` folder (the ten-file standard from adrianludum/Mission-control) into each repo, back-filled from what you can read in it.

## Promote a chat idea to a tracked project ("track this" flow, per Decision 4.2)
1. Create the repo: https://github.com/new — private, named after the idea
2. Grant the Claude GitHub App access to the new repo
3. Back in the chat, paste the repo URL and say: **"sync with git <name>"**
4. The session seeds `.mission/` from the chat, pushes, and adds the project to the index — carry on riffing; it checkpoints into the repo from here

## Phrases
- **"update log"** — force a save right now (sessions checkpoint continuously anyway; this is the comfort word)
- **"track this"** → then follow the promote flow above
- **"retire <project>"** — session removes it from the index

## Resume discovery
See `HANDOFF.md` for the Black Swan resume prompt.
