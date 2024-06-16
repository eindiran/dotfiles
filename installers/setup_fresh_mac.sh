#!/usr/bin/env bash
#===============================================================================
#
#          FILE: setup_fresh_mac.sh
#
#         USAGE: ./setup_fresh_mac.sh [-h]
#
#   DESCRIPTION: Setup a new macOS machine from scratch to fairly configured.
#
#       OPTIONS:
#                  -h: Print the usage and exit
#  REQUIREMENTS: ---
#         NOTES: ---
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

set -Eeuo pipefail

usage() {
    # Print the usage and exit
    echo "setup_fresh_mac.sh"
    echo "Usage: setup_fresh_mac.sh [-h]"
    echo "    -h: print the usage and exit"
    echo
    exit "$1"
}

while getopts "h" option; do
    case "${option}" in
        h)
            usage 0
            ;;
        *)
            printf "Unknown option %s\n" "${option}"
            usage 1
            ;;
    esac
done
shift $((OPTIND - 1))

# Install brew:
echo "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install brew packages:
echo "Installing brew formulae..."

brew install ansifilter cairo cmake coreutils expect fastfetch \
    ffmpeg fzf gdk-pixbuf gh ghostscript git git-delta git-lfs \
    gnu-sed gnupg go gobject-introspection htop imagemagick java \
    jq librsvg lsd mactex macvim nodejs pandoc perl pkg-config \
    poppler python python-setuptools rename shellcheck shfmt \
    thefuck tmux tree universal-ctags vale watch wget youtube-dl \
    zoxide
sudo ln -sfn "$(brew --prefix java)/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk

# Install rustup and cargo:
echo "Installing rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
if [ -f "${HOME}/.cargo/env" ]; then
    # shellcheck source=/dev/null
    source "${HOME}/.cargo/env"
fi

# Install cargo packages and binaries:
echo "Installing cargo packages..."
cargo install action-validator bat broot du-dust fd-find hexyl hx hyperfine \
    numbat-cli procs ripgrep skim

# Setup git repos:
echo "Setting up Workspace"
mkdir -p "${HOME}/Workspace"
cd "${HOME}/Workspace"
echo "Cloning git repos"
git clone https://github.com/eindiran/dotfiles.git
git clone https://github.com/eindiran/git-tools.git
gh auth login
git clone https://github.com/eindiran/shell-scripts.git
git clone https://github.com/eindiran/notes.git
cd dotfiles

# Install dotfiles:
./installers/install_dotfiles_macos.sh
mkdir -p ~/.cache/zsh/
# Run vale sync
vale --config ~/.vale.ini sync

# Install omz
echo "Installing ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
omz update

# Install themes and plugins for zsh:
echo "Installing OMZ plugins and themes..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone https://github.com/joshskidmore/zsh-fzf-history-search "${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search"

# Start setting up vim:
echo "Installing Vim plugins"
cd ~/Workspace/dotfiles/vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
./install_plugins.sh
cd ~/.vim/plugged/YouCompleteMe
python3 install.py --all

# Setup pip for Python
echo "Installing pip"
cd ~/Downloads && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
echo "Setting up top-level venv"
python3 -m venv ~/.venv
# shellcheck source=/dev/null
source ~/.venv/bin/activate
echo "Installing common pip packages..."
pip install PyGObject art build coverage matplotlib meson mypy ninja \
    numpy opencv pandas pango pillow precommit pycairo pylint qrcode \
    ruff scipy setuptools setuptools sphinx torch twine wheel
echo "Setup completed!"
fastfetch
