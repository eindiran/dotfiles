#!/usr/bin/env zsh
#===============================================================================
#
#          FILE: .shell_utils.sh
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

refresh() {
    # Refresh after updating rc files
    # shellcheck disable=SC1090
    source ~/.zshrc
}

public_ip() {
    # Display your public IP address
    dig +short myip.opendns.com @resolver1.opendns.com
}

workspace() {
    # shellcheck disable=SC2164
    cd "${WORKSPACE}"
}

dotfiles() {
    # Go to my dotfiles directory, since they are symlinked from home:
    cd "${WORKSPACE}/dotfiles/"
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

# Define OS specific stuff here:
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sudoedit() {
        if [[ -n "$EDITOR" ]]; then
            sudo "$EDITOR" "$@"
        else
            sudo vim "$@"
        fi
    }

    local_ip() {
        # Display your local network IP address
        if ! ipconfig getifaddr en1; then
            ipconfig getifaddr en0
        fi
    }

    meld() {
        # Open the Meld visual diff app from the CLI:
        /Applications/Meld.app/Contents/MacOS/Meld "$@"
    }

    resign_discord() {
        sudo codesign --remove-signature /Applications/Discord.app/Contents/Frameworks/Discord\ Helper* && sudo codesign --sign - /Applications/Discord.app/Contents/Frameworks/Discord\ Helper*
    }

    chkvpn() {
        scutil --nc list | grep "Connected" | cut -d' ' -f8-
        echo "Public IP: $(public_ip)"
        echo "Local IP: $(local_ip)"
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
                dotfiles
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
else
    # Linux
    trim() {
        # Trim whitespace
        sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g'
    }

    local_ip() {
        # Display your local network IP address
        hostname -I | cut -f 1 -d' '
    }

    chkvpn() {
        nmcli con | grep -i vpn
        echo "Public IP: $(public_ip)"
        echo "Local IP: $(local_ip)"
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
fi

lm() {
    if [ $# -gt 0 ]; then
        lh "$1" | bat
    else
        lh | bat
    fi
}

tm() {
    if [ $# -gt 0 ]; then
        tree -C "$1" | bat
    else
        tree -C | bat
    fi
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

mana()  {
    # An alias for 'man' that will search apropos if no manpage is initially found
    local MAN_PAGE
    MAN_PAGE="$(man "$@" 2>&1)"
    if beginswith "No manual entry for" "$MAN_PAGE"; then
        man "$@"
        printf "\nSearching for similar pages via apropos...\n\n"
        # Tee apropos to /dev/null to prevent it from using paging
        apropos "$@" | tee /dev/null
    else
        man "$@"
    fi
}

disk_usage_percentage() {
    # Print the percentage of used disk space for a specific disk
    df "$1" | tail -n 1 | awk '{sub(/%/,""); print $5}'
}

dedup() {
    # Deduplicate a file while preserving the original ordering of lines
    awk '!seen[$0] ++' "$@"
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

sbs() {
    # Toggle side-by-side mode for git-delta
    if [[ "${DELTA_FEATURES:-EMPTY}" != "EMPTY" ]]; then
        unset DELTA_FEATURES
    else
        export DELTA_FEATURES="+side-by-side +line-numbers"
    fi
}

s() {
    # shellcheck disable=SC1091
    source .venv/bin/activate
}
