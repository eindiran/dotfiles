#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .git_utils.sh
#
#         USAGE: Source from a shell, then call the functions within.
#
#   DESCRIPTION: Add git utility functions to the shell. The main work is being done
#                by the `git` function which wraps the standard `git` command to
#                add additional functionality.
#
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

githash() {
    if [ $# -gt 0 ]; then
        shift 1
        git rev-parse "$@"
    else
        git rev-parse --short=16 HEAD
    fi
}

git() {
    # Wrapper for the git command
    case "$*" in
        # Log as graph (all decorate oneline graph)
        adog|log-graph)
            command git log --all --decorate --oneline --graph
            ;;
        # Amend a commit
        amend)
            command git commit --amend
            ;;
        # Alias for `git commit ...`
        c|c\ *)
            shift 1
            command git commit "$@"
            ;;
        # Alias for `git checkout ...`
        co|co\ *)
            shift 1
            command git checkout "$@"
            ;;
        # Alias for `git clone ...`
        cl\ *)
            shift 1
            command git clone "$@"
            ;;
        # Checkout a new branch, with HEAD set to current HEAD
        cb\ *)
            shift 1
            command git checkout -b "$@"
            ;;
        # Alias for `git commit -m ...`
        cm\ *)
            shift 1
            command git commit -m "$@"
            ;;
        # Alias for `git commit -am ...`
        cam\ *)
            shift 1
            command git commit -am "$@"
            ;;
        # List all <items>
        list\ *)
            shift 1
            case "$*" in
                # Submodules
                submod*)
                    command git submodule status --recursive
                    ;;
                # Remotes
                remote*)
                    command git remote -v
                    ;;
                # Revisions
                rev*)
                    shift 1
                    command git rev-list "$@"
                    ;;
                # All branches
                branch*)
                    command git branch
                    ;;
                # Remote branches
                rbranch*)
                    command git branch -r
                    ;;
                # Local branches
                lbranch*)
                    command git branch -l
                    ;;
                # Commits
                commit*)
                    command git log --all --decorate
                    ;;
                *)
                    printf "Can't display values: %s\n" "$@"
                    ;;
            esac
            ;;
        # Log patch
        log-patch|log-patch\ *|lp|lp\ *)
            shift 1  # git lp
            command git log --patch --stat "$@"
            ;;
        # Show remotes
        remotes)
            command git remote -v
            ;;
        # Rename a branch
        rename\ *)
            shift 1  # git rename
            command git branch -m "$@"
            ;;
        # Generates a line chart of commits by hour
        # From here: https://gist.github.com/bessarabov/674ea13c77fc8128f24b5e3f53b7f094
        timegraph|timegraph\ *)
            shift 1
            command git log --format="%ad" "$@" --date="format:%H" | awk '{n=$1+0;if(H[n]++>max)max=H[n]}END{for(i=0;i<24;i++){printf"%02d -%5d ",i,H[i];for(n=0;n<H[i]/max*50;n++){printf "*"}print""}}'
            ;;
        # Help for wrapper function
        wrapper-help)
            echo "git: This function wraps the standard git command."
            echo "Use like the standard command. This adds the following new commands:"
            echo "git adog, git amend, git lp, git log-graph, git log-patch, git remotes"
            echo "git list {submodule(s), remote(s), rev(s), branch(es), rbranch(es), lbranch(es)}"
            echo "git rename, git timegraph, git wrapper-help"
            echo
            echo "Additionally, it supports the following aliases:"
            echo "git co:   git checkout"
            echo "git cb:   git checkout -b"
            echo "git c:    git commit"
            echo "git cm:   git commit -m"
            echo "git cam:  git commit -am"
            echo "git cl:   git clone"
            ;;
        # All standard commands
        *)
            command git "$@"
            ;;
    esac
}
