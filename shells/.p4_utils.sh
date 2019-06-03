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

p4e() {
    # Find all files matching a pattern and open them for edit
    fd -t file "$@" | xargs p4 edit
}

p4a() {
    # Same as `p4e`, but for adding files
    fd -t file "$@" | xargs p4 add
}

p4r() {
    # Same as `p4e`, but for reverting files
    fd -t file "$@" | xargs p4 revert
}

p4d() {
    # Same as `p4e`, but for diffing files
    fd -t file "$@" | xargs p4 diff
}

p4() {
    # Wrapper for the p4 command
    # Allows us to define p4 blame
    case "$*" in
        blame*)
            shift 1
            command p4 annotate "$@"
            ;;
        shelves*)
            shift 1
            command p4 changes -u "$P4USER" -s shelved "$@"
            ;;
        submits*)
            shift 1
            command p4 changes -u "$P4USER" -s submitted "$@"
            ;;
        pending*)
            shift 1
            command p4 changes -u "$P4USER" -s pending "$@"
            ;;
        *)
            command p4 "$@"
            ;;
    esac
}
