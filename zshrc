# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=~/.zsh/themes

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sean"

# ZSH related options
# For more interesting options, use man zshoptions
setopt NO_BG_NICE
setopt NO_LIST_BEEP
setopt LIST_PACKED
setopt MULTIBYTE
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt NO_HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt TRANSIENT_RPROMPT
COMPLETION_WAITING_DOTS="true"

export GIT_PAGER='less -FRX'

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew bundler gem rails3 rake)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/opt/homebrew/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:$HOME/.bin:/opt/local/bin:/opt/local/sbin:$PATH

# Setup rbenv
eval "$(rbenv init - zsh)"

# Source my custom files after oh-my-zsh so I can override things.
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/functions

# Set this so topo burnup doesn't ask for my password
export TZ=America/Los_Angeles

# Sublime text
export SUBLIME_BIN=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin
export PATH=$SUBLIME_BIN:$PATH

# Force JavaSDK v17
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export PATH="$JAVA_HOME/bin:$PATH"

# Add a custom watcher for CloudFormation deployments
if [[ $PWD == "$HOME/Projects/custom_models" ]]; then
    source "$HOME/Projects/custom_models/.deploy_cf.zsh"
fi

# Use the homebrew version of the bc utility.
export PATH="/opt/homebrew/opt/bc/bin:$PATH"

# Use a separate history file for Tmux
if [[ -n "$TMUX" ]]; then
    HISTFILE="$HOME/.tmux_history"
fi

# Source md2epub function
source ~/.zsh/extras/md2pdf.zsh

# Add visual studio code integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Created by `pipx` on 2025-10-15 23:33:02
export PATH="$PATH:/Users/seantodd/.local/bin"

# Source local configuration (machine-specific settings, credentials)
# This file is created during installation and should NOT be committed
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
