#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .torque_utils.sh
# 
#   DESCRIPTION: Adds a number of utility functions for using Torque.
#                More info on using Torque here:
#                    http://www.arc.ox.ac.uk/content/torque-job-scheduler
#                    https://kb.iu.edu/d/avmy
# 
#         NOTES: Source this in the rc file of your prefered shell.
#  REQUIREMENTS: Requires torque and ripgrep.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

torque_jobs() {
    # Find Torque jobs matching a pattern
    if [ $# -eq 0 ]; then
        qstat
    else
        qstat | tail -n +3 | rg "$@"
    fi
}

lmtd_jobs() {
    # A special case of `torque_jobs()`
    # Find the remaining Torque jobs for building the LMTD
    qstat | tail -n +3 | rg "make_LMTD"
}

qtop() {
    # Runs qstat repeatedly, giving a top-like display of torque jobs
    watch qstat
}

qkill() {
    # Kill all torque jobs matching a pattern
    case "$#" in
        0)
            # No pattern
            printf "Usage: qkillall <pattern>\n"
            printf "<pattern> may not be empty."
            ;;
        1)
            # Correct number of args
            # Select correct jobs using qstat, print the job IDs, then call qdel on them
            qstat | tail -n +3 | rg "$@" | awk '{ print $1 }' | xargs --no-run-if-empty qdel
            ;;
        *)
            # Too many args
            printf "Usage: qkillall <pattern>\n"
            printf "qkill takes a single argument only."
            ;;
    esac
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
