# https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x
# mac 优化速度
# defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
# defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

# https://github.com/tmux/tmux/issues/353

# 优化启动时间
# https://blog.skk.moe/post/make-oh-my-zsh-fly/
zmodload zsh/zprof

# ----------------- zinit 基础，不要动 ------------------------------------------------------------------------------------------------------------
export PATH=$HOME/bin:/usr/local/bin:$PATH
source ~/.bash_profile
# source your own zsh file if exists
[ -f ~/.config/.zsh.sh ] && source ~/.config/.zsh.sh

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
