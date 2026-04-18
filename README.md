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

### Keeping your existing shell settings

> [!NOTE]
> Stowing `shell` will replace your existing `~/.zshrc` with a symlink to my
> version here. While stow will force you to back up your existing config to
> `~/.zshrc.bak`, this still means that any settings in your old file won't
> be picked up. That includes sensitive or machine-specific things
> that shouldn't live in a public repo anyway (e.g. employer tooling,
> credentials, API keys, etc.)
>
> One solution is to manually copy over these old (machine-specific) settings
> to `~/.zshrc`. But a better solution, which we adopt here, is to create a
> companion `~/.zshrc.local` file. This file will be automatically
> sourced at the end of `.zshrc`, but is never tracked in git. Sourcing a local
> override file is a widely-used convention in the dotfiles community, and it
> cleanly separates what is shared (this repo) from what is private (your
> machine).

**You must create `~/.zshrc.local` yourself.** After stowing, rescue any
machine-specific settings from your backup:

```bash
touch ~/.zshrc.local
```

Open `~/.zshrc.bak` and copy over anything specific to this machine rather
than general shell setup. Look for:

- Tool environment setups (e.g. `. "$HOME/.cargo/env"`, `. "$HOME/.local/bin/env"`)
- Machine-specific `PATH` exports (e.g. Homebrew, toolbox, system paths)
- Employer-specific tooling and integrations
- SSH key loading
- Editor shell integrations (e.g. Kiro, VS Code)
- Language-specific environment variables (e.g. `JAVA_HOME`, `GOPATH`)
- `CODECOMPANION_AGENT` — set to `"kiro"` or `"claude_code"` to enable the
  Neovim AI agent integration (see [CodeCompanion.nvim](https://codecompanion.olimorris.dev))

For example:

```bash
# Rust
. "$HOME/.cargo/env"

# Deno
. "$HOME/.deno/env"

# AI agent for CodeCompanion.nvim
export CODECOMPANION_AGENT=claude_code
```

If your backup is long, an AI assistant can help. Try:

> Here is my old `~/.zshrc.bak`. Extract only the machine-specific settings
> that don't belong in a shared dotfiles repo — tool environments, PATH
> additions, employer tooling, etc. Format them as a clean `~/.zshrc.local`
> and skip anything already covered by a standard Oh My Zsh setup.

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
| `a`    | **a**i (AI CodeCompanion) | `aa` action palette, `ac` toggle chat, `ai` new chat, `al` CLI agent                    |
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
