#!/bin/zsh
# =============================================================================
# iTerm2 Helper Functions
# =============================================================================
# Only loaded when running in iTerm2. Provides helper functions for badges,
# notifications, theme switching, and other iTerm2-specific features.
#
# Sourced by: ~/.dotfiles/shell/zshrc (when TERM_PROGRAM == "iTerm.app")
# =============================================================================

# Guard: Only run in iTerm2
[[ "$TERM_PROGRAM" != "iTerm.app" ]] && return

# -----------------------------------------------------------------------------
# Badge Management
# -----------------------------------------------------------------------------

# Set iTerm2 badge text
# Usage: iterm-badge "text" or iterm-badge (clears badge)
function iterm-badge() {
    printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "${1:-}" | base64)
}

# Set badge to show current directory and git branch
function iterm-badge-auto() {
    local badge_text="%d"
    if git rev-parse --git-dir &>/dev/null; then
        badge_text+="\n$(git branch --show-current 2>/dev/null)"
    fi
    iterm-badge "$badge_text"
}

# -----------------------------------------------------------------------------
# Tab/Window Title
# -----------------------------------------------------------------------------

# Set tab title
function iterm-tab-title() {
    echo -ne "\e]1;${1}\a"
}

# Set window title
function iterm-window-title() {
    echo -ne "\e]2;${1}\a"
}

# -----------------------------------------------------------------------------
# Notifications
# -----------------------------------------------------------------------------

# Send a notification when a command completes
# Usage: long-running-command; iterm-notify "Done!"
function iterm-notify() {
    printf "\e]9;%s\a" "${1:-Command completed}"
}

# Mark attention (bounce dock icon)
function iterm-attention() {
    printf "\e]1337;RequestAttention=yes\a"
}

# -----------------------------------------------------------------------------
# Appearance
# -----------------------------------------------------------------------------

# Set iTerm2 color preset
# Usage: iterm-preset "Solarized Dark"
function iterm-preset() {
    echo -ne "\e]1337;SetColors=preset=${1}\a"
}

# Switch to light theme (Dawnfox)
function iterm-light() {
    iterm-preset "Dawnfox"
}

# Switch to dark theme (Breadog)
function iterm-dark() {
    iterm-preset "Breadog"
}

# Auto-switch based on macOS appearance
function iterm-sync-theme() {
    if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
        iterm-dark
    else
        iterm-light
    fi
}

# -----------------------------------------------------------------------------
# Utilities
# -----------------------------------------------------------------------------

# Clear scrollback buffer
function iterm-clear-scrollback() {
    printf "\e]1337;ClearScrollback\a"
}

# Set cursor shape: block, underline, or bar
function iterm-cursor() {
    case "${1:-block}" in
        block)     printf "\e]1337;CursorShape=0\a" ;;
        underline) printf "\e]1337;CursorShape=2\a" ;;
        bar)       printf "\e]1337;CursorShape=1\a" ;;
    esac
}

# -----------------------------------------------------------------------------
# Auto Theme Sync (runs on shell startup)
# -----------------------------------------------------------------------------

# Sync theme with macOS appearance on shell startup
# iterm-sync-theme
