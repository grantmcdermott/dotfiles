# Claude Code Configuration

Personal Claude Code configuration with agents and skills.

## Structure

```
claude/
├── CLAUDE.md                       # Global defaults (git, general principles)
├── agents/
│   ├── r-expert.md                 # R data analysis agent
│   └── spark-expert.md             # Spark tuning agent
└── skills/
    ├── r-prefs/SKILL.md           # R preferences, packages, S3 I/O
    └── spark-optimization/SKILL.md # Spark diagnostic methodology
```

## Installation

```bash
ln -sfn ~/dotfiles/claude ~/.claude
ln -sfn ~/dotfiles/claude/mcp.json ~/.claude.json
```

## Agents

Agents are specialized subagents with focused tools, skills, and MCP access:

- **r-expert** — R programming with data.table, fixest, tinyplot preferences
- **spark-expert** — Spark tuning with AWS knowledge MCP

Claude auto-delegates based on task, or invoke explicitly: "Use the r-expert agent to..."

## MCP Servers

MCP servers are configured in `mcp.json` (symlinked to `~/.claude.json`):

- **r-btw** — btw R session tools (docs, packages, environment inspection)
- **github** — GitHub API (requires auth via `/mcp`)

For btw to access your R session, run `btw::btw_mcp_session()` in that session.

## Usage

Skills are automatically activated by Claude based on context. No explicit invocation needed.

## Adding Skills

Follow the [Agent Skills standard](https://agentskills.io/):

```
skill-name/
├── SKILL.md      # YAML frontmatter + instructions
├── chapters/     # Optional: conceptual content
└── man/          # Optional: reference docs
```

## References

- [posit-dev/skills](https://github.com/posit-dev/skills) — Posit's skill collection
- [marginaleffects-SKILL](https://github.com/vincentarelbundock/marginaleffects-SKILL) — Example package skill
- [claude-code-my-workflow](https://github.com/pedrohcgs/claude-code-my-workflow) — Academic workflow template
