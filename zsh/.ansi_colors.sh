#!/usr/bin/env zsh
#===============================================================================
#
#          FILE: .ansi_colors.sh
#
#   DESCRIPTION: Provides environment variables for easy access to ANSI
#                formatting/color codes.
#
#      REVISION: 1.0.0
#
#===============================================================================

# Regular:
export BLACK="\e[0;30m"
export RED="\e[0;31m"
export GREEN="\e[0;32m"
export YELLOW="\e[0;33m"
export BLUE="\e[0;34m"
export PURPLE="\e[0;35m"
export CYAN="\e[0;36m"
export WHITE="\e[0;37m"

# Bold:
export B_BLACK="\e[1;30m"
export B_RED="\e[1;31m"
export B_GREEN="\e[1;32m"
export B_YELLOW="\e[1;33m"
export B_BLUE="\e[1;34m"
export B_PURPLE="\e[1;35m"
export B_CYAN="\e[1;36m"
export B_WHITE="\e[1;37m"

# Italics:
export I_BLACK="\e[3;30m"
export I_RED="\e[3;31m"
export I_GREEN="\e[3;32m"
export I_YELLOW="\e[3;33m"
export I_BLUE="\e[3;34m"
export I_PURPLE="\e[3;35m"
export I_CYAN="\e[3;36m"
export I_WHITE="\e[3;37m"

# Underline:
export UL_BLACK="\e[4;30m"
export UL_RED="\e[4;31m"
export UL_GREEN="\e[4;32m"
export UL_YELLOW="\e[4;33m"
export UL_BLUE="\e[4;34m"
export UL_PURPLE="\e[4;35m"
export UL_CYAN="\e[4;36m"
export UL_WHITE="\e[4;37m"

# Double underline:
export DUL_BLACK="\e[21;30m"
export DUL_RED="\e[21;31m"
export DUL_GREEN="\e[21;32m"
export DUL_YELLOW="\e[21;33m"
export DUL_BLUE="\e[21;34m"
export DUL_PURPLE="\e[21;35m"
export DUL_CYAN="\e[21;36m"
export DUL_WHITE="\e[21;37m"

# Blink (slow):
export BL_BLACK="\e[5;30m"
export BL_RED="\e[5;31m"
export BL_GREEN="\e[5;32m"
export BL_YELLOW="\e[5;33m"
export BL_BLUE="\e[5;34m"
export BL_PURPLE="\e[5;35m"
export BL_CYAN="\e[5;36m"
export BL_WHITE="\e[5;37m"

# Blink (fast):
export BLF_BLACK="\e[6;30m"
export BLF_RED="\e[6;31m"
export BLF_GREEN="\e[6;32m"
export BLF_YELLOW="\e[6;33m"
export BLF_BLUE="\e[6;34m"
export BLF_PURPLE="\e[6;35m"
export BLF_CYAN="\e[6;36m"
export BLF_WHITE="\e[6;37m"

# Strikethrough:
export STR_BLACK="\e[9;30m"
export STR_RED="\e[9;31m"
export STR_GREEN="\e[9;32m"
export STR_YELLOW="\e[9;33m"
export STR_BLUE="\e[9;34m"
export STR_PURPLE="\e[9;35m"
export STR_CYAN="\e[9;36m"
export STR_WHITE="\e[9;37m"

# Background:
export BG_BLACK="\e[40m"
export BG_RED="\e[41m"
export BG_GREEN="\e[42m"
export BG_YELLOW="\e[43m"
export BG_BLUE="\e[44m"
export BG_PURPLE="\e[45m"
export BG_CYAN="\e[46m"
export BG_WHITE="\e[47m"

# High Intensity:
export HI_BLACK="\e[0;90m"
export HI_RED="\e[0;91m"
export HI_GREEN="\e[0;92m"
export HI_YELLOW="\e[0;93m"
export HI_BLUE="\e[0;94m"
export HI_PURPLE="\e[0;95m"
export HI_CYAN="\e[0;96m"
export HI_WHITE="\e[0;97m"

# Bold High Intensity
export BHI_BLACK="\e[1;90m"
export BHI_RED="\e[1;91m"
export BHI_GREEN="\e[1;92m"
export BHI_YELLOW="\e[1;93m"
export BHI_BLUE="\e[1;94m"
export BHI_PURPLE="\e[1;95m"
export BHI_CYAN="\e[1;96m"
export BHI_WHITE="\e[1;97m"

# High Intensity backgrounds
export HIBG_BLACK="\e[0;100m"
export HIBG_RED="\e[0;101m"
export HIBG_GREEN="\e[0;102m"
export HIBG_YELLOW="\e[0;103m"
export HIBG_BLUE="\e[0;104m"
export HIBG_PURPLE="\e[0;105m"
export HIBG_CYAN="\e[0;106m"
export HIBG_WHITE="\e[0;107m"

# Reset
export ANSI_RESET="\e[0m"
export UL_RESET="\e[24m"
export BL_RESET="\e[25m"
export STR_RESET="\e[29m"
