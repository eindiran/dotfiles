#!/usr/bin/env zsh
#===============================================================================
#
#          FILE: symlink_dotfiles.sh
#
#         USAGE: ./symlink_dotfiles.sh [-h] [-g] [-t] [-a]
#
#      EXAMPLES:
#                  symlink_dotfiles.sh -h  -> Print the usage and exit.
#                  symlink_dotfiles.sh -> Run the script, installing
#                      dotfiles into symlinks in $HOME.
#                  symlink_dotfiles.sh -g -t -a -> Run the script with
#                      config symlinking for git, htop, and aerospace enabled
#                      (disabled by default).
#
#   DESCRIPTION: Script to add symlinks from $HOME to the dotfiles files in
#       the dotfiles/ directory. Will skip links that already exist.
#
#       OPTIONS:
#                  -h: Print the usage and exit
#                  -g: Symlink git config files
#                  -a: Symlink Aerospace config file
#                  -t: Force symlink htop config file
#  REQUIREMENTS: ---
#         NOTES: ---
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#      REVISION: 1.0.1
#
#===============================================================================

set -Eeuo pipefail

ANSI_RESET="${ANSI_RESET:-\e[0m}"
BHI_GREEN="${BHI_GREEN:-\e[1;92m}"
BHI_RED="${BHI_RED:-\e[1;91m}"
BHI_YELLOW="${BHI_YELLOW:-\e[1;93m}"
GREEN="${GREEN:-\e[0;32m}"
HI_YELLOW="${HI_YELLOW:-\e[0;93m}"

usage() {
    # Print the usage and exit
    cat <<EOF
       FILE: symlink_dotfiles.sh

      USAGE: ./symlink_dotfiles.sh [-h] [-g] [-t] [-a]

DESCRIPTION: Script to add symlinks from \$HOME to the dotfiles files in
    the dotfiles/ directory. Will skip links that already exist.

    OPTIONS:
               -h: Print the usage and exit
               -g: Symlink git config files
               -a: Symlink Aerospace config file
               -t: Force symlink htop config file

   EXAMPLES:
               symlink_dotfiles.sh -h  -> Print the usage and exit.
               symlink_dotfiles.sh -> Run the script, installing
                   dotfiles into symlinks in \$HOME.
               symlink_dotfiles.sh -g -t -a -> Run the script with
                   config symlinking for git, htop, and aerospace enabled
                   (disabled by default).
EOF
    exit "$1"
}

chklink() {
    # Check for a symlink, creating it if required
    local _source
    local _target
    _source="${1}"
    _target="${2}"
    if [[ -L "${_target}" ]]; then
        echo -e "${BHI_YELLOW}Skipping existing link: ${GREEN}${_target}${ANSI_RESET}"
    elif [[ -f "${_target}" ]]; then
        # File exists as a file
        echo -e "${BHI_RED}WARNING: ${HI_YELLOW}path exists as file ${_target}${ANSI_RESET}"
        echo -e "${BHI_RED}Skipping ${_target}${ANSI_RESET}"
    else
        # No file or link:
        echo -e "Installing ${_source} to ${GREEN}${_target}${ANSI_RESET}"
        ln -ns "${_source}" "${_target}"
        echo -e "${GREEN}Symlink installed from ${BHI_GREEN}${_target}${GREEN} to ${BHI_GREEN}${_source}${ANSI_RESET}"
    fi
}

# Track the optional configs to install:
install_git_configs=false
install_aerospace_configs=false
install_htop_configs=false


# Parse args to decide which configs to install
while getopts "hgat" option; do
    case "${option}" in
        h)
            usage 0
            ;;
        g)
            install_git_configs=true
            ;;
        a)
            install_aerospace_configs=true
            ;;
        t)
            install_htop_configs=true
            ;;
        *)
            printf "Unknown option %s\n" "${option}"
            usage 1
            ;;
    esac
done
shift $((OPTIND-1))

if [[ $# -gt 0 ]]; then
    printf "Unknown positional argument(s) %s\n" $@
    echo "symlink_dotfiles.sh does not take any positional arguments."
    usage 1
fi

script_dir="$(dirname "$(realpath "${0}")")"
cd "${script_dir}/../"
dotfiles_dir="$(pwd)"
current_user="$(whoami)"

echo "Using dotfile path: ${dotfiles_dir}"
echo "Using home path: ${HOME}"
echo "Using user: ${current_user}"

echo "Installing shell dotfiles, functions, and extensions"
for f in $(fd \^\. --absolute-path --hidden zsh); do
    tf="$(realpath "${f}")"
    ff=$(basename "${f}")
    chklink "${tf}" "${HOME}/${ff}"
done

echo "Installing hidden shell dotfiles, functions, and extensions"
if [[ -d "zsh/hidden" ]]; then
    for f in $(fd \^\. --absolute-path --hidden zsh/hidden); do
        tf="$(realpath "${f}")"
        ff=$(basename "${f}")
        chklink "${tf}" "${HOME}/${ff}"
    done
else
    echo "No hidden dotfiles found, skipping"
fi

echo "Installing FZF dotfiles"
chklink "${dotfiles_dir}/fzf" "${HOME}/.fzf"

if [[ -d "neovim/" ]]; then
    echo "Installing neovim init.vim"
    mkdir -p "${HOME}/.config/nvim"
    chklink "${dotfiles_dir}/neovim/init.vim" "${HOME}/.config/nvim/init.vim"
else
    echo "Installing .vimrc"
    chklink "${dotfiles_dir}/vim/.vimrc" "${HOME}/.vimrc"
fi

echo "Installing .tmux.conf"
chklink "${dotfiles_dir}/tmux/.tmux" "${HOME}/.tmux"
chklink "${dotfiles_dir}/tmux/.tmux.conf" "${HOME}/.tmux.conf"

echo "Installing miscellaneous configs"
chklink "${dotfiles_dir}/misc/.fdignore" "${HOME}/.fdignore"
chklink "${dotfiles_dir}/misc/.rgignore" "${HOME}/.rgignore"
chklink "${dotfiles_dir}/misc/.editorconfig" "${HOME}/.editorconfig"
chklink "${dotfiles_dir}/misc/.vale.ini" "${HOME}/.vale.ini"
chklink "${dotfiles_dir}/python/.ruff.toml" "${HOME}/.ruff.toml"
mkdir -p "${HOME}/.config/fastfetch"
chklink "${dotfiles_dir}/misc/fastfetch/config.jsonc" "${HOME}/.config/fastfetch/config.jsonc"

if [[ "${install_htop_configs}" == true ]]; then
    echo "Installing htop config"
    mkdir -p "${HOME}/.config/htop"
    # Always force overwrite this:
    ln -fns "${dotfiles_dir}/misc/htoprc" "${HOME}/.config/htop/htoprc"
    echo "${BHI_YELLOW} Force symlinking ${BHI_GREEN}${dotfiles_dir}/misc/htoprc${ANSI_RESET}"
fi

if [[ "${install_git_configs}" == true ]]; then
    echo "Installing Git configs"
    for f in "${dotfiles_dir}"/git/.git*; do
        tf="$(realpath "${f}")"
        ff=$(basename "${f}")
        chklink "${tf}" "${HOME}/${ff}"
    done
fi

if [[ "${install_aerospace_configs}" == true ]]; then
    echo "Installing Aerospace config"
    chklink "${dotfiles_dir}/misc/.aerospace.toml" "${HOME}/.aerospace.toml"
fi
