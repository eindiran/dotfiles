#!/usr/bin/env bash
#==============================================================================
#
#          FILE: resize-tmux-pane.sh
#
#         USAGE: ./resize-tmux-pane.sh [-l <LAYOUT-NAME>] [-p <PERCENT>]
#
#   DESCRIPTION: Adaptable tmux resize script; takes a percentage
#
#       OPTIONS: -l layout name;
#                -p percentage;
#                -t target window
#        AUTHOR: Elliott Indiran
#
#        Based heavily on a script by Tony Narlock -->
#        github.com/tony/tmux-config/blob/master/scripts/resize-adaptable.sh
#        This script preserves 2/3 of the interface to that script
#
#==============================================================================

set -o errexit  # Exit on a command failing
set -o errtrace # Exit when a function or subshell has an error
set -o nounset  # Treat unset variables as an error
set -o pipefail # Return error code for first failed command in pipe

# Redirect all all output to stderr
exec >&2

LAYOUT=""
PERCENTAGE=""

usage()  {
    # Print out the usage information
    printf "Usage: %s [-l LAYOUT] [-p PERCENTAGE]\n" "$0"
    printf "       LAYOUT -- Required; the name of the layout:"
    printf "either \"main-horizontal\" or \"main-vertical\"\n"
    printf "       PERCENTAGE -- Required; the percentage of pane width/height\n"
}

while [[ $# -gt 0 ]]; do
    flag="$1"
    case "$flag" in
        --help | -h)
            # print usage info if a help flag is used
            usage
            exit 0
            ;;
        --layout | -l)
            shift
            LAYOUT="$1"
            ;;
        --percent | -p)
            shift
            PERCENTAGE="$1"
            ;;
        *)
            # Unknown option
            printf "Unknown option or flag: \"%s\"\n" "$flag"
            usage
            exit 1
            ;;
    esac
    shift
done

if [ "$LAYOUT" = "" ]; then
    printf "The -l flag must be provided\n"
    usage
    exit 1
elif [ "$PERCENTAGE" = "" ]; then
     printf "The -p flag must be provided\n"
    usage
    exit 1
elif ! echo "$PERCENTAGE" | grep -E -q "^[0-9][0-9]?[0-9]?$"; then
    printf "The -p flag takes a percentage: \"%s\" is not a valid value\n" "$PERCENTAGE"
    usage
    exit 1
fi

# Check that $LAYOUT is set to a good value
if [ "$LAYOUT" = "main-vertical" ]; then
    WIDTH=$(tmux display -p '#{window_width}')
    MAIN_PANE_SIZE=$((WIDTH * PERCENTAGE / 100))
    MAIN_SIZE_OPTION='main-pane-width'
elif [ "$LAYOUT" = "main-horizontal" ]; then
    HEIGHT=$(tmux display -p '#{window_height}')
    MAIN_PANE_SIZE=$((HEIGHT * PERCENTAGE / 100))
    MAIN_SIZE_OPTION='main-pane-height'
else
    printf "The -l flag takes either \"main-horizontal\" or \"main-vertical\"\n"
    usage
    exit 1
fi

# Actually do the setting of pane size
tmux setw "$MAIN_SIZE_OPTION" "$MAIN_PANE_SIZE"
tmux select-layout "$LAYOUT"
