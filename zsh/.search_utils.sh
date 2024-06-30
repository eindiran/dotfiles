#!/usr/bin/env zsh
#===============================================================================
#
#          FILE: .search_utils.sh
#
#   DESCRIPTION: Add search utility functions to the shell.
#
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

if [[ ! "$OSTYPE" == "darwin"* ]]; then
    # Linux
    fullpath() {
        # Print out the absolute path for a file
        readlink -f "$1"
    }
fi

igrep() {
    # Add support for 'igrep'
    grep -i "$@"
}

rgrep() {
    # Add support for rgrep
    grep -r "$@"
}

fpdfgrep() {
    # Search pdf files in current directory using pdfgrep
    find . -iname '*.pdf' -exec pdfgrep "$@" {} +
}

rgp() {
    # Page the output of rg through bat
    rg -p "$@" | bat
}

rga() {
    # Don't filter out anything with rg
    rg -uuu "$@"
}

find_non_utf8_chars() {
    # Find non-UTF-8 characters
    # shellcheck disable=SC2063
    grep -axv '.*' "$@"
}

find_non_ascii_chars() {
    # Find non-ASCII characters
    rg "[^\x00-\x7F]" "$@"
}

find_non_printable_chars() {
    # Find non-printable characters
    rg "[\x00-\x08\x0E-\x1F\x80-\xFF]" "$@"
}

ski() {
    # Open interactive 'sk' using 'rg' to do the search
    sk --ansi -i -c 'rg --color=always --line-number "{}"'
}

show_path() {
    # Print our PATH variable
    echo "$PATH" | tr ":" "\n"
}

swap_files() {
    # Find any open swap files
    fd --hidden --no-ignore "^\..*\.sw[op]$"
}

hidden_files() {
    # Find all hidden files
    fd --type f --type l --hidden --no-ignore "^\..*$"
}
