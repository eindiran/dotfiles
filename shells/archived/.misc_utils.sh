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

yotld() {
    # This function is a joke
    echo "$(($(date +%Y)+1)) is the year of the Linux desktop."
}

resolve_doi() {
    # Resolve a DOI to get the final resulting URL
    curl -Ls -o /dev/null -w "%{url_effective}" "https://www.doi.org/${1}" | awk -F'?' '{print $1}'
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

timer() {
    # macOS timer
    # ARG 1: Sleep time seconds
    # ARG 2: Ring count
    sleep "$1"
    i=$2
    until [ "$i" -eq 0 ]; do
        tput bel
        sleep 1
        i=$((i-1))
    done 
}
