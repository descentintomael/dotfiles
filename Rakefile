# =============================================================================
# Dotfiles Installation Script
# =============================================================================
# Installs symlinks for all configuration files and sets up Homebrew packages.
#
# Usage:
#   rake install     - Full installation with interactive prompts
#   rake symlinks    - Only create symlinks (no brew, no prompts)
#
# Directory Structure:
#   shell/     → Shell configs (zshrc, aliases, functions)
#   editor/    → Neovim configuration
#   git/       → Git configuration
#   tools/     → Modern CLI tool configs (starship, sheldon)
#   ruby/      → Ruby development configs (irbrc, gemrc, railsrc)
#   templates/ → Local config templates (not symlinked)
#   themes/    → Terminal themes (not symlinked)
# =============================================================================

require 'rake'
require 'fileutils'

# Explicit symlink mapping: source (relative to repo) => target (absolute)
SYMLINKS = {
  # Shell configuration → ~/.*
  'shell/zshrc'   => File.join(ENV['HOME'], '.zshrc'),
  'shell/zlogin'  => File.join(ENV['HOME'], '.zlogin'),

  # Git configuration → ~/.*
  'git/config'    => File.join(ENV['HOME'], '.gitconfig'),
  'git/ignore'    => File.join(ENV['HOME'], '.gitignore'),

  # Ruby configuration → ~/.*
  'ruby/irbrc'    => File.join(ENV['HOME'], '.irbrc'),
  'ruby/gemrc'    => File.join(ENV['HOME'], '.gemrc'),
  'ruby/railsrc'  => File.join(ENV['HOME'], '.railsrc'),

  # Tmux configuration → ~/.*
  'tools/tmux/tmux.conf' => File.join(ENV['HOME'], '.tmux.conf'),

  # ~/.config/ targets
  'editor/nvim'        => File.join(ENV['HOME'], '.config', 'nvim'),
  'tools/starship.toml' => File.join(ENV['HOME'], '.config', 'starship.toml'),
  'tools/sheldon'      => File.join(ENV['HOME'], '.config', 'sheldon'),
}.freeze

desc "Put all dotfiles in place and install homebrew"
task :install do
  puts "\n=== Dotfiles Installation ===\n\n"

  setup_local_configs
  setup_symlinks
  setup_homebrew
  setup_sheldon_plugins

  puts "\n=== Installation Complete ===\n"
  puts "New shell features:"
  puts "  - Use 'z' for smart directory jumping (learns your habits)"
  puts "  - Press Ctrl+R for fuzzy history search (fzf)"
  puts "  - 'ls' now shows icons and git status (eza)"
  puts "  - Git diffs are syntax highlighted (delta)"
  puts ""
  puts "Run 'nvim' to install editor plugins automatically."
  puts "Restart your terminal or run 'source ~/.zshrc' to apply changes.\n\n"
end

desc "Only create symlinks (no brew, no prompts for local configs)"
task :symlinks do
  puts "\n=== Creating Symlinks ===\n\n"
  setup_symlinks(interactive: false)
  puts "\n=== Done ===\n"
end

# -----------------------------------------------------------------------------
# Local Configuration Setup
# -----------------------------------------------------------------------------

def setup_local_configs
  puts "--- Git Configuration ---"
  setup_gitconfig_local

  puts "\n--- Shell Configuration ---"
  setup_zshrc_local
end

def setup_gitconfig_local
  gitconfig_local = File.join(ENV['HOME'], '.gitconfig.local')

  if File.exist?(gitconfig_local)
    puts "~/.gitconfig.local already exists, skipping..."
    return
  end

  print "Enter your git name (or press Enter to skip): "
  name = $stdin.gets.chomp

  if name.empty?
    puts "Skipping git configuration. You can set it up later by copying templates/gitconfig.local.template"
    return
  end

  print "Enter your git email: "
  email = $stdin.gets.chomp

  if email.empty?
    puts "Email required. Skipping git configuration."
    return
  end

  File.write(gitconfig_local, <<~CONFIG)
    # Git Local Configuration
    # Generated during dotfiles installation

    [user]
        name = #{name}
        email = #{email}
  CONFIG

  puts "Created ~/.gitconfig.local"
end

def setup_zshrc_local
  zshrc_local = File.join(ENV['HOME'], '.zshrc.local')

  if File.exist?(zshrc_local)
    puts "~/.zshrc.local already exists, skipping..."
    return
  end

  print "Enter AWS profile name (or press Enter to skip): "
  aws_profile = $stdin.gets.chomp

  config_lines = ["# ZSH Local Configuration", "# Generated during dotfiles installation", ""]

  unless aws_profile.empty?
    config_lines << "# AWS Configuration"
    config_lines << "export AWS_PROFILE=#{aws_profile}"
    config_lines << ""
  end

  config_lines << "# Add any machine-specific configuration below"
  config_lines << ""

  File.write(zshrc_local, config_lines.join("\n"))
  puts "Created ~/.zshrc.local"
end

# -----------------------------------------------------------------------------
# Symlink Setup
# -----------------------------------------------------------------------------

def setup_symlinks(interactive: true)
  puts "--- Setting up symlinks ---\n\n"

  # Ensure ~/.config exists
  config_dir = File.join(ENV['HOME'], '.config')
  FileUtils.mkdir_p(config_dir) unless File.directory?(config_dir)

  replace_all = false

  SYMLINKS.each do |source, target|
    source_path = File.join(Dir.pwd, source)

    unless File.exist?(source_path)
      puts "WARNING: Source not found: #{source}"
      next
    end

    if File.exist?(target) || File.symlink?(target)
      if replace_all || !interactive
        replace_symlink(source_path, target)
      else
        print "overwrite #{target}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_symlink(source_path, target)
        when 'y'
          replace_symlink(source_path, target)
        when 'q'
          exit
        else
          puts "skipping #{target}"
        end
      end
    else
      create_symlink(source_path, target)
    end
  end
end

def replace_symlink(source, target)
  FileUtils.rm_rf(target)
  create_symlink(source, target)
end

def create_symlink(source, target)
  # Ensure parent directory exists
  FileUtils.mkdir_p(File.dirname(target))
  system %Q{ln -s "#{source}" "#{target}"}
  puts "linked #{target}"
end

# -----------------------------------------------------------------------------
# Homebrew & Sheldon Setup
# -----------------------------------------------------------------------------

def setup_homebrew
  puts "\n--- Setting up Homebrew ---"

  if system("which brew > /dev/null 2>&1")
    puts "Homebrew already installed"
  else
    puts "Installing Homebrew..."
    system '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  end

  puts "Running Homebrew bundler..."
  system "brew bundle"

  # Setup Java symlink for development
  puts "Setting up Java..."
  system "sudo ln -sfn $(brew --prefix java)/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk 2>/dev/null || true"
end

def setup_sheldon_plugins
  puts "\n--- Installing Shell Plugins ---"

  if system("which sheldon > /dev/null 2>&1")
    puts "Initializing sheldon plugins (this may take a moment)..."
    system "sheldon lock"
    puts "Sheldon plugins installed"
  else
    puts "Sheldon not yet installed - will be configured after 'brew bundle'"
  end
end
