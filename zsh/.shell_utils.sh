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

echo_separator() {
    echo "==============================================================="
}

refresh() {
    # Refresh after updating rc files
    # shellcheck disable=SC1090
    source ~/.zshrc
}

public_ip() {
    # Display your public IP address; try opendns, then fallback to Google
    local public_ip_addr
    public_ip_addr="$(curl https://myipv4.p1.opendns.com/get_my_ip 2> /dev/null | jq .ip | sed -e 's|"||g' | head -n 1)"
    if [[ -n "${public_ip_addr}" ]]; then
        echo "${public_ip_addr}"
    else
        dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed -e 's|"||g'
    fi
}

ip_info() {
    # Print IP info about specified IP:
    curl "https://ipinfo.io/${1}" 2> /dev/null | python3 -c 'import json; import sys; x=json.loads("".join([l.strip() for l in sys.stdin])); print(x.get("city", "") + ", " + x.get("region", "") + ", " + x.get("country", "") + " " + x.get("postal", "") + "\n" + x.get("loc", "") + "\n" + x.get("org"))'
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

update_vim_plugins() {
    # vim-plug updates and cleanup:
    echo "${HI_YELLOW}Updating vim-plug plugins${ANSI_RESET}"
    # Install, then update, then clean
    "${WORKSPACE}/dotfiles/vim/plugins.sh" -i -u -c
}

sync_git_tools() {
    # Sync the git-tools local repo with remote
    local gittools_version_old
    local gittools_version_new
    (
        set -e
        cd "${WORKSPACE}/git-tools"
        gittools_version_old="$(git rev-parse --short HEAD)"
        echo "${HI_YELLOW}git-tools version: ${HI_RED}${gittools_version_old}${ANSI_RESET}"
        echo "${HI_YELLOW}Syncing git-tools${ANSI_RESET}"
        git pull
        gittools_version_new="$(git rev-parse --short HEAD)"
        if [[ "${gittools_version_new}" != "${gittools_version_old}" ]]; then
            echo "${HI_YELLOW}New git-tools version: ${HI_RED}${gittools_version_new}${ANSI_RESET}"
        fi
    )
}

sync_shell_scripts() {
    # Sync the shell-scripts local repo with remote
    local shellscripts_version_old
    local shellscripts_version_new
    (
        set -e
        cd "${WORKSPACE}/shell-scripts"
        shellscripts_version_old="$(git rev-parse --short HEAD)"
        echo "${HI_YELLOW}shell-scripts version: ${HI_RED}${shellscripts_version_old}${ANSI_RESET}"
        echo "${HI_YELLOW}Syncing shell-scripts${ANSI_RESET}"
        git pull
        shellscripts_version_new="$(git rev-parse --short HEAD)"
        if [[ "${shellscripts_version_new}" != "${shellscripts_version_old}" ]]; then
            echo "${HI_YELLOW}New shell-scripts version: ${HI_RED}${shellscripts_version_new}${ANSI_RESET}"
        fi
    )
}

sync_dotfiles() {
    # Sync the dotfiles local repo with remote
    local dotfiles_version_old
    local dotfiles_version_new
    (
        set -e
        dotfiles
        dotfiles_version_old="$(git rev-parse --short HEAD)"
        echo "${HI_YELLOW}dotfiles version: ${HI_RED}${dotfiles_version_old}${ANSI_RESET}"
        echo "${HI_YELLOW}Syncing dotfiles${ANSI_RESET}"
        git pull
        dotfiles_version_new="$(git rev-parse --short HEAD)"
        if [[ "${dotfiles_version_new}" != "${dotfiles_version_old}" ]]; then
            echo "${HI_YELLOW}New dotfiles version: ${HI_RED}${dotfiles_version_new}${ANSI_RESET}"
        fi
    )

}

update_omz() {
    # Update OMZ
    local omz_version_old
    local omz_version_new
    (
        set -e
        # OMZ updates:
        omz_version_old="$(omz version)"
        echo "${HI_YELLOW}omz version: ${HI_RED}${omz_version_old}${ANSI_RESET}"
        echo "${HI_YELLOW}Running 'omz update'${ANSI_RESET}"
        # Upgrade via upgrade.sh directly:
        if [[ -e "${ZSH}/tools/upgrade.sh" ]]; then
            "${ZSH}/tools/upgrade.sh"
        fi
        omz_version_new="$(omz version)"
        if [[ "${omz_version_new}" != "${omz_version_old}" ]]; then
            echo "${HI_YELLOW}New omz version: ${HI_RED}${omz_version_new}${ANSI_RESET}"
        fi
    )
}

# Define OS specific stuff here:
if [[ "${OSTYPE}" =~ ^darwin ]]; then
    # macOS
    iterm2() {
        /Applications/iTerm.app/Contents/MacOS/iTerm2 2> /dev/null &
    }

    sudoedit() {
        if [[ -n "$EDITOR" ]]; then
            sudo "$EDITOR" "$@"
        else
            sudo vim "$@"
        fi
    }

    local_ip() {
        # Display your local network IP address
        local vpn_status
        vpn_status="$(scutil --nc list | grep "Connected" | wc -l)"
        local ifaces
        ifaces=('en0' 'en1' 'en2' 'en3' 'en4' 'en5' 'en6')
        if (( vpn_status > 0 )) && ifconfig -a | rg -q "inet .* --> .*"; then
            ifconfig -a | rg "inet .* --> .*" | awk ' { print $2 } ' | head -n 1
        else
            for i in ${ifaces}; do
                ipconfig getifaddr $i
            done | head -n 1
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
        # Check VPN status
        # Known limitation: scutil --nc list fails to show
        # Cisco IPSec type VPNs.
        local scutil_nc_output
        scutil_nc_output="$(scutil --nc list)"
        # Sort into connected and disconnected
        local scutil_conn
        scutil_conn="$(echo "${scutil_nc_output}" | grep "Connected" | cut -d' ' -f8- | awk '{ print $4,$3 }')"
        local scutil_disconn
        scutil_disconn="$(echo "${scutil_nc_output}" | grep "Disconnected" | awk '{ print "    * " $6,$5 }')"
        # Compute counts
        local scutil_conn_cnt
        scutil_conn_cnt="$(echo "${scutil_nc_output}" | grep "Connected" | wc -l)"
        local scutil_disconn_cnt
        scutil_disconn_cnt="$(echo "${scutil_nc_output}" | grep "Disconnected" | wc -l)"
        if (( scutil_conn_cnt < 1 )) && (( scutil_disconn_cnt < 1 )); then
            echo "${BHI_RED}DISCONNECTED: no VPNs found!${ANSI_RESET}"
        elif (( scutil_conn_cnt >= 1 )); then
            echo "Currently ${BHI_GREEN}CONNECTED${ANSI_RESET} to VPN"
            echo "${BHI_GREEN}${scutil_conn}${ANSI_RESET}"
        else
            # Disconnected VPN only:
            echo "Currently ${BHI_RED}DISCONNECTED${ANSI_RESET} from VPN"
            echo "Available VPNs:"
            echo "${BHI_YELLOW}${scutil_disconn}${ANSI_RESET}"
        fi
        local internet_conn
        internet_conn="$(ifconfig | rg -A 20 "^en" | rg -v "^[^e\t]" | awk '/status:/{print toupper($2)}' | sort | head -n 1)"
        if [[ "${internet_conn}" == "ACTIVE" ]]; then
            echo "Internet connection is ${BHI_GREEN}${internet_conn}${ANSI_RESET}"
            # Local/private IP first:
            local private_ip_addr
            private_ip_addr="$(local_ip)"
            echo "Local IP: ${BHI_BLUE}$(local_ip)${ANSI_RESET}"
            # Then public IP:
            local public_ip_addr
            public_ip_addr="$(public_ip)"
            if [[ -n "${public_ip_addr}" ]]; then
                echo "Public IP: ${BHI_BLUE}${public_ip_addr}${ANSI_RESET}"
                echo "Public IP info: ${BLUE}"
                ip_info "${public_ip_addr}"
                printf "${ANSI_RESET}"
            else
                # Empty
                echo "${BHI_RED}Failed to connect to internet, no public IP${ANSI_RESET}"
            fi
        else
            echo "Internet connection is ${BHI_RED}${internet_conn}${ANSI_RESET}"
        fi
    }

    update_homebrew() {
        # Update homebrew and installed packages
        local homebrew_version_old
        local homebrew_version_new
        (
            set -e
            # Homebrew update:
            homebrew_version_old="$(brew --version)"
            echo "${HI_YELLOW}Homebrew version: ${HI_RED}${homebrew_version_old}${ANSI_RESET}"
            echo "${HI_YELLOW}Running brew update${ANSI_RESET}"
            brew update --verbose
            homebrew_version_new="$(brew --version)"
            if [[ "${homebrew_version_new}" != "${homebrew_version_old}" ]]; then
                echo "${HI_YELLOW}New Homebrew version: ${HI_RED}${homebrew_version_new}${ANSI_RESET}"
            fi
            echo_separator
            # Homebrew package upgrades:
            echo "${HI_YELLOW}Running brew upgrade${ANSI_RESET}"
            brew upgrade --verbose
            echo_separator
            # Homebrew cleanup:
            echo "${HI_YELLOW}Running brew cleanup${ANSI_RESET}"
            brew cleanup --verbose
        )
    }
elif [[ "${OSTYPE}" =~ ^linux ]]; then
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
            make -Bnd "$@" | /usr/local/bin/make2graph | dot -Tpng -o Makefile_Dependencies.png
        else
            make -Bnd | /usr/local/bin/make2graph | dot -Tpng -o Makefile_Dependencies.png
        fi
    }
fi

lm() {
    # ls -l to pager
    if [ $# -gt 0 ]; then
        lh "$@" | bat
    else
        lh | bat
    fi
}

treep() {
    # tree with pager
    if [ $# -gt 0 ]; then
        tree -C "$@" | bat
    else
        tree -C | bat
    fi
}

treeh() {
    # Show hidden files with tree, ignore .git
    if [ $# -gt 0 ]; then
        tree -a -I .git "$@"
    else
        tree -a -I .git
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

we() {
    # Alias for weather script
    weather.sh -i -v n $@
}

weather() {
    local current_weather
    local weather_report
    local time_report
    local raw_richtext_report
    local location_report
    # Check that there was a location passed to this script:
    if [[ $# -eq 0 ]]; then
        echo "weather() requires a location to be specified"
        return 1
    fi
    # Alias for weather script, with rich data
    raw_richtext_report="$(weather.sh -i -r $@)"
    current_weather="$(weather.sh -i -v 0 $@)"
    weather_report="$(echo "${raw_richtext_report}" | head -n -5)"
    time_report="$(echo "${raw_richtext_report}" | tail -n 4 | head -n 3)"
    location_report="$(echo "${raw_richtext_report}" | tail -n 1 | head -n 1)"
    echo
    echo "${location_report}"
    echo
    echo "${weather_report}"
    echo "${current_weather}"
    echo
    echo "${time_report}"
}

cwe() {
    # Current weather
    weather.sh -i -v 0 $@ 2> /dev/null | tail -n +2
}

status() {
    echo_separator
    weather "New Haven"; echo; echo_separator; echo
    chkvpn; echo; echo_separator; echo
    fastfetch; echo; echo_separator
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        local repo_name
        repo_name="$(basename "$(git rev-parse --show-toplevel)")"
        local branch_name
        branch_name="$(git rev-parse --abbrev-ref HEAD)"
        echo "\nGit repository: ${BHI_PURPLE}${repo_name}${ANSI_RESET}"
        echo "\nCurrent branch: ${BHI_PURPLE}${branch_name}${ANSI_RESET}\n"
        git -c color.status=always status | tail -n +2; echo; echo_separator
    fi
}
if [[ "${OSTYPE}" =~ ^darwin ]]; then
    monday() {
        # Update all tooling repos and packages:
        (
            # Use a subshell with set -e
            set -e
            update_omz; echo_separator
            update_homebrew; echo_separator
            sync_dotfiles; echo_separator
            sync_git_tools; echo_separator
            sync_shell_scripts; echo_separator
            update_vim_plugins; echo_separator
            dotfiles
            cd installers
            ./symlink_dotfiles.sh; echo_separator
            # Final status:
            echo "${BHI_GREEN}Updates complete!${ANSI_RESET}"
            status
        ) && refresh || echo "${BHI_RED}monday() failed to complete!${ANSI_RESET}"
    }
fi
