if vim.env.Test then
    return
end


-- 最大高亮单词长度
local MAX_LEN = 64
local window_matches = {} -- 记录每个窗口的匹配ID

function has_non_ascii(s)
	for c in s:gmatch(".") do
		if string.byte(c) > 127 then
			return true
		end
	end
	return false
end

-- 高亮当前光标下的单词（支持打开的所有window）
local function matchadd()
	if vim.bo.filetype == "" then
		return
	end

	-- step1: 获取当前光标位置的单词
	local column = vim.api.nvim_win_get_cursor(0)[2]
	local line = vim.api.nvim_get_current_line()
	local left = vim.fn.matchstr(line:sub(1, math.min(column + 1, #line)), [[\k*$]])
	local right = vim.fn.matchstr(line:sub(math.min(column + 1, #line)), [[^\k*]]):sub(2)
	local cursorword = left .. right

	-- step2: 如果单词没有变化，则不需要更新
	if cursorword == vim.g.cursorword_global then
		return
	end

	-- step3: 存储全局光标单词
	vim.g.cursorword_global = cursorword

	-- step4: 清理所有窗口旧高亮
	-- 只清除我们创建的matchadd匹配
	for win, match_id in pairs(window_matches) do
		if vim.api.nvim_win_is_valid(win) then
			pcall(vim.fn.matchdelete, match_id, win)
		end
	end
	window_matches = {} -- 重置记录表

	-- step5: 如果单词为空，或者单词过长，或者包含非ASCII字符，则不需要更新
	if cursorword == "" or #cursorword > MAX_LEN then
		return
	end

	if has_non_ascii(cursorword) then
		return
	end

	-- 检查 cursorword 是否为有效的正则表达式
	if string.find(cursorword, "~") then
		return -- 如果是无效字符，直接返回
	end

	-- 为所有窗口的对应缓冲区添加高亮
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)

		if vim.bo[buf].filetype ~= "" or vim.bo[buf].buftype ~= "" then
			-- 添加窗口匹配并记录ID
			if cursorword and cursorword ~= "" then -- 确保 cursorword 有效
				local match_id = vim.fn.matchadd("CursorWord", [[\<]] .. cursorword .. [[\>]], -1, -1, { window = win })
				window_matches[win] = match_id
			end
		end
	end
end

-- 定义高亮组
vim.api.nvim_set_hl(0, "CursorWord", { underline = true })

-- 自动命令
Autocmd({ "CursorMoved", "CursorMovedI", "VimEnter" }, {
	group = GroupId("cursorword", { clear = true }),
	callback = matchadd,
})

-- 分屏的时候也支持下
Autocmd({ "WinNew" }, {
	group = GroupId("cursorword-wn", { clear = true }),
	callback = function(args)
		local win = vim.fn.win_getid()

		if vim.g.cursorword_global == nil then
			return
		end

		local match_id =
			vim.fn.matchadd("CursorWord", [[\<]] .. vim.g.cursorword_global .. [[\>]], -1, -1, { window = win })
		window_matches[win] = match_id
	end,
})
