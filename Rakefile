require 'rake'

desc "Put all dotfiles in place and install homebrew"
task :install do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README LICENSE Brewfile].include? file
    
    if File.exist?(File.join(ENV['HOME'], ".#{file}"))
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
  
  # Need to do this to make vim use RVM's ruby version
  # Commenting this out since it doesn't work right now. Too busy to debug.
  # puts "Moving zshenv to zshrc"
  # system %Q{sudo mv /etc/zshenv /etc/zshrc}

  # system %Q{mkdir ~/.tmp}

  # Install Homebrew
  if system("which brew")
    print "Homebrew already installed"
  else
    print "Installing Homebrew..."
    system "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)\""
  end

  # Brew bundle
  print "Running Homebrew bundler..."
  system "brew bundle"
end

def replace_file(file)
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
