#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .docker_utils.sh
# 
#         USAGE: ./.docker_utils.sh 
# 
#   DESCRIPTION: Docker-specific shell utils.
# 
#         NOTES: ---
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

nuke_docker_containers() {
    # Kill all docker containers
    docker ps | tail -n +2 | awk '{ print $1 }' | xargs docker container stop
}
