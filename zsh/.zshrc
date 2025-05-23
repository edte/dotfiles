source $HOME/dotfiles/zsh/init.zsh

# FILES_STR=$(fd --glob '*.zsh' --exclude 'init.zsh' --exclude 'plugin.zsh' $CONFIGS)
# FILES=($(echo $FILES_STR | tr '\n' ' '))
# for FILE in $FILES; do
#     source $FILE
# done

# 目录 /Users/edte/.config/zsh

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
