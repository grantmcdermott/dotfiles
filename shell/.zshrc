
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Kiro CLI (macOS only; Amazon's agentic CLI). The block above and the one at
# the very bottom are written by `kiro-cli integrations install dotfiles`,
# which scans this file to detect them — so they live here rather than in
# ~/.zshrc.local, which would just get them re-added on the next update.
# Kiro also *repositions* them, forcing its pre block first and its post
# block last, so nothing can be appended after the latter. The `[[ -f ]]`
# guards make both silent no-ops wherever that path is absent (Linux, or
# macOS without Kiro installed) — the only cost there is that the failed
# guard leaves $? = 1, which can tint the first p10k prompt char red until
# you run a command.

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias r="arf"

# >>> juliaup initialize >>>
# !! Contents within this block are managed by juliaup !!
path=("$HOME/.juliaup/bin" $path)
export PATH
# <<< juliaup initialize <<<

# Rust
. "$HOME/.cargo/env"

# Machine-specific overrides (not tracked in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
