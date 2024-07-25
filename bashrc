#!/usr/bin/env bash
#
# Custom bashrc
#
# Author: Dave Eddy <dave@daveeddy.com>
# Date: Sometime in 2011
# License: MIT
#
# Editor: Max Drexler <mndrexler@gmail.com>
# Date: Jul. 25 2024

. ~/.commonrc

# Shell Options
shopt -s checkwinsize
shopt -s extglob

# Prompt
PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'; PS1='\u@\h
\w (${PS1_CMD1})\\$ '
PROMPT_DIRTRIM=6

# Load external files
. ~/.bash_aliases    2>/dev/null || true
. ~/.bashrc.local    2>/dev/null || true

# load completion
. /etc/bash/bash_completion 2>/dev/null ||
	. ~/.bash_completion 2>/dev/null


true
