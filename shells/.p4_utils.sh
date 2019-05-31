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

# Aliases and utility functions
p4ev() {
    # p4 sync a file, open for edit, then open in vim
    command p4 sync "$@"
    command p4 edit "$@"
    vim "$@"
}

p4a_cd() {
    # Add all files in the current directory
    find . -type f -print | command p4 -x add
}

p4e_cd() {
    # Open all files in the current directory for edit
    find . -type f -print | command p4 -x add
}

p4r_cd() {
    # Revert all files in the current directory
    find . -type f -print | command p4 -x revert
}

p4e() {
    # Find all files matching a pattern and open them for edit
    fd "$@" | xargs command p4 edit
}

p4a() {
    # Same as `p4e`, but for adding files
    fd "$@" | xargs command p4 add
}

p4r() {
    # Same as `p4e`, but for reverting files
    fd "$@" | xargs command p4 revert
}

p4() {
    # Wrapper for the p4 command
    # Allows us to define p4 blame
    case "$*" in
        blame*)
            shift 1
            command p4 annotate "$@"
            ;;
        *)
            command p4 "$@"
            ;;
    esac
}
