-- tmux 状态栏和vim 状态栏同步
-- 使用节流机制防止文件描述符耗尽

local tmux_timer = nil
local pending_status = nil

local function set_tmux_status(status)
	-- 如果已有待处理的相同状态，直接返回
	if pending_status == status then
		return
	end
	pending_status = status

	-- 取消之前的定时器
	if tmux_timer then
		tmux_timer:stop()
		tmux_timer:close()
		tmux_timer = nil
	end

	-- 延迟执行，合并短时间内的多次调用
	tmux_timer = vim.uv.new_timer()
	if tmux_timer then
		tmux_timer:start(
			50,
			0,
			vim.schedule_wrap(function()
				if tmux_timer then
					tmux_timer:stop()
					tmux_timer:close()
					tmux_timer = nil
				end
				-- 同步执行，避免异步进程累积
				vim.fn.system({ "tmux", "set", "status", status })
				pending_status = nil
			end)
		)
	end
end

Autocmd({ "FocusLost", "VimSuspend" }, {
	group = GroupId("tmux-status-on", { clear = true }),
	callback = function()
		set_tmux_status("on")
	end,
})

-- VimLeavePre 必须同步执行，不能用节流
Autocmd({ "VimLeavePre" }, {
	group = GroupId("tmux-status-leave", { clear = true }),
	callback = function()
		-- 取消待处理的定时器
		if tmux_timer then
			tmux_timer:stop()
			tmux_timer:close()
			tmux_timer = nil
		end
		-- 同步执行，确保退出前完成
		vim.fn.system({ "tmux", "set", "status", "on" })
	end,
})

Autocmd({ "FocusGained", "VimResume" }, {
	group = GroupId("tmux-status-off", { clear = true }),
	callback = function()
		set_tmux_status("off")
	end,
})

Autocmd({ "VimEnter" }, {
	group = GroupId("tmux-status-init", { clear = true }),
	callback = function()
		set_tmux_status("off")
	end,
})
