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

p4ev() {
    # p4 sync a file, open for edit, then open in vim
    p4 sync "$@"
    p4 edit "$@"
    vim "$@"
}

p4e() {
    # Find all files matching a pattern and open them for edit
    fd "$@" | xargs /usr/local/bin/p4 edit
}

p4a() {
    # Same as `p4e`, but for adding files
    fd "$@" | xargs /usr/local/bin/p4 add
}

p4r() {
    # Same as `p4e`, but for reverting files
    fd "$@" | xargs /usr/local/bin/p4 revert
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
