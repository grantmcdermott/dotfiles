# Claude Code Configuration

Personal Claude Code configuration with agents, skills, and MCP servers.

## Installation

Clone the repo and symlink the claude directory into place. The commented line is
just a reminder; skip it if you've already cloned the dotfiles repo.

```bash
# git clone https://github.com/grantmcdermott/dotfiles ~/dotfiles
ln -sfn ~/dotfiles/claude ~/.claude
```

## Structure

```
claude/
├── CLAUDE.md          # Global defaults (git rules, general principles)
├── mcp-servers.json   # MCP server definitions (reference; add via Claude Code)
├── settings.json      # Permissions and behavior settings
├── agents/            # Subagent definitions (.md files)
└── skills/            # Skill packages (each with a SKILL.md)
```

## Agents vs Skills

**Skills** inject context and preferences into the current conversation. They
activate automatically when Claude detects relevant context. Or, you can load a
skill explicitly for the session with a slash (`/`) command and then ask
follow-up questions, for example:

```
/r-prefs
```

> How should I join two data.tables on multiple keys?
> Now add a rolling mean by group...
> Run `str(dat)` and describe the structure

**Agents** are subprocesses with their own model, tools, and MCP access. Claude
auto-delegates based on task description, or you can invoke them explicitly:

```
Use the r-expert agent to refactor this data.table pipeline.
```

```
Use the spark-expert agent — this job is OOMing on the sort-merge join, here are the logs.
```

For a full list of available agents and skills, see the `agents/` and `skills/` directories.

## MCP Servers

Server definitions are in `mcp-servers.json` for reference. Add them via the
`/mcp` command in Claude Code. Read-only corteza tools are auto-allowed in
`settings.json`; write/exec tools prompt for approval.

The R workflow requires the [`corteza`](https://github.com/cornball-ai/corteza)
(>=0.6.0) package.

```r
# Install from CRAN
install.packages("corteza")
```

Corteza runs its own R session via stdio — no manual setup needed. It starts
automatically when Claude Code connects to the MCP server.
