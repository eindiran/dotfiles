#!/usr/bin/env bash
#===============================================================================
#
#          FILE: install_dotfiles.sh
#
#         USAGE: ./install_dotfiles.sh
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
# command -v cabal >/dev/null 2>&1 || { sudo apt-get install -y haskell-platform; sudo cabal update; sudo cabal install cabal-install --global; }


# Install fzf
command -v fzf >/dev/null 2>&1 || { git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install; }

# Install packages via cargo
command -v rg >/dev/null 2>&1 || cargo install ripgrep
command -v fd >/dev/null 2>&1 || cargo install fd-find
command -v sk >/dev/null 2>&1 || cargo install skim
command -v hx >/dev/null 2>&1 || cargo install hx
command -v broot >/dev/null 2>&1 || cargo install broot

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
# sudo apt-get install -y postgresql-*
sudo apt-get install -y mongodb
sudo apt-get install -y ranger

echo "Cleaning Up via apt-get autoremove..." &&
    sudo apt-get -f install &&
    sudo apt-get -y autoremove &&
    sudo apt-get -y autoclean &&
    sudo apt-get -y clean

cd shells && ./install_zshrc.sh -w && cd ..

# Copy over fzf dotfiles
mkdir -p ~/.fzf/shell
cp fzf/.fzf.*sh ~/
cp fzf/completion.* ~/.fzf/shell
cp fzf/key-bindings.* ~/.fzf/shell

# Copy over .htoprc
mkdir -p ~/.config/htop
cp htop/htoprc ~/.config/htop/htoprc

# Copy over irssi dotfiles
mkdir -p ~/.irssi
cp irssi/.irssi/config ~/.irssi/config

# Copy over .muttrc
mkdir -p ~/.mutt
cp mutt/.mutt/* ~/.mutt/
cp mutt/.muttrc ~/.mutt/muttrc

# Copy over .vimrc
cp vim/.vimrc ~/.vimrc

# Copy over tmux dotfiles
mkdir -p ~/.tmux/scripts
cp tmux/.tmux.conf ~/.tmux.conf
cp tmux/scripts/* ~/.tmux/scripts

# Copy over .xbindkeysrc
cp xbindkeys/.xbindkeysrc ~/.xbindkeysrc

# Copy over ALSA config
cp alsa/.asoundrc ~/.asoundrc

# Copy over cabal config
cd cabal/ && cp -a .cabal ~/ && cd ..

# Copy over .ignore files
cp ignore/.rgignore ~/.rgignore
cp ignore/.fdignore ~/.fdignore
cp ignore/.gitignore ~/.gitignore

# Copy over global .gitconfig
cp git/.gitconfig ~/.gitconfig

echo "Installation of dotfiles complete!"
