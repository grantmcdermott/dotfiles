# Claude Code Configuration

Personal Claude Code configuration with agents and skills.

## Structure

- `CLAUDE.md` — Global defaults (git, general principles)
- `mcp.json` — MCP server configuration
- `agents/` — Specialized subagent definitions (`.md` files)
- `skills/` — Reusable skill packages (each with a `SKILL.md`)

## Installation

```bash
ln -sfn ~/dotfiles/claude ~/.claude
ln -sfn ~/dotfiles/claude/mcp.json ~/.claude.json
```

## Agents

Agents are specialized subagents with focused tools, skills, and MCP access. Claude auto-delegates based on task, or invoke explicitly: "Use the [agent-name] agent to..."

## MCP Servers

MCP servers are configured in `mcp.json` (symlinked to `~/.claude.json`). See that file for the current list.

## Usage

Skills activate automatically when Claude detects relevant context (e.g., R code triggers r-prefs). No explicit invocation needed.

To use a specific agent, ask Claude directly: "Use the r-expert agent to help me with this data.table code."

To browse available agents and skills, check the `agents/` and `skills/` directories.
