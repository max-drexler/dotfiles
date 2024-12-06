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

IS_LINUX=false
IS_MACOS=false

case "$(uname)" in
    Linux) IS_LINUX=true ;;
    Darwin) IS_MACOS=true ;;
esac


## Shell Options
## =============
##

shopt -s extglob

# If set, a command name that is the name of a directory is executed as if it were the argument to the cd command.
shopt -s autocd

# If set, minor errors in the spelling of a directory component in a cd command will be corrected.
shopt -s cdspell

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

export GREP_OPTIONS='--color=always'

if $IS_LINUX; then
    # https://www.man7.org/linux/man-pages/man1/grep.1.html
    echo 'Please set grep colors on linux'
elif $IS_MACOS; then
    export GREP_COLOR='1;31'
fi

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
	tree --fromfile < "$PWD" &>/dev/null || return 1
	git ls-tree -r --name-only HEAD | tree --fromfile
}

# good-enough ripgrep
rg() {
    # if we're in a git directory use 'git grep'
    if [ -d "$PWD/.git" ]; then
        git grep -rni "$@"
    else
        # otherwise let's just use 'grep'
        # -H: show file in output
        # -I: no binary files
        # -i: ignore case
        # -r: recursive
        # -n: line numbers
        #
        # rg pattern [files]
        [ "$#" -lt 1 ] && return 1
        pattern="$1"
        shift
        grep -HIirns "$pattern" "${@:-$PWD}" | less -FR
    fi
}

# cat file | highlight match
highlight() {
      grep --color -E "$1|\$"
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

