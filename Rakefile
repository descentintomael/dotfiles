require 'rake'
require 'fileutils'

EXCLUDED_FILES = %w[Rakefile README.rdoc LICENSE Brewfile nvim sheldon starship.toml gitconfig.local.template zshrc.local.template].freeze

desc "Put all dotfiles in place and install homebrew"
task :install do
  puts "\n=== Dotfiles Installation ===\n\n"

  # Setup local configuration files first (with sensitive data)
  setup_local_configs

  # Symlink dotfiles
  setup_symlinks

  # Setup Neovim config directory
  setup_neovim_config

  # Setup modern tool configs (sheldon, starship)
  setup_modern_tools

  # Install Homebrew and packages
  setup_homebrew

  # Initialize sheldon plugins
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
    puts "Skipping git configuration. You can set it up later by copying gitconfig.local.template"
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

def setup_symlinks
  puts "\n--- Setting up symlinks ---"

  replace_all = false
  Dir['*'].each do |file|
    next if EXCLUDED_FILES.include?(file)
    next if file.end_with?('.template')

    home_file = File.join(ENV['HOME'], ".#{file}")

    if File.exist?(home_file) || File.symlink?(home_file)
      if replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end
end

def setup_neovim_config
  puts "\n--- Setting up Neovim ---"

  nvim_config_dir = File.join(ENV['HOME'], '.config')
  nvim_link = File.join(nvim_config_dir, 'nvim')
  nvim_source = File.join(Dir.pwd, 'nvim')

  # Create ~/.config if it doesn't exist
  FileUtils.mkdir_p(nvim_config_dir) unless File.directory?(nvim_config_dir)

  if File.exist?(nvim_link) || File.symlink?(nvim_link)
    print "overwrite ~/.config/nvim? [yn] "
    if $stdin.gets.chomp == 'y'
      FileUtils.rm_rf(nvim_link)
      system %Q{ln -s "#{nvim_source}" "#{nvim_link}"}
      puts "linked ~/.config/nvim"
    else
      puts "skipping ~/.config/nvim"
    end
  else
    system %Q{ln -s "#{nvim_source}" "#{nvim_link}"}
    puts "linked ~/.config/nvim"
  end
end

def setup_modern_tools
  puts "\n--- Setting up Modern Tools ---"

  config_dir = File.join(ENV['HOME'], '.config')
  FileUtils.mkdir_p(config_dir) unless File.directory?(config_dir)

  # Sheldon (plugin manager)
  sheldon_config_dir = File.join(config_dir, 'sheldon')
  sheldon_source = File.join(Dir.pwd, 'sheldon')

  if File.exist?(sheldon_config_dir) || File.symlink?(sheldon_config_dir)
    print "overwrite ~/.config/sheldon? [yn] "
    if $stdin.gets.chomp == 'y'
      FileUtils.rm_rf(sheldon_config_dir)
      system %Q{ln -s "#{sheldon_source}" "#{sheldon_config_dir}"}
      puts "linked ~/.config/sheldon"
    else
      puts "skipping ~/.config/sheldon"
    end
  else
    system %Q{ln -s "#{sheldon_source}" "#{sheldon_config_dir}"}
    puts "linked ~/.config/sheldon"
  end

  # Starship (prompt)
  starship_link = File.join(config_dir, 'starship.toml')
  starship_source = File.join(Dir.pwd, 'starship.toml')

  if File.exist?(starship_link) || File.symlink?(starship_link)
    print "overwrite ~/.config/starship.toml? [yn] "
    if $stdin.gets.chomp == 'y'
      FileUtils.rm_rf(starship_link)
      system %Q{ln -s "#{starship_source}" "#{starship_link}"}
      puts "linked ~/.config/starship.toml"
    else
      puts "skipping ~/.config/starship.toml"
    end
  else
    system %Q{ln -s "#{starship_source}" "#{starship_link}"}
    puts "linked ~/.config/starship.toml"
  end
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

def replace_file(file)
  home_file = File.join(ENV['HOME'], ".#{file}")
  FileUtils.rm_rf(home_file)
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
