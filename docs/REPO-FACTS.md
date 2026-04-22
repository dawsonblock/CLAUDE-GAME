# REPO-FACTS

This file records the authoritative inventory counts for this repository.
Run `tools/audit_repo.sh` to verify these numbers are still correct.

## What This Repository Is

Claude Code Game Studios is a **Claude Code workspace template** for structured game development.
It is not a game runtime, a playable game, a game engine project, or an autonomous execution system.

## Inventory

| Item | Count | Location |
|------|-------|----------|
| Agent role prompts | 49 | `.claude/agents/*.md` |
| Skills | 72 | immediate subdirectories of `.claude/skills/` |
| Hooks | 12 | `.claude/hooks/` |
| Rules | 11 | `.claude/rules/` |
| Templates | 38 | `.claude/docs/templates/` (recursive file count) |

## Contents

- **Role prompts** — markdown files that define specialized Claude Code personas (directors, leads, specialists)
- **Skills** — slash commands invoked with `/` in Claude Code, each in its own subdirectory
- **Hooks** — bash scripts triggered at session start/stop, commit, push, and file write events
- **Rules** — path-scoped markdown standards loaded automatically based on the file being edited
- **Templates** — document starters for GDDs, ADRs, sprint plans, UX specs, and more
