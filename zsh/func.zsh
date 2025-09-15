#!/bin/bash

# ----------------- func ------------------------------------------------------------------------------------------------------------
# path 复制pwd路径
function path() {
    realpath | pbcopy
}

function branch() {
    git branch --show-current | pbcopy
}

function gitbranch() {
    git branch --show-current | pbcopy
}

function backup() {
    cd ~/dotfiles/ && git add . && git commit && git push origin master && cd -
}

function commit() {
    git add .
    git commit
    git push
}

function update() {
    tmp=$(pwd)
    cd ~
    mv gongfeng-copilot-vim-latest.tar.gz gongfeng-copilot-vim-latest.tar.gz.bk
    wget https://mirrors.tencent.com/repository/generic/gongfeng-copilot/vim/gongfeng-copilot-vim-latest.tar.gz
    tar -xzvf gongfeng-copilot-vim-latest.tar.gz
    cp -r vim/ copilot
    cd copilot
    git add .
    git commit -m "update"
    git push origin master

    cd ~
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
    tar xzf nvim-macos-arm64.tar.gz

    brew install --cask squirrel
    bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)
    zinit self-update
    zinit update --parallel
    brew update
    brew upgrade

    cd $tmp
}

function tpushbuild() {
    ~/Downloads/epc build -b -r https://git.woa.com/tme/push/tpush/server --path "$1"
}

# http proxy
function unset_httpproxy() {
    unset https_proxy
    unset http_proxy
}

function ss_httpproxy() {
    export http_proxy=http://127.0.0.1:1087
    export https_proxy=http://127.0.0.1:1087
}

# shadowsocks
function ss_gitproxy() {
    git config --global http.proxy http://127.0.0.1:1087
    git config --global https.proxy https://127.0.0.1:1087
}

function gitproxy() {
    git config --global http.proxy http://127.0.0.1:1080
    git config --global https.proxy https://127.0.0.1:1080
}

function unset_gitproxy() {
    git config --global --unset http.proxy
    git config --global --unset https.proxy
}

function gt() {
    go test -v -run "$1" .
}

function difffile() {
    sort "$1" >a.file.tmp
    sort "$2" >b.file.tmp
    comm -12 a.file.tmp b.file.tmp >diff.txt
    rm -rf a.file.tmp b.file.tmp
}

function _history_substring_search_config() {
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
}

# 光标改为线格式
function zle-keymap-select zle-line-init zle-line-finish
{
    case $KEYMAP in
    vicmd) print -n '\033[1 q' ;;        # block cursor
    viins | main) print -n '\033[5 q' ;; # line cursor
    esac
}

function github_config {
    git config user.name edte
    git config user.email zzzzip6@gmail.com
}

function gs() {
    if git status &>/dev/null; then
        git status -s
    else
        ls
    fi
}

# 统计字节数
byte() {
    if [[ -f $1 ]]; then
        wc -c <"$1"
    else
        print -n -- "$1" | wc -c
    fi
}

len() {
    if [[ -f $1 ]]; then
        wc -c <"$1"
    else
        print -n -- "$1" | wc -c
    fi
}

# 统计字符数
char() {
    if [[ -f $1 ]]; then
        wc -m <"$1"
    else
        print -n -- "$1" | wc -m
    fi
}

# 统计行数
line() {
    if [[ -f $1 ]]; then
        wc -l <"$1"
    else
        print -n -- "$1" | wc -l
    fi
}

zlog() {
    rm -rf ~/test/tmp.log
    unzip -p "$1" | >~/test/tmp.log | v ~/test/tmp.log
}

gm() {
    git add .
    git commit
    git push
}
