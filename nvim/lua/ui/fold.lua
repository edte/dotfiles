local M = {}

-- :mkview,  Vim 并不会自动记忆手工折叠。但你可以使用以下命令，来保存当前的折叠状态：
-- :loadview, 在下次打开文档时，使用以下命令，来载入记忆的折叠信息：
-- zo 打开折叠文本
-- zc 关闭折叠
-- za 切换折叠。
-- zr	打开所有折叠
-- zR	打开所有折叠及其嵌套的折叠
-- zm	关闭所有折叠
-- zM	关闭所有折叠及其嵌套的折叠
-- zd	删除当前折叠
-- zE	删除所有折叠
-- zj	移动至下一个折叠
-- zk	移动至上一个折叠
-- zn	禁用折叠
-- zN	启用折叠

-- 手工折叠
-- zf, 后面跟文本对象
-- set foldmethod=manual

--  缩进折叠
-- :set foldmethod=indent

--  表达折叠
-- :set foldmethod=expr

--  语法折叠
-- :set foldmethod=syntax

--  差异 diff折叠
-- foldmethod=diff

--  标记折叠
-- :set foldmethod=marker
-- Vim 将 {{{和}}} 视为折叠指示符，并折叠它们之间的文本。通过标记折叠，Vim 会查找由'foldmarker' 选项定义的特殊标记来标记折叠区域。要查看 Vim 使用的标记，请运行：
-- :set foldmarker?

M.Opts = {
	-- INFO: Uncomment to use treeitter as fold provider, otherwise nvim lsp is used
	-- provider_selector = function(bufnr, filetype, buftype)
	--   return { "treesitter", "indent" }
	-- end,
	open_fold_hl_timeout = 400,
	close_fold_kinds_for = { "imports", "comment" },
	preview = {
		win_config = {
			border = { "", "─", "", "", "", "─", "", "" },
			-- winhighlight = "Normal:Folded",
			winblend = 0,
		},
		mappings = {
			scrollU = "<C-u>",
			scrollD = "<C-d>",
			jumpTop = "[",
			jumpBot = "]",
		},
	},
}

M.init = function()
	-- 'foldcolumn' 是一个数字，它设置一侧的列的宽度
	-- 窗口来指示折叠。当它为零时，没有折叠列。一个正常的 值为自动：9。最大值为 9。
	vim.o.foldcolumn = "1"

	-- “foldlevel”是一个数字选项：越高，打开的折叠区域越多。
	-- 当 'foldlevel' 为 0 时，所有折叠均关闭。
	-- 当“foldlevel”为正值时，某些折叠会关闭。
	-- 当“foldlevel”非常高时，所有折叠都会打开。
	-- 'foldlevel' 在更改时应用。  之后手动折叠即可 打开和关闭。
	-- 当增加时，新水平之上的折叠将打开。  无需手动打开 折叠将被关闭。
	-- 当减少时，新水平之上的折叠将关闭。  无需手动关闭 折叠将被打开。
	vim.o.foldlevel = 99
	vim.o.foldlevelstart = 99

	-- 在未设置时打开所有折叠
	vim.o.foldenable = true

	-- 打开的折叠由顶部有 “-” 和 “|” 的列表示
	-- 下面的字符。该列在打开折叠停止的地方停止。折叠时
	-- 嵌套，嵌套折叠是它所包含的折叠右侧的一个字符。
	-- 闭合折叠用 “+” 表示。
	-- 这些字符可以使用 “fillchars” 选项进行更改。

	-- item		default		Used for ~
	-- stl		' '		statusline of the current window
	-- stlnc	' '		statusline of the non-current windows
	-- wbr		' '		window bar
	-- horiz	'─' or '-'	horizontal separators |:split|
	-- horizup	'┴' or '-'	upwards facing horizontal separator
	-- horizdown	'┬' or '-'	downwards facing horizontal separator
	-- vert		'│' or '|'	vertical separators |:vsplit|
	-- vertleft	'┤' or '|'	left facing vertical separator
	-- vertright	'├' or '|'	right facing vertical separator
	-- verthoriz	'┼' or '+'	overlapping vertical and horizontal
	-- 		separator
	-- fold		'·' or '-'	filling 'foldtext'
	-- foldopen	'-'		mark the beginning of a fold
	-- foldclose	'+'		show a closed fold
	-- foldsep	'│' or '|'      open fold middle marker
	-- diff		'-'		deleted lines of the 'diff' option
	-- msgsep	' '		message separator 'display'
	-- eob		'~'		empty lines at the end of a buffer
	-- lastline	'@'		'display' contains lastline/truncate
	vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
end

-- 延迟加载
M.config = function(_, opts)
	local handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local totalLines = vim.api.nvim_buf_line_count(0)
		local foldedLines = endLnum - lnum
		local suffix = (" 󰁂 %d "):format(endLnum - lnum)
		local sufWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - sufWidth
		local curWidth = 0
		for _, chunk in ipairs(virtText) do
			local chunkText = chunk[1]
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, chunk)
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				local hlGroup = chunk[2]
				table.insert(newVirtText, { chunkText, hlGroup })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				-- str width returned from truncate() may less than 2nd argument, need padding
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end
		local rAlignAppndx = math.max(math.min(vim.api.nvim_win_get_width(0), width - 1) - curWidth - sufWidth, 0)
		suffix = (" "):rep(rAlignAppndx) .. suffix
		table.insert(newVirtText, { suffix, "MoreMsg" })
		return newVirtText
	end
	opts["fold_virt_text_handler"] = handler
	require("ufo").setup(opts)
	vim.keymap.set("n", "zr", require("ufo").openAllFolds)
	vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

	vim.cmd([[set viewoptions-=curdir]])

	-- remember folds
	-- vim.cmd([[
	--        augroup remember_folds
	--        autocmd!
	--        autocmd BufWinLeave *.* mkview
	--        autocmd BufWinEnter *.* silent! loadview
	--        augroup END
	--        ]])
end

return M
