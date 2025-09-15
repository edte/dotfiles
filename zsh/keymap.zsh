#!/bin/bash

# ----------------- keymap ------------------------------------------------------------------------------------------------------------
bindkey "jj" clear-screen
bindkey "jk" clear-screen
# bindkey -M viins jk vi-cmd-mode
bindkey ',' autosuggest-accept
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

bindkey '^R' .history-incremental-search-backward

# History menu.
zstyle ':autocomplete:history-search-backward:*' list-lines 1024

# 上下键查看相同前缀的历史命令
# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward

# what is this
# source /Users/edte/.config/broot/launcher/bash/br

# 可以输入time命令，查看shell启动时间
# export PATH="/opt/homebrew/bin:$PATH"
# export PATH="/Users/edte/.cargo/bin:$PATH"

zstyle ':autocomplete:*' frecent-dirs off

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# c-z
fancy-ctrl-z() {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
        zle clear-screen
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# 复制多行按键是用
autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# EDITOR=vim
# export EDITOR
bindkey -e
