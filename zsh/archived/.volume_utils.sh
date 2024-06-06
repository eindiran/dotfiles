#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .volume_utils.sh
#
#   DESCRIPTION: Adds a number of controls for the master volume.
#
#         NOTES: Source this file in the rc file of your preferred shell.
#  REQUIREMENTS: Requires ALSA for amixer; libnotify for notify-send
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

volup () {
    # If no args given: increase system volume by 5%
    # Otherwise do it n times
    local NEW_VOLUME
    if [ $# -gt 0 ] ; then
        if [ "$1" -le 1 ] ; then
            NEW_VOLUME=$(amixer -D pulse sset Master 5%+ | tail -n 1 | awk '{print $5}' | sed -e 's!\[\([0-9]\+\)%\]!\1!')
            notify-send "Volume increased" "New volume: $NEW_VOLUME / 100"
            return
        fi
        amixer -D pulse sset Master 5%+ > /dev/null
        volup $(($1-1))
    else
        NEW_VOLUME=$(amixer -D pulse sset Master 5%+ | tail -n 1 | awk '{print $5}' | sed -e 's!\[\([0-9]\+\)%\]!\1!')
        notify-send "Volume increased" "New volume: $NEW_VOLUME / 100"
    fi
}

voldown () {
    # If no args given: decrease system volume by 5%
    # Otherwise do it n times
    local NEW_VOLUME
    if [ $# -gt 0 ] ; then
        if [ "$1" -le 1 ] ; then
            NEW_VOLUME=$(amixer -D pulse sset Master 5%- | tail -n 1 | awk '{print $5}' | sed -e 's!\[\([0-9]\+\)%\]!\1!')
            notify-send "Volume decreased" "New volume: $NEW_VOLUME / 100"
            return
        fi
        amixer -D pulse sset Master 5%- > /dev/null
        voldown $(($1-1))
    else
        NEW_VOLUME=$(amixer -D pulse sset Master 5%- | tail -n 1 | awk '{print $5}' | sed -e 's!\[\([0-9]\+\)%\]!\1!')
        notify-send "Volume decreased" "New volume: $NEW_VOLUME / 100"
    fi
}

volset () {
    # Set the master volume to $1
    local NEW_VOLUME
    if [ $# -ne 1 ] ; then
        echo "volset takes a single integer argument in range 0 - 100"
        return
    fi
    NEW_VOLUME=$(amixer -D pulse sset Master "$1"% | tail -n 1 | awk '{print $5}' | sed -e 's!\[\([0-9]\+\)%\]!\1!')
    notify-send "Volume set" "New volume: $NEW_VOLUME / 100"
}

mute () {
    # Mute/unmute master volume
    local MUTE_STATUS
    MUTE_STATUS=$(amixer -D pulse set Master 1+ toggle | tail -n 1 | awk '{print $NF}')
    if [ "$MUTE_STATUS" = "[off]" ] ; then
        notify-send "Mute toggled" "Volume is now muted"
    else
        notify-send "Mute toggled" "Volume is now unmuted"
    fi
}

unmute () {
    # Similar to mute, but will only unmute
    local MUTE_STATUS
    MUTE_STATUS=$(amixer -D pulse set Master 1+ toggle | tail -n 1 | awk '{print $NF}')
    if [ "$MUTE_STATUS" = "[off]" ] ; then
        amixer -D pulse set Master 1+ toggle > /dev/null
        notify-send "Mute toggled" "Mute was already off"
    else
        notify-send "Mute toggled" "Volume is now unmuted"
    fi
}
