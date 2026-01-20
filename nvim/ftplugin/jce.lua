-- JCE 折叠表达式函数 (全局函数，只需定义一次)
-- 使用缩进来判断折叠层级，支持嵌套结构
if not _G.JceFoldExpr then
	function _G.JceFoldExpr()
		local lnum = vim.v.lnum
		local line = vim.fn.getline(lnum)

		-- 空行保持上一行的折叠级别
		if line:match("^%s*$") then
			return "="
		end

		-- 计算当前行的缩进级别（用 4 空格或 1 tab 作为一个层级）
		local function get_indent_level(l)
			local indent = l:match("^(%s*)")
			-- 将 tab 转换为 4 空格计算
			local expanded = indent:gsub("\t", "    ")
			return math.floor(#expanded / 4)
		end

		local indent_level = get_indent_level(line)

		-- 检查是否是块的开始行（包含 { 的行）
		-- 匹配: module xxx {, struct xxx {, enum xxx {, interface xxx {
		local is_block_start = line:match("^%s*module%s+")
			or line:match("^%s*struct%s+")
			or line:match("^%s*enum%s+")
			or line:match("^%s*interface%s+")

		if is_block_start then
			-- 如果同一行有 { 则开始折叠
			if line:match("{%s*$") then
				return ">" .. (indent_level + 1)
			end
			-- 检查下一行是否是单独的 {
			local next_line = vim.fn.getline(lnum + 1)
			if next_line:match("^%s*{%s*$") then
				return ">" .. (indent_level + 1)
			end
		end

		-- 单独一行的 { (紧跟在 module/struct/enum/interface 声明之后)
		if line:match("^%s*{%s*$") then
			local prev_line = vim.fn.getline(lnum - 1)
			if
				prev_line:match("^%s*module%s+")
				or prev_line:match("^%s*struct%s+")
				or prev_line:match("^%s*enum%s+")
				or prev_line:match("^%s*interface%s+")
			then
				return get_indent_level(prev_line) + 1
			end
		end

		-- 检查是否是块的结束行 };
		if line:match("^%s*};%s*$") then
			return "<" .. (indent_level + 1)
		end

		-- 保持当前折叠级别
		return "="
	end
end

-- 加载插件 (只需一次)
if not vim.g.jce_loaded then
	vim.g.jce_loaded = true
	vim.pack.add({
		{ src = "https://github.com/edte/jce-highlight.git" },
	}, { confirm = false })
end

-- JCE 语法折叠配置 (每个 buffer 都需要设置)
-- 使用 vim.schedule 确保在所有其他初始化之后执行
vim.schedule(function()
	vim.wo.foldmethod = "expr"
	vim.wo.foldexpr = "v:lua.JceFoldExpr()"
	vim.wo.foldlevel = 99
end)
