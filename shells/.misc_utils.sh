#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .misc_utils.sh
# 
#         USAGE: ./.misc_utils.sh 
# 
#   DESCRIPTION: Add miscellaneous utility functions for a variety
#                of programs and purposes.
# 
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

# NoMachine
nxtunnel() {
    # Create an SSH tunnel for accessing a machine via nx
    # Use like so: "nxtunnel foo@<ip address>"
    ssh -L 4003:localhost:4000 "$@"
}

# Dropbox
dropboxstart() {
    # Start the Dropbox daemon
    start-stop-daemon -b -o -c "$(whoami)" -S -u "$(whoami)" -x "$HOME/.dropbox-dist/dropboxd"
}

dropboxstop() {
    # Stop the Dropbox daemon
    start-stop-daemon -o -c "$(whoami)" -K -u "$(whoami)" -x "$(/bin/ls -1 "$HOME"/.dropbox-dist/dropbox-lnx.*/dropbox)"
}

# Home Assistant
hass() {
    # Run homeassistant
    sudo -u homeassistant -H /srv/homeassistant/bin/hass
}

# Postgres
postgres_start() {
    # Start the postgres -D daemon
    sudo service postgresql start
}

postgres_stop() {
    # Stop the postgres -D daemon
    sudo service postgresql stop
}

postgres_status() {
    # Report the status of the postgres -D daemon
    sudo service postgresql status
}

pg_ctl() {
    if [ "$1" = "reload" ] ; then
        sudo pg_ctlcluster 9.5 main reload
    elif [ "$1" = "start" ] ; then
        sudo pg_ctlcluster 9.5 main start
    elif [ "$1" = "stop" ] ; then
        sudo pg_ctlcluster 9.5 main stop
    else
        echo "Unknown command \"$1\". Cannot continue..."
    fi
}

psql_schemas() {
    # List all available schemas for a given database
    psql -U postgres -t "$@" -c "SELECT nspname FROM pg_catalog.pg_namespace;"
}

# MongoDB
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

# setxkbmap
set_caps() {
    # Set the behavior of the caps-lock key
    case "$1" in
        'shift')    setxkbmap -option caps:'shift'  ;;
        off)        setxkbmap -option caps:none ;;
        on)         setxkbmap -option caps:capslock ;;
        *)  printf "Unrecognized argument. Cannot set caps key to \"%s\"\n" "$1"  ;;
    esac
}

# Browsh
browsh() {
    # Launch a browsh pane
    sudo docker run --rm -it browsh/browsh
}

# Prodigy
prodigy() {
    # Run Prodigy from the command line
    python3 -m prodigy
}

# Timers
export BEEP_NOISE=/usr/share/sounds/KDE-Im-Contact-In.ogg

play_beep() {
    # Plays a beep noise through headphones
    # Use as you would 'beep'
    play $BEEP_NOISE > /dev/null 2>&1
}

posture() {
    # Reminds you to maintain good posture
    local MINUTES
    if [ $# -gt 0 ] ; then
        MINUTES="$1"
        ((SECONDS=MINUTES*60)) # The magical builtin SECONDS, not a normal var.
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
        local ARGUMENT
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

# Android
find_android_external_storage() {
    adb shell 'echo ${SECONDARY_STORAGE%%:*}'  # shellcheck disable=SC2016
}

# Cryptocurrency price info
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

# Node
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

# LMTD info
sumnf() {
    # Sum the final column - for generating counts of matching LMTD lines
    rg "$@" | awk '{sum += $NF} END {print sum}'
}

find_macro() {
    fd ".*\.csv" . | xargs -n 1 -P 0 rg "[%$]$1\b" - 2> /dev/null
}

# Mouse control
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

# Other
vp() {
    # Use VLC to play video files
    vlc "$@" >/dev/null 2>&1
}

moon() {
    # Get info about the lunar phase
    curl wttr.in/moon 2> /dev/null | head -n -1
}

yotld() {
    # This function is a joke
    echo "$(($(date +%Y)+1)) is the year of the Linux desktop."
}

resolve_doi() {
    # Resolve a DOI to get the final resulting URL
    curl -Ls -o /dev/null -w %{url_effective} "$(echo "https://www.doi.org/${1}")" | awk -F'?' '{print $1}'
}

chkport() {
    # Check for processes using a port
    if [ "$1" = "-h" ]; then
        echo "chkport:"
        echo "	Check for processes using specified port"
        echo "	If run without specifying a port, check for all ports"
        echo "	Args:"
        echo "		default: LISTEN + ESTABLISHED"
        echo "		-l:      LISTEN"
        echo "		-e:      ESTABLISHED"
        echo "		-a:      ALL"
        echo "		-h:      print help and exit"
        echo "	Example:"
        echo "		chkport -l 9000"
        echo "		chkport -e"
    elif [ "$1" = "-l" ]; then
        # LISTEN only
        sudo lsof -i -P -n | rg ":${2:-[[:digit:]]+} \(LISTEN\)\$"
    elif [ "$1" = "-e" ]; then
        # ESTABLISHED only
        sudo lsof -i -P -n | rg ":${2:-[[:digit:]]+} \(ESTABLISHED\)\$"
    elif [ "$1" = "-a" ]; then
        # all types
        sudo lsof -i -P -n | rg ":${2:-[[:digit:]]+} \([A-Z_0-9]+\)\$"
    else
        # default is LISTEN + ESTABLISHED
        sudo lsof -i -P -n | rg ":${1:-[[:digit:]]+} \(((LISTEN)|(ESTABLISHED))\)\$"
    fi
}

pwt() {
    # Print working directory and then run `tree`
    pwd
    tree "$@"
}

timer() {
    # macOS timer
    # ARG 1: Sleep time seconds
    # ARG 2: Ring count
    sleep $1
    i=$2
    until [ $i -eq 0 ]; do
        tput bel
        sleep 1
        i=$((i-1))
    done 
}
