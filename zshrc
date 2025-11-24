#!/bin/zsh
# ZSH Configuration - Modernized with sheldon + starship

# ============================================================================
# ZSH Options
# ============================================================================
setopt NO_BG_NICE
setopt NO_LIST_BEEP
setopt LIST_PACKED
setopt MULTIBYTE
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt NO_HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# Use a separate history file for Tmux
if [[ -n "$TMUX" ]]; then
    HISTFILE="$HOME/.tmux_history"
fi

# ============================================================================
# PATH Configuration
# ============================================================================
export PATH=/opt/homebrew/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:$HOME/.bin:/opt/local/bin:/opt/local/sbin:$PATH

# Sublime text
export SUBLIME_BIN=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin
export PATH=$SUBLIME_BIN:$PATH

# Java SDK v17
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export PATH="$JAVA_HOME/bin:$PATH"

# Homebrew bc utility
export PATH="/opt/homebrew/opt/bc/bin:$PATH"

# pipx
export PATH="$PATH:$HOME/.local/bin"

# ============================================================================
# Shell Plugin Manager (sheldon)
# ============================================================================
if command -v sheldon &> /dev/null; then
    eval "$(sheldon source)"
fi

# ============================================================================
# Modern Tool Initialization
# ============================================================================

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# zoxide (smart cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# fzf (fuzzy finder)
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)"
fi

# direnv (per-directory environment)
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# rbenv (Ruby version manager)
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init - zsh)"
fi

# ============================================================================
# Completion System
# ============================================================================
# Initialize zsh completion system (required for compdef)
autoload -Uz compinit
compinit -i

# ============================================================================
# Custom Configuration
# ============================================================================

# Source my custom aliases and functions
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/functions

# Source md2pdf function
[[ -f ~/.zsh/extras/md2pdf.zsh ]] && source ~/.zsh/extras/md2pdf.zsh

# Environment variables
export TZ=America/Los_Angeles
export GIT_PAGER='delta'

# Add a custom watcher for CloudFormation deployments
if [[ $PWD == "$HOME/Projects/custom_models" ]]; then
    source "$HOME/Projects/custom_models/.deploy_cf.zsh"
fi

# VS Code shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# ============================================================================
# Local Configuration (machine-specific, not in git)
# ============================================================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
