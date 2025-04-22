if vim.env.Test then
    return
end

-- tmux 状态栏和vim 状态栏同步
Autocmd({ "VimLeavePre", "FocusLost", "VimSuspend" }, {
	group = GroupId("tmux-status-on", { clear = true }),
	callback = function()
		local p = vim.system({ "tmux", "set", "status", "on" }):wait()
		assert(p.code == 0, p.stderr)
	end,
})

Autocmd({ "FocusGained", "VimResume" }, {
	group = GroupId("tmux-status-off", { clear = true }),
	callback = function()
		local p = vim.system({ "tmux", "set", "status", "off" }):wait()
		assert(p.code == 0, p.stderr)
	end,
})

local p = vim.system({ "tmux", "set", "status", "off" }):wait()
assert(p.code == 0, p.stderr)
