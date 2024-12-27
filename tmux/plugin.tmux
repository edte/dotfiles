#!/bin/zsh

# -- plugin ---------------------------------------------------------------------------------------------------------
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'edte/tmux-fzf'

# https://github.com/tmux-plugins/tmux-resurrect/blob/master/docs/restoring_previously_saved_environment.md
# 存在 /Users/edte/.local/share/tmux/resurrect

set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

run -b '~/.tmux/plugins/tpm/tpm'
