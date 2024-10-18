#!/bin/zsh

set-environment -g PATH "/opt/homebrew/bin:/usr/local/bin:/bin:/usr/bin"

#http://louiszhai.github.io/2017/09/30/tmux/#%E7%81%B5%E6%B4%BB%E7%9A%84%E9%85%8D%E7%BD%AE%E6%80%A7

# tell Tmux that outside terminal supports true color
set-option -ga terminal-overrides ',xterm-kitty:cnorm=\E[?12h\E[?25h'
set -g default-terminal "tmux-256color"
# set-option -g default-terminal "tmux-256color"
setw -q -g utf8 on
setw -g mode-keys vi
set -sg escape-time 5
set -g status-interval 60

set-window-option -g automatic-rename off
set-option -g allow-rename off

# https://dev.to/brandonwallace/make-your-tmux-status-line-100-better-with-bash-mgf

# 整个状态栏（status bar）是由以下部分组成的：
# status-left：状态栏左侧的内容，通常包括会话名和当前窗口名。
# window-status-current-format：定义当前窗口（活动窗口）在状态栏中的显示格式。
# window-status-format：定义非当前窗口（不活动窗口）在状态栏中的显示格式。
# status-right：状态栏右侧的内容，通常包括日期、时间等其他信息。

#I：窗口索引。每个窗口都有一个唯一的索引号，它可以帮助您在多个窗口之间快速切换。
#W：窗口名。这是窗口的名称，通常显示正在运行的程序或命令。
#S：会话名。这是当前 tmux 会话的名称。

#[fg=colour222,bg=colour238] 用于设置前景色和背景色

# set -g status off

bind C-p set-option -g status

set -g status-style fg=default,bg=default
# set -g status-justify centre
set-option -g status-bg default
set-option -g status-fg colour240

set-window-option -g window-status-style fg=magenta
set-window-option -g window-status-style bg=default
set -g window-status-current-format "#[fg=black,bold bg=default]│#[fg=colour135 bg=black]#I#[fg=black,bold bg=default]│"

# 其他设置保持不变
setw -g window-status-activity-style fg='colour154',bg='colour235',none
setw -g window-status-separator ''
setw -g window-status-style fg='colour121',bg='colour235',none
set -g status-left '#[fg=colour232,bg=colour154] #S #[fg=colour154,bg=colour238,nobold,nounderscore,noitalics]'
# set -g status-left ''

# 不显示非活动窗口
setw -g window-status-format ''

# 仅显示当前窗口的名称，不显示窗口索引
setw -g window-status-current-format '#[fg=color222,bg=colour238] #W #[fg=colour238,bg=colour235]'

set -g status-right '#[fg=colour238,bg=colour235,nobold,nounderscore,noitalics]#[fg=colour222,bg=colour238] %m-%d 周%a %H:%M #[fg=colour154,bg=colour238,nobold,nounderscore,noitalics]'

set -g default-command "reattach-to-user-namespace -l $SHELL"

set -g base-index 1      # 设置窗口的起始下标为1
set -g pane-base-index 1 # 设置面板的起始下标为1
setw -g automatic-rename off
setw -g allow-rename off

set -g history-limit 200
# set-option -g mouse on # 等同于以上4个指令的效果
setw -g mouse on
set-option -g prefix2 ^ # 设置一个不常用的`键作为指令前缀，按键更快些

# https://github.com/3rd/image.nvim
set -gq allow-passthrough on
set -g visual-activity off

set-option -g focus-events on

# set -g @resurrect-strategy-vim 'session'
# set -g @resurrect-strategy-nvim 'session'

set -g @resurrect-save 'C-s'
set -g @resurrect-restore 'C-r'

# set -g @resurrect-processes 'vim nvim lvim'

set -g @continuum-save-interval '5'
set -g @continuum-restore 'on'
set -g @resurrect-capture-pane-contents 'on'

# tmux 状态栏消息仅持续约一秒：我可以延长它吗？
# set -g display-time 60
