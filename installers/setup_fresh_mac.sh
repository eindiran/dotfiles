#!/usr/bin/env zsh
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

brew install age ansifilter cairo cmake coreutils expect fastfetch \
    ffmpeg fzf gdk-pixbuf gh ghostscript git git-delta git-lfs \
    gnu-sed gnupg go gobject-introspection htop imagemagick java \
    jq librsvg llvm lsd mactex nodejs pandoc perl pkg-config \
    poppler python python-setuptools rename shellcheck shfmt \
    thefuck tmux tree universal-ctags vale watch wget youtube-dl \
    zoxide freetype lzo sshpass bzip2 wireshark sqlite zig
echo "Installing neovim..."
brew unlink utf8proc && brew install --HEAD utf8proc
brew install neovim
# Install the python3 neovim package to enable Python support:
pip install --break-system-packages neovim
echo "Installing brew casks..."
brew install --cask nikitabobko/tap/aerospace
brew install --cask freecad
brew install --cask imhex
brew install --cask wireshark-chmodbpf
# Install Nerd fonts
echo "Installing brew fonts..."
brew install font-hack-nerd-font
sudo ln -sfn "$(brew --prefix java)/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk

# Install rustup and cargo:
echo "Installing rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
if [ -f "${HOME}/.cargo/env" ]; then
    # shellcheck source=/dev/null
    source "${HOME}/.cargo/env"
fi
# Use rustup to add/update rustfmt and clippy:
rustup component add rustfmt
rustup component add clippy
rustup update

# Install cargo packages and binaries:
echo "Installing cargo packages..."
cargo install action-validator bat broot du-dust fd-find hexyl hx hyperfine \
    numbat-cli procs ripgrep skim hwatch

# Setup git repos:
echo "Setting up Workspace"
mkdir -p "${HOME}/Workspace"
cd "${HOME}/Workspace"
echo "Making scratch directory"
mkdir -p "scratch"
echo "Cloning git repos"
gh auth login
git clone https://github.com/eindiran/dotfiles.git
git clone https://github.com/eindiran/git-tools.git
git clone https://github.com/eindiran/shell-scripts.git
git clone https://github.com/eindiran/notes.git
git clone https://github.com/eindiran/brightness.git

echo "Installing brightness"
cd brightness
make
sudo make install

# Install dotfiles:
cd ../dotfiles
./installers/symlink_dotfiles.sh -a -g -t
echo "Creating zsh cache"
mkdir -p ~/.cache/zsh/
# Run vale sync
echo "Creating vale style cache"
mkdir -p ~/.vale
echo "Syncing vale styles/plugins"
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
git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions"
git clone https://github.com/joshskidmore/zsh-fzf-history-search "${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search"

# Add dragging window support
defaults write -g NSWindowShouldDragOnGesture YES

# Start setting up vim:
echo "Installing Vim plugins"
cd ~/Workspace/dotfiles/vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
./plugins.sh -i

# Install checkmake
echo "Installing checkmake"
go install github.com/mrtazz/checkmake/cmd/checkmake@latest

# Setup pip for Python
echo "Setting up top-level venv"
python3 -m venv ~/.venv
# shellcheck source=/dev/null
source ~/.venv/bin/activate
echo "Installing common pip packages..."
pip install PyGObject art build coverage matplotlib meson mypy ninja \
    numpy opencv pandas pango pillow precommit pycairo qrcode ruff scipy \
    setuptools setuptools sphinx torch twine wheel

echo "Setting up ZLS for Zig"
cd ~
mkdir -p .zls
cd .zls
git clone https://github.com/zigtools/zls
cd zls
git checkout 0.13.0
zig build -Doptimize=ReeaseSafe
sudo ln -fns ~/.zls/zls/zig-out/bin/zls /usr/local/bin/zls

echo "Setup completed!"
fastfetch
