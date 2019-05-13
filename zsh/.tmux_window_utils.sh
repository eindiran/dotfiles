#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .tmux_window_utils.sh
# 
#         USAGE: ./.tmux_window_utils.sh 
# 
#   DESCRIPTION: Add utility functions and aliases for tmux and controlling
#                windows to the shell.
# 
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

# tmux related functions:
t() {
    # Alias for quickly typing `tmux`
    TERM=screen-256color tmux "$@"
}

resize_tmux_pane() {
    # Calls the .tmux/scripts/resize-tmux-pane.sh script, passing along its params
    ~/.tmux/scripts/resize-tmux-pane.sh "$@"
}

rtp() {
    # Alias for resize_tmux_pane()
    ~/.tmux/scripts/resize-tmux-pane.sh "$@"
}

# Other window-control functions
set_title() {
    # Use this function to set the terminal title
    printf "\e]2;%s\a" "$*";
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
