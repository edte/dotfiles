-- tmux 状态栏和vim 状态栏同步
Autocmd({ "VimLeavePre", "FocusLost", "VimSuspend" }, {
    group = GroupId("tmux-status-on", { clear = true }),
    callback = function()
        vim.system({ "tmux", "set", "status", "on" }, {}, function() end)
    end,
})

Autocmd({ "FocusGained", "VimResume" }, {
    group = GroupId("tmux-status-off", { clear = true }),
    callback = function()
        vim.system({ "tmux", "set", "status", "off" }, {}, function() end)
    end,
})

vim.system({ "tmux", "set", "status", "off" }, {}, function() end)
