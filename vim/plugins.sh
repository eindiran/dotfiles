#!/usr/bin/env bash
#===============================================================================
#
#          FILE: plugins.sh
#
#         USAGE: ./plugins.sh [-h] [-i | -u] [-c] [-v <vimrc>]
#
#   DESCRIPTION:
#
#       OPTIONS:
#                  -h: Print the usage and exit
#                  -i: Install via PlugInstall
#                  -u: Update via PlugUpdate
#                  -c: Clean via PlugClean
#                  -v: Specify a .vimrc path
#  REQUIREMENTS: Vim, vim-plug
#      REVISION: 1.0.0
#
#===============================================================================

set -Eeuo pipefail

usage() {
    # Print the usage and exit
    echo "plugins.sh"
    echo "Usage: plugins.sh [-h] [-i | -u] [-c] [-v <vimrc>]"
    echo "    -h: print the usage and exit"
    echo "    -i: install plugins w/ PlugInstall"
    echo "    -u: update plugins w/ PlugUpdate"
    echo "    -c: clean up plugin installation w/ PlugClean"
    echo "    -v: specify a vimrc file"
    echo
    exit "$1"
}

install_vimplug_plugins() {
    vim -c ':PlugInstall' -c ':q' -c ':q' -u "$1"
}

update_vimplug_plugins() {
    vim -c ':PlugUpdate' -c ':q' -c ':q' -u "$1"
}

clean_vimplug_plugins() {
    vim -c ':PlugClean' -c ':q' -c ':q' -u "$1"
}

PLUG_INSTALL=false
PLUG_UPDATE=false
PLUG_CLEAN=false
VIMRC_PATH="$HOME/.vimrc"

while getopts "hiucv:" option; do
    case "${option}" in
        h)
            usage 0
            ;;
        i)
            PLUG_INSTALL=true
            ;;
        u)
            PLUG_UPDATE=true
            ;;
        c)
            PLUG_CLEAN=true
            ;;
        v)
            VIMRC_PATH="${OPTARG}"
            ;;
        *)
            printf "Unknown option %s\n" "${option}"
            usage 1
            ;;
    esac
done
shift $((OPTIND - 1))

if [[ "${PLUG_INSTALL}" == true ]]; then
    echo "Installing vim-plug plugins with vimrc: ${VIMRC_PATH}"
    install_vimplug_plugins "${VIMRC_PATH}"
fi
if [[ "${PLUG_UPDATE}" == true ]]; then
    echo "Updating vim-plug plugins with vimrc: ${VIMRC_PATH}"
    update_vimplug_plugins "${VIMRC_PATH}"
fi
if [[ "${PLUG_CLEAN}" == true ]]; then
    echo "Cleaning up vim-plug plugins with vimrc: ${VIMRC_PATH}"
    clean_vimplug_plugins "${VIMRC_PATH}"
fi
echo "vim-plug setup complete!"
