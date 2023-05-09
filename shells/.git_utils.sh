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

gwipc() {
    # Create a WIP commit with a standardized message, that allows collapsing
    # into a squashed commit with gwip_squash
    git commit -a -m "wip - fixup"
}

gwip_squash() {
    # Squash all the commits created using gwip.
    # NOTE: this will ignore gwip commits before the latest non-gwip commit.
    # If you create a non-gwip commit, you'll need to amend the message or do
    # the squash manually.
    git rebase -i --autosquash "$(git log --pretty="%H %s" | grep -v "wip - fixup" | head -n 1 | awk '{print $1}')"
}

git_revert() {
    # Implements p4 revert in git
    git checkout HEAD -- "$@"
}

git_edited_files() {
    # Get all the files touched by an author in this branch
    git log --pretty="%H" --author="$1" | while read -r commit_hash; do git show --oneline --name-only "$commit_hash" | tail -n+2; done | sort | uniq
}

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
        if [ -z "$BASH_VERSION" ]; then
            echo "[WARNING] - This command may not work in your shell."
        fi
        # bash version
        history | cut -c 8- | rg "^git" | awk '{print $1, $2}' | sort | uniq -c | sort --numeric --reverse | rg "git .*$"
    fi
}

jnb() {
    # Create a new branch using the format <initials>_YYYYMMDD_<branch_name>
    git checkout -b "ei_$(gdate +%Y%m%d)_$(join_by "_" "$@")"
}
