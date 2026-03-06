-- 最大高亮单词长度
local MAX_LEN = 64
local window_matches = {} -- 记录每个窗口的匹配ID
local han_regex = vim.regex([[\p{Han}]])

local function is_han_char(char)
	return char ~= '' and han_regex:match_str(char) ~= nil
end

local function get_han_word(line, column)
	local char_index = vim.fn.charidx(line, column)
	local char = vim.fn.strcharpart(line, char_index, 1)

	if not is_han_char(char) then
		return ''
	end

	local start_index = char_index
	while start_index > 0 do
		local prev_char = vim.fn.strcharpart(line, start_index - 1, 1)
		if not is_han_char(prev_char) then
			break
		end
		start_index = start_index - 1
	end

	local total_chars = vim.fn.strchars(line)
	local end_index = char_index
	while end_index + 1 < total_chars do
		local next_char = vim.fn.strcharpart(line, end_index + 1, 1)
		if not is_han_char(next_char) then
			break
		end
		end_index = end_index + 1
	end

	return vim.fn.strcharpart(line, start_index, end_index - start_index + 1)
end

-- 高亮当前光标下的单词（支持打开的所有window）
local function matchadd()
	if vim.bo.filetype == '' then
		return
	end

	-- step1: 获取当前光标位置的单词
	local column = vim.api.nvim_win_get_cursor(0)[2]
	local line = vim.api.nvim_get_current_line()
	local cursorword = get_han_word(line, column)
	local use_keyword_boundary = cursorword == ''

	if use_keyword_boundary then
		local left = vim.fn.matchstr(line:sub(1, math.min(column + 1, #line)), [[\k*$]])
		local right = vim.fn.matchstr(line:sub(math.min(column + 1, #line)), [[^\k*]]):sub(2)
		cursorword = left .. right
	end

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

	-- step5: 如果单词为空或者单词过长，则不需要更新
	if cursorword == '' or #cursorword > MAX_LEN then
		return
	end

	-- 检查 cursorword 是否为有效的正则表达式，转义特殊字符
	cursorword = vim.fn.escape(cursorword, '\\^$.*~[]')
	if cursorword == '' then
		return
	end

	local pattern = cursorword
	if use_keyword_boundary then
		pattern = [[\<]] .. cursorword .. [[\>]]
	end

	-- 为所有窗口的对应缓冲区添加高亮
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)

		if vim.bo[buf].filetype ~= '' or vim.bo[buf].buftype ~= '' then
			-- 添加窗口匹配并记录ID
			if cursorword and cursorword ~= '' then -- 确保 cursorword 有效
				pcall(function()
					local match_id = vim.fn.matchadd('CursorWord', pattern, -1, -1, { window = win })
					window_matches[win] = match_id
				end)
			end
		end
	end
end

-- 定义高亮组
vim.api.nvim_set_hl(0, 'CursorWord', { underline = true })

-- 自动命令
Autocmd({ 'CursorMoved', 'CursorMovedI', 'VimEnter' }, {
	group = GroupId('cursorword', { clear = true }),
	callback = matchadd,
})

-- 分屏的时候也支持下
Autocmd({ 'WinNew' }, {
	group = GroupId('cursorword-wn', { clear = true }),
	callback = function(args)
		local win = vim.fn.win_getid()

		if vim.g.cursorword_global == nil or vim.g.cursorword_global == '' then
			return
		end

		local escaped_word = vim.fn.escape(vim.g.cursorword_global, '\\^$.*~[]')
		if escaped_word ~= '' then
			local pattern = escaped_word
			if not is_han_char(vim.fn.strcharpart(vim.g.cursorword_global, 0, 1)) then
				pattern = [[\<]] .. escaped_word .. [[\>]]
			end
			local match_id = vim.fn.matchadd('CursorWord', pattern, -1, -1, { window = win })
			window_matches[win] = match_id
		end
	end,
})
