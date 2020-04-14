#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .git_utils.sh
#
#         USAGE: Source from a shell, then call the functions within.
#
#   DESCRIPTION: Add git utility functions to the shell. The main work is being done
#                by the `git` function which wraps the standard `git` command to
#                add additional functionality.
#
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

githash() {
    if [ $# -gt 0 ]; then
        shift 1
        git rev-parse "$@"
    else
        git rev-parse --short=16 HEAD
    fi
}

find_git_commands() {
    # Find the list of git commands that are used on a regular basis in the shell
    if [ -n "$ZSH_VERSION" ]; then
        # zsh version
        history 0 | cut -c 8- | rg "^git" | awk '{print $1, $2}' | sort | uniq -c | sort --numeric --reverse | rg "git .*$"
    else
        if [ ! -n "$BASH_VERSION" ]; then
            echo "[WARNING] - This command may not work in your shell."
        fi
        # bash version
        history | cut -c 8- | rg "^git" | awk '{print $1, $2}' | sort | uniq -c | sort --numeric --reverse | rg "git .*$"
    fi
}
