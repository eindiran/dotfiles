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

## Typo-catching for my most common typos

# clear
typo ckear='clear'       # ckear -> clear
typo cvlear='clear'      # cvkear -> clear
typo clera='clear'       # clera -> clear
typo clea='clear'        # clear -> clear
typo cear='clear'        # cear -> clear
typo ear='true'          # c;ear -> clear
typo lear='true'         # c;lear -> clear

# history
typo histpry='history'   # histpry -> history
typo histpory='history'  # histpory -> history
typo histroy='history'   # histroy -> history

# vim
typo bim='vim'           # bim -> vim
typo cim='vim'           # cim -> vim
typo im='vim'            # im -> vim
typo vin='vim'           # vin -> vim

# ls / ll
typo l='ll'              # l -> ll
typo lll='ll'            # lll -> ll
typo kk='ll'             # kk -> ll
typo ks='ls'             # ks -> ls

# tree
typo tre='tree'          # tre -> tree
typo reww='tree'         # reww -> tree

# exit
typo xit='exit'          # xit -> exit
typo exitr='exit'        # exitr -> exit
typo exut='exit'         # exut -> exit
typo exot='exit'         # exot -> exit
typo exity='exit'        # exity -> exit
typo exiy='exit'         # exiy -> exit
typo exiyt='exit'        # exiyt -> exit

# git
typo cit='git'           # cit -> git
typo fit='git'           # fit -> git
typo hit='git'           # hit -> git

# which
typo wich='which'        # wich -> which
typo whihc='which'       # whihc -> which
typo whih='which'        # which -> which

# Other misc. commands
typo refrhs='refresh'    # refrhs -> refresh
typo eoch='echo'         # eoch -> echo
typo hava='java'         # hava -> java
typo havac='javac'       # havac -> java
typo mu='mutt'           # mu -> mutt
