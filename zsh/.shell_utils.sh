#!/usr/bin/env zsh
#===============================================================================
#
#          FILE: .shell_utils.sh
#
#         USAGE: ./.shell_utils.sh
#
#   DESCRIPTION: Add utility functions to the shell. Intended to replace
#                most of the utility functions and aliases in my .zshrc.
#
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

beginswith() {
    # Check that second argument begins with first argument
    case "$2" in
        "$1"*)
            true
            ;;
        *)
            false
            ;;
    esac
}

join_by() {
    # Taken from: https://stackoverflow.com/questions/1527049
    local delim=${1-} elem=${2-}
    if shift 2; then # 1 for join_by, 1 for delimiter
        printf %s "$elem" "${@/#/$delim}"
    fi
}

trim() {
    # Trim whitespace
    sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g'
}

c() {
    # Alias for quickly typing `clear`
    clear
}

e() {
    # Alias for quickly typing `exit`
    exit
}

m() {
    # Alias for quickly typing `make`
    make "$@"
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sudoedit() {
        if [[ -n "$EDITOR" ]]; then
            sudo "$EDITOR" "$@"
        else
            sudo vim "$@"
        fi
    }
fi

lm() {
    # More advanced version of ls -l | more
    if [ $# -gt 0 ]; then
        lh "$1" | bat
    else
        lh | bat
    fi
}

tm() {
    # More advanced version of tree | more
    if [ $# -gt 0 ]; then
        tree "$1" | bat
    else
        tree | bat
    fi
}

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

jc() {
    # Compile Java files
    javac "$@"
}

jj() {
    # Open JAR files: an alias for `java -jar ...`
    java -jar "$@"
}

jjc() {
    (
        # Use a subshell with set -e
        set -e
        # Compile Java files into a JAR file
        mkdir -p ./build
        javac -d ./build ./*.java
        cd ./build
        jar cvf "$@" ./*
    )
}

ssh() {
    # Add flags to ssh calls
    command ssh -X -Y "$@"
}

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

zhg() {
    history 0 | cut -c 8- | rg "$@" | sort | uniq -c | sort --numeric --reverse | rg "$@"
}

history_commands() {
    # Commands only history
    history 0 | rg --color=never -o "^\s*[0-9]+\*?\s+[0-9]{4}-[0-9]{2}-[0-9]{2}\s+[0-9]{2}:[0-9]{2}\s+(.*)$" -r '$1'
}

rgp() {
    # Page the output of rg through less
    rg -p "$@" | less -RFX
}

rga() {
    # Don't filter out anythign with rg
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

fullpath() {
    # Print out the absolute path for a file
    readlink -f "$1"
}

man()  {
    # An alias for 'man' that will search apropos if no manpage is initially found
    local MAN_PAGE
    MAN_PAGE="$(command man "$@" 2>&1)"
    if beginswith "No manual entry for" "$MAN_PAGE"; then
        command man "$@"
        printf "\nSearching for similar pages via apropos...\n\n"
        # Tee apropos to /dev/null to prevent it from using paging
        apropos "$@" | tee /dev/null
    else
        command man "$@"
    fi
}

lcc() {
    # Alias for Mono license compiler so that `lc` can be used for the `wc` alias below
    command lc "$@"
}

lc() {
    # Line count; alias for `wc -l`
    wc -l "$@"
}

countfiles() {
    # Count the non-hidden files in directory
    if [ $# -gt 0 ]; then
        total_count=$(find "$1" -not -path '*/\.*' -print | wc -l)
        calc "$total_count"-1 # reduce by one to get count w/o '.'
    else
        total_count=$(find . -not -path '*/\.*' -print | wc -l)
        calc "$total_count"-1
    fi
}

histnl() {
    # Print out history without line numbers
    history 0 | sed 's/^ *[0-9]\+\*\? *//'
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

makefile_deps() {
    # Create a dot-graph of the dependencies in a Makefile
    local TARGET_NAME
    if [ $# -gt 0 ]; then
        TARGET_NAME="$1"
        make -Bnd "$TARGET_NAME" | /usr/local/bin/make2graph | dot -Tpng -o Makefile_Dependencies.png
    else
        make -Bnd | /usr/local/bin/make2graph | dot -Tpng -o Makefile_Dependencies.png
    fi
}

dow() {
    # Prints the day of the week
    Days=("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
    printf "%s\n" "${Days[$(date +%u)]}"
}

get_disk_usage_percentage() {
    # Print the percentage of used disk space for a specific disk
    df "$1" | tail -n 1 | awk '{sub(/%/,""); print $5}'
}

wf() {
    # Word frequency
    sed -e 's/[^[:alpha:]]/ /g' "$1" | tr " " '\n' | sort | uniq -c | sort -nr
}

wf_rank() {
    # Word frequency and rank
    wf "$1" | nl
}

refresh() {
    # Refresh after updating rc files
    # shellcheck disable=SC1090
    source ~/.zshrc
}

get_path() {
    # Print our PATH variable
    echo "$PATH" | tr ":" "\n"
}

public_ip() {
    # Display your public IP address
    dig +short myip.opendns.com @resolver1.opendns.com
}

local_ip() {
    # Display your local network IP address
    hostname -I | cut -f 1 -d' '
}

devices() {
    # Display info about a particular device
    # Wraps the `lspci` command
    if [ $# -gt 0 ]; then
        case "$*" in
            video | v*)
                # Video card info
                lspci -vnn | command grep --color=auto "VGA" -A 10
                ;;
            audio | sound*)
                # Sound card info
                lspci -vnn | command grep --color=auto "Audio device" -A 7
                ;;
            dram)
                # DRAM controller info
                lspci -vnn | command grep --color=auto "DRAM" -A 5
                ;;
            usb)
                # USB controller info
                lspci -vnn | command grep --color=auto "USB" -A 5
                ;;
            sata | disk | raid)
                # RAID bus controller info
                lspci -vnn | command grep --color=auto "RAID" -A 11
                ;;
            all | --all | -a)
                # All devices
                lspci -vnn
                ;;
            help | --help | -h)
                echo "Usage: devices <arg>"
                echo "where <arg>: [all, help, sata, disk, raid, usb, dram, audio, video]"
                ;;
            *)
                # Unknown args
                printf "Unknown option %s\n" "$*"
                ;;
        esac
    else
        # If no args passed, show all devices
        lspci -vnn
    fi
}

linker_path() {
    # Prints out the path used by ld
    local LNKR_PATH
    LNKR_PATH=$(ldconfig -v 2>/dev/null | command grep --color=auto -v ^$'\t' | cut -d':' -f1)
    if [ -n "$LD_LIBRARY_PATH" ]; then
        LNKR_PATH+=$(awk -F: '{for (i=0;++i<=NF;) print $i}' <<<"$LD_LIBRARY_PATH")
    fi
    echo "$LNKR_PATH" | sort -u
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

dedup() {
    # Deduplicate a file while preserving the original ordering of lines
    awk '!visited[$0] ++' "$@"
}

xmlformat() {
    # Format XML via Python's minidom library
    # Note that this function may not be appropriate for large XML files on machines
    # w/ limited resources, as the minidom library operates on the whole file.
    python3 -c "import xml.dom.minidom, sys; print('\n'.join([line for line in xml.dom.minidom.parse(sys.stdin).toprettyxml(indent=' '*2).split('\n') if line.strip()]), flush=True)"
}

zeropad() {
    # Zero-pad a number in a string
    # Useful for batch renaming files to make lexical
    # sort order the same as numerical sort order
    PADLEN=5
    if [ $# -eq 2 ]; then
        PADLEN="$2"
    fi
    NUM="$(echo "$1" | sed -n -e 's/.*_\([[:digit:]]\+\)\..*/\1/p')"
    PADDED_NUM="$(printf "%0${PADLEN}d" "$NUM")"
    echo "${1/$NUM/$PADDED_NUM}"
}

find_swap_files() {
    # Find any open swap files
    fd -H "^\..*\.sw[op]$"
}

resign_discord() {
    sudo codesign --remove-signature /Applications/Discord.app/Contents/Frameworks/Discord\ Helper* && sudo codesign --sign - /Applications/Discord.app/Contents/Frameworks/Discord\ Helper*
}

dotfiles() {
    # Go to my dotfiles directory, since they are symlinked from home:
    cd "${WORKSPACE}/dotfiles/"
}

meld() {
    /Applications/Meld.app/Contents/MacOS/Meld "$@"
}

sbs() {
    # Toggle side-by-side mode for git-delta
    if [[ "${DELTA_FEATURES:-EMPTY}" != "EMPTY" ]]; then
        unset DELTA_FEATURES
    else
        export DELTA_FEATURES="+side-by-side +line-numbers"
    fi
}

monday() {
    (
        # Use a subshell with set -e
        set -e
        # OMZ updates:
        echo "${HI_YELLOW}omz version: ${HI_RED}$(omz version)${ANSI_RESET}"
        echo "${HI_YELLOW}Running 'omz update'${ANSI_RESET}"
        # Upgrade via upgrade.sh directly:
        if [[ -e "${ZSH}/tools/upgrade.sh" ]]; then
            "${ZSH}/tools/upgrade.sh"
        fi
        echo "${HI_YELLOW}New omz version: ${HI_RED}$(omz version)${ANSI_RESET}"
        echo
        # Homebrew update:
        echo "${HI_YELLOW}Homebrew version: ${HI_RED}$(brew --version)${ANSI_RESET}"
        echo "${HI_YELLOW}Running brew update${ANSI_RESET}"
        brew update --verbose
        echo "${HI_YELLOW}New Homebrew version: ${HI_RED}$(brew --version)${ANSI_RESET}"
        echo
        # Homebrew package upgrades:
        echo "${HI_YELLOW}Running brew upgrade${ANSI_RESET}"
        brew upgrade --verbose
        echo
        # Homebrew cleanup:
        echo "${HI_YELLOW}Running brew cleanup${ANSI_RESET}"
        brew cleanup --verbose
        echo
        # dotfile repo sync:
        (
            cd ~/Workspace/dotfiles/
            echo "${HI_YELLOW}dotfiles version: ${HI_RED}$(git rev-parse --short HEAD)${ANSI_RESET}"
            echo "${HI_YELLOW}Syncing dotfiles${ANSI_RESET}"
            git pull
            echo "${HI_YELLOW}New dotfiles version: ${HI_RED}$(git rev-parse --short HEAD)${ANSI_RESET}"
        )
        echo
        # vim-plug updates and cleanup:
        echo "${HI_YELLOW}Updating vim-plug plugins${ANSI_RESET}"
        # Install, then update, then clean
        "${WORKSPACE}/dotfiles/vim/plugins.sh" -i -u -c
        echo
        # Final status:
        echo "${BHI_GREEN}Updates complete!${ANSI_RESET}"
    ) && refresh || echo "${BHI_RED}monday() failed to complete!${ANSI_RESET}"
}

workspace() {
    # shellcheck disable=SC2164
    cd ~/Workspace
}

s() {
    # shellcheck disable=SC1091
    source .venv/bin/activate
}
