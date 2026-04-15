# Neovim Config

Lightly modified from Josean Martinez's excellent
[guide](https://www.josean.com/posts/how-to-setup-neovim-2024).

## System Dependencies

**macOS (Homebrew):**

```bash
brew install neovim lazygit ripgrep fd
brew install --cask font-meslo-lg-nerd-font
```

**Arch Linux (pacman):**

```bash
sudo pacman -S neovim lazygit ripgrep fd ttf-meslo-nerd
```

## Plugins

Managed by [lazy.nvim](https://github.com/folke/lazy.nvim) (`<space>lz` to
open). Plugins are auto-installed on first launch.

### Core workflow

| Plugin                                                             | Description                                                                             |
| ------------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder — search files, text, LSP symbols                                          |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)        | File explorer sidebar                                                                   |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)      | Persistent floating terminal                                                            |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)           | LazyGit TUI inside nvim                                                                 |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)        | Git gutter signs, hunk staging, inline blame                                            |
| [trouble.nvim](https://github.com/folke/trouble.nvim)              | Diagnostics and TODO list panel                                                         |
| [R.nvim](https://github.com/R-nvim/R.nvim)                         | R console, help, object browser                                                         |
| [neotest](https://github.com/nvim-neotest/neotest)                 | Test runner (with [testthat](https://github.com/shunsambongi/neotest-testthat) adapter) |

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

| Plugin                                                                          | Description                                       |
| ------------------------------------------------------------------------------- | ------------------------------------------------- |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)                     | Colorscheme                                       |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                    | Status line                                       |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)                   | Tab-style buffer bar                              |
| [alpha-nvim](https://github.com/goolord/alpha-nvim)                             | Dashboard start screen                            |
| [which-key.nvim](https://github.com/folke/which-key.nvim)                       | Shows available keybindings after pressing leader |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indentation guides                                |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim)                      | Improved input/select UI                          |

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
| `Cmd+Enter` | Send line/selection to REPL (R or Python) |
| `<space>rr` | Start R (R filetypes only)                |

### General

| Key         | Action                  |
| ----------- | ----------------------- |
| `<space>nh` | Clear search highlights |
| `<space>+`  | Increment number        |
| `<space>-`  | Decrement number        |

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

### Splits & Tabs

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
| `<space>lg` | Open LazyGit |

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
| `<space>lz` | Open Lazy plugin manager |
| `<space>mp` | Format file/selection    |

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
| `Cmd+Enter` | Send line/selection to REPL (R or Python) |
| `<space>rr` | Start R (R filetypes only)                |
