# CLAUDE.md — ClaudeAgentConfig Repo

## Purpose

This repo manages the Xcode 26 integrated Claude agent configuration. The agent reads its config from `~/Library/Developer/Xcode/CodingAssistant/ClaudeAgentConfig/` — symlinks point back here.

## Structure

```
xcode-agent/
├── CLAUDE.md          # Xcode agent instructions (symlinked)
└── skills/            # Agent skills (symlinked)
    ├── <skill-name>/
    │   ├── SKILL.md
    │   └── references/   (optional)
    └── ...
```

## Working in This Repo

- **Do not modify Xcode-managed files** — `.claude.json`, `debug/`, `plans/`, `projects/`, `session-env/`, `shell-snapshots/`, `todos/` live at the Xcode path and are not part of this repo
- Edits to `xcode-agent/CLAUDE.md` and `xcode-agent/skills/` are reflected in Xcode immediately via symlinks
- Test changes by opening an Xcode project and verifying the agent picks up updated instructions

## Skills Format

Each skill lives in `xcode-agent/skills/<skill-name>/` with:

- `SKILL.md` — required. Contains frontmatter (`name`, `description`, `version`) and the skill content
- `references/` — optional directory with supporting reference files the agent reads for deeper context

Standalone skills (like Axiom) have only a `SKILL.md` with no `references/` directory.

## Adding a Skill

1. Create `xcode-agent/skills/<skill-name>/SKILL.md` (and optional `references/`)
2. Update the Skills Reference table in `xcode-agent/CLAUDE.md`
3. Commit with `Chore(skills): add <skill-name>`

## Updating the Xcode Agent Config

Edit `xcode-agent/CLAUDE.md` directly. Changes take effect on the next Xcode agent session.

## Git Conventions

- **No Claude signature** — omit "Generated with Claude Code" and "Co-Authored-By"
- **Conventional commits with Swift casing:** `Feat(scope):`, `Fix(scope):`, `Docs(scope):`, `Chore(scope):`
- Scope is typically `skills`, `config`, or a specific skill name
