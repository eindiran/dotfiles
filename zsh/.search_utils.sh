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

if [[ "${OSTYPE}" =~ ^linux ]]; then
    # Linux-specific functionality:
    fullpath() {
        # Print out the absolute path for a file
        readlink -f "$1"
    }
fi

## grep aliases:

igrep() {
    # Add support for 'igrep'
    grep -i "$@"
}

rgrep() {
    # Add support for rgrep
    grep -r "$@"
}

## ripgrep aliases:

rgp() {
    # Page the output of rg through bat
    rg -p "$@" | bat
}

rga() {
    # Don't filter out anything with rg
    # Equivalent to --hidden --no-ignore --binary
    rg -uuu "$@"
}

rgh() {
    # Search in hidden files and gitignored files as well;
    # equivalent to --hidden --no-ignore
    rg -uu "$@"
}

rghi() {
    # Search in hidden files and gitignored files (case-insensitive)
    # equivalent to --hidden --no-ignore -i
    rg -uu -i "$@"
}

rgi() {
    # case-insensitive search
    rg -i "$@"
}

## fd aliases:

fdfp() {
    # Search for matches in the full-path
    fd --full-path --prune "$@"
}

fdx() {
    # When piping results to xargs, use this to null separate results:
    fd --color=never --print0 "$@"
}

fda() {
    # Absolute path is printed, rather than relative path
    fd --absolute-path "$@"
}

fdh() {
    # Search for hidden and gitignored files as well:
    fd --hidden --no-ignore --exclude='.git' "$@"
}

fdi() {
    # Search case insenstively
    fd -i "$@"
}

fdhi() {
    # Search for hidden and gitignored files (case-insensitive)
    fd --hidden --no-ignore --exclude='.git' -i "$@"
}

fdl() {
    # Produce results like `ls -lah`/`ll`, but skipping
    # gitignored files
    fd --hidden --exclude='.git' --list-details --color=always "$@"
}

## Character matchers:

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

## Misc:

fpdfgrep() {
    # Search pdf files in current directory using pdfgrep
    find . -iname '*.pdf' -exec pdfgrep "$@" {} +
}

ski() {
    # Open interactive 'sk' using 'rg' to do the search
    sk --ansi -i -c 'rg --color=always --line-number "{}"'
}

skh() {
    # Like `ski` above, but with support for hidden files,
    # gitignored files, and binary files (like -uuu).
    sk --ansi -i -c 'rg --hidden --no-ignore-vcs --binary --color=always --line-number "{}"'
}

skf() {
    # Like 'ski' above, but using file name matching with fd instead of rg
    sk --ansi -i -c 'fd --hidden --no-ignore --full-path --color=always "{}"'
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
    # Find all hidden files and links
    fd --type f --type l --hidden --no-ignore "^\..*$"
}
