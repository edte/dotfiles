# 开启 ZSH 自带的自动补全：
setopt AUTO_PUSHD

# export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"

export LANGUAGE=en_US
export LANG=en_US.UTF-8

export PATH=/home/edte/.local/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
# export HTTP_PROXY=
# export HTTPS_PROXY=
# export NO_PROXY="localhost,127.0.0.1"
# export http_proxy=$HTTP_PROXY
# export https_proxy=$HTTPS_PROXY
# export no_proxy=$NO_PROXY

export GOPATH=/Users/edte/go
export GOBIN=/Users/edte/go/bin
export PATH=$PATH:$GOPATH/bin

export PATH=$PATH:/Users/edte/nvim-macos-arm64/bin

export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

export PATH=/Users/edte/.local/bin:$PATH
export PATH=/usr/local/bin:$PATH

# #oh my zsh 内置了安全功能、避免 oh my zsh 插件使用不安全的目录和文件，但是这意味着插件在加载时需要通过一系列 security checker。通过禁用安全功能 （export ZSH_DISABLE_COMPFIX="true"）可以使 zsh 启动速度加快 0.06s。微不足道，但值得一试。
export ZSH_DISABLE_COMPFIX="true"

# export DYLD_LIBRARY_PATH=/usr/local/lib

# export LIBRIME_LIB_DIR=/usr/local/lib
# export LIBRIME_INCLUDE_DIR=/usr/local/include

# export BOOST_ROOT="$(pwd)/deps/boost-1.84.0"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#586e75'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#2cfc03'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=#fc0303'
export HISTORY_SUBSTRING_SEARCH_PREFIXED=1

# export YSU_MESSAGE_POSITION="after"
# export YSU_MESSAGE_FORMAT="%alias_type %command: %alias"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

export ESCDELAY=0

export PATH=~/.local/bin/:$PATH

# export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# source <(fzf --zsh)

# export PNPM_HOME="/Users/edte/Library/pnpm"
# case ":$PATH:" in
# *":$PNPM_HOME:"*) ;;
# *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
