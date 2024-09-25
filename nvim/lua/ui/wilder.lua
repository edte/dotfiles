local M = {}

M.config = function()
	local wilder = try_require("wilder")
	if wilder == nil then
		return
	end
	wilder.event = "CmdlineEnter" -- 懒加载：首次进入cmdline时载入

	wilder.setup({
		modes = { ":", "/", "?" },
		next_key = 0,
		previous_key = 0,
		reject_key = 0,
		accept_key = 0,
	})
	vim.api.nvim_command("silent! UpdateRemotePlugins") -- 需要载入一次py依赖 不然模糊过滤等失效
	-- 设置source
	wilder.set_option("pipeline", {
		wilder.branch(
			-- 当默认无输入时 展示15条历史记录
			{
				wilder.check(function(_, x)
					return vim.fn.empty(x)
				end),
				wilder.history(10),
			},
			-- 当输入时 展示所有匹配项(模糊匹配)
			wilder.cmdline_pipeline({
				fuzzy = 1,
				fuzzy_filter = wilder.vim_fuzzy_filter(),
			}),
			-- pipeline for search
			wilder.search_pipeline()
		),
	})
	-- 设置样式
	wilder.set_option(
		"renderer",
		wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
			-- 设置特定高亮
			highlights = {
				accent = "WilderAccent",
				selected_accent = "WilderSelectedAccent",
			},
			highlighter = wilder.basic_highlighter(),
			left = { " ", wilder.popupmenu_devicons() }, -- 左侧加入icon
			right = { " ", wilder.popupmenu_scrollbar() }, -- 右侧加入滚动条
			border = "rounded",
			max_height = 17, -- 最大高度限制 因为要计算上下 所以17支持最多15个选项
			pumblend = 0,
		}))
	)
	-- 设置快捷键
	vim.api.nvim_set_keymap(
		"c",
		"<tab>",
		[[wilder#in_context() ? wilder#next() : '<tab>']],
		{ noremap = true, expr = true }
	)
	vim.api.nvim_set_keymap(
		"c",
		"<Down>",
		[[wilder#in_context() ? wilder#next() : '<down>']],
		{ noremap = true, expr = true }
	)
	vim.api.nvim_set_keymap(
		"c",
		"<up>",
		[[wilder#in_context() ? wilder#previous() : '<up>']],
		{ noremap = true, expr = true }
	)
	vim.api.nvim_set_keymap("c", "0", "0", {}) -- 不清楚原因导致0无法使用 强制覆盖

	-- 设置高亮
	vim.api.nvim_set_hl(0, "WilderAccent", { fg = "#FF4500" })
	vim.api.nvim_set_hl(0, "WilderSelectedAccent", { fg = "#FF4500", bg = "#4e4e4e" })

	vim.cmd("call wilder#set_option('noselect', 0)")
end

return M
