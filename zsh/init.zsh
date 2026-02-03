#!/bin/bash

# https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x
# mac 优化速度
# defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
# defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

# https://github.com/tmux/tmux/issues/353

# 优化启动时间
# https://blog.skk.moe/post/make-oh-my-zsh-fly/
zmodload zsh/zprof

# ----------------- zinit 基础,不要动 ------------------------------------------------------------------------------------------------------------
# 优先使用 .local/bin (包括 uv 等工具),然后是 homebrew,最后是 /usr/local/bin
export PATH=$HOME/.local/bin:/opt/homebrew/bin:$HOME/bin:/usr/local/bin:$PATH
source ~/.bash_profile
# bash_profile 可能会修改 PATH,再次确保 .local/bin 在最前面
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    PATH=$(echo $PATH | sed "s|$HOME/.local/bin:||g")
fi
export PATH=$HOME/.local/bin:$PATH
# source your own zsh file if exists
# [ -f ~/.config/.zsh.sh ] && source ~/.config/.zsh.sh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" &&
        print -P "%F{33} %F{34}Installation successful.%f%b" ||
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

source $HOME/dotfiles/zsh/plugin.zsh
source $HOME/dotfiles/zsh/env.zsh
source $HOME/dotfiles/zsh/alias.zsh
source $HOME/dotfiles/zsh/func.zsh
source $HOME/dotfiles/zsh/keymap.zsh
source $HOME/dotfiles/zsh/eval.zsh
source $HOME/dotfiles/zsh/private/config.zsh # 本机的一些私密配置，不同步到github
