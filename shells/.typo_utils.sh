#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .typo_utils.sh
#
#   DESCRIPTION: Adds an alias for 'alias' called 'typo'; adds a number of 
#                aliases for my most common typos in command names.
#
#         NOTES: Source this file in the rc file of your preferred shell.
#  REQUIREMENTS: No special requirements.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

# Add alias for 'alias'.
# Only to be used for aliases that convey that the alias in question fixes a typo
alias typo='alias'

# Find possible typos
find_typos() {
    history 0 | awk -F' ' '{print $2}' | grep -v "=" | grep -v "/" | grep -v "(" | sort | uniq -c | less
}

add_typo() {
    echo "typo $1='$2'" >> ~/.typo_utils.sh
}

## Typo-catching for my most common typos

# clear
typo ckear='clear'       # ckear  -> clear
typo kear='clear'        # kear   -> clear
typo cvlear='clear'      # cvkear -> clear
typo clera='clear'       # clera  -> clear
typo celar='clear'       # celar  -> clear
typo clea='clear'        # clear  -> clear
typo cear='clear'        # cear   -> clear
typo clar='clear'        # clar   -> clear
typo cler='clear'        # cler   -> clear
typo ear='true'          # c;ear  -> clear
typo lear='true'         # c;lear -> clear
typo cl='clear'          # cl;ear -> clear
typo cleear='clear'      # cleear -> clear
typo clewar='clear'      # clewar -> clear
typo cledar='clear'      # cledar -> clear
typo clesar='clear'      # clesar -> clear
typo clerar='clear'      # clerar -> clear
typo cleazr='clear'      # cleazr -> clear
typo clrar='clear'       # clrar  -> clear

# history
typo histpry='history'   # histpry  -> history
typo histpory='history'  # histpory -> history
typo histroy='history'   # histroy  -> history

# vim
typo vi='vim'            # vi     -> vim
typo bim='vim'           # bim    -> vim
typo cim='vim'           # cim    -> vim
typo im='vim'            # im     -> vim
typo vum='vim'           # vum    -> vim
typo vun='vim'           # vun    -> vim
typo vom='vim'           # vom    -> vim
typo von='vim'           # von    -> vim
typo vin='vim'           # vin    -> vim
typo viim='vim'          # viim   -> vim
typo viiim='vim'         # viiim  -> vim
typo viiiim='vim'        # viiiim -> vim
typo vii='vim'           # vii    -> vim
typo viii='vim'          # viii   -> vim
typo viiii='vim'         # viiii  -> vim

# ls / ll
typo l='ll'              # l   -> ll
typo lll='ll'            # lll -> ll
typo kk='ll'             # kk  -> ll
typo ks='ls'             # ks  -> ls

# tree
typo tre='tree'          # tre  -> tree
typo reww='tree'         # reww -> tree

# exit
typo xit='exit'          # xit   -> exit
typo exitr='exit'        # exitr -> exit
typo eixt='exit'         # eixt  -> exit
typo exut='exit'         # exut  -> exit
typo exot='exit'         # exot  -> exit
typo exiot='exit'        # exiot -> exit
typo exity='exit'        # exity -> exit
typo exiy='exit'         # exiy  -> exit
typo exiyt='exit'        # exiyt -> exit

# git
typo cit='git'           # cit -> git
typo fit='git'           # fit -> git
typo hit='git'           # hit -> git

# p4
typo p45='p4'            # p45 -> p4
typo p5='p4'             # p5  -> p4
typo p3='p4'             # p3  -> p4

# which
typo wich='which'        # wich  -> which
typo whihc='which'       # whihc -> which
typo whih='which'        # which -> which

# refresh
typo refrhs='refresh'    # refrhs  -> refresh
typo refrsh='refresh'    # refrsh  -> refresh
typo refrehs='refresh'   # refrehs -> refresh

# echo
typo eoch='echo'         # eoch -> echo
typo wcho='echo'         # wcho -> echo

# pip/pip2/pip3
typo pop='pip'           # pop   -> pip
typo pup='pip'           # pup   -> pip
typo pop2='pip2'         # pop2  -> pip2
typo pup2='pip2'         # pup2  -> pip2
typo pop3='pip3'         # pop3  -> pip3
typo pup3='pip3'         # pup3  -> pip3

# rsync
typo rsybc='rsync'       # rsybc    -> rsync
typo rsyncc='rsync'      # rsyncc   -> rsync
typo rysnc='rsync'       # rysnc    -> rsync

# Other misc. commands
typo puthon='python'     # puthon   -> python
typo puthon2='python2'   # puthon2  -> python2
typo puthon3='python3'   # puthon3  -> python3
typo hava='java'         # hava     -> java
typo havac='javac'       # havac    -> java
typo hyop='htop'         # hyop     -> htop
typo ssg='ssh'           # ssg      -> ssh
typo groovysj='groovysh' # groovysj -> groovysh
typo oing='ping'         # oing     -> ping
