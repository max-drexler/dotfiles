#! /usr/bin/env bash
## My bashrc
## =========
##
## Author: Max Drexler <mndrexler@gmail.com>
## Date: Nov. 26 2024
## License: MIT
##

# If not run interactively, don't do anything
[[ -z "$PS1" ]] && return


## Shell Options
## =============
##

shopt -s extglob

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

## Environment
## ===========
##

export EDITOR='vim'
export VISUAL='vim'

#export GREP_COLOR='1;36'
export HISTCONTROL='ignoredups'
export HISTSIZE=5000
export HISTFILESIZE=5000
export LSCOLORS='ExGxbEaECxxEhEhBaDaCaD'
export PAGER='less'
export TZ='America/Chicago'


# Homebrew
if [ -d "/opt/homebrew/" ]; then
    BREW_BIN="/opt/homebrew/bin/brew"
else
    BREW_BIN="/usr/local/bin/brew"
fi

if command -v $BREW_BIN --version &>/dev/null; then
    HOMEBREW_PREFIX="$($BREW_BIN --prefix)"
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

    if [ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [ -r "${COMPLETION}" ] && source "${COMPLETION}"
        done
    fi
fi


# Local executables
if [ ! -d "$HOME/.local/bin" ]; then
    mkdir "$HOME/.local/bin"
fi
export PATH="$HOME/.local/bin:$PATH"



## Custom Functions
## ================
##

# tree output that respects .gitignore
gtree() {
	# --fromfile in tree >=1.8.0
	tree --fromfile < $PWD &>/dev/null || return 1
	git ls-tree -r --name-only HEAD | tree --fromfile
}

## Prompt
## ======
##

# Unused Prompt colors
#GREEN="\[\033[0;32m\]"
#RED="\[\033[0;31m\]"
#PURPLE="\[\033[0;35m\]"
#BROWN="\[\033[0;33m\]"
#LIGHT_GRAY="\[\033[0;37m\]"
#LIGHT_CYAN="\[\033[1;36m\]"
#YELLOW="\[\033[1;33m\]"
#WHITE="\[\033[1;37m\]"

# Used Prompt colors
LIGHT_BLUE="\[\033[1;34m\]"
CYAN="\[\033[0;36m\]"
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
        echo "@$(hostname)"
    fi
}

# Directory parts to show in the prompt 
PROMPT_DIRTRIM=3
PS1="${LIGHT_RED}\$(_prompt_rv)${RESET}${LIGHT_GREEN}\u${RESET}${CYAN}\$(_prompt_host)${RESET}:${LIGHT_BLUE}\w ${LIGHT_PURPLE}\$(_prompt_git_branch)${RESET}> "
PS2='>> '

# Keep environment clean
unset LIGHT_RED LIGHT_GREEN LIGHT_PURPLE RESET

# Load aliases
[ -r ~/.aliasrc ] && . ~/.aliasrc

# Load local file if exist
[ -r ~/.bashrc.local ]  && . ~/.bashrc.local

