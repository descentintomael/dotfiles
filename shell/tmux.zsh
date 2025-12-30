# =============================================================================
# Tmux Session Management
# =============================================================================
# Functions for managing labeled tmux sessions with fuzzy finding.
# Sourced by: shell/zshrc
#
# Key functions:
#   ts [name]       - Smart session attach/create with fzf picker
#   tls             - List all tmux sessions
#   tk [name]       - Kill a session (with fzf if no name)
#   tmux-search     - Search through tmux session logs
#   tmux-capture    - Capture current pane history to file
# =============================================================================

# Smart tmux session manager
# Usage: ts [session-name]
#   - No args: fzf picker showing existing sessions + create new option
#   - With arg: attach to existing or create new session with that name
function ts() {
    local session_name="$1"

    # If no argument, show interactive picker
    if [[ -z "$session_name" ]]; then
        local sessions
        sessions=$(tmux list-sessions -F "#{session_name}|#{session_windows} windows|#{?session_attached,attached,detached}" 2>/dev/null)

        if [[ -n "$sessions" ]]; then
            # Format for display and add create option
            local formatted
            formatted=$(echo "$sessions" | awk -F'|' '{printf "%-20s %s (%s)\n", $1, $2, $3}')
            formatted="+ Create new session\n$formatted"

            # Use fzf with preview showing session content
            local selection
            selection=$(echo "$formatted" | fzf \
                --prompt="tmux session: " \
                --header="Select session or create new" \
                --preview='
                    session=$(echo {} | awk "{print \$1}")
                    if [[ "$session" != "+" ]]; then
                        tmux capture-pane -t "$session" -p 2>/dev/null | tail -30
                    else
                        echo "Create a new labeled session"
                    fi
                ' \
                --preview-window=right:50%:wrap \
                --height=50% \
                --border)

            [[ -z "$selection" ]] && return 0

            # Extract session name from selection
            session_name=$(echo "$selection" | awk '{print $1}')

            if [[ "$session_name" == "+" ]]; then
                session_name=""
            fi
        fi

        # Prompt for new session name if needed
        if [[ -z "$session_name" ]]; then
            echo -n "Session name: "
            read session_name
            [[ -z "$session_name" ]] && return 1
        fi
    fi

    # Validate session name (alphanumeric, dash, underscore only)
    if [[ ! "$session_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Error: Session name can only contain letters, numbers, dashes, and underscores"
        return 1
    fi

    # Attach or create
    if tmux has-session -t "$session_name" 2>/dev/null; then
        if [[ -n "$TMUX" ]]; then
            tmux switch-client -t "$session_name"
        else
            tmux attach -t "$session_name"
        fi
    else
        if [[ -n "$TMUX" ]]; then
            tmux new-session -d -s "$session_name"
            tmux switch-client -t "$session_name"
        else
            tmux new-session -s "$session_name"
        fi
    fi
}

# List all tmux sessions with details
function tls() {
    if ! tmux list-sessions 2>/dev/null; then
        echo "No tmux sessions running"
    fi
}

# Kill a tmux session
# Usage: tk [session-name]
#   - No args: fzf picker to select session to kill
#   - With arg: kill the named session
function tk() {
    local session_name="$1"

    if [[ -z "$session_name" ]]; then
        local sessions
        sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

        if [[ -z "$sessions" ]]; then
            echo "No tmux sessions running"
            return 1
        fi

        session_name=$(echo "$sessions" | fzf \
            --prompt="Kill session: " \
            --header="Select session to kill" \
            --preview='tmux capture-pane -t {} -p 2>/dev/null | tail -20' \
            --preview-window=right:50%:wrap \
            --height=40% \
            --border)

        [[ -z "$session_name" ]] && return 0
    fi

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux kill-session -t "$session_name"
        echo "Killed session: $session_name"
    else
        echo "Session not found: $session_name"
        return 1
    fi
}

# Search through tmux session logs
# Requires tmux-logging plugin to be active
# Usage: tmux-search <pattern>
function tmux-search() {
    local pattern="$1"
    local log_dir="$HOME/.tmux/logs"

    if [[ ! -d "$log_dir" ]]; then
        echo "No tmux logs found at $log_dir"
        echo "Enable logging with: prefix + shift + p (toggle logging)"
        return 1
    fi

    if [[ -z "$pattern" ]]; then
        # Interactive search with fzf
        rg --color=always --line-number "" "$log_dir" 2>/dev/null | \
            fzf --ansi \
                --prompt="Search logs: " \
                --header="Type to search tmux session history" \
                --preview='
                    file=$(echo {} | cut -d: -f1)
                    line=$(echo {} | cut -d: -f2)
                    bat --color=always --highlight-line "$line" --line-range "$((line > 10 ? line - 10 : 1)):$((line + 10))" "$file" 2>/dev/null || cat "$file"
                ' \
                --preview-window=right:60%:wrap \
                --height=80% \
                --border
    else
        # Direct search with pattern
        rg --color=always "$pattern" "$log_dir" | head -100
    fi
}

# Capture current pane history to a searchable file
# Usage: tmux-capture [lines] [output-file]
function tmux-capture() {
    local lines="${1:-10000}"
    local session_name=$(tmux display-message -p '#S' 2>/dev/null)
    local output="${2:-/tmp/tmux-capture-${session_name:-unknown}.txt}"

    if [[ -z "$TMUX" ]]; then
        echo "Not in a tmux session"
        return 1
    fi

    tmux capture-pane -p -S "-$lines" > "$output"
    echo "Captured $lines lines to: $output"
    echo "Search with: rg 'pattern' $output"
}

# Quick session aliases
alias ta='tmux attach'
alias tad='tmux attach -d'  # Detach other clients
alias tks='tmux kill-server'
