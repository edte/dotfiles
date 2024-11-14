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
    cd ~/dotfiles/
    git add .
    git commit -m "update"
    git push origin master
}

function update() {
    cd ~
    mv gongfeng-copilot-vim-latest.tar.gz gongfeng-copilot-vim-latest.tar.gz.bk
    wget https://mirrors.tencent.com/repository/generic/gongfeng-copilot/vim/gongfeng-copilot-vim-latest.tar.gz
    tar -xzvf gongfeng-copilot-vim-latest.tar.gz
    cp -r vim/ copilot
    cd copilot
    git add .
    git commit -m "update"
    git push origin master
    brew install --cask squirrel
    bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)
    zinit self-update
    zinit update --parallel
    brew upgrade neovim
    brew update
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
