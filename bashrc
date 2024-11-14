#!/usr/bin/env bash
# Custom bashrc
# ============
#
# Inspired by:
#   https://github.com/bahamas10/dotfiles
#   https://gitweb.gentoo.org/repo/gentoo.git/tree/app-shells/bash/files/bashrc

#
# Author: Max Drexler <mndrexler@gmail.com>
# Date: Jul. 25 2024
# License: MIT
#

. ~/.commonrc

# Shell Options
shopt -s extglob

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Load local file if exist
. ~/.bashrc.local    2>/dev/null || true

## Prompt Customization
## ====================
##

# Unused Prompt colors
#GREEN="\[\033[0;32m\]"
#CYAN="\[\033[0;36m\]"
#RED="\[\033[0;31m\]"
#PURPLE="\[\033[0;35m\]"
#BROWN="\[\033[0;33m\]"
#LIGHT_GRAY="\[\033[0;37m\]"
#LIGHT_BLUE="\[\033[1;34m\]"
#LIGHT_CYAN="\[\033[1;36m\]"
#YELLOW="\[\033[1;33m\]"
#WHITE="\[\033[1;37m\]"

# Used Prompt colors
LIGHT_RED="\[\033[1;31m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
LIGHT_GREEN="\[\033[1;32m\]"
RESET="\[\033[0m\]"

## Prompt functions
# These must stay in the environment so prefix with a _ to remove <tab> clutter

_prompt_git_branch(){
    if git rev-parse --git-dir >/dev/null 2>&1; then
        # in a git repo
        echo "($(git branch --show-current))"
    fi
}

_prompt_rv(){
    rv="$?"
    if [ "$rv" -gt 0 ]; then
        echo "!$rv "
    fi
}

_prompt_host(){
    # Add a prompt component for the host depending on ssh
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        echo "@${YELLOW}\h${RESET}"
    fi
}

# Directory parts to show in the prompt 
PROMPT_DIRTRIM=3
PS1="${LIGHT_RED}\$(_prompt_rv)${RESET}${LIGHT_GREEN}\u${RESET}\$(_prompt_host):\w ${LIGHT_PURPLE}\$(_prompt_git_branch)${RESET}> "
PS2='>> '

# Keep environment clean
unset LIGHT_RED LIGHT_GREEN LIGHT_PURPLE RESET

