#!/usr/bin/env bash
#===============================================================================
#
#          FILE: install_dotfiles_macos.sh
#
#         USAGE: ./install_dotfiles_macos.sh
#
#   DESCRIPTION: Installs all dotfiles from github.com/eindiran/dotfiles
#
#  REQUIREMENTS: Requires apt-get.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

set -Eeuo pipefail

sudo apt-get update
sudo apt-get -y upgrade

command -v zsh >/dev/null 2>&1 || sudo apt-get install -y zsh
command -v git >/dev/null 2>&1 || sudo apt-get install -y git
command -v htop >/dev/null 2>&1 || sudo apt-get install -y htop
command -v tree >/dev/null 2>&1 || sudo apt-get install -y tree
command -v less >/dev/null 2>&1 || sudo apt-get install -y less
command -v xbindkeys >/dev/null 2>&1 || sudo apt-get install -y xbindkeys xbindkeys-config
command -v tmux >/dev/null 2>&1 || sudo apt-get install -y tmux
command -v mutt >/dev/null 2>&1 || sudo apt-get install -y mutt
command -v irssi >/dev/null 2>&1 || sudo apt-get install -y irssi
command -v rustc >/dev/null 2>&1 || sudo apt-get install -y rustc rust-doc cargo cargo-doc rust-gdb


# Install fzf
command -v fzf >/dev/null 2>&1 || { git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install; }

# Install packages via cargo
command -v rg >/dev/null 2>&1 || cargo install ripgrep
command -v fd >/dev/null 2>&1 || cargo install fd-find
command -v sk >/dev/null 2>&1 || cargo install skim
command -v hx >/dev/null 2>&1 || cargo install hx
command -v broot >/dev/null 2>&1 || cargo install broot
command -v procs >/dev/null 2>&1 || cargo install procs
command -v dust >/dev/null 2>&1 || cargo install du-dust
command -v bat >/dev/null 2>&1 || cargo install bat
command -v hyperfine >/dev/null 2>&1 || cargo install hyperfine
command -v hexyll >/dev/null 2>&1 || cargo install hexyl
command -v tokei >/dev/null 2>&1 || cargo install tokei

sudo apt-get install -y terminator
sudo apt-get install -y shellcheck
sudo apt-get install -y lynx
sudo apt-get install -y gawk
sudo apt-get install -y sox
sudo apt-get install -y zip
sudo apt-get install -y unzip
sudo apt-get install -y pandoc
sudo apt-get install -y alien
sudo apt-get install -y rpm
sudo apt-get install -y ntfs-3g
sudo apt-get install -y mtools
sudo apt-get install -y mpd
sudo apt-get install -y xclip
sudo apt-get install -y xz-utils
sudo apt-get install -y audacity
sudo apt-get install -y lame
sudo apt-get install -y flac
sudo apt-get install -y thunderbird
sudo apt-get install -y default-jdk
sudo apt-get install -y gradle
sudo apt-get install -y groovy
sudo apt-get install -y junit
sudo apt-get install -y python3
sudo apt-get install -y python3-pip
sudo apt-get install -y pypy
sudo apt-get install -y pylint
sudo apt-get install -y pylint3
sudo apt-get install -y pydf
sudo apt-get install -y sqlite
sudo apt-get install -y sqlite3
sudo apt-get install -y mongodb
sudo apt-get install -y ranger
sudo apt-get install -y mplayer
sudo apt-get install -y mpv
sudo apt-get install -y vlc
sudo apt-get install -y newsboat

echo "Cleaning Up..." &&
    sudo apt-get -f install &&
    sudo apt-get -y autoremove &&
    sudo apt-get -y clean

# Install .zshrc using the install script:
cd shells && ./install_zshrc.sh -w && cd ..

# Copy over fzf dotfiles
mkdir -p ~/.fzf/shell
cp fzf/.fzf.*sh ~/
cp fzf/completion.* ~/.fzf/shell
cp fzf/key-bindings.* ~/.fzf/shell

# Copy over global .gitconfig
cp git/.gitconfig ~/.gitconfig
cp git/.gitignore ~/.gitignore

# Copy over .htoprc
mkdir -p ~/.config/htop
cp htop/htoprc ~/.config/htop/htoprc

# Handle all the misc files:
# Copy over ALSA config
cp misc/alsa/.asoundrc ~/.asoundrc
# Copy over .ignore files for ripgrep and fd:
cp misc/.rgignore ~/.rgignore
cp misc/.fdignore ~/.fdignore
# Copy over .xbindkeysrc
cp misc/xbindkeys/.xbindkeysrc ~/.xbindkeysrc

# Copy over the URLs file, config file, and bookmarking script
# for the RSS reader newsboat:
mkdir -p ~/.newsboat
cp newsboat/urls ~/.newsboat
cp newsboat/config ~/.newsboat
cp newsboat/bookmark.sh ~/.newsboat

# Copy over irssi dotfiles
mkdir -p ~/.irssi
cp irssi/config ~/.irssi/config

# Copy over .muttrc
mkdir -p ~/.mutt
cp mutt/.mutt/* ~/.mutt/
cp mutt/.muttrc ~/.mutt/muttrc

# Copy over tmux scripts and config file:
mkdir -p ~/.tmux/scripts
cp tmux/.tmux.conf ~/.tmux.conf
cp tmux/scripts/* ~/.tmux/scripts
# Get tmux Plugin Manager (TPM)
mkdir -p ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copy over .vimrc
cp vim/.vimrc ~/.vimrc
./vim/install_plugins.sh
## Overwrite the default comments.templates file from bash-support:
cp vim/shell-template/comments.templates ~/.vim/bundle/bash-support.vim/bash-support/templates/comments.templates

# Install black formatter with pip:
pip3 install black
# Install glances:
pip3 install glances
# Install spellchecking:
pip3 install pygtkspellcheck pyenchant
# Install mypy:
pip3 install mypy

echo "Installation of dotfiles complete!"
