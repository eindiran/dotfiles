#!/bin/bash - 
#===============================================================================
#
#          FILE: mouse_jiggle.sh
# 
#         USAGE: ./mouse_jiggle.sh 
# 
#   DESCRIPTION: Jiggles the mouse periodically using xdotool.
#                Used to prevent the screen from entering sleep mode, etc.
# 
#       OPTIONS: None
#  REQUIREMENTS: xdotool must be installed (apt-get install xdotool)
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#       CREATED: 01/03/2019
#      REVISION: v1.0.0
#===============================================================================

while true; do
    # Loop forever, moving the mouse one pixel
    # Do it once every 4 minutes and 59 seconds
    xdotool mousemove 0 0
    sleep 299
    xdotool mousemove 0 1
    sleep 299
done
