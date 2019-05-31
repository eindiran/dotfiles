#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .volume_utils.sh
# 
#   DESCRIPTION: Adds a number of controls for the master volume.
# 
#         NOTES: Source this file in the rc file of your preferred shell.
#  REQUIREMENTS: Requires PulseAudio.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

volup () {
    # Increase system volume by 5%
    # if no args given, otherwise do it n times
    if [ $# -gt 0 ] ; then
        if [ "$1" -eq 0 ] ; then
            return
        fi
        amixer -D pulse sset Master 5%+
        volup $(($1-1))
    else
        amixer -D pulse sset Master 5%+
    fi
}

voldown () {
    # Decrease system volume by 5%
    # if no args given, otherwise do it n times
    if [ $# -gt 0 ] ; then
        if [ "$1" -eq 0 ] ; then
            return
        fi
        amixer -D pulse sset Master 5%-
        voldown $(($1-1))
    else
        amixer -D pulse sset Master 5%-
    fi
}

volset () {
    # Set the master volume to $1
    if [ $# -ne 1 ] ; then
        echo "volset takes a single integer argument in range 0 - 100"
        return
    fi
    amixer -D pulse sset Master "$1"%
}

mute () {
    # Mute/unmute master volume
    amixer -D pulse set Master 1+ toggle
}

unmute () {
    # An alias for 'mute'
    amixer -D pulse set Master 1+ toggle
}
