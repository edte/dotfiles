#!/bin/zsh

# -- system keymap ---------------------------------------------------------------------------------------------------------
bind r source-file ~/.tmux.conf \; display-message "Config reloaded.."     # 重载配置

bind-key -n "c-q" kill-server

# Ctrl+b	?	显示快捷键帮助文档
# Ctrl+b	:	进入命令行模式，此时可直接输入 ls 等命令

# 用于电脑断电等时候保存 tmux
# prefix ctrl+s:  保存所有 session
# prefix ctrl+r:  恢复所有 session

# -- session keymap ---------------------------------------------------------------------------------------------------------
# Ctrl+b	d	断开当前会话
# Ctrl+b	D	选择要断开的会话
# Ctrl+b	Ctrl+z	挂起当前会话
# Ctrl+b	s	显示会话列表用于选择并切换

# create session
bind C-t command-prompt -p "Enter new session name: " "new-session -s '%%'"

bind s choose-tree -sZ -O name

bind-key    -T prefix       \$                   command-prompt -I "#S" { rename-session "%%" }

# -- window keymap ---------------------------------------------------------------------------------------------------------
# Ctrl+b	0~9	切换到指定窗口
# Ctrl+b	w	打开窗口列表，用于且切换窗口
# Ctrl+b	,	重命名当前窗口
# Ctrl+b	.	修改当前窗口编号（适用于窗口重新排序）
# Ctrl+b	f	快速定位到窗口（输入关键字匹配窗口名称

bind t new-window           # 新建窗口

bind i  swap-window -t -1
bind o  swap-window -t +1

bind-key w run-shell 'tmux choose-tree -Nwf"##{==:##{session_name},#{session_name}}"'


# -- pane keymap ---------------------------------------------------------------------------------------------------------
# Ctrl+b	;	切换到最后一次使用的面板
# Ctrl+b	空格键	在自带的面板布局中循环切换

# bind h splitw -v -c '#{pane_current_path}' # 水平方向新增面板，默认进入当前目录
bind v splitw -h -c '#{pane_current_path}'   # 垂直方向新增面板，默认进入当前目录

#bind c     kill-pane                         # 关闭当前面板
bind-key c confirm-before "kill-pane"


bind-key    -T prefix  m  resize-pane -Z     # 最大化当前面板，再重复一次按键后恢复正常
# bind > swap-pane -D                          # 向前置换当前面板
# bind < swap-pane -U                          # 向前置换当前面板
bind -r h select-pane -L                     # move left
bind -r j select-pane -D                     # move down
bind -r k select-pane -U                     # move up
bind -r l select-pane -R                     # move right

set -g repeat-time 10

# -- copy mode keymap ---------------------------------------------------------------------------------------------------------
bind Enter copy-mode        # enter copy mode

bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi C-v send -X rectangle-toggle
bind -T copy-mode-vi y send -X copy-selection-and-cancel
bind -T copy-mode-vi Escape send -X cancel
bind -T copy-mode-vi H send -X start-of-line
bind -T copy-mode-vi L send -X end-of-line


# -- unbind keymap ---------------------------------------------------------------------------------------------------------
unbind b
unbind %
unbind x
unbind n
unbind p
unbind &
unbind space
# unbind ;
# unbind L
