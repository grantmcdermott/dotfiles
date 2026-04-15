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

- [Oh My Zsh](https://ohmyz.sh/) with
  [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and
  [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- [GNU Stow](https://www.gnu.org/software/stow/): `brew install stow`
- Neovim system deps: [LazyGit](https://github.com/jesseduffield/lazygit),
  [Nerd Fonts](https://www.nerdfonts.com/) (MesloLGS NF recommended)

### Setup

Clone the repo and stow the packages you want:

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

## Notes

- The Neovim config is lightly modified from Josean Martinez's excellent
  [guide](https://www.josean.com/posts/how-to-setup-neovim-2024).
- The `claude/` directory contains Claude Code / Kiro CLI configuration and is
  not stowed automatically since its target path varies by setup.
