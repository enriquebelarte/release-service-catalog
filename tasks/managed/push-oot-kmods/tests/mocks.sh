#!/usr/bin/env bash
set -eux

# mocks to be injected into task step scripts

function git() {
    case "$1" in
        lfs)
            echo "Mocking LFS install: $*"
            ;;
        clone)
            echo "Mocking clone command: $*"
            mkdir local-artifacts
            echo "$*" >> "$(workspaces.signed-kmods.path)/mock_git_clone.txt"
            ;;
        config)
            echo "Skipping git config: $*"
            ;;
        checkout)
            echo "Skipping git checkout: $*"
            ;;
        add)
            echo "Mock git add: $*"
            echo "Files to add: $(ls -l ${DRIVER_VENDOR}_${DRIVER_VERSION}_${KERNEL_VERSION}/)"
            ;;
        commit)
            echo "Mocking commit: $*"
            ;;
        push)
            echo "Skipping push: $*"
            ;;
        *)
            echo "Unknown subcommand: $1"
            ;;
    esac
}
