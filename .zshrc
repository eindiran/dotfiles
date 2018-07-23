#
# ===============================================================================
#
#       FILE:        ~/.zshrc
#       
#       DESCRIPTION: Define the behavior of zsh; you may source this file from an
#                    interactive shell or simply open a new shell once changes
#                    are made.
#
#       AUTHOR:      Elliott Indiran <elliott.indiran@protonmail.com>
#       CREATED:     10/09/2017
#       MODIFIED:    Thu 03 May 2018
#       REVISION:    v1.0.7
#
# ===============================================================================

autoload -Uz compinit promptinit
compinit
promptinit

# Set prompt to default walters theme
prompt bigfade

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD
## arrow-key driven autocompletion
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
setopt COMPLETE_ALIASES

## history
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

## Allow search of history
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "$key[Up]"   ]] && bindkey -- "$key[Up]"   up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

## never ever beep ever
setopt NO_BEEP

## automatically decide when to page a list of completions
LISTMAX=0

## set coloring prefs
## used by the zsh-syntax-highlighting plugin
autoload -U colors
colors
export CLICOLOR=1
LS_COLORS='no=00:fi=00:di=34:ow=34;40:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.hpp=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.cl=32:*.sh=32:*.bash=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.go=32:*.sql=32:*.csv=32:*.sv=32:*.svh=32:*.v=32:*.vh=32:*.vhd=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.PNG=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.m4a=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.opus=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.MOV=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.webm=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.odt=31:*.dot=31:*.dotx=31:*.ott=31:*.xls=31:*.xlsx=31:*.ods=31:*.ots=31:*.ppt=31:*.pptx=31:*.odp=31:*.otp=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:*.sqlite=34:';
export LS_COLORS

## Aliases
alias up='source up'

alias rm='rm -iv'
alias mv='mv -v'
alias cp='cp -v'
alias strings='strings -a'

## Convenient 'ls' aliases
alias ls='/bin/ls --color -AF'
alias ll='/bin/ls --color -lFhtr'
In mathematics, specifically in category theory, the Yoneda lemma is an abstract result on functors of alias lh='/bin/ls --color -AFlhtr' # don't include implied '.' and '..'

alias ssh='ssh -X -Y'

alias rgrep='grep -r'
alias igrep='grep -i'

alias p4-add-cd='find . -type f -print | p4 -x add'
alias p4-edit-cd='find . -type f -print | p4 -x edit'
export P4CLIENT='eindiran'

# Run homeassistant
alias hass='sudo -u homeassistant -H /srv/homeassistant/bin/hass'

# Start the Dropbox daemon
alias dropbox-start='start-stop-daemon -b -o -c $(whoami) -S -u $(whoami) -x "$HOME/.dropbox-dist/dropboxd"'
# Stop the Dropbox daemon
alias dropbox-stop='start-stop-daemon -o -c $(whoami) -K -u $(whoami) -x $(/bin/ls -1 $HOME/.dropbox-dist/dropbox-lnx.*/dropbox)'

# Set thefuck alias
eval $(thefuck --alias redo)

## Functions
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

mcd () {
    # make a new directory, then cd to it
    mkdir -p "$1"
    cd "$1"
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
    # more advanced version of "ls -l | more"
    if [ $# -gt 0 ] ; then
        lh "$1" | less
    else
        lh | less
    fi
}

tm () {
    # more advanced version of "tree | more"
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
    which $(ps -p $(echo "$$") | tail -n 1 | awk {'print $NF'})
}

broken_links () {
    # Find broken symbolic links in the current directory
    find . -type l -xtype l -exec ls -l {} \;
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

# Export used by play_beep()
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
        sleep 1500 # 25 minutes; standard Pomodoro length
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
            qselect -u $(whoami) -s EHQRTW | xargs --no-run-if-empty qdel -a
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
            echo "Usage: qkillall <username> [<state(s)>]"
            echo "Examples:\n\tqkillall steve EHR"
            echo "\tqkillall rms"
            ;;
    esac
}

mongodb_stop() {
    # stop mongod
    mongo --eval "db.getSiblingDB('admin').shutdownServer()"
}

resize_tmux_pane() {
    # calls the .tmux/scripts/resize-tmux-pane.sh script, passing along its params
    ~/.tmux/scripts/resize-tmux-pane.sh "$@"
}

p4() {
    # I am tired of accidentally typing 'p4 blame' instead of 'p4 annotate'
    case $* in
        blame*)
            shift 1
            command p4 annotate "$@"
            ;;
        *)
            command p4 "$@"
            ;;
    esac
}

get_disk_usage_percentage() {
    # Print the percentage of used disk space for a specific disk
    df "$1" | tail -n 1 | awk '{sub(/%/,""); print $5}'
}


## Exports
export P4HOME=/home/eindiran/p4
export P4PORT=perforce.mp.promptu.com:1666
export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/include
export LD_RUN_PATH=/usr/local/lib:/usr/local/include
export PERL5LIB=./lib:/home/sconrad/src/atv/2005/data/perl/install/lib/perl5:/home/sconrad/src/atv/2005/data/perl/install/lib64/perl5:$P4HOME/atv/2005/data/perl/install/lib/perl5:$P4HOME/atv/2005/perl
export NAME='eindiran'
# Git env variables: change these depending on where you are making commits from
export GIT_AUTHOR_NAME='eindiran'
export GIT_AUTHOR_EMAIL='eindiran@promptu.com'
export GIT_COMMITTER_NAME='eindiran'
export GIT_COMMITTER_EMAIL='eindiran@promptu.com'
export USERNAME='Elliott Indiran <eindiran@promptu.com>'
export SUDO_EDITOR=/usr/bin/vim
export EDITOR=/usr/bin/vim
export PATH=/home/eindiran/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/eindiran/p4/atv/2005/data/perl:/local/nim-0.17.2/bin:/home/eindiran/.nimble/bin
export ATV=$P4HOME/atv/2005/
export SHELL=/bin/zsh
export DROPBOX=$HOME/Dropbox
export SPARK_HOME=/usr/local/share/spark/spark-2.3.0-bin-hadoop2.7/
export PYSPARK_PYTHON=/usr/bin/python3
export PYSPARK_DRIVER_PYTHON=/usr/bin/python3
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export JRE_HOME=/usr/lib/jvm/java-8-oracle/jre

# Enable help command
autoload -Uz run-help
alias help=run-help
# Enable helper functions for run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-p4
autoload -Uz run-help-sudo

## Dirstack
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

## This reverts the +/- operators.
setopt PUSHD_MINUS

# This following line MUST BE last for syntax highlighting to work.
source /home/eindiran/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
