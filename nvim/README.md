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

## Leader Keys

- **Leader**: `Space`
- **Local leader**: `\` (default, used by R.nvim for R-specific commands)

Press the leader key and wait to see available mappings via
[which-key](https://github.com/folke/which-key.nvim).

## Key Mappings

### General

| Key | Action |
|-----|--------|
| `<space>nh` | Clear search highlights |
| `<space>+` | Increment number |
| `<space>-` | Decrement number |

### File Explorer (nvim-tree)

| Key | Action |
|-----|--------|
| `<space>ee` | Toggle file explorer |
| `<space>ef` | Find current file in explorer |
| `<space>ec` | Collapse explorer |
| `<space>er` | Refresh explorer |

### Search (Telescope)

| Key | Action |
|-----|--------|
| `<space>ff` | Find files |
| `<space>fr` | Find recent files |
| `<space>fs` | Live grep (search text in project) |
| `<space>fc` | Grep string under cursor |
| `<space>ft` | Find TODOs |

### Splits & Tabs

| Key | Action |
|-----|--------|
| `<space>sv` | Split vertically |
| `<space>sh` | Split horizontally |
| `<space>se` | Equalize split sizes |
| `<space>sx` | Close current split |
| `<space>sm` | Maximize/minimize split |
| `<space>to` | New tab |
| `<space>tx` | Close tab |
| `<space>tn` | Next tab |
| `<space>tp` | Previous tab |
| `<space>tf` | Current buffer in new tab |

### Git (gitsigns)

| Key | Action |
|-----|--------|
| `<space>hs` | Stage hunk |
| `<space>hr` | Reset hunk |
| `<space>hS` | Stage buffer |
| `<space>hR` | Reset buffer |
| `<space>hu` | Undo stage hunk |
| `<space>hp` | Preview hunk |
| `<space>hb` | Blame line |
| `<space>hB` | Toggle line blame |
| `<space>hd` | Diff this |
| `<space>hD` | Diff against last commit |

### Git (lazygit)

| Key | Action |
|-----|--------|
| `<space>lg` | Open LazyGit |

### LSP

| Key | Action |
|-----|--------|
| `<space>ca` | Code action |
| `<space>rn` | Rename symbol |
| `<space>D` | File diagnostics |
| `<space>d` | Line diagnostics |
| `<space>rs` | Restart LSP |

### Diagnostics (Trouble)

| Key | Action |
|-----|--------|
| `<space>xw` | Workspace diagnostics |
| `<space>xd` | Document diagnostics |
| `<space>xq` | Quickfix list |
| `<space>xl` | Location list |
| `<space>xt` | TODOs |

### Terminal (toggleterm)

| Key | Action |
|-----|--------|
| `<space>tt` | Toggle floating terminal |
| `<Esc><Esc>` | Dismiss terminal (from inside) |

### Sessions

| Key | Action |
|-----|--------|
| `<space>wr` | Restore session |
| `<space>ws` | Save session |

### Other

| Key | Action |
|-----|--------|
| `<space>l` | Trigger linting |
| `<space>lz` | Open Lazy plugin manager |
| `<space>mp` | Format file/selection |

### R.nvim (local leader: `\`)

These mappings are active in R and Quarto files. Press `\` to see the
full menu via which-key.

| Key | Group |
|-----|-------|
| `\a` | All |
| `\b` | Between marks |
| `\c` | Chunks |
| `\f` | Functions |
| `\g` | Goto |
| `\i` | Install |
| `\k` | Knit |
| `\p` | Paragraph |
| `\q` | Quarto |
| `\r` | R general |
| `\s` | Split or send |
| `\t` | Terminal |
| `\v` | View |
| `Enter` | Send line (normal) / Send selection (visual) |
