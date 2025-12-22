-- Lua 版本的 matchquote 插件
-- 功能: 增强 % 快捷键，支持引号匹配和括号匹配
-- 优点: 直接通过 Lua 回调，不进入命令行模式

local M = {}

local QUOTES = { '"', "'", "`", "|" }

--- 回退到原生 % 功能（括号匹配）
--- @param mode string 'n' 为 normal，'x' 为 visual
local function fallback_to_builtin(mode)
	if mode == "n" then
		vim.cmd("normal! %")
	else
		vim.cmd("normal! gv%")
	end
end

--- 获取光标下的字符
--- @return string 字符内容
local function get_char_at_cursor()
	local col = vim.fn.col(".")
	local line = vim.fn.getline(".")
	if col > #line then
		return ""
	end
	return line:sub(col, col)
end

--- 检查字符是否是引号
--- @param char string 字符
--- @return boolean
local function is_quote(char)
	for _, quote in ipairs(QUOTES) do
		if char == quote then
			return true
		end
	end
	return false
end

--- 计算字符在行中出现的次数（从行首到光标）
--- @param line string 行内容
--- @param char string 要查找的字符
--- @return number 出现次数
local function count_char_before_cursor(line, char)
	local col = vim.fn.col(".")
	local part = line:sub(1, col - 1)
	local count = 0
	for i = 1, #part do
		if part:sub(i, i) == char then
			count = count + 1
		end
	end
	return count
end

--- 匹配引号
--- @param mode string 'n' 为 normal，'x' 为 visual
local function match_quote(mode)
	-- 保存当前位置标记
	vim.cmd("normal! m'")

	if mode == "x" then
		vim.cmd("normal! gv")
	end

	local char = get_char_at_cursor()

	if not is_quote(char) then
		fallback_to_builtin(mode)
		return
	end

	local line = vim.fn.getline(".")

	-- 计算整行中该引号出现的总次数
	local total_count = 0
	for i = 1, #line do
		if line:sub(i, i) == char then
			total_count = total_count + 1
		end
	end

	-- 如果该引号在行中出现次数为奇数，不处理
	if total_count % 2 == 1 then
		return
	end

	-- 计算光标前该引号出现的次数
	local count_before = count_char_before_cursor(line, char)

	-- 根据奇偶性决定查找方向
	local is_forward = count_before % 2 == 0

	-- 跳转到匹配的引号
	-- 使用 feedkeys 来避免字符转义问题
	if is_forward then
		vim.fn.feedkeys("f" .. char, "n")
	else
		vim.fn.feedkeys("F" .. char, "n")
	end

	if mode == "x" then
		vim.cmd("normal! m>gv")
	end
end

--- 处理 % 按键
local function handle_percent()
	match_quote("n")
end

--- 处理 visual 模式下的 %
local function handle_percent_visual()
	match_quote("x")
end

--- 初始化插件
function M.setup()
	-- normal 模式
	vim.keymap.set("n", "%", handle_percent, { noremap = true, silent = true })

	-- visual 模式
	vim.keymap.set("x", "%", handle_percent_visual, { noremap = true, silent = true })

	-- operator pending 模式
	vim.keymap.set("o", "%", function()
		vim.cmd("normal! v%")
	end, { noremap = true, silent = true })
end

return M
