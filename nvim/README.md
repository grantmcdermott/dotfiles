# Neovim Config

Adapted from Josean Martinez's excellent
[guide](https://www.josean.com/posts/how-to-setup-neovim-2024),
with additional focus on the data science tools that I use in my daily
workflow.

## System Dependencies

**macOS (Homebrew):**

```bash
brew install neovim lazygit ripgrep fd tree-sitter-cli
brew install --cask font-meslo-lg-nerd-font
```

**Arch Linux (pacman):**

```bash
sudo pacman -S neovim lazygit ripgrep fd ttf-meslo-nerd tree-sitter-cli
```

> [!IMPORTANT]
> `tree-sitter-cli` (**0.26.1 or later**) is required, not optional.
> nvim-treesitter's `main` branch shells out to the `tree-sitter` binary to
> compile parsers; without it every `install()` fails and you silently get no
> syntax highlighting and no treesitter-dependent features — e.g. `Cmd+Enter`
> quietly degrades from sending a whole statement to sending a single line.
> A C compiler must also be present, since parsers are built per machine.
>
> Two gotchas: on macOS the `tree-sitter` formula is the library only, so
> install `tree-sitter-cli`; and upstream advises against the npm build, so use
> your package manager or `cargo install tree-sitter-cli`. Debian/Ubuntu apt
> versions are all still below 0.26.1 — use cargo there.

## Plugins

Managed by [lazy.nvim](https://github.com/folke/lazy.nvim) (`<space>ll` to
open). Plugins are auto-installed on first launch.

### Core workflow

| Plugin                                                                | Description                                                                             |
| --------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)    | Fuzzy finder — search files, text, LSP symbols                                          |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)           | File explorer sidebar                                                                   |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)         | Persistent floating terminal                                                            |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)              | LazyGit TUI inside nvim                                                                 |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)           | Git gutter signs, hunk staging, inline blame                                            |
| [trouble.nvim](https://github.com/folke/trouble.nvim)                 | Diagnostics and TODO list panel                                                         |
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) | AI agent integration via ACP (Kiro, Claude Code)                                        |
| [R.nvim](https://github.com/R-nvim/R.nvim)                            | R console, help, object browser                                                         |
| [iron.nvim](https://github.com/Vigemus/iron.nvim)                     | Interactive Python REPL (emulates R.nvim ergonomics)                                    |
| [uv.nvim](https://github.com/benomahony/uv.nvim)                      | Python package management via [uv](https://github.com/astral-sh/uv)                     |
| [neotest](https://github.com/nvim-neotest/neotest)                    | Test runner (with [testthat](https://github.com/shunsambongi/neotest-testthat) adapter) |

### Editing

| Plugin                                                            | Description                                                 |
| ----------------------------------------------------------------- | ----------------------------------------------------------- |
| [nvim-surround](https://github.com/kylechui/nvim-surround)        | Add/change/delete surrounding pairs (`cs"'`, `ysiw)`, etc.) |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim)          | Toggle comments (`gc`)                                      |
| [substitute.nvim](https://github.com/gbprod/substitute.nvim)      | Substitute and exchange operators                           |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs)        | Auto-close brackets and quotes                              |
| [vim-maximizer](https://github.com/szw/vim-maximizer)             | Maximize/restore a split window                             |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight and search TODO/FIXME/HACK comments               |

### UI

| Plugin                                                                               | Description                                              |
| ------------------------------------------------------------------------------------ | -------------------------------------------------------- |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)                          | Colorscheme                                              |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                         | Status line                                              |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)                        | Tab-style bar listing open buffers                       |
| [alpha-nvim](https://github.com/goolord/alpha-nvim)                                  | Dashboard start screen                                   |
| [which-key.nvim](https://github.com/folke/which-key.nvim)                            | Shows available keybindings after pressing leader        |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)      | Indentation guides                                       |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim)                           | Improved input/select UI                                 |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Renders markdown in-buffer (headings, code blocks, etc.) |

### Language support (mostly automatic)

| Plugin                                                                | Description                                    |
| --------------------------------------------------------------------- | ---------------------------------------------- |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)            | LSP server configuration                       |
| [mason.nvim](https://github.com/williamboman/mason.nvim)              | Auto-installs LSP servers, linters, formatters |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                       | Autocompletion engine                          |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and code parsing           |
| [conform.nvim](https://github.com/stevearc/conform.nvim)              | Code formatting                                |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint)                | Linting                                        |
| [auto-session](https://github.com/rmagatti/auto-session)              | Saves/restores sessions per project            |

## Leader Keys

- **Leader**: `Space`
- **Local leader**: `,` (used by R.nvim for R-specific commands)

Press the leader key and wait to see available mappings via
[which-key](https://github.com/folke/which-key.nvim).

## Key Mappings

### IDE-style shortcuts

These mirror VS Code / Positron keybindings. Use `Cmd` on macOS, `Ctrl`
on Linux.

| Key         | Action                                    |
| ----------- | ----------------------------------------- |
| `Cmd+/`     | Toggle comment (line or selection)        |
| `Cmd+Enter` | Send statement/selection to REPL (R or Python) |
| `<space>rr` | Start R (R filetypes only)                |

### General

| Key         | Action                  |
| ----------- | ----------------------- |
| `<space>nh` | Clear search highlights |
| `<space>+`  | Increment number        |
| `<space>-`  | Decrement number        |

### Macros

`q` and `Q` are swapped from their Vim defaults: `Q` records a macro,
`q` is disabled. This prevents accidentally starting macro recording
when reaching for `:q`. Playback (`@<register>`) is unchanged.

| Key           | Action                       |
| ------------- | ---------------------------- |
| `Q<register>` | Start/stop recording a macro |
| `@<register>` | Play back a macro            |

### File Explorer (nvim-tree)

| Key         | Action                        |
| ----------- | ----------------------------- |
| `<space>ee` | Toggle file explorer          |
| `<space>ef` | Find current file in explorer |
| `<space>ec` | Collapse explorer             |
| `<space>er` | Refresh explorer              |

### Search (Telescope)

| Key         | Action                             |
| ----------- | ---------------------------------- |
| `<space>ff` | Find files                         |
| `<space>fr` | Find recent files                  |
| `<space>fs` | Live grep (search text in project) |
| `<space>fc` | Grep string under cursor           |
| `<space>ft` | Find TODOs                         |

### Buffers

Buffers are the working unit for switching between files; the bufferline
along the top reflects them left to right. `<space>bn`/`<space>bp` follow
that visible order rather than buffer numbers.

| Key         | Action                                            |
| ----------- | ------------------------------------------------- |
| `<space>bl` | List/fuzzy-find open buffers (Telescope)          |
| `<space>bb` | Alternate buffer (same as `Ctrl-^`)               |
| `<space>bn` | Next buffer                                       |
| `<space>bp` | Previous buffer                                   |
| `<space>bd` | Delete current buffer                             |
| `<space>bo` | Delete other buffers (skips modified + terminals) |

Opening a file from nvim-tree with `Enter` loads it as a new buffer, so
`<space>bb` toggles back to the previous one. Inside the Telescope buffer
picker, `<C-d>` deletes the selected buffer.

### Splits & Tabs

Tabpages are window *layouts*, not file containers — buffers and REPL
processes are global and reachable from any tab. Reach for tabs when you
want a distinct window arrangement or a per-tab working directory
(`:tcd`); use the buffer mappings above to move between files.

| Key         | Action                    |
| ----------- | ------------------------- |
| `<space>sv` | Split vertically          |
| `<space>sh` | Split horizontally        |
| `<space>se` | Equalize split sizes      |
| `<space>sx` | Close current split       |
| `<space>sm` | Maximize/minimize split   |
| `<space>to` | New tab                   |
| `<space>tx` | Close tab                 |
| `<space>tn` | Next tab                  |
| `<space>tp` | Previous tab              |
| `<space>tf` | Current buffer in new tab |
| `<space>sw` | Toggle soft wrap at 80 columns |

Lines soft-wrap at the window edge by default (`wrap` + `linebreak` +
`breakindent`, so wrapped lines break on words and stay indented). Nothing is
written to the file — use `gq` for that, and `vipJ` to unwrap a paragraph
again.

Neovim can only wrap at the window edge, so `<space>sw` (`:SoftWrap`) moves
the edge inward: it pads the window with an empty scratch split until the text
area is exactly 80 columns, and pins the width while active. Pass a count for
other widths (`:SoftWrap 100`); toggle off to drop the pad and re-equalize.
Useful on a wide monitor where full-width prose is hard to read.

### Git (gitsigns)

| Key         | Action                   |
| ----------- | ------------------------ |
| `<space>hs` | Stage hunk               |
| `<space>hr` | Reset hunk               |
| `<space>hS` | Stage buffer             |
| `<space>hR` | Reset buffer             |
| `<space>hu` | Undo stage hunk          |
| `<space>hp` | Preview hunk             |
| `<space>hb` | Blame line               |
| `<space>hB` | Toggle line blame        |
| `<space>hd` | Diff this                |
| `<space>hD` | Diff against last commit |

### Git (lazygit)

| Key         | Action       |
| ----------- | ------------ |
| `<space>gg` | Open LazyGit |

### LSP

| Key         | Action           |
| ----------- | ---------------- |
| `<space>ca` | Code action      |
| `<space>rn` | Rename symbol    |
| `<space>D`  | File diagnostics |
| `<space>d`  | Line diagnostics |
| `<space>rs` | Restart LSP      |

### Diagnostics (Trouble)

| Key         | Action                |
| ----------- | --------------------- |
| `<space>xw` | Workspace diagnostics |
| `<space>xd` | Document diagnostics  |
| `<space>xq` | Quickfix list         |
| `<space>xl` | Location list         |
| `<space>xt` | TODOs                 |

### Terminal (toggleterm)

| Key          | Action                           |
| ------------ | -------------------------------- |
| `<space>tt`  | Toggle floating terminal         |
| `<space>th`  | Toggle horizontal split terminal |
| `<space>tv`  | Toggle vertical split terminal   |
| `<Esc><Esc>` | Dismiss terminal (from inside)   |

### Sessions

| Key         | Action          |
| ----------- | --------------- |
| `<space>wr` | Restore session |
| `<space>ws` | Save session    |

### Other

| Key         | Action                   |
| ----------- | ------------------------ |
| `<space>l`  | Trigger linting          |
| `<space>ll` | Open Lazy plugin manager |
| `<space>mp` | Format file/selection    |

### AI (CodeCompanion)

Requires `CODECOMPANION_AGENT` set in `~/.zshrc.local` (e.g., `"kiro"` or
`"claude_code"`). Without it, `<space>aa` shows a setup prompt.

| Key         | Action                         |
| ----------- | ------------------------------ |
| `<space>aa` | Action palette                 |
| `<space>ac` | Toggle chat buffer             |
| `<space>ai` | New chat                       |
| `<space>al` | Open CLI agent                 |
| `ga`        | Add selection to chat (visual) |

### R.nvim (local leader: `,`)

Opening an R file directly (e.g., `nvim myfile.R`) will auto-start the R
console. When opening a directory and navigating to an R file via nvim-tree,
start R manually with `,rf` or `<space>rr`.

These mappings are active in R and Quarto files. Press `,` to see the
full menu via which-key.

| Key     | Group                                        |
| ------- | -------------------------------------------- |
| `,a`    | All                                          |
| `,b`    | Between marks                                |
| `,c`    | Chunks                                       |
| `,f`    | Functions                                    |
| `,g`    | Goto                                         |
| `,i`    | Install                                      |
| `,k`    | Knit                                         |
| `,p`    | Paragraph                                    |
| `,q`    | Quarto                                       |
| `,r`    | R general                                    |
| `,s`    | Split or send                                |
| `,t`    | Terminal                                     |
| `,v`    | View                                         |
| `Enter` | Send line (normal) / Send selection (visual) |

Also note the general (IDE-flavoured) keymappings described above:

| Key         | Group                                     |
| ----------- | ----------------------------------------- |
| `Cmd+/`     | Toggle comment (line or selection)        |
| `Cmd+Enter` | Send statement/selection to REPL (R or Python) |
| `<space>rr` | Start R (R filetypes only)                |

### R tooling stack

Three LSP-level tools cooperate for R files:

- **[Air](https://posit-dev.github.io/air/)** — formatting (format-on-save via LSP)
- **[Jarl](https://jarl.etiennebacher.com/)** — linting
- **r_language_server** — completions and hover (formatting disabled so Air owns it)

The split is toggled in `core/init.lua` with a single require swap.

### Python (iron.nvim + uv.nvim)

Python REPL support is designed to emulate the R.nvim ergonomics.
[iron.nvim](https://github.com/Vigemus/iron.nvim) provides an interactive
REPL (IPython if available, plain Python as fallback) running through
[uv](https://github.com/astral-sh/uv), so the project's virtual environment
is used automatically.

`Cmd+Enter` sends the whole statement under the cursor, so a method chain
spanning several lines goes as one unit with no visual selection needed.
Treesitter locates the enclosing statement, then the cursor moves to the next
non-blank line, so repeated presses walk down the buffer as in RStudio.

With the cursor on a `def`/`for`/`if` line the whole construct is sent. That
also happens from a line *inside* the body, because the cursor sits in the
indentation and treesitter resolves column 0 to the enclosing block; select the
lines visually to send just part of a body.

This needs the python parser, so `tree-sitter-cli` is a hard requirement (see
[System Dependencies](#system-dependencies)) — without it this silently
degrades to sending one line at a time.

The uv.nvim default keymap prefix is changed from `<leader>x` to `<leader>u`
to avoid conflicting with trouble.nvim diagnostics.

| Key         | Action                                             |
| ----------- | -------------------------------------------------- |
| `<space>u`  | Show uv commands menu                              |
| `<space>ua` | Add a package                                      |
| `<space>ud` | Remove a package                                   |
| `<space>ur` | Run current file                                   |
| `<space>us` | Run selected code (visual mode)                    |
| `<space>uf` | Run a specific function                            |
| `<space>uc` | Sync packages                                      |
| `<space>uC` | Sync all (extras + groups)                         |
| `<space>ue` | Environment management                             |
| `<space>ui` | Initialize a new uv project                        |
| `Cmd+Enter` | Send statement (normal) / selection (visual) to IPython |

Requires `uv` installed on the system. For IPython support, add it to
your project: `uv add ipython`.

### Python tooling stack

- **[autopep8](https://github.com/hhatto/autopep8)** — formatting
- **[ruff](https://docs.astral.sh/ruff/)** — import sorting and linting
- **pyright** — completions, hover, type checking

All come from mason, so there is no separate setup step. Don't install a
second ruff (`uv tool install`, Homebrew): mason prepends its `bin` to nvim's
`PATH` and would shadow it, leaving format-on-save and the shell on different
versions.

autopep8 rather than `ruff format` (or black) because it is minimally invasive:
it only fixes actual PEP 8 violations instead of reflowing from the syntax tree,
so hand-broken leading-dot polars/pandas chains survive a save. ruff and black
both discard your line breaks and rejoin anything fitting the line limit,
collapsing a chain onto one line; yapf does too, even with `SPLIT_BEFORE_DOT`.
Neither has an option to preserve chain breaks, which is why `# fmt: off` /
`# fmt: on` used to be necessary here. It no longer is.

The trade-off is a less opinionated formatter: no quote normalisation, no
enforced trailing commas, and long lines are not reflowed into a canonical
shape. Run with `-a -a` (see `plugins/formatting.lua`) to get the non-whitespace
fixes as well. Widen ruff's lint rules to pick up some of the slack.

Default lint rules are narrow — pyflakes plus a few pycodestyle errors. Widen
them per project in `pyproject.toml`:

```toml
[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "SIM"]
```

Python buffers indent by 4, overriding the global 2 to match PEP 8.
`g:python_indent` in `core/options.lua` gives a single indent level inside an
open paren and returns a lone closing paren to the statement's own indent,
which suits parenthesised polars/pandas chains.
