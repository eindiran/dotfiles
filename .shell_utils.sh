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
#        AUTHOR: Elliott Indiran <eindiran@uchicago.edu>
#===============================================================================

c() {
    # Alias for quickly typing 'clear'
    clear
}

ls() {
    # Alias for 'ls'
    /bin/ls --color -AF "$@"
}

ll() {
    # Alias for 'll'
    /bin/ls --color -Flhtr "$@"
}

lh() {
    # Display all files in 'll' format
    /bin/ls --color -AFlhtr "$@"
}

ssh() {
    # Add flags to ssh calls
    command ssh -X -Y "$@"
}

rgrep() {
    grep -r "$@"
}

igrep() {
    grep -i "$@"
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

extract () {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1"    ;;
            *.tar.gz)    tar xvzf "$1"    ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xvf "$1"     ;;
            *.tbz2)      tar xvjf "$1"    ;;
            *.tgz)       tar xvzf "$1"    ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

targz() {
    # Tar and gzip a file
    tar "$@" | gzip
}

batch_ext_rename() {
    # Batch rename files from one extension to another
    for file in *.$1
    do
        mv "$file" "${file%.$1}.$2"
    done
}

mcd () {
    # make a new directory, then cd to it
    mkdir -p "$1"
    cd "$1" || exit 1
    pwd
}

countfiles () {
    # count the non-hidden files in directory
    if [ $# -gt 0 ] ; then
        total_count=$(find "$1" -not -path '*/\.*' -print | wc -l)
        calc "$total_count"-1 # reduce by one to get count w/o '.'
    else
        total_count=$(find . -not -path '*/\.*' -print | wc -l)
        calc "$total_count"-1
    fi
}

lm () {
    # more advanced version on ls -l | more
    if [ $# -gt 0 ] ; then
        lh "$1" | less
    else
        lh | less
    fi
}

tm () {
    # more advanced version on ls -l | more
    if [ $# -gt 0 ] ; then
        tree "$1" | less
    else
        tree | less
    fi
}

volup () {
    # Increase volume by 5%
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
    # Decrease volume by 5%
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

mute () {
    # Mute/unmute master volume
    amixer -D pulse set Master 1+ toggle
}

histsearch () {
    # Search through the history for a given word
    # fc -lim "$@" 1 # not as good
    history 0 | grep "$1"
}

bhistory () {
    # Replace zsh's history command with one that behaves like
    # bash's history command
    history 0
}

nhistory () {
    # Get the last n history entries
    if [ $# -eq 0 ] ; then
        # If no arg passed, return last 100 entries
        history 0 | tail -n 100
    else
        history 0 | tail -n "$1"
    fi
}

set_title () {
    # Use this function to set the terminal title
    printf "\e]2;%s\a" "$*";
}

rgp() {
    # Page the output of rg through less
    rg -p "$@" | less -RFX
}

which_shell () {
    # Find which shell is running
    which "$(ps -p "$$" | tail -n 1 | awk '{print $NF}')"
}

broken_links () {
    # Find broken symbolic links in the current directory
    find . -type l -xtype l -exec /bin/ls -l {} \;
}

makefile_deps () {
    if [ $# -gt 0 ] ; then
        TARGET_NAME="$1"
        make -Bnd "$TARGET_NAME" | /usr/local/bin/make2graph | dot -Tpng -o Makefile_Dependencies.png
    else
        make -Bnd | /usr/local/bin/make2graph | dot -Tpng -o Makefile_Dependencies.png
    fi
}

max_win () {
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

close_win () {
    # close the specified window
    # Unlike max_win the default is NOT to close the current window
    WINDOW_NAME="$1"
    WINDOW_ID=$(wmctrl -l | rg "$WINDOW_NAME" | awk '{print $1}')
    wmctrl -ic "$WINDOW_ID"
}

set_caps () {
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

pomodoro() {
    # Do a pomodoro
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

clean_perl() {
    # Cleans untidy or obfuscated perl code
    perl -MO=Deparse "$1" | perltidy -ce -i=4 -st
}

jpg_to_png() {
    # Converts files in dir/subdirs from jpg to png
    find . -name "*.jpg" -exec mogrify -format png {} \;
}

png_to_jpg() {
    # Converts files in dir/subdirs from png to jpg
    find . -name "*.png" -exec mogrify -format jpg {} \;
}

transparent_png_to_jpg() {
    # Converts transparent background png files to jpg files
    find . -name "*.png" -exec mogrify -format jpg -background black -flatten {} \;
}

set_dir_permissions() {
    # Sets ideal directory permissions
    find . -type d -exec chmod 755 {} \;
}

svg_to_png() {
    # Converts svg files to png
    for file in $(find . -name "*.svg"); do
        svgexport "${file}" "${file/svg/png}" 1024:1024 --format png
    done
}

svg_to_jpg() {
    # Converts svg files to jpg
    for file in $(find . -name "*.svg"); do
        svgexport "${file}" "${file/svg/jpg}" --format jpg
    done
}

hidden() {
    # Finds hidden files recursively in current directory
    # Handle no argument case
    if [ $# -eq 0 ] ; then
        ls -l -d .[!.]?*
        return
    fi
    DIR_TO_SEARCH="$1"
    shift
    # Handle first argument
    case "$DIR_TO_SEARCH" in
        -h|--help)
            echo "Usage: hidden <dir> [-d|-f|-r]"
            return
            ;;
        *)
            if [ ! -d "$DIR_TO_SEARCH" ] ; then
                printf "%s is not a directory.\n" "$DIR_TO_SEARCH"
                return
            fi
            ;;
    esac
    # Handle optional second argument
    if [ $# -gt 0 ] ; then
        ARGUMENT="$1"
        case "$ARGUMENT" in
            -d|--dirs)
                find "$DIR_TO_SEARCH" -type d -iname ".*" -ls
                ;;
            -f|--files)
                find "$DIR_TO_SEARCH" -type f -iname ".*" -ls
                ;;
            -r|--recursive)
                find "$DIR_TO_SEARCH" -name ".*" -ls
                ;;
            *)
                echo "Unknown option: hidden <dir> [-d|-f|-r]"
                ;;
        esac
    fi
}

yotld() {
    # This function is a joke
    echo "$(($(date +%Y)+1)) is the year of the Linux desktop."
}

qtop() {
    # Runs qstat repeatedly, giving a top-like interface to torque jobs
    watch qstat
}

qkillall() {
    # Kill all torque jobs associated with a particular user
    case "$#" in
        0)
            # "qkillall" --> kill all jobs for current user
            qselect -u "$(whoami)" -s EHQRTW | xargs --no-run-if-empty qdel -a
            ;;
        1)
            # "qkillall <user>" --> kill all jobs for <user>
            qselect -u "$1" -s EHQRTW | xargs qdel
            ;;
        2)
            # "qkillall <user> <state(s)>" --> kill jobs in listed states for <user>
            qselect -u "$1" -s "$2" | xargs qdel
            ;;
        *)
            # If given a weird number of args, print usage
            printf "Usage: qkillall <username> [<state(s)>]\n"
            printf "Examples:\n\tqkillall steve EHR\n"
            printf "\tqkillall rms\n"
            ;;
    esac
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
    # calls the .tmux/scripts/resize-tmux-pane.sh script, passing along its params
    ~/.tmux/scripts/resize-tmux-pane.sh "$@"
}

p4() {
    case "$*" in
        blame*)
            shift 1
            command p4 annotate "$@"
            ;;
        *)
            command p4 "$@"
            ;;
    esac
}

git() {
    case "$*" in
        adog)
            command git log --all --decorate --oneline --graph
            ;;
        lp*)
            shift 2
            command git log --patch --stat "$@"
            ;;
        *)
            command git "$@"
            ;;
    esac
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
