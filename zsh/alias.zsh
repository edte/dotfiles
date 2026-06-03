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
alias remove="/bin/rm -rf"
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
# alias ps=procs
alias ps='ps aux'
alias -g g='| _g'
alias bench=hyperfine
alias cp="cp -v"
alias mv="mv -v"
# alias tree="eza --tree --icons"

alias ch=cheat
alias list=cheat

alias dns=dog

#git
alias gc="git clone"
# alias gs="git status -s"
alias gst="git status"
alias ga="git add"
alias gr="git remote -v"

alias gmt="go mod tidy"
# alias gco="git checkout"

glog() {
    _fzf_git_hashes
}

gco() {
    _fzf_git_each_ref --no-multi | xargs git checkout
}

alias gb="git branch"
alias gcm="git commit -m"
gd() {
    local cdup prefix arg file show_untracked after_pathspecs i pager_width diff_file render_status
    local ignored_pathspecs=(
        ':(top,exclude,glob)**/go.mod'
        ':(top,exclude,glob)**/go.sum'
        ':(top,exclude,glob)**/*_test.go'
    )
    local untracked_diff_args=()
    local untracked_pathspecs=()

    show_untracked=1
    after_pathspecs=0
    for (( i = 1; i <= $#argv; i++ )); do
        arg="${argv[$i]}"
        if (( after_pathspecs )); then
            untracked_pathspecs+=("$arg")
            continue
        fi

        case "$arg" in
            --)
                after_pathspecs=1
                ;;
            --cached|--staged)
                show_untracked=0
                ;;
            --stat*|--name-only|--name-status|--numstat|--shortstat|--summary|--check|--compact-summary|--no-compact-summary|--color|--color=*|--no-color|-p|--patch|-s|--no-patch|-u|-U*|--unified*|--word-diff*|--color-words*)
                untracked_diff_args+=("$arg")
                ;;
            *)
                if [[ "$arg" != -* && -e "$arg" ]]; then
                    untracked_pathspecs+=("$arg")
                fi
                ;;
        esac
    done

    cdup=$(git rev-parse --show-cdup 2>/dev/null)
    prefix=$(git rev-parse --show-prefix 2>/dev/null)
    pager_width=${COLUMNS:-0}
    if (( pager_width <= 0 )); then
        pager_width=$(tput cols 2>/dev/null)
    fi
    if (( ${pager_width:-0} <= 0 )); then
        pager_width=80
    fi

    diff_file=$(mktemp "${TMPDIR:-/tmp}/gd.XXXXXX") || return
    {
        if [[ -z "$prefix" ]]; then
            git --no-pager diff "$@" "${ignored_pathspecs[@]}"
        else
            git --no-pager diff --src-prefix="a/${cdup}" --dst-prefix="b/${cdup}" "$@" "${ignored_pathspecs[@]}"
        fi
        if (( show_untracked )); then
            git ls-files -z --others --exclude-standard -- "${untracked_pathspecs[@]}" "${ignored_pathspecs[@]}" |
                while IFS= read -r -d '' file; do
                    git --no-pager diff --no-index "${untracked_diff_args[@]}" -- /dev/null "$file" 2>/dev/null || true
                done
        fi
    } > "$diff_file"

    if [[ ! -s "$diff_file" ]]; then
        command rm -f "$diff_file"
        return
    fi

    {
        if [[ -z "$prefix" ]]; then
            cat "$diff_file"
        else
            sed "s|${cdup}${prefix}||g" "$diff_file"
        fi
    } | {
        if [[ -t 1 ]]; then
            delta --paging=never --width="$pager_width" | LESS= less -R
        else
            delta --paging=never
        fi
    }
    render_status=$?
    command rm -f "$diff_file"
    return "$render_status"
}
alias gpl="git pull"
alias gps="git push"
alias merge='git mergetool'

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

# show env
alias p="printenv | fzf --multi | pbcopy"

#else
alias gcc="gcc-5"
# alias proc="ps aux| grep "
alias task='/Users/edte/asynctasks.vim/bin/asynctask -f'
# alias q='exit'
alias quit='exit'

alias codex="codex --dangerously-bypass-approvals-and-sandbox"
alias codex-internal="codex-internal --dangerously-bypass-approvals-and-sandbox"

alias i="brew install "

# 常用的配置文件
alias gsh="git show --date=format-local:'%Y-%m-%d %H:%M:%S'"
alias gshow="git show --date=format-local:'%Y-%m-%d %H:%M:%S'"
# https://devhints.io/git-log-format
# alias glog="git log --graph --pretty=format:'%>|(12,trunc)%Cred%h%Creset  -  %C(yellow)%<(60,trunc)%s%Creset %Cgreen%<(30,trunc)%d %C(bold blue)%<(15,trunc)%an%Creset%>(1)%>(50)%cd' --date=format-local:'%Y-%m-%d %H:%M:%S'"
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

# brew tap universal-ctags/universal-ctags
# brew install --HEAD universal-ctags
alias ctags="$(brew --prefix)/bin/ctags --recurse=yes"

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
