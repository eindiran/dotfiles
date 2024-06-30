#!/usr/bin/env zsh
#===============================================================================
#
#          FILE: .other_shell_utils.sh
#
#   DESCRIPTION: Old and unused shell utility functions, originally from
#                .shell_utils.sh but moved here on deprecation.
#
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

cl() {
    # Clear, then list the current directory
    clear
    ll "$@"
}

ct() {
    # Clear, the tree the current directory
    clear
    tree "$@"
}

j() {
    # Run Java classes: alias for `java ...`
    java "$@"
}

fpdfgrep() {
    # Search pdf files in current directory using pdfgrep
    find . -iname '*.pdf' -exec pdfgrep "$@" {} +
}

zhg() {
    history 0 | cut -c 8- | rg "$@" | sort | uniq -c | sort --numeric --reverse | rg "$@"
}

history_commands() {
    # Commands only history
    history 0 | rg --color=never -o "^\s*[0-9]+\*?\s+[0-9]{4}-[0-9]{2}-[0-9]{2}\s+[0-9]{2}:[0-9]{2}\s+(.*)$" -r '$1'
}

lcc() {
    # Alias for Mono license compiler so that `lc` can be used for the `wc` alias below
    command lc "$@"
}

lc() {
    # Line count; alias for `wc -l`
    wc -l "$@"
}

histsearch() {
    # Search through the history for a given word
    # fc -lim "$@" 1 # not as good
    history 0 | command grep --color=auto "$1"
}

nhistory() {
    # Get the last n history entries
    if [ $# -eq 0 ]; then
        # If no arg passed, return last 100 entries
        history 0 | tail -n 100
    else
        history 0 | tail -n "$1"
    fi
}

broken_links() {
    # Find broken symbolic links in the current directory
    find . -type l -xtype l -exec /bin/ls -l {} \;
}

dow() {
    # Prints the day of the week
    Days=("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
    printf "%s\n" "${Days[$(date +%u)]}"
}

wf() {
    # Word frequency
    sed -e 's/[^[:alpha:]]/ /g' "$1" | tr " " '\n' | sort | uniq -c | sort -nr
}

wf_rank() {
    # Word frequency and rank
    wf "$1" | nl
}

pmd() {
    # Compile markdown to html w/ pandoc
    pandoc -f markdown -t html "$1" >"${1%.md}.html"
}

groff2man() {
    # Compile [g]roff/troff into a man-page
    groff -Tascii -man "$@"
}

fdw() {
    # Find writable files in the current directory
    find . -maxdepth 1 -type f -writable
}

fdnw() {
    # Find non-writable files in the current directory
    find . -maxdepth 1 -type f ! -writable
}

fde() {
    # Find executable files in the current directory
    find . -maxdepth 1 -type f -executable
}

fdne() {
    # Find non-executable files in the current directory
    find . -maxdepth 1 -type f ! -executable
}

xmlformat() {
    # Format XML via Python's minidom library
    # Note that this function may not be appropriate for large XML files on machines
    # w/ limited resources, as the minidom library operates on the whole file.
    python3 -c "import xml.dom.minidom, sys; print('\n'.join([line for line in xml.dom.minidom.parse(sys.stdin).toprettyxml(indent=' '*2).split('\n') if line.strip()]), flush=True)"
}
