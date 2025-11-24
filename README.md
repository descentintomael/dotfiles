# Dotfiles

Personal configuration files for macOS development environment.

## Quick Start

```zsh
git clone git@github.com:descentintomael/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
```

The install script will:
1. Prompt for git user name/email (stored in `~/.gitconfig.local`)
2. Prompt for AWS profile (stored in `~/.zshrc.local`)
3. Create symlinks for all configuration files
4. Install Homebrew and packages from `Brewfile`
5. Initialize shell plugins via sheldon

## Directory Structure

```
~/.dotfiles/
├── shell/           # Shell configuration
│   ├── zshrc        # Main zsh config → ~/.zshrc
│   ├── zlogin       # Login shell config → ~/.zlogin
│   ├── aliases      # Shell aliases (sourced by zshrc)
│   ├── functions    # Shell functions (sourced by zshrc)
│   └── extras/      # Additional shell scripts (md2pdf, etc.)
│
├── editor/          # Editor configuration
│   └── nvim/        # Neovim (Lua-based) → ~/.config/nvim/
│
├── git/             # Git configuration
│   ├── config       # Main git config → ~/.gitconfig
│   ├── ignore       # Global gitignore → ~/.gitignore
│   └── attributes   # Git attributes
│
├── tools/           # Modern CLI tool configs
│   ├── starship.toml    # Prompt → ~/.config/starship.toml
│   └── sheldon/         # Plugin manager → ~/.config/sheldon/
│
├── ruby/            # Ruby development configs
│   ├── irbrc        # IRB config → ~/.irbrc
│   ├── gemrc        # Gem config → ~/.gemrc
│   └── railsrc      # Rails generators → ~/.railsrc
│
├── templates/       # Local config templates (not symlinked)
│   ├── gitconfig.local.template
│   └── zshrc.local.template
│
├── themes/          # Terminal themes
│   └── iterm/       # iTerm color schemes
│
├── Brewfile         # Homebrew packages
└── Rakefile         # Installation script
```

## Tools Overview

### Shell Environment

| Tool | Purpose | Usage |
|------|---------|-------|
| **zsh** | Shell | Default macOS shell |
| **sheldon** | Plugin manager | Fast, declarative plugin management |
| **starship** | Prompt | Cross-shell, fast, customizable |
| **fzf** | Fuzzy finder | `Ctrl+R` for history, `Ctrl+T` for files |
| **zoxide** | Smart cd | `z <partial-path>` learns your habits |
| **eza** | Modern ls | Icons, git status, tree view |
| **direnv** | Per-directory env | Auto-load `.envrc` files |

### Development Tools

| Tool | Purpose |
|------|---------|
| **neovim** | Editor with Lua config |
| **delta** | Syntax-highlighted git diffs |
| **ripgrep** | Fast code search (`rg`) |
| **fd** | Fast file finder |
| **bat** | Cat with syntax highlighting |
| **jq** | JSON processor |

### Language Support

| Tool | Purpose |
|------|---------|
| **rbenv** | Ruby version manager |
| **node** | JavaScript runtime |
| **python** | Python runtime |
| **go** | Go runtime |
| **java** | OpenJDK 17 |

## Key Features

### Prompt (Starship)

The prompt displays:
- `➜` - Prompt indicator (red)
- Ruby version (when in Ruby project)
- Git branch `±(branch)`
- Dirty indicator `✗` (yellow, when uncommitted changes)
- Current directory (right-aligned)

### Shell Plugins (Sheldon)

- **zsh-autosuggestions** - History-based suggestions
- **fast-syntax-highlighting** - Real-time syntax highlighting
- **fzf-tab** - Fuzzy completion menu
- **oh-my-zsh git** - Git aliases and completions
- **oh-my-zsh bundler** - Bundle exec shortcuts
- **oh-my-zsh rake** - Rake task completion

### Git Configuration

- **Delta** for side-by-side diffs with syntax highlighting
- **Kaleidoscope** as diff/merge tool
- Auto-prune on fetch
- Auto-setup remote on push
- Useful aliases: `git lol`, `git recent`, `git amend`, `git undo`

## Customization

### Machine-Specific Settings

Create local config files for machine-specific settings (not tracked in git):

**~/.gitconfig.local** - Git user identity:
```ini
[user]
    name = Your Name
    email = your@email.com
```

**~/.zshrc.local** - Machine-specific shell config:
```zsh
# AWS
export AWS_PROFILE=your-profile

# Project-specific paths
export PATH="$HOME/custom/bin:$PATH"
```

### Adding New Symlinks

Edit `Rakefile` and add to the `SYMLINKS` hash:
```ruby
SYMLINKS = {
  # ... existing entries ...
  'path/in/repo' => File.join(ENV['HOME'], '.target'),
}
```

## Rake Tasks

```zsh
rake install    # Full installation with prompts
rake symlinks   # Only create symlinks (non-interactive)
```

## License

MIT
