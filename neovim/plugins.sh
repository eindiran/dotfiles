#!/usr/bin/env zsh
#===============================================================================
#
#          FILE: plugins.sh
#
#         USAGE: ./plugins.sh [-h] [-v <vimrc>]
#
#   DESCRIPTION:
#
#       OPTIONS:
#                  -h: Print the usage and exit
#                  -v: Optionally specify a .vimrc, init.vim, or init.lua path
#  REQUIREMENTS: neovim, lazy.nvim
#      REVISION: 2.0.0
#
#===============================================================================

set -Eeuo pipefail

usage() {
    # Print the usage and exit
    echo "plugins.sh"
    echo "Usage: plugins.sh [-h] [-v <vimrc>]"
    echo "    -h: print the usage and exit"
    echo "    -v: optionally specify a vimrc, init.vim, or init.lua file path"
    echo
    exit "$1"
}

lazy_plugins() {
    if [[ "$#" -eq 1 ]]; then
        nvim --headless '+Lazy! sync' +qa -u "$1"
    else
        nvim --headless '+Lazy! sync' +qa
    fi
}

USE_VIMRC_PATH=false
VIMRC_PATH="$HOME/.config/nvim/init.lua"

while getopts "hv:" option; do
    case "${option}" in
        h)
            usage 0
            ;;
        v)
            USE_VIMRC_PATH=true
            VIMRC_PATH="${OPTARG}"
            ;;
        *)
            printf "Unknown option %s\n" "${option}"
            usage 1
            ;;
    esac
done
shift $((OPTIND - 1))

echo "${HI_GREEN}Installing lazy.nvim plugins with vimrc: ${HI_YELLOW}${VIMRC_PATH}${ANSI_RESET}"
if [[ "${USE_VIMRC_PATH}" = true ]]; then
    lazy_plugins "${VIMRC_PATH}"
else
    lazy_plugins
fi
echo "${HI_GREEN}lazy.nvim setup complete!${ANSI_RESET}"
