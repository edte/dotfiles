#!/bin/bash

# -----------sages----- alias ------------------------------------------------------------------------------------------------------------
#file
alias c=clear
alias cl=clear
alias clr=clear
alias clea=clear
alias cleawr=clear
alias cleasr=clear
alias claer=clear
alias cle=clear
alias clewa=clear
alias clera=clear
alias ear=clear
alias lear=clear
alias l=lsd
alias ls=lsd
alias ll="ls -l"
# alias ll='ls --totl-size -l --date "+%F %T"'
alias lt='ls -lt  --date "+%F %T" | head -n 8'
alias la="ls -la"
alias lh='ls -lh  --date "+%F %T"'
alias s="exec zsh"
alias sl="ls"
# alias rf="rm -rf"
alias rf="trash"
alias rl='ls ~/.Trash'
alias remove="rm"
alias rm="trash"
# alias rg="rg -i"
alias rg="rg -i -z"
alias grep="rg"
alias tf='tail -f '
alias cloc='scc'
alias log='tspin'
alias du=dust
alias df=duf
# alias tree=yazi
alias find=fd
alias ps=procs
alias bench=hyperfine
alias cp="cp -v"
alias mv="mv -v"
alias tree="eza --tree --icons"

alias ch=cheat
alias list=cheat

alias dns=dog

alias vbackup="vim /Users/edte/config/backup.sh"
alias vupdate="vim /Users/edte/config/update.sh"

#git
alias gc="git clone"
# alias gs="git status -s"
alias gst="git status"
alias ga="git add"
alias gco="git checkout"
alias gb="git branch"
alias gcm="git commit -m"
alias gd="git diff"
alias gpl="git pull"
alias gps="git push"
alias merge='git diff --name-only --diff-filter=U | xargs nvim'

#tmux
alias t=tmux
alias ta="tmux attach"

# vim
alias v=nvim
alias vim=nvim

#make
alias m="make -j5"
alias mc="make clean"
alias mi="make mini"

#proxy
alias p="proxychains"

#else
alias gcc="gcc-5"
alias proc="ps aux| grep "
alias task='/Users/edte/asynctasks.vim/bin/asynctask -f'
# alias q='exit'
alias quit='exit'

alias i="brew install "

# 常用的配置文件
alias gsh="git show --date=format-local:'%Y-%m-%d %H:%M:%S'"
alias gshow="git show --date=format-local:'%Y-%m-%d %H:%M:%S'"
# https://devhints.io/git-log-format
alias glog="git log --graph --pretty=format:'%>|(12,trunc)%Cred%h%Creset  -  %C(yellow)%<(60,trunc)%s%Creset %Cgreen%<(30,trunc)%d %C(bold blue)%<(15,trunc)%an%Creset%>(1)%>(50)%cd' --date=format-local:'%Y-%m-%d %H:%M:%S'"
# alias glog=serie
# alias gwch="git whatchanged -p --abbrev-commit --pretty=medium --date=format-local:'%Y-%m-%d %H:%M:%S'"
alias gwch="git whatchanged --date=format-local:'%Y-%m-%d %H:%M:%S'"
alias vzsh='nvim ~/dotfiles/zsh'
alias vr="nvim README.md"
alias vm='nvim main.go'
alias vi='nvim init.lua'
alias vp="PROF=1 nvim"
alias vtask="nim /Users/edte/.config/asynctask/tasks.ini"
alias vtmux='nvim ~/dotfiles/tmux'
alias zkitty='cd /Users/edte/.config/kitty'
alias vkitty='nvim /Users/edte/.config/kitty/kitty.conf'
alias zconf='cd /Users/edte/config'
alias zconfig='cd /Users/edte/config'
alias vtest='/Users/edte/go/src/test'
alias zzsh="cd /Users/edte/.config/zsh"
alias tailf="tail -f"

alias cs='cd $(git rev-parse --show-toplevel)'
# alias pip=pipx

# benchmark
# zsh基准测试
alias benchzsh='for i in $(seq 1 5); do /usr/bin/time /bin/zsh -i -c exit; done'
# 原始zsh基准测试
alias benchrawzsh='for i in $(seq 1 20); do /usr/bin/time /bin/zsh --no-rcs -i -c exit; done'
# zsh 插件启动时间分析测试
alias benchplugin='zprof | less'

alias icat="kitty +kitten icat"

alias ztest="z /Users/edte/go/src/login/test"

# alias cmd="history | awk '{CMD[\$2]++;count++;}END { for (a in CMD)print CMD[a] \" \" CMD[a]/count*100 \"% \" a;}' | grep -v \"./\" | column -c3 -s \" \" -t | sort -nr | nl |  head -n20"
# alias cmdtop="history | awk '{CMD[\$2]++;count++;}END { for (a in CMD)print CMD[a] \" \" CMD[a]/count*100 \"% \" a;}' | grep -v \"./\" | column -c3 -s \" \" -t | sort -nr | nl |  head -n20"
# alias topcmd="history | awk '{CMD[\$2]++;count++;}END { for (a in CMD)print CMD[a] \" \" CMD[a]/count*100 \"% \" a;}' | grep -v \"./\" | column -c3 -s \" \" -t | sort -nr | nl |  head -n20"
# alias gittop="history | awk '{ if (\$2 == \"git\") { CMD[\$2 \" \" \$3]++; } else { CMD[\$2]++; } count++; } END { for (a in CMD) print CMD[a] \" \" CMD[a]/count*100 \"% \" a; }' | grep -v \"./\" | column -c3 -s \" \" -t | sort -nr | nl | head -n20"
