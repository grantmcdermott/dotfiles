# Dotfiles

My dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
dotfiles/
├── shell/          → ~/.zshrc, ~/.p10k.zsh
├── R/              → ~/.Rprofile, ~/.lintr, ~/.radian_profile
├── nvim/           → ~/.config/nvim/
├── ghostty/        → ~/.config/ghostty/
├── claude/         → (not stowed; see below)
└── README.md
```

Each top-level directory is a stow "package". Stow creates symlinks from `~`
that point into this repo, so the repo is always the source of truth.

## Installation

### Prerequisites

Install system dependencies:

**macOS (Homebrew):**

```bash
brew install neovim lazygit ripgrep fd stow
brew install --cask font-meslo-lg-nerd-font ghostty
```

**Arch Linux (pacman):**

```bash
sudo pacman -S neovim lazygit ripgrep fd stow ghostty ttf-meslo-nerd
# If ghostty is not in the repos yet:
# yay -S ghostty
```

- [Oh My Zsh](https://ohmyz.sh/) with
  [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and
  [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme

### Setup

Clone the repo and [stow](https://www.gnu.org/software/stow/) the packages you want:

```bash
git clone https://github.com/<username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow shell R nvim ghostty
```

This creates symlinks like `~/.zshrc → ~/dotfiles/shell/.zshrc`,
`~/.config/nvim → ~/dotfiles/nvim/.config/nvim`, etc.

If stow complains about existing files, back them up first:

```bash
mv ~/.zshrc ~/.zshrc.bak
mv ~/.config/nvim ~/.config/nvim.bak
# etc.
```

### Machine-specific config

Machine-specific shell config goes in `~/.zshrc.local`, which is sourced at the
end of `.zshrc` but not tracked in git (excluded via `*.local` in `.gitignore`).

Typical contents for `.zshrc.local`:

- Machine-specific `PATH` exports (e.g., Homebrew, toolbox, system paths)
- Employer-specific tooling and integrations
- SSH key loading
- Editor shell integrations (e.g., Kiro, VS Code)
- Language-specific environment variables (e.g., `JAVA_HOME`)

## Ergonomics

A few design principles run across the configs:

### Vim-style navigation everywhere

- Ghostty + Neovim: `Cmd+Enter` is unbound in Ghostty so it passes through to
  nvim (send-to-REPL). Raycast's `Alt+m` (maximize) replaces the default
  macOS `Cmd+Enter` fullscreen toggle.
- Telescope: `Ctrl+j`/`Ctrl+k` to move through results.
- Raycast window management: `Alt+h/j/k/l` for left/bottom/top/right halves.
- Radian (R terminal REPL): vi editing mode.

### Mnemonic leader keys (Neovim)

Leader is `Space`. Most Neovim bindings follow a `<Space><noun><verb>` pattern
where the first (noun) letter identifies the domain:

| Prefix | Domain                    | Examples                                                                                |
| ------ | ------------------------- | --------------------------------------------------------------------------------------- |
| `f`    | **f**ind (Telescope)      | `ff` files, `fs` string, `fr` recent, `fc` cursor word, `ft` todos                      |
| `e`    | **e**xplorer (nvim-tree)  | `ee` toggle, `ef` find file, `ec` collapse, `er` refresh                                |
| `s`    | **s**plits / windows      | `sv` vertical, `sh` horizontal, `se` equalise, `sx` close, `sm` maximise                |
| `t`    | **t**erminal / **t**abs   | `tt`/`th`/`tv` terminal float/horiz/vert; `to` new tab, `tx` close, `tn`/`tp` next/prev |
| `x`    | diagnostics (Trouble)     | `xw` workspace, `xd` document, `xq` quickfix, `xl` loclist, `xt` todos                  |
| `w`    | **w**orkspace (sessions)  | `wr` restore, `ws` save                                                                 |
| `g`    | **g**it                   | `gg` lazygit                                                                            |
| `l`    | **l**azy                  | `ll` Lazy plugin manager                                                                |
| `r`    | **R** (R filetypes only)  | `rr` start R                                                                            |
| `u`    | **u**v (Python filetypes) | `ui` init, `ua` add, `ur` run, `uc` sync                                                |
| `,`    | localleader (R.nvim)      | `,a` all, `,c` chunks, `,k` knit, `,v` view, etc.                                       |

### IDE-familiar shortcuts

`Cmd+/` (macOS) or `Ctrl+/` (Linux) toggles comments. `Cmd+Enter` or
`Ctrl+Enter` sends the current line or selection to the appropriate REPL
(R.nvim for R files, iron.nvim for Python). These mirror Positron / VS Code
muscle memory.

### Format on save

Conform.nvim auto-formats on save. R uses [Air](https://posit-dev.github.io/air/),
Lua uses stylua, Python uses isort + black, and web languages use prettier.
`<Space>mp` manually formats a file or visual selection.

## Notes

- The Neovim config is adapted from Josean Martinez's excellent
  [guide](https://www.josean.com/posts/how-to-setup-neovim-2024).
- The `claude/` directory contains Claude Code / Kiro CLI configuration and is
  not stowed automatically since its target path varies by setup.
