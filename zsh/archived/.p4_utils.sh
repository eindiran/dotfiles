#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .p4_utils.sh
#
#   DESCRIPTION: Add Perforce (aka p4) utility functions to the shell.
#
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

# Set the p4 client name
export P4CLIENT='eindiran'
export P4USER='eindiran'

find_p4_commands() {
    # Find the list of p4 commands that are used on a regular basis in the shell
    if [ -n "$ZSH_VERSION" ]; then
        # zsh version
        history 0 | cut -c 8- | rg --only-matching "^(p4 .*|p4[a-z]+)" | awk '{print $1, $2}' | sort | uniq -c | sort --numeric --reverse | rg "p4.*$"
    else
        if [ -z "$BASH_VERSION" ]; then
            echo "[WARNING] - This command may not work in your shell."
        fi
        # bash version
        history | cut -c 8- | rg --only-matching "^(p4 .*|p4[a-z]+)" | awk '{print $1, $2}' | sort | uniq -c | sort --numeric --reverse | rg "p4.*$"
    fi
}

p4_default_diff() {
    # `p4 diff` everything in the default changelist
    # Note that the shellcheck error doesn't apply, as we will use the default `p4` binary,
    # instead of the aliasing function below.
    # shellcheck disable=SC2033
    p4 opened ... | rg "default" | awk -F'#' '{print $1}' | xargs p4 diff | colordiff
}

# Aliases and utility functions
p4ev() {
    # p4 sync a file, open for edit, then open in vim
    command p4 sync "$@"
    command p4 edit "$@"
    vim "$@"
}

p4rs() {
    # Revert then sync a file
    p4 revert "$@"
    p4 sync "$@"
}

p4of() {
    # Return the paths of open files
    p4 opened "$@" | awk '{ sub(/\//, "$P4HOME"); sub("#[0-9]+", ""); print $1 }'
}

p4e() {
    # Find all files matching a pattern and open them for edit
    # shellcheck disable=SC2033
    fd -t file "$@" | xargs "p4" edit
}

p4a() {
    # Same as `p4e`, but for adding files
    # shellcheck disable=SC2033
    fd -t file "$@" | xargs "p4" add
}

p4r() {
    # Same as `p4e`, but for reverting files
    # shellcheck disable=SC2033
    fd -t file "$@" | xargs "p4" revert
}

p4d() {
    # Same as `p4e`, but for diffing files
    # shellcheck disable=SC2033
    fd -t file "$@" | xargs "p4" diff | colordiff
}

# shellcheck disable=SC2033
p4() {
    # Wrapper for the p4 command
    # Allows us to define p4 blame, log, etc
    case "$*" in
        blame\ *)
            # Alias annotate to git's "blame"
            shift 1
            command p4 annotate "$@"
            ;;
        shelves | shelves\ *)
            shift 1
            command p4 changes -u "$P4USER" -s shelved "$@"
            ;;
        commits\ all\ *)
            shift 1
            command p4 changes -s submitted "$@"
            ;;
        commits | commits\ *)
            shift 1
            command p4 changes -u "$P4USER" -s submitted "$@"
            ;;
        diff\ *)
            shift 1
            command p4 diff "$@" | colordiff
            ;;
        log\ *)
            # Alias filelog to git's "log"
            shift 1
            command p4 filelog "$@"
            ;;
        submits | submits\ *)
            shift 1
            command p4 changes -u "$P4USER" -s submitted "$@"
            ;;
        pending | pending\ *)
            shift 1
            command p4 changes -u "$P4USER" -s pending "$@"
            ;;
        us\ *)
            shift 1
            command p4 unshelve -s "$@"
            ;;
        revertf\ *)
            shift 1
            command p4 revert "$@"
            command p4 sync -f "$@"
            ;;
        *)
            command p4 "$@"
            ;;
    esac
}
