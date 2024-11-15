#
# Custom zshrc
# Author: Max Drexler <mndrexler@gmail.com>
# Date: Jul. 25 2024
# License: MIT

. ~/.commonrc

# Shell options
setopt prompt_subst


# Prompt
prmopt='%n@%m %1~ ($(git branch --show-current 2>/dev/null))$ '

# Load external files
. ~/.zshrc.local    2>/dev/null || true

true
