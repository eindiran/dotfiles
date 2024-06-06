#!/usr/bin/env bash
#===============================================================================
#
#          FILE: install_plugins.sh
#
#         USAGE: ./install_plugins.sh [/path/to/.vimrc]
#
#   DESCRIPTION: Use the PlugInstall command from vim-plug to install all
#                vim-plug plugins listed in the current .vimrc
#
#       OPTIONS: May optionally specify the .vimrc file to use.
#  REQUIREMENTS: vim
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

set -Eeuo pipefail

if [ "$#" -eq 0 ]; then
    # When no args are passed, use the user's standard .vimrc, usually $HOME/.vimrc
    vim +PlugInstall
elif [ "$#" -eq 1 ]; then
    # If a path is specified, ues that .vimrc file instead
    vim +PlugInstall -u "$1"
else
    # If more than 1 arg is passed, print out the usage:
    printf "Incorrect number of arguments passed!\nUsage:\t"
    printf "./install_plugins.sh [/path/to/.vimrc]\n"
    exit 1
fi
