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
#       MODIFIED:    Sun 30 Jun 2024
#       REVISION:    v1.5.1
#
# ===============================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Disable all checking of 'source foo' style lines
# shellcheck disable=1090,1091
true

#--------------------------------------------------------------------
# Setup tab completion:
autoload -Uz compinit

# Allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

# Allow tab complete to use aliases
setopt COMPLETE_ALIASES

# Support #,~,^ in filename globs
setopt EXTENDED_GLOB

# Arrow-key driven autocompletion
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zmodload zsh/complist
compinit

# Support hidden/dotfiles
_comp_options+=(globdots)
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Make sure every script we source knows that we should respond to
# using Oh My ZSH
export USING_OMZ="true"
# Setup history:
export HISTFILE=~/.zsh_history
export HISTFILESIZE=100000
export HISTSIZE=100000
export SAVEHIST=100000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY

# For sharing history between zsh processes:
setopt SHARE_HISTORY
# Better history search with arrow keys (skip dupes):
setopt HIST_FIND_NO_DUPS
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Never, ever beep. Ever. Ever ever.
setopt NO_BEEP

# Automatically `cd` into typed out dirs:
setopt AUTOCD
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Setup ctrl + s as a way to quickly set the terminal name/title

# Allow ctrl + s to be rebound
if [[ "${OSTYPE}" =~ ^linux ]]; then
    stty stop undef
fi

# Set terminal title using read to fetch user input:
function _input_terminal_title() {
    local terminal_title
    read terminal_title"?Enter new title for this terminal: "
    printf '\033]2;%s%s%s\033\\' "[" "${terminal_title}" "]"
}

# Now rebind ctrl + s to this function
bindkey -s '^s' '_input_terminal_title\n'
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Bind additional keys:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e'    edit-command-line
bindkey '^[[P'  delete-char
bindkey "^U"    backward-kill-line
bindkey "^u"    backward-kill-line

# Allow search of history
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "$key[Up]"   ]] && bindkey -- "$key[Up]"   up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Automatically decide when to page a list of completions
LISTMAX=0
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Set coloring prefs
# Used by the zsh-syntax-highlighting plugin, ls, and programs that use
# the LS_COLORS environment variable
autoload -U colors
colors
export CLICOLOR=1
if [[ "${OSTYPE}" =~ ^darwin ]]; then
    # Setup LSCOLORS for macOS:
    export LSCOLORS="EHfxcxdxBxegecabagacad"
elif [[ "${OSTYPE}" =~ ^linux ]]; then
    # Setup LS_COLORS for Linux:
    LS_COLORS='no=00:fi=00:di=34:ow=34;40:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.hpp=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.cl=32:*.sh=32:*.bash=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.erb=32:*.haml=32:*.xml=32:*.rdf=32:*.css=32:*.sass=32:*.scss=32:*.less=32:*.js=32:*.coffee=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.go=32:*.sql=32:*.csv=32:*.sv=32:*.svh=32:*.v=32:*.vh=32:*.vhd=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.PNG=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.m4a=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.opus=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.MOV=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.webm=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.odt=31:*.dot=31:*.dotx=31:*.ott=31:*.xls=31:*.xlsx=31:*.ods=31:*.ots=31:*.ppt=31:*.pptx=31:*.odp=31:*.otp=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:*.sqlite=34:';
    export LS_COLORS
fi
export TERM=screen-256color
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Charset preferences
export LESSCHARSET='utf-8'
export LANGUAGE='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Exports

### Workspace directory:
export WORKSPACE=$HOME/Workspace  # Support the workspace directory

### Path:
export PATH="/opt/homebrew/opt/llvm/bin:$HOME/bin:/usr/local/bin:$WORKSPACE/git-tools/scripts:/usr/local/opt/ruby/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/opt/coreutils/bin:$HOME/.go/bin:$WORKSPACE/shell-scripts/scripts:$PATH"

### ld:
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

### Go:
export GOPATH="${HOME}/.go"
export GOBIN="${HOME}/.go/bin"

### Editor setup:
export SUDO_EDITOR=vim
export EDITOR=vim

if [[ "${OSTYPE}" =~ ^darwin ]]; then
    export PACKAGE_MANAGER=brew
else
    if command -v apt-get &> /dev/null; then
        # Debian and derivatives:
        export PACKAGE_MANAGER=apt-get
    elif command -v pacman &> /dev/null; then
        # Arch and derivatives:
        export PACKAGE_MANAGER=pacman
    elif command -v dnf &> /dev/null; then
        # Red Hat family:
        export PACKAGE_MANAGER=dnf
    elif command -v emerge &> /dev/null; then
        # Gentoo and derivatives:
        export PACKAGE_MANAGER=emerge
    else
        echo "Unknown package manager, update the PACKAGE_MANAGER in .zshrc"
    fi
fi
#--------------------------------------------------------------------


#--------------------------------------------------------------------
export HELPDIR="/usr/share/zsh/$(zsh --version | cut -d' ' -f2)/help"
# Enable run-help command
autoload -Uz run-help
(( ${+aliases[run-help]} )) && unalias run-help

# Enable helper functions for run-help
autoload -Uz run-help-git run-help-ip run-help-openssl run-help-sudo
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Dirstack
DIRSTACKFILE="$HOME/.cache/zsh/dirs"

if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
    dirstack=( ${(uf)"$(< $DIRSTACKFILE)"} )
    [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi

function chpwd() {
    print -l $PWD ${(u)${dirstack:#$PWD}} >$DIRSTACKFILE
}

DIRSTACKSIZE=15

# Set various pushd/popd options
setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

# Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

# This reverts the +/- operators.
setopt PUSHD_MINUS
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# fzf:
if [ -f ~/.fzf.zsh ]; then
    # FZF Commands:
    # Ctrl + f --> default command
    # Ctrl + t --> default command + bat preview
    # Ctrl + r -->
    source ~/.fzf.zsh
    # `fzf`
    export FZF_DEFAULT_COMMAND="fd ."
    # CTRL + T
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
    # CTRL + R
    # CTRL-/ to toggle small preview window to see the full command
    # CTRL-Y to copy the command into clipboard using pbcopy
    export FZF_CTRL_R_OPTS="
    --preview 'echo {}' --preview-window up:3:hidden:wrap
    --bind 'ctrl-/:toggle-preview'
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --color header:italic
    --header 'Press CTRL-Y to copy command into clipboard'"
    # ALT + C
    export FZF_ALT_C_COMMAND="fd -t d . $HOME"
    export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

    # Setup CTRL + f as a way to FZF + cd to a directory:
    # This needs to appear below: bindkey -s '^f' '_cdfzf\n'
    function _cdfzf() {
        local directory
        directory="$(fzf)"
        cd "${directory}" || printf "Directory '%s' doesn't exist!" "${directory}"
    }
    # Setup ctrl + z as a way to FZF + edit the file:
    # This needs to appear below: bindkey -s '^z' '_fzf_vim\n'
    function _fzf_vim() {
        vim "$(fzf)"
    }
    # Setup CTRL + h as a way to fzf starting at home
    # This needs to appear below: bindkey -s '^h' '_homefzf\n'
    function _homefzf() {
        _FZF_DCMD="${FZF_DEFAULT_COMMAND}"
        FZF_DEFAULT_COMMAND="fd . $HOME"
        local directory
        directory="$(fzf)"
        cd "${directory}" || printf "Directory '%s' doesn't exist!" "${directory}"
        FZF_DEFAULT_COMMAND="${_FZF_DCMD}"
        unset _FZF_DCMD
    }
fi
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# OMZ Configuration:
ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
zstyle ':omz:update' mode auto      # Update automatically without asking
zstyle ':omz:update' frequency 13
DISABLE_AUTO_TITLE="true"
HIST_STAMPS="yyyy-mm-dd"

# Setup zoxide plugin
# Override 'cd' as default 'z' command:
ZOXIDE_CMD_OVERRIDE="cd"

# Setup thefuck plugin
export THEFUCK_HISTORY_LIMIT=9999
export THEFUCK_ALTER_HISTORY=false
export THEFUCK_REQUIRE_CONFIRMATION=true
export THEFUCK_NUM_CLOSE_MATCHES=7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

if [[ "${OSTYPE}" =~ ^darwin ]]; then
    plugins=(
        iterm2
        macos
        brew
        zsh-autosuggestions
        zsh-completions
        zsh-history-substring-search
        zsh-syntax-highlighting
        zsh-fzf-history-search
        git
        bundler
        dotenv
        thefuck
        zoxide
    )
else
    plugins=(
        zsh-autosuggestions
        zsh-completions
        zsh-history-substring-search
        zsh-syntax-highlighting
        zsh-fzf-history-search
        git
        bundler
        dotenv
        thefuck
        zoxide
    )
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
source $ZSH/oh-my-zsh.sh
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Sourcing my scripts:
# These should go below source omz, since omz tries to overwrite
# some of these names:
[ -f ~/.ansi_colors.sh ] && source ~/.ansi_colors.sh
[ -f ~/.shell_utils.sh ] && source ~/.shell_utils.sh
[ -f ~/.search_utils.sh ] && source ~/.search_utils.sh
[ -f ~/.file_utils.sh ] && source ~/.file_utils.sh
[ -f ~/.tmux_window_utils.sh ] && source ~/.tmux_window_utils.sh
# env_variables, .hidden/*.sh and hidden.sh should never be checked in and will be
# unique to each machine.
[ -f ~/.env_variables ] && source ~/.env_variables
[ -f ~/.hidden.sh ] && source ~/.hidden.sh
if [ -d ~/.hidden ]; then
    for dotfile in ~/.hidden/.*.sh;  do
        source ${dotfile}
    done
fi
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Aliases
# These should go below source omz, since omz tries to overwrite
# several of these with aliases I don't really like.

unalias_if_exists() {
    # Use unalias iff the alias exists to avoid "no such hash table element" errors:
    case "$(type "$1")" in
        (*alias*)
            unalias "$1"
            ;;
    esac
}

# Names requiring unalias:
unalias_if_exists ls
unalias_if_exists ll
alias ll="ls --color -Flhtr"
unalias_if_exists la
alias la="ls --color -Flhtra"
unalias_if_exists lh
alias lh="ls --color -AFlhtr"
unalias_if_exists l
alias l="ls --color -Flhtra"
# Finally alias ls
alias ls="ls --color -AF"
unalias_if_exists grep
alias grep="grep --color=auto"

if [[ "${OSTYPE}" =~ ^darwin ]]; then
    alias vim='nvim'
    alias v='nvim'
else
    alias v='nvim'
fi
alias rm='rm -iv'
alias mv='mv -v'
alias cp='cp -v'
alias strings='strings -a'
alias err='fuck'  # Alias for thefuck
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Final steps to make sure the following are the last keybindings we enter:
bindkey -s '^f' '_cdfzf\n'
bindkey -s '^z' '_fzf_vim\n'
bindkey -s '^h' '_homefzf\n'
bindkey 'ç' fzf-cd-widget
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PYTHONPATH="${PYTHONPATH}:/Users/elliottindiran/Workspace/scratch/mpm_proc2/mpm_processor"
alias mpmp='source /Users/elliottindiran/Workspace/scratch/mpm_proc2/mpm_processor/.venv/bin/activate'
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then
    source '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'
fi
if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then
    source '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'
fi
