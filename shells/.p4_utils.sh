#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .p4_utils.sh
#
#         USAGE: ./.p4_utils.sh
#
#   DESCRIPTION: Add Perforce (aka p4) utility functions to the shell.
#
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

# Set the p4 client name
export P4CLIENT='eindiran'
export P4USER='eindiran'

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
    fd -t file "$@" | xargs "p4" edit
}

p4a() {
    # Same as `p4e`, but for adding files
    fd -t file "$@" | xargs "p4" add
}

p4r() {
    # Same as `p4e`, but for reverting files
    fd -t file "$@" | xargs "p4" revert
}

p4d() {
    # Same as `p4e`, but for diffing files
    fd -t file "$@" | xargs "p4" diff
}

p4() {
    # Wrapper for the p4 command
    # Allows us to define p4 blame
    case "$*" in
        blame\ *)
            shift 1
            command p4 annotate "$@"
            ;;
        shelves|shelves\ *)
            shift 1
            command p4 changes -u "$P4USER" -s shelved "$@"
            ;;
        commits\ all\ *)
            shift 1
            command p4 changes -s submitted "$@"
            ;;
        commits|commits\ *)
            shift 1
            command p4 changes -u "$P4USER" -s submitted "$@"
            ;;
        submits|submits\ *)
            shift 1
            command p4 changes -u "$P4USER" -s submitted "$@"
            ;;
        pending|pending\ *)
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
