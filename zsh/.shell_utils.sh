#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .shell_utils.sh
# 
#         USAGE: ./.shell_utils.sh 
# 
#   DESCRIPTION: Add utility functions to the shell. Replaces a lot of aliases
#                and functions in my .bashrc and .zshrc files.
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
    esac;
}

c() {
    # Alias for quickly typing `clear`
    clear
}

e() {
    # Alias for quickly typing `exit`
    exit
}

t() {
    # Alias for quickly typing `tmux`
    TERM=screen-256color tmux "$@"
}

m() {
    # Alias for quickly typing `make`
    make "$@"
}

ls() {
    # Alias for 'ls'
    command ls --color -AF "$@"
}

ll() {
    # Alias for 'll'
    command ls --color -Flhtr "$@"
}

la() {
    # Alias for 'ls -la'
    command ls --color -Flhtra "$@"
}

lh() {
    # Display all files in 'll' format
    command ls --color -AFlhtr "$@"
}

l() {
    # Alias for ll
    command ls --color -Flhtr "$@"
}

lm() {
    # More advanced version of ls -l | more
    if [ $# -gt 0 ] ; then
        lh "$1" | less
    else
        lh | less
    fi
}

tm() {
    # More advanced version of tree | more
    if [ $# -gt 0 ] ; then
        tree "$1" | less
    else
        tree | less
    fi
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
    # Compile Java files into a JAR file
    mkdir -p ./build
    javac -d ./build *.java
    cd ./build
    jar cvf "$@" *
}

ssh() {
    # Add flags to ssh calls
    command ssh -X -Y "$@"
}

grep() {
    # Alias for 'grep'
    command grep --color=auto "$@"
}

egrep() {
    # Add support for 'egrep'
    command grep --color=auto -E "$@"
}

fgrep() {
    # Add support for 'fgrep'
    command grep --color=auto -F "$@"
}

igrep() {
    # Add support for 'igrep'
    command grep --color=auto -i "$@"
}

rgrep() {
    # Add support for rgrep
    command grep --color=auto -r "$@"
}

rgp() {
    # Page the output of rg through less
    rg -p "$@" | less -RFX
}

dropboxstart() {
    # Start the Dropbox daemon
    start-stop-daemon -b -o -c "$(whoami)" -S -u "$(whoami)" -x "$HOME/.dropbox-dist/dropboxd"
}

dropboxstop() {
    # Stop the Dropbox daemon
    start-stop-daemon -o -c "$(whoami)" -K -u "$(whoami)" -x "$(/bin/ls -1 "$HOME"/.dropbox-dist/dropbox-lnx.*/dropbox)"
}

hass() {
    # Run homeassistant
    sudo -u homeassistant -H /srv/homeassistant/bin/hass
}

countfiles() {
    # Count the non-hidden files in directory
    if [ $# -gt 0 ] ; then
        total_count=$(find "$1" -not -path '*/\.*' -print | wc -l)
        calc "$total_count"-1 # reduce by one to get count w/o '.'
    else
        total_count=$(find . -not -path '*/\.*' -print | wc -l)
        calc "$total_count"-1
    fi
}

histsearch() {
    # Search through the history for a given word
    # fc -lim "$@" 1 # not as good
    history 0 | command grep --color=auto "$1"
}

bhistory() {
    # Replace zsh's history command with one that behaves like
    # bash's history command
    history 0
}

nhistory() {
    # Get the last n history entries
    if [ $# -eq 0 ] ; then
        # If no arg passed, return last 100 entries
        history 0 | tail -n 100
    else
        history 0 | tail -n "$1"
    fi
}

set_title() {
    # Use this function to set the terminal title
    printf "\e]2;%s\a" "$*";
}

which_shell() {
    # Find which shell is running
    which "$(ps -p "$$" | tail -n 1 | awk '{print $NF}')"
}

which_editor() {
    # Find out the default editor
    if [ -z "$EDITOR" ] ; then
        if [ -t 1 ] ; then
            # If output is to a terminal just print info
            echo "No default editor set in \$EDITOR."
        else
            # Otherwise, send along path to executable of valid editor
            >&2 echo "No default editor set in \$EDITOR. Defaulting to vi."
            which vi
        fi
    else
        echo "$EDITOR"
    fi
}

broken_links() {
    # Find broken symbolic links in the current directory
    find . -type l -xtype l -exec /bin/ls -l {} \;
}

makefile_deps() {
    # Create a dot-graph of the dependencies in a Makefile
    if [ $# -gt 0 ] ; then
        TARGET_NAME="$1"
        make -Bnd "$TARGET_NAME" | /usr/local/bin/make2graph | dot -Tpng -o Makefile_Dependencies.png
    else
        make -Bnd | /usr/local/bin/make2graph | dot -Tpng -o Makefile_Dependencies.png
    fi
}

max_win() {
    # Maximize the current window, or if an argument is given
    # search for a window matching that and maximize it
    if [ $# -gt 0 ] ; then
        WINDOW_NAME="$1"
        WINDOW_ID=$(wmctrl -l | rg "$WINDOW_NAME" | awk '{print $1}')
        wmctrl -ir "$WINDOW_ID" -b toggle,maximized_vert,maximized_horz
    else
        wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz
    fi
}

close_win() {
    # Close the specified window
    # Unlike max_win the default is NOT to close the current window
    WINDOW_NAME="$1"
    WINDOW_ID=$(wmctrl -l | rg "$WINDOW_NAME" | awk '{print $1}')
    wmctrl -ic "$WINDOW_ID"
}

set_caps() {
    # Set the behavior of the caps-lock key
    case "$1" in
        'shift')    setxkbmap -option caps:'shift'  ;;
        off)    setxkbmap -option caps:none ;;
        on) setxkbmap -option caps:capslock ;;
        *)  printf "Unrecognized argument. Cannot set caps key to \"%s\"\n" "$1"  ;;
    esac
}

export BEEP_NOISE=/usr/share/sounds/KDE-Im-Contact-In.ogg

play_beep() {
    # Plays a beep noise through headphones
    # Use as you would 'beep'
    play $BEEP_NOISE > /dev/null 2>&1
}

posture() {
    # Reminds you to maintain good posture
    if [ $# -gt 0 ] ; then
        MINUTES="$1"
        ((SECONDS=MINUTES*60))
        while true; do
            {
                sleep "$SECONDS"
                play_beep
                zenity --info --text="Mind your posture"
            } > /dev/null 2>&1
        done
    else
        while true; do
            SECONDS=3600
            {
                sleep "$SECONDS"
                play_beep
                zenity --info --text="Mind your posture"
            } > /dev/null 2>&1
        done
    fi
}

pomodoro() {
    # Start a Pomodoro timer
    if [ $# -gt 0 ] ; then
        ARGUMENT="$1"
        case "$ARGUMENT" in
            long|l|--long|-l)
                echo "Taking a long break."
                sleep 900 # 15 minutes
                play_beep
                zenity --info --text="Break over" > /dev/null 2>&1
                ;;
            'break'|b|--'break'|-b|short|s|--short|-s)
                echo "Taking a short break."
                sleep 300 # 5 minutes
                play_beep
                zenity --info --text="Break over" > /dev/null 2>&1
                ;;
            *)
                echo "Unknown option. Try again."
                ;;
        esac
    else
        echo "Begin a normal Pomodoro."
        sleep 1500
        play_beep
        zenity --warning --text="25 minutes passed" > /dev/null 2>&1
    fi
}

dow() {
    # Prints the day of the week
    Days=("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
    printf "%s\n" "${Days[$(date +%u)]}"
}

yotld() {
    # This function is a joke
    echo "$(($(date +%Y)+1)) is the year of the Linux desktop."
}

mongodb_start() {
    # Start mongod
    sudo service mongod start
}

mongodb_stop() {
    # Stop mongod
    mongo --eval "db.getSiblingDB('admin').shutdownServer()"
}

mongod_status() {
    # Report the status of mongod
    sudo service mongod status
}

resize_tmux_pane() {
    # Calls the .tmux/scripts/resize-tmux-pane.sh script, passing along its params
    ~/.tmux/scripts/resize-tmux-pane.sh "$@"
}

rtp() {
    # Alias for resize_tmux_pane()
    ~/.tmux/scripts/resize-tmux-pane.sh "$@"
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

browsh() {
    # Launch a browsh pane
    sudo docker run --rm -it browsh/browsh
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
    if [ $# -gt 0 ] ; then
        case "$*" in
            video|v*)
                # Video card info
                lspci -vnn | command grep --color=auto "VGA" -A 10
                ;;
            audio|sound*)
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
            sata|disk|raid)
                # RAID bus controller info
                lspci -vnn | command grep --color=auto "RAID" -A 11
                ;;
            all|--all|-a)
                # All devices
                lspci -vnn
                ;;
            help|--help|-h)
                echo "Usage: devices <arg>"
                echo "where <arg> in [all, help, sata, disk, raid, usb, dram, audio, video]"
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
    TMP=$(ldconfig -v 2>/dev/null | command grep --color=auto -v ^$'\t' | cut -d':' -f1)
    if [ -n "$LD_LIBRARY_PATH" ]; then
        TMP+=$(awk -F: '{for (i=0;++i<=NF;) print $i}' <<< "$LD_LIBRARY_PATH")
    fi
    echo "$TMP" | sort -u
}

md() {
    # Compile markdown to html w/ pandoc
    pandoc -f markdown -t html "$1" > "${1%.md}.html"
}

groff2man() {
    # Compile [g]roff/troff into a man-page
    groff -Tascii -man "$@"
}

prodigy() {
    # Run Prodigy from the command line
    python3 -m prodigy
}

fdw() {
    # find writable files in current directory
    find . -maxdepth 1 -writable
}

fdnw() {
    # Find non-writable files in current directory
    find . -maxdepth 1 ! -writable
}

btc() {
    # Get Bitcoin (BTC) price info
    curl http://rate.sx/btc
}

eth() {
    # Get Ethereum (ETH) price info
    curl http://rate.sx/eth
}

xrp() {
    # Get Ripple (XRP) price info
    curl http://rate.sx/xrp
}

xmr() {
    # Get Monero (XMR) price info
    curl http://rate.sx/xmr
}

moon() {
    # Get info about the lunar phase
    curl wttr.in/moon 2> /dev/null | head -n -1
}

vp() {
    # Use VLC to play video files
    vlc "$@" >/dev/null 2>&1
}

jg() {
    # Alias for mouse jiggle
    while true; do
        xdotool mousemove 0 0
        sleep 299
        xdotool mousemove 0 1
        sleep 299
    done
}

click() {
    # Use xdotool to click the mouse
    if [ $# -eq 1 ] ; then
        case "$1" in
            left|l|1)      xdotool click 1 ;;
            middle|m|2)    xdotool click 2 ;;
            right|r|3)     xdotool click 3 ;;
            *)             echo "Unknown parameter to click()" ;;
        esac
    else
        xdotool click 1
    fi
}

sumnf() {
    # Sum the final column - for generating counts of matching LMTD lines
    rg "$@" | awk '{sum += $NF} END {print sum}'
}

update_node() {
    # Update node to latest stable version
    sudo -H npm cache clean -f
    sudo -H npm install -g n
    sudo -H n stable
}

update_npm() {
    # Update npm
    sudo -H npm install -g npm
}

find_macro() {
    fd ".*\.csv" . | xargs -n 1 -P 0 rg "[%$]$1\b" - 2> /dev/null
}

find_android_external_storage() {
    adb shell 'echo ${SECONDARY_STORAGE%%:*}'
}
