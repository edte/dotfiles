# ----------------- plugins ------------------------------------------------------------------------------------------------------------
# TODO:
# 1. 键入字符时，自动补全文件，目录，函数，命令flag
# 2. 按tab循环选择
# 3. 补全模式下，按↑ ↓ ← →	移动选择
# 4. 默认模式下，按↑ ↓出现历史
# 5. 使用ctrl+r，用fzf套搜索历史
# 6. 输入部分命令时，按 ↑ ↓ 补全相同前缀的历史命令
# 7. 按 z 后，下面会自动显示历史命令
# 8. 如果命令有换行符号，那么就回不了上一行了,bug

# FIX: 问题
# 1. 历史模式下，按 ↑ ↓ 不是循环的，只能暂时扩大条数
# 2. 历史模式下，按 ← → 也是移动历史，想要的是直接移动光标
# 3. 有部分前缀命令时，用 ↑ ↓ 会卡住
# 6. 用zinit安装会有问题，手动安装

# 自动补全
# zinit light marlonrichert/zsh-autocomplete
# 手动安装，用zinit安装会有点问题
if [[ ! -e ~/zsh-autocomplete ]]; then
    git clone --depth 1 -- https://github.com/edte/zsh-autocomplete.git ~/zsh-autocomplete
fi
source ~/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# 输入命令时可提示自动补全（灰色部分）
zi ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# 语法高亮
zi light zdharma/fast-syntax-highlighting

# 一个简单的 zsh 插件，用包含日期/时间的 fzf 驱动选择替换 Ctrl+R
# zinit ice lucid wait'0'
# zinit light joshskidmore/zsh-fzf-history-search
# 完成后将光标置于行尾
export ZSH_FZF_HISTORY_SEARCH_END_OF_LINE=true

# 替换，也是c-r搜索，但是功能更多
zinit load atuinsh/atuin

# 彩色man手册
zinit ice lucid wait='1'
zinit light ael-code/zsh-colored-man-pages

# 快速目录跳转
zinit ice lucid wait='1'
zinit light skywind3000/z.lua.git

# 双击esc给上一个命令加sudo
zinit ice lucid wait='1'
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

# x 解压
# zinit snippet OMZ::plugins/extract

# 该插件使用 zsh 的 command-not-found 包来在找不到命令时提供建议安装的包。
# zinit snippet OMZ::plugins/command-not-found

# zinit snippet OMZ::plugins/tmux

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git/
# 一些git的alias
# zinit snippet OMZ::plugins/git/git.plugin.zsh
# 基础git依赖，不能删
zinit snippet OMZ::lib/git.zsh

zinit ice wait atload'_history_substring_search_config' \
    ver'dont-overwrite-config'
zinit load 'ericbn/zsh-history-substring-search'

# Oh My Zsh 功能
# zinit snippet OMZ::lib/clipboard.zsh
# zinit snippet OMZ::lib/completion.zsh
# zinit snippet OMZ::lib/history.zsh
# zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::plugins/svn
zinit snippet OMZ::lib/async_prompt.zsh

# 加载 Oh My Zsh 的主题：ys
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet OMZT::ys

# 提示 alias
zinit ice lucid wait='2'
zinit light MichaelAquilina/zsh-you-should-use
