#!/usr/bin/env bash
#===============================================================================
#
#          FILE: install_dotfiles_macos.sh
#
#         USAGE: ./install_dotfiles_macos.sh [-h]
#
#   DESCRIPTION:
#
#       OPTIONS:
#                  -h: Print the usage and exit
#  REQUIREMENTS: brew
#         NOTES: ---
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

set -Eeuo pipefail

usage() {
    # Print the usage and exit
    echo "install_dotfiles_macos.sh"
    echo "Usage: install_dotfiles_macos.sh [-h]"
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
shift $((OPTIND-1))

# Make sure we have realpath installed
echo "Installing realpath via coreutils in brew"
brew install coreutils

dotfiles_dir="$(dirname "$(realpath "${0}")")"
current_user="$(whoami)"

echo "Using dotfile path: ${dotfiles_dir}"
echo "Using home path: ${HOME}"
echo "Using user: ${current_user}"

echo "Installing shell dotfiles:"
for f in "${dotfiles_dir}"/shells/.*rc ; do
    tf="$(realpath "${f}")"
    ff=$(basename "${f}")
    ln -ns "${tf}" "${HOME}/${ff}"
done

echo "Installing shell functions and extensions:"
for f in "${dotfiles_dir}"/shells/.*sh ; do
    tf="$(realpath "${f}")"
    ff=$(basename "${f}")
    ln -ns "${tf}" "${HOME}/${ff}"
done
if [ -d "${dotfiles_dir}/shells/hidden/" ]; then
    for f in "${dotfiles_dir}"/shells/hidden/.*sh ; do
        tf="$(realpath "${f}")"
        ff=$(basename "${f}")
        ln -ns "${tf}" "${HOME}/${ff}"
    done
fi

echo "Installing FZF dotfiles:"
ln -ns "${dotfiles_dir}/fzf" "${HOME}/.fzf"

echo "Installing .vimrc:"
ln -ns "${dotfiles_dir}/vim/.vimrc" "${HOME}/.vimrc"

echo "Installing .tmux.conf:"
ln -ns "${dotfiles_dir}/tmux/.tmux" "${HOME}/.tmux"
ln -ns "${dotfiles_dir}/tmux/.tmux.conf" "${HOME}/.tmux.conf"

echo "Installing Git configs:"
for f in "${dotfiles_dir}"/git/.git* ; do
    tf="$(realpath "${f}")"
    ff=$(basename "${f}")
    ln -ns "${tf}" "${HOME}/${ff}"
done

echo "Installing miscellaneous configs:"
ln -ns "${dotfiles_dir}/misc/.fdignore" "${HOME}/.fdignore"
ln -ns "${dotfiles_dir}/misc/.rgignore" "${HOME}/.rgignore"
ln -ns "${dotfiles_dir}/python/.pylintrc" "${HOME}/.pylintrc"
ln -ns "${dotfiles_dir}/python/.ruff.toml" "${HOME}/.ruff.toml"
