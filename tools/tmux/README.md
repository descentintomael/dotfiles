# Tmux Session Management

A workflow for managing labeled tmux sessions with fuzzy finding, persistence, and searchable history.

## Quick Start

```zsh
# Open the session picker (fzf with preview)
ts

# Attach to or create a named session directly
ts project-name

# List all sessions
tls

# Kill a session interactively
tk
```

## Session Naming Convention

Use descriptive names to find sessions later:

- `project-feature` → `webapp-auth`, `api-refactor`
- `client-project` → `acme-dashboard`
- `task-context` → `debug-memory-leak`

## Shell Commands

| Command | Description |
|---------|-------------|
| `ts` | Interactive session picker with fzf |
| `ts <name>` | Attach to existing or create new session |
| `tls` | List all tmux sessions with details |
| `tk` | Kill a session (fzf picker if no arg) |
| `tk <name>` | Kill a specific session |
| `ta` | Attach to last session |
| `tad` | Attach and detach other clients |
| `tks` | Kill the tmux server (all sessions) |

## Tmux Keybindings

Prefix key: `Ctrl-a`

### Session Management

| Keys | Action |
|------|--------|
| `prefix + s` | Session tree picker |
| `prefix + N` | New named session (prompts for name) |
| `prefix + R` | Rename current session |
| `prefix + f` | FZF session/window picker |
| `prefix + d` | Detach from session |

### Windows & Panes

| Keys | Action |
|------|--------|
| `prefix + c` | New window (in current path) |
| `prefix + \|` | Split pane vertically |
| `prefix + -` | Split pane horizontally |
| `prefix + h/j/k/l` | Navigate panes (vim-style) |
| `prefix + H/J/K/L` | Resize panes |
| `prefix + z` | Toggle pane zoom |

### Copy Mode & Search

| Keys | Action |
|------|--------|
| `prefix + [` | Enter copy mode |
| `prefix + /` | Enter copy mode and search |
| `v` | Begin selection (in copy mode) |
| `y` | Copy selection to clipboard |
| `q` | Exit copy mode |

### Utility

| Keys | Action |
|------|--------|
| `prefix + r` | Reload tmux config |
| `prefix + I` | Install plugins (TPM) |
| `prefix + U` | Update plugins |

## BetterTouchTool Integration

Two AppleScripts are provided in `~/.dotfiles/tools/bettertouchtool/`:

### Session Picker (`tmux-session.applescript`)

Opens new iTerm tab and runs `ts` for interactive selection.

**Setup:**
1. BetterTouchTool → Keyboard Shortcuts
2. Add shortcut: `⌘⇧T` (or your preference)
3. Action: "Run Apple Script (blocking)"
4. Paste contents of `tmux-session.applescript`

### Named Session (`tmux-session-named.applescript`)

Prompts for session name first, then opens it.

**Setup:**
1. Add shortcut: `⌘⇧⌥T` (or your preference)
2. Action: "Run Apple Script (blocking)"
3. Paste contents of `tmux-session-named.applescript`

## Searching Session History

### Enable Logging

In tmux, press `prefix + shift + P` to toggle logging for the current pane. Logs are saved to `~/.tmux/logs/`.

### Search Commands

```zsh
# Interactive search through all logs
tmux-search

# Search for a specific pattern
tmux-search "error"

# Capture current pane history to a file
tmux-capture

# Capture with custom line count
tmux-capture 5000 /tmp/my-capture.txt
```

## Session Persistence

Sessions automatically persist across tmux server restarts via `tmux-resurrect` and `tmux-continuum`:

- Auto-saves every 15 minutes
- Auto-restores on tmux start
- Captures pane contents and nvim sessions

Manual save/restore:
- `prefix + Ctrl-s` → Save
- `prefix + Ctrl-r` → Restore

## Typical Workflow

1. **Start work:** `ts project-name` or use BetterTouchTool shortcut
2. **Create windows:** `prefix + c` for new tasks within the session
3. **Split panes:** `prefix + |` or `prefix + -` for side-by-side work
4. **Switch sessions:** `ts` to pick a different session
5. **End of day:** Just close terminal - sessions persist
6. **Next day:** `ts` to pick up where you left off

## Plugin Management

Plugins are managed by TPM (Tmux Plugin Manager).

**Installed plugins:**
- `tmux-sensible` - Sensible defaults
- `tmux-resurrect` - Session persistence
- `tmux-continuum` - Auto-save/restore
- `tmux-logging` - Pane logging for search
- `tmux-better-mouse-mode` - Improved scrolling
- `tmux-fzf` - FZF integration

**Commands:**
- `prefix + I` - Install new plugins
- `prefix + U` - Update plugins
- `prefix + alt + u` - Uninstall removed plugins

## File Locations

| File | Purpose |
|------|---------|
| `~/.tmux.conf` | Symlink to config |
| `~/.dotfiles/tools/tmux/tmux.conf` | Actual config |
| `~/.dotfiles/shell/tmux.zsh` | Shell functions |
| `~/.tmux/plugins/` | TPM plugins |
| `~/.tmux/logs/` | Session logs (for search) |
| `~/.tmux/resurrect/` | Saved sessions |
