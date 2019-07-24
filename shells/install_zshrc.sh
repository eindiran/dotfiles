#!/usr/bin/env bash
#===============================================================================
#
#          FILE: install_zshrc.sh
#
#         USAGE: ./install_zshrc.sh
#
#   DESCRIPTION: Install dotfiles used by .zshrc.
#
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

set -Eeuo pipefail

usage() {
    echo "install_zshrc.sh"
    echo "Usage: ./install_zshrc.sh    --> install .zshrc + base utility packages."
    echo "       ./install_zshrc.sh -w --> install .zshrc + base utility packages + work-related packages."
    echo "       ./install_zshrc.sh -h --> print this message and exit."
}

INSTALL_ALL=false

while getopts "hw" option; do
    case "${option}" in
        h)
            usage
            exit 0
            ;;
        w)
            INSTALL_ALL=true
            ;;
        *)  # Unknown option
            usage
            exit 1
            ;;
    esac
done

# Install the base .zshrc file
install -D -m 644 .zshrc \
                  ~/.zshrc

# Install all common/not work-related utility packages
install -D -m 644 .shell_utils.sh \
                  ~/.shell_utils.sh
install -D -m 644 .file_utils.sh \
                  ~/.file_utils.sh
install -D -m 644 .misc_utils.sh \
                  ~/.misc_utils.sh
install -D -m 644 .tmux_window_utils.sh \
                  ~/.tmux_window_utils.sh
install -D -m 644 .git_utils.sh \
                  ~/.git_utils.sh
install -D -m 644 .typo_utils.sh \
                  ~/.typo_utils.sh
install -D -m 644 .volume_utils.sh \
                  ~/.volume_utils.sh
install -D -m 644 .welcome.sh \
                  ~/.welcome.sh

# If INSTALL_ALL is true, proceed to install the work-related utility packages
if test "$INSTALL_ALL"; then
    install -D -m 644 .p4_utils.sh \
                    ~/.p4_utils.sh
    install -D -m 644 .torque_utils.sh \
                    ~/.torque_utils.sh
fi
