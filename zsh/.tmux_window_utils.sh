#!/usr/bin/env zsh
#===============================================================================
#
#          FILE: .tmux_window_utils.sh
#
#         USAGE: ./.tmux_window_utils.sh
#
#   DESCRIPTION: Add utility functions and aliases for tmux and controlling
#                windows to the shell.
#
#  REQUIREMENTS: tmux and wmctrl
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
    printf "\e]2;%s\a" "$*"
}

st() {
    # Alias for set_title, which wraps the words in brackets
    printf "\e]2;%s%s%s\a" "[" "$*" "]"
}

max_win() {
    # Maximize the current window, or if an argument is given
    # search for a window matching that and maximize it
    local WINDOW_NAME
    local WINDOW_ID

    if [ $# -gt 0 ]; then
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
    local WINDOW_NAME
    local WINDOW_ID

    WINDOW_NAME="$1"
    WINDOW_ID=$(wmctrl -l | rg "$WINDOW_NAME" | awk '{print $1}')
    wmctrl -ic "$WINDOW_ID"
}

switch_win() {
    # Switch to the first window with a title matching the string following
    wmctrl -a "$1"
}

sw() {
    # Switch to the first window with a title matching the string following
    # Alias for switch_win
    wmctrl -a "$1"
}

rename_win() {
    # Rename a window
    local OLD_WINDOW_NAME
    local NEW_WINDOW_NAME
    local WINDOW_ID

    if [ $# -eq 2 ]; then
        OLD_WINDOW_NAME="$1"
        NEW_WINDOW_NAME="$2"
        WINDOW_ID=$(wmctrl -l | rg "$OLD_WINDOW_NAME" | awk '{print $1}')
        wmctrl -ir "$WINDOW_ID" -T "$NEW_WINDOW_NAME"
    elif [ $# -eq 1 ]; then
        NEW_WINDOW_NAME="$1"
        wmctrl -r :SELECT: -T "$NEW_WINDOW_NAME"
    else
        printf "usage: rename_win <old window name> <new name>\n"
        printf "       rename_win <new name>\n"
    fi
}

sticky_win() {
    # Make a window sticky
    # If its already sticky, toggle its stickiness
    local WINDOW_ID
    local TARGET_WIN_NAME

    if [ $# -eq 1 ]; then
        TARGET_WIN_NAME="$1"
        WINDOW_ID=$(wmctrl -l | rg "$TARGET_WIN_NAME" | awk '{print $1}')
        wmctrl -ir "$WINDOW_ID" -b toggle,sticky
    else
        wmctrl -r :SELECT: -b toggle,sticky
    fi
}

shade_win() {
    # Make a window shaded
    # If its already shaded, toggle its shadedness
    local WINDOW_ID
    local TARGET_WIN_NAME

    if [ $# -eq 1 ]; then
        TARGET_WIN_NAME="$1"
        WINDOW_ID=$(wmctrl -l | rg "$TARGET_WIN_NAME" | awk '{print $1}')
        wmctrl -ir "$WINDOW_ID" -b toggle,shaded
    else
        wmctrl -r :SELECT: -b toggle,shaded
    fi
}

ldesk() {
    # List opened desktops - alias for wmctrl -d
    wmctrl -d
}

newdesk() {
    # Create a new desktop
    local NUM_DESKTOPS

    NUM_DESKTOPS=$(wmctrl -d | wc -l)
    NUM_DESKTOPS=$((NUM_DESKTOPS + 1))
    wmctrl -n "$NUM_DESKTOPS"
}

deldesk() {
    # Shut a desktop down
    local NUM_DESKTOPS

    NUM_DESKTOPS=$(wmctrl -d | wc -l)
    if [ "$NUM_DESKTOPS" -gt 1 ]; then
        NUM_DESKTOPS=$((NUM_DESKTOPS - 1))
        wmctrl -n "$NUM_DESKTOPS"
    fi
}

cdesk() {
    # Get the desktop id for the current desktop
    local DESKTOP_LIST

    DESKTOP_LIST=$(wmctrl -d)
    # shellcheck disable=SC2034
    while read -r ID STATUS REMAINDER; do
        if test "$STATUS" = "*"; then
            echo "$ID"
        fi
    done <<-EOF
$DESKTOP_LIST
EOF
}

ndesk() {
    # Advance to the next desktop
    local CURRENT_DESKTOP
    local NEXT_DESKTOP

    CURRENT_DESKTOP=$(cdesk)
    NEXT_DESKTOP=$((CURRENT_DESKTOP + 1))
    wmctrl -s "$NEXT_DESKTOP"
}

pdesk() {
    # Advance to the previous desktop
    local CURRENT_DESKTOP
    local PREV_DESKTOP

    CURRENT_DESKTOP=$(cdesk)
    PREV_DESKTOP=$((CURRENT_DESKTOP - 1))
    wmctrl -s "$PREV_DESKTOP"
}
