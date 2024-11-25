#!/bin/sh

# Install user configuration
#
# Author: Max Drexler
# Date: 11/25/24
# License: MIT
#

# Where the current file is located
WORKDIR="$(dirname $0)"
WORKDIR="$(realpath $WORKDIR)"

# Exit with message
abort(){
    printf "%s\n" "$@"
    exit 1
}

# Portable ln -v
symlink(){
    printf "%30s ==> %s\n" "$1" "${2}"
    ln -fns "$@"
}

for f in "$WORKDIR"/home/*; do
    name="$(basename $f)"
    symlink "$f" ~/."$name"
done

# Install dotfiles/config to $HOME/.config
mkdir "$HOME/.config" &>/dev/null
for dir in "$WORKDIR"/config/*; do
    symlink "$dir" ~/.config
done

# Install shell configuration based on what shell is currently being used
SHELL_DIR="$WORKDIR/$(basename $SHELL)"

if [ ! -d "$SHELL_DIR" ]; then
    abort "No configuration for '$SHELL'"
fi

for f in "$SHELL_DIR"/*; do
    name="$(basename $f)"
    symlink "$f" ~/."$name"
done

