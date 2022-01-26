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
#       MODIFIED:    Wed 26 Jan 2022
#       REVISION:    v1.4.0
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
export HISTSIZE=100000
export SAVEHIST=100000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY

# For sharing history between zsh processes:
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Never, ever beep. Ever. Ever ever.
setopt NO_BEEP

# Automatically `cd` into typed out dirs:
setopt AUTOCD
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Setup ctrl + f as a way to FZF + cd to a directory:
function _cdfzf() {
    local directory
    directory="$(fzf)"
    cd "${directory}" || printf "Directory '%s' doesn't exist!" "${directory}"
}
bindkey -s '^f' '_cdfzf\n'

# Setup ctrl + z as a way to FZF + edit the file:
function _fzf_vim() {
    vim "$(fzf)"
}
bindkey -s '^z' '_fzf_vim\n'
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Setup ctrl + s as a way to quickly set the terminal name/title

# Allow ctrl + s to be rebound
stty stop undef

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
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Setup LSCOLORS for macOS:
    export LSCOLORS="EHfxcxdxBxegecabagacad"
else
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
# Aliases
alias up='source up'
alias rm='rm -iv'
alias mv='mv -v'
alias cp='cp -v'
alias strings='strings -a'

# IRC
alias irc='irssi -n eindiran'
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Exports

### ld:
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export LD_RUN_PATH=$LD_RUN_PATH

### git:
export NAME='eindiran'
export GIT_AUTHOR_NAME='eindiran'
export GIT_AUTHOR_EMAIL='elliott.indiran@juul.com'
export GIT_COMMITTER_NAME='eindiran'
export GIT_COMMITTER_EMAIL='elliott.indiran@juul.com'
export USERNAME='Elliott Indiran <elliott.indiran@juul.com>'

### Editor setup:
export SUDO_EDITOR=vim
export EDITOR=vim

### Path:
export PATH=$HOME/bin:/usr/local/bin:$PATH

### Workspace directory:
export WORKSPACE=$HOME/Workspace  # Support the workspace directory
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Enable help command
autoload -Uz run-help
alias help=run-help

# Enable helper functions for run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-p4
autoload -Uz run-help-sudo
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Dirstack
DIRSTACKFILE="$HOME/.cache/zsh/dirs"

if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
    dirstack=(${(f)"$(< $DIRSTACKFILE)"})
    [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi

function chpwd() {
    print -l $PWD ${(u)dirstack} > $DIRSTACKFILE
}

DIRSTACKSIZE=20
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Set various pushd/popd options
setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

# Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

# This reverts the +/- operators.
setopt PUSHD_MINUS
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# Sourcing other scripts:
#--------------------------------------------------------------------

#--------------------------------------------------------------------
# Universal stuff:
[ -f ~/.env_variables ] && source ~/.env_variables
[ -f ~/.shell_utils.sh ] && source ~/.shell_utils.sh
[ -f ~/.file_utils.sh ] && source ~/.file_utils.sh
[ -f ~/.volume_utils.sh ] && source ~/.volume_utils.sh
[ -f ~/.welcome.sh ] && source ~/.welcome.sh
[ -f ~/.git_utils.sh ] && source ~/.git_utils.sh
[ -f ~/.typo_utils.sh ] && source ~/.typo_utils.sh
[ -f ~/.tts_utils.sh ] && source ~/.tts_utils.sh
[ -f ~/.tmux_window_utils.sh ] && source ~/.tmux_window_utils.sh
[ -f ~/.misc_utils.sh ] && source ~/.misc_utils.sh
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# fzf:
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"
#--------------------------------------------------------------------


#--------------------------------------------------------------------
# These lines come from the default OMZ .zshrc

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13
DISABLE_AUTO_TITLE="true"
HIST_STAMPS="yyyy-mm-dd"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  git
  bundler
  dotenv
  macos
)

source $ZSH/oh-my-zsh.sh
#--------------------------------------------------------------------

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
