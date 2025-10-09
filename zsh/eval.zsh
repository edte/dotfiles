#!/bin/bash

# eval $(thefuck --alias)

# eval "$(lua /Users/edte/.oh-my-zsh/plugins/z.lua/z.lua --init zsh)"

# eval "$(rbenv init - zsh)"

# eval "$(atuin init zsh)"

# zoxide import --from=z "$HOME/.zlua"
# eval "$(zoxide init zsh)"

# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
#
# nvm use v23.6.0

eval "$(~/.local/bin/mise activate zsh)"

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(lua /Users/edte/.oh-my-zsh/plugins/z.lua/z.lua --init zsh)"

# pnpm
# export PNPM_HOME="/Users/edte/Library/pnpm"
# case ":$PATH:" in
# *":$PNPM_HOME:"*) ;;
# *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
# pnpm end
