#!/usr/bin/env bash
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

# Underline:
export UL_BLACK="\e[4;30m"
export UL_RED="\e[4;31m"
export UL_GREEN="\e[4;32m"
export UL_YELLOW="\e[4;33m"
export UL_BLUE="\e[4;34m"
export UL_PURPLE="\e[4;35m"
export UL_CYAN="\e[4;36m"
export UL_WHITE="\e[4;37m"

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
