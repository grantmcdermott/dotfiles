# Dotfiles

[Structure](#structure) | [Design](#design-principles-and-ergonomics) | [Installation](#installation) | [Notes](#notes)

Grant McDermott's personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

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

## Design principles and ergonomics

My major goal for these configs is improved efficiency and consistency. I want
to reduce typing, re-use the same patterns and shortcuts across programs (and
operating systems), and generally make a keyboard-centric workflow as enjoyable
as possible. With that in mind, here are a few design principles that run across
all of my configs:

- **Vim-style navigation everywhere**, e.g. `Alt+h/j/k/l`
  for Raycast window halves (macOS), `Ctrl+j`/`Ctrl+k` in Telescope.
- **Simple and consistent mnemonics**, e.g. in Neovim our Space-leader bindings follow a
  `<Space><noun><verb>` pattern. So `<Space>ff` for **f**ind **f**ile,
  `<Space>gg` for **g**it (lazygit), etc. Full table in
  [`nvim/README.md`](nvim/README.md).
- **IDE-familiar shortcuts** — `Cmd+/` (macOS) or `Ctrl+/` (Linux) toggles
  comments, `Cmd+Enter` / `Ctrl+Enter` sends to the REPL. Mirrors
  Positron / VS Code muscle memory.

## Installation

### Setup

Assuming you have installed the [prerequisites](#prerequisites) (below) simply
clone the repo and [stow](https://www.gnu.org/software/stow/) the packages you
want:

```bash
git clone https://github.com/grantmcdermott/dotfiles.git ~/dotfiles
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

<details>
<summary><b>Tip: Preserve your private shell settings in <code>~/.zshrc.local</code></b></summary>

Stowing `shell` will replace your existing `~/.zshrc` with a symlink to my
version here. While stow will force you to back up your existing config to
`~/.zshrc.bak`, this still means that any settings in your old file won't
be picked up. That includes sensitive or machine-specific things
that shouldn't live in a public repo anyway (e.g. employer tooling,
credentials, API keys, etc.)

One solution is to manually copy over these old (machine-specific) settings
to `~/.zshrc`. But a better solution, which we adopt here, is to create a
companion **`~/.zshrc.local`** file. This file will be automatically
sourced at the end of `.zshrc`, but is never tracked in git. Sourcing a local
override file is a widely-used convention in the dotfiles community, and it
cleanly separates what is shared (this repo) from what is private (your
machine).

**Important:** You must create `~/.zshrc.local` yourself. After stowing, rescue
any machine-specific settings from your backup:

```bash
touch ~/.zshrc.local
```

Open `~/.zshrc.bak` and copy over anything specific to this machine rather
than general shell setup. Look for:

- Tool environment setups (e.g. `. "$HOME/.cargo/env"`, `. "$HOME/.local/bin/env"`)
- Machine-specific `PATH` exports (e.g. Homebrew, system paths)
- Employer-specific tooling and integrations
- SSH key loading
- Editor shell integrations (e.g. Kiro, VS Code)
- Language-specific environment variables (e.g. `JAVA_HOME`, `GOPATH`)
- `CODECOMPANION_AGENT`, e.g. set to `"kiro"` or `"claude_code"` to enable the

For example:

```bash
# AI agent for CodeCompanion.nvim
export CODECOMPANION_AGENT=claude_code
```

If your backup is long, an AI assistant can help. Try:

> Here is my old `~/.zshrc.bak`. Extract only the machine-specific settings
> that don't belong in a shared dotfiles repo — tool environments, PATH
> additions, employer tooling, etc. Format them as a clean `~/.zshrc.local`
> and skip anything already covered by a standard Oh My Zsh setup.

</details>

### Prerequisites

In order to clone my setup exactly, you need the following:

- [**Ghostty**](https://ghostty.org/) — my favourite terminal emulator
- [**GNU Stow**](https://www.gnu.org/software/stow/) — what manages the symlinks
- [**MesloLGS Nerd Font**](https://github.com/ryanoasis/nerd-fonts) — for Powerlevel10k glyphs
- [**Oh My Zsh**](https://ohmyz.sh/) + [**Powerlevel10k**](https://github.com/romkatv/powerlevel10k) + zsh-autosuggestions + zsh-syntax-highlighting
- [**Neovim**](https://neovim.io/) (≥ 0.10) — my primary editor and what much of my config is built around
- [**ripgrep**](https://github.com/BurntSushi/ripgrep), [**fd**](https://github.com/sharkdp/fd), [**lazygit**](https://github.com/jesseduffield/lazygit) — used by Neovim plugins

You can either click on these links to install everything manually, or expand
the installation _tl;dr_ blocks below to get to get the appropriate shell
commands for your OS.

#### Installation _tl;dr_

<details>
<summary><b>macOS</b></summary>

```bash
brew install neovim lazygit ripgrep fd stow
brew install --cask font-meslo-lg-nerd-font ghostty raycast
```

Raycast config lives in its internal database, not in dotfiles; see
[`raycast/README.md`](raycast/README.md) for the export/import workflow.

</details>

<details>
<summary><b>Arch Linux</b></summary>

```bash
# Core tools
sudo pacman -S neovim lazygit ripgrep fd stow ghostty ttf-meslo-nerd zsh
# If ghostty is not in the repos yet:
# yay -S ghostty

# Oh My Zsh + Powerlevel10k + plugins
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyz/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

</details>

<details>
<summary><b>Ubuntu</b></summary>

Note: I haven't tested these; please let me know if they work for you.

```bash
sudo apt update
sudo apt install lazygit ripgrep fd-find stow zsh
# `fd` is installed as `fdfind` on Debian/Ubuntu; alias it if you like:
#   ln -s $(which fdfind) ~/.local/bin/fd
```

> [!IMPORTANT]
> Ubuntu's default apt repos usually ship an older Neovim than this config
> requires. Install a current release from the
> [Neovim releases page](https://github.com/neovim/neovim/releases) or via the
> [unstable PPA](https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable).

Ghostty and the Meslo Nerd Font aren't in the default apt repos. Install them
from their upstream sources:

- Ghostty: <https://ghostty.org/download>
- MesloLGS Nerd Font: <https://github.com/ryanoasis/nerd-fonts/releases> (grab
  the `Meslo.zip` release and drop the `.ttf` files into
  `~/.local/share/fonts`, then `fc-cache -fv`)

</details>

\
My config also reflects that I use a _lot_ of R (mostly) and Python in my daily
workflow. You only need these extra bits if you plan to stow the equivalent
components on your machine:

<details>
<summary><b>R and Python (optional)</b></summary>

- **R** — requires [R](https://www.r-project.org/) itself. The primary R workflow
  is through Neovim ([R.nvim](https://github.com/R-nvim/R.nvim)
  \+ Air + Jarl; see `nvim/README.md`), so no extra terminal REPL is strictly
  needed. If you also want a nicer REPL when launching R directly from the
  terminal or VS Code, install [arf](https://github.com/eitsupi/arf) — the
  `R/.config/arf/` config here enables vi mode and matches the old radian
  setup. The `.Rprofile` also auto-starts a
  [btw](https://posit-dev.github.io/btw/) MCP session if the package is
  installed (optional, for AI tooling).
- **Python** — requires [uv](https://github.com/astral-sh/uv) on `PATH` for
  `uv.nvim` and the iron.nvim Python REPL. Install with
  `curl -LsSf https://astral.sh/uv/install.sh | sh`.

</details>

## Notes

- The Neovim config is adapted from Josean Martinez's excellent
  [guide](https://www.josean.com/posts/how-to-setup-neovim-2024).
- The `claude/` directory contains Claude Code / Kiro CLI configuration and is
  not stowed automatically since its target path varies by setup.
