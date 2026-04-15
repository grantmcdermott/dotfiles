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

- [Neovim](https://neovim.io/) (>= 0.9)
- [LazyGit](https://github.com/jesseduffield/lazygit) — git TUI (`<space>lg`)
- [ripgrep](https://github.com/BurntSushi/ripgrep) — required by Telescope for live grep
- [fd](https://github.com/sharkdp/fd) — required by Telescope for file finding

### Fonts

Install a [Nerd Font](https://www.nerdfonts.com/) for icons and Powerlevel10k.
MesloLGS NF is recommended:

```bash
brew install --cask font-meslo-lg-nerd-font
```
