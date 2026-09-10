#!/usr/bin/env zsh
#===============================================================================
#
#          FILE: plugins.sh
#
#         USAGE: ./plugins.sh [-h] [-v <vimrc>]
#
#   DESCRIPTION: Sync lazy.nvim plugins, then install any language server from
#                lua/user/lsp.lua that Mason does not have yet. Needs network.
#
#       OPTIONS:
#                  -h: Print the usage and exit
#                  -v: Optionally specify a .vimrc, init.vim, or init.lua path
#  REQUIREMENTS: neovim, lazy.nvim, mason.nvim
#      REVISION: 2.1.0
#
#===============================================================================

set -Eeuo pipefail

# Colors are exported by .ansi_colors.sh in an interactive shell; default them so
# the script also runs from setup_fresh_mac.sh
ANSI_RESET="${ANSI_RESET:-\e[0m}"
HI_GREEN="${HI_GREEN:-\e[0;92m}"
HI_YELLOW="${HI_YELLOW:-\e[0;93m}"

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

mason_servers() {
    # mason-lspconfig skips ensure_installed when headless, so install explicitly
    local -a extra=()
    if [[ "$#" -eq 1 ]]; then
        extra=(-u "$1")
    fi
    nvim --headless "${extra[@]}" \
        -c 'lua require("user.lsp").mason_install_missing()' -c 'qall!'
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
echo "${HI_GREEN}Installing language servers with Mason${ANSI_RESET}"
if [[ "${USE_VIMRC_PATH}" = true ]]; then
    mason_servers "${VIMRC_PATH}"
else
    mason_servers
fi
echo "${HI_GREEN}Mason setup complete!${ANSI_RESET}"
