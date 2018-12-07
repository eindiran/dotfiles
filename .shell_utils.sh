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
    # Alias for quickly typing clear
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

lm () {
    # More advanced version of ls -l | more
    if [ $# -gt 0 ] ; then
        lh "$1" | less
    else
        lh | less
    fi
}

tm () {
    # More advanced version of tree | more
    if [ $# -gt 0 ] ; then
        tree "$1" | less
    else
        tree | less
    fi
}

ssh() {
    # Add flags to ssh calls
    command ssh -X -Y "$@"
}

egrep() {
    # Add support for egrep
    grep -E "$@"
}

fgrep() {
    # Add support for fgrep
    grep -F "$@"
}

igrep() {
    # Add support for igrep
    grep -i "$@"
}

rgrep() {
    # Add support for rgrep
    grep -r "$@"
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

extract () {
    # Extract the contents of a compressed file
    # Most common archive types are currently supported
    # Support for new types can be added using the "case" block below:
    if [ -f "$1" ] ; then
        # Check that a file actually exists at $1
        echo "Trying to extract file '$1'..."
        case "$1" in
            *.tar)       tar xvf "$1"                  ;;  # tar
            *.7z)        7z x "$1"                     ;;  # 7zip
            *.7zip)      7z x "$1"                     ;;  # "
            *.7z.+[0-9]) 7z x "$1"                     ;;  # 7zip: format '.7z1'
            *.tar.bz2)   tar xvjf "$1"                 ;;  # tar + bzip
            *.tbz2)      tar xvjf "$1"                 ;;  # "
            *.tar.gz)    tar xvzf "$1"                 ;;  # tar + gzip
            *.tgz)       tar xvzf "$1"                 ;;  # "
            *.tar.xz)    tar xvJf "$1"                 ;;  # tar + lmza/lmza2
            *.txz)       tar xvJf "$1"                 ;;  # "
            *.tar.lz)    tar --lzip -xvf "$1"          ;;  # tar + lzip
            *.tlz)       tar --lzip -xvf "$1"          ;;  # "
            *.tar.7z)    7z x -so "$1" | tar xF - -C . ;;  # tar + 7zip
            *.t7z)       7z x -so "$1" | tar xF - -C . ;;  # "
            *.bz2)       bunzip2 "$1"                  ;;  # bzip
            *.gz)        gunzip "$1"                   ;;  # gzip
            *.lz)        lzip -d -k "$1"               ;;  # lzip
            *.rar)       unrar x "$1"                  ;;  # rar
            *.rar+[0-9]) unrar x "$1"                  ;;  # rar: format '.rar1'
            *.xz)        xz -d "$1"                    ;;  # xz-utils
            *.zip)       unzip "$1"                    ;;  # zip
            *.Z)         uncompress "$1"               ;;  # compress
            *.zlib)      zlib-flate -uncompress "$1"   ;;  # zlib
            ###################################################################
            ### Everything has failed to be matched; unknown file extension ###
            ###################################################################
            *)           echo "Encountered unknown type (${1##*.}) with file: $1" ;;
        esac
    else
        echo "'$1', with filetype '${1##*.}', is not a valid file!"
        echo "Check if the file exists with:  stat '$1'"
    fi
}

targz() {
    # Tar and gzip a file or set of files
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
    # Make a new directory, then cd into it
    mkdir -p "$1"
    cd "$1" || exit 1
    pwd
}

countfiles () {
    # Count the non-hidden files in directory
    if [ $# -gt 0 ] ; then
        total_count=$(find "$1" -not -path '*/\.*' -print | wc -l)
        calc "$total_count"-1 # reduce by one to get count w/o '.'
    else
        total_count=$(find . -not -path '*/\.*' -print | wc -l)
        calc "$total_count"-1
    fi
}

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

which_shell () {
    # Find which shell is running
    which "$(ps -p "$$" | tail -n 1 | awk '{print $NF}')"
}

broken_links () {
    # Find broken symbolic links in the current directory
    find . -type l -xtype l -exec /bin/ls -l {} \;
}

makefile_deps () {
    # Create a dot-graph of the dependencies in a Makefile
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
    # Close the specified window
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

svg_to_png() {
    # Converts svg files to png
    for file in $(find . -name "*.svg"); do
        svgexport "${file}" "${file/svg/png}" 1024:1024
    done
}


svg_to_jpg() {
    # Converts svg files to jpg
    for file in $(find . -name "*.svg"); do
        svgexport "${file}" "${file/svg/jpg}" --format jpg
    done
}

set_dir_permissions() {
    # Sets ideal directory permissions
    find . -type d -exec chmod 755 {} \;
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
    # Calls the .tmux/scripts/resize-tmux-pane.sh script, passing along its params
    ~/.tmux/scripts/resize-tmux-pane.sh "$@"
}

p4() {
    # Wrapper for the p4 command
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
    # Wrapper for the git command
    case "$*" in
        adog)
            command git log --all --decorate --oneline --graph
            ;;
        amend*)
            shift 1  # git amend $@
            command git commit --amend "$@"
            ;;
        lp*)
            shift 1  # git lp $@
            command git log --patch --stat "$@"
            ;;
        rename*)
            shift 1  # git rename $@
            command git branch -m "$@"
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
                lspci -vnn | grep "VGA" -A 10
                ;;
            audio|sound*)
                # Sound card info
                lspci -vnn | grep "Audio device" -A 7
                ;;
            dram)
                # DRAM controller info
                lspci -vnn | grep "DRAM" -A 5
                ;;
            usb)
                # USB controller info
                lspci -vnn | grep "USB" -A 5
                ;;
            sata|disk|raid)
                # RAID bus controller info
                lspci -vnn | grep "RAID" -A 11
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
    TMP=$(ldconfig -v 2>/dev/null | grep -v ^$'\t' | cut -d':' -f1)
    if [ -n "$LD_LIBRARY_PATH" ]; then
        TMP+=$(awk -F: '{for (i=0;++i<=NF;) print $i}' <<< "$LD_LIBRARY_PATH")
    fi
    echo "$TMP" | sort -u
}

md() {
    # Compile markdown to html w/ pandoc
    pandoc -f markdown -t html "$1" > "${1%.md}.html"
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

moon() {
    # Get info about the lunar phase
    curl wttr.in/moon 2> /dev/null | head -n -1
}
