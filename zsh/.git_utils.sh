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
        # List all <items>
        list*)
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
        log-patch|lp*)
            shift 1  # git lp
            command git log --patch --stat "$@"
            ;;
        # Show remotes
        remotes)
            command git remote -v
            ;;
        # Rename a branch
        rename*)
            shift 1  # git rename
            command git branch -m "$@"
            ;;
        # Help for wrapper function
        wrapper-help)
            echo "git: This function wraps the standard git command."
            echo "Use like the standard command. This adds the following new commands:"
            echo "git adog, git amend, git lp, git log-graph, git log-patch, git remotes"
            echo "git list {submodule(s), remote(s), rev(s), branch(es), rbranch(es), lbranch(es)}"
            echo "git rename, git wrapper-help"
            ;;
        # All standard commands
        *)
            command git "$@"
            ;;
    esac
}
