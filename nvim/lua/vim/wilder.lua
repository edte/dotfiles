local M = {}

local function get_tiny_cmdline_win_config()
	local ok, ui2 = pcall(require, 'vim._core.ui2')
	if not ok or type(ui2) ~= 'table' or type(ui2.wins) ~= 'table' then
		return nil
	end

	local win = ui2.wins.cmd
	if not win or not vim.api.nvim_win_is_valid(win) then
		return nil
	end

	local config = vim.api.nvim_win_get_config(win)
	local row = tonumber(config.row)
	local col = tonumber(config.col)
	if row == nil or col == nil then
		return nil
	end

	return {
		row = row,
		col = col,
	}
end

local function tiny_cmdline_popup_position(_, pos, dimensions)
	local anchor = vim.g.ui_cmdline_pos
	local cols = vim.o.columns
	local lines = vim.o.lines
	local cmdline_win = get_tiny_cmdline_win_config()

	if cmdline_win ~= nil then
		local cmdline_height = 1
		local ok, ui2 = pcall(require, 'vim._core.ui2')
		if ok and type(ui2) == 'table' and type(ui2.wins) == 'table' then
			local win = ui2.wins.cmd
			if win and vim.api.nvim_win_is_valid(win) then
				cmdline_height = vim.api.nvim_win_get_height(win)
			end
		end
		local row = cmdline_win.row + cmdline_height + 1
		local col = cmdline_win.col
		if col + dimensions.width > cols then
			col = cols - dimensions.width
		end

		return {
			math.max(0, row),
			math.max(0, col),
		}
	end

	if type(anchor) ~= 'table' or #anchor < 2 then
		local cmdheight = vim.o.cmdheight
		local row = lines - cmdheight - dimensions.height
		local col = math.min(pos % cols, math.max(0, cols - dimensions.width))
		return { math.max(0, row), math.max(0, col) }
	end

	local row = anchor[1] + 1
	local col = anchor[2] - 4

	if col + dimensions.width > cols then
		col = cols - dimensions.width
	end

	return {
		math.max(0, row),
		math.max(0, col),
	}
end

M.setup = function()
	local wilder = Require('wilder')
	if wilder == nil then
		return
	end
	wilder.event = 'CmdlineEnter' -- 懒加载：首次进入cmdline时载入

	wilder.setup({
		modes = { ':', '/', '?' },
		next_key = 0,
		previous_key = 0,
		reject_key = 0,
		accept_key = 0,
	})
	api.nvim_command('silent! UpdateRemotePlugins') -- 需要载入一次py依赖 不然模糊过滤等失效

	-- 设置source
	wilder.set_option('pipeline', {
		wilder.branch(
			-- 在替换命令中为搜索部分提供搜索建议
			wilder.substitute_pipeline({
				pipeline = wilder.python_search_pipeline({
					skip_cmdtype_check = 1,
					pattern = wilder.python_fuzzy_pattern({
						start_at_boundary = 0,
					}),
				}),
			}),

			-- 当输入文件名时 展示文件名
			wilder.python_file_finder_pipeline({
				file_command = function(ctx, arg)
					if string.find(arg, '.') ~= nil then
						return { 'fd', '-tf', '-H' }
					else
						return { 'fd', '-tf' }
					end
				end,
				dir_command = { 'fd', '-td' },
				filters = { 'fuzzy_filter' },
			}),

			-- 当默认无输入时 展示10条历史记录
			{
				wilder.check(function(_, x)
					return vim.fn.empty(x)
				end),
				wilder.history(10),
			},
			-- 当输入时 展示所有匹配项(模糊匹配)
			wilder.cmdline_pipeline({
				fuzzy = 2,
				fuzzy_filter = wilder.vim_fuzzy_filter(),
				set_pcre2_pattern = 1,
			}),
			-- pipeline for search
			-- wilder.search_pipeline({
			-- 	-- 去抖动
			-- 	debounce = 10,
			-- }),

			wilder.python_search_pipeline({
				pattern = wilder.python_fuzzy_pattern({
					start_at_boundary = 0,
				}),
			})
		),
	})
	-- 设置样式
	wilder.set_option(
		'renderer',
		wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
			position = tiny_cmdline_popup_position,
			border = 'single',
			-- 设置特定高亮
			highlights = {
				default = 'WilderThemeNormal',
				selected = 'WilderThemeSelection',
				border = 'WilderThemeBorder',
				accent = 'WilderAccent',
				selected_accent = 'WilderSelectedAccent',
			},
			highlighter = wilder.basic_highlighter(),
			left = { ' ', wilder.popupmenu_devicons() },
			right = {
				' ',
				wilder.popupmenu_scrollbar({
					thumb_hl = 'WilderThemeThumb',
					scrollbar_hl = 'WilderThemeScrollbar',
				}),
			},
			max_height = 17, -- 最大高度限制 因为要计算上下 所以17支持最多15个选项
			pumblend = 0,
		}))
	)

	-- wilder.set_option(
	-- 	"renderer",
	-- 	wilder.popupmenu_renderer(wilder.popupmenu_palette_theme({
	-- 		-- 'single', 'double', 'rounded' or 'solid'
	-- 		-- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
	-- 		-- border = "rounded",
	-- 		-- max_height = "75%", -- max height of the palette
	-- 		min_height = 0, -- set to the same as 'max_height' for a fixed height window
	-- 		prompt_position = "top", -- 'top' or 'bottom' to set the location of the prompt
	-- 		reverse = 0, -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
	--
	-- 		highlights = {
	-- 			accent = "WilderAccent",
	-- 			selected_accent = "WilderSelectedAccent",
	-- 		},
	-- 		highlighter = wilder.basic_highlighter(),
	-- 		left = { " ", wilder.popupmenu_devicons() }, -- 左侧加入icon
	-- 		right = { " ", wilder.popupmenu_scrollbar() }, -- 右侧加入滚动条
	-- 		border = "rounded",
	-- 		max_height = 17, -- 最大高度限制 因为要计算上下 所以17支持最多15个选项
	-- 		--设置pumblend选项来更改弹出菜单的透明度
	-- 		pumblend = 0,
	-- 	}))
	-- )

	-- 设置快捷键
	cmap('<tab>', [[wilder#in_context() ? wilder#next() : '<tab>']], { noremap = true, expr = true })
	cmap('<Down>', [[wilder#in_context() ? wilder#next() : '<down>']], { noremap = true, expr = true })
	cmap('<up>', [[wilder#in_context() ? wilder#previous() : '<up>']], { noremap = true, expr = true })
	vim.cmd([[cnoremap <Esc> <C-C>]])

	cmap('0', '0', {}) -- 不清楚原因导致0无法使用 强制覆盖

	-- 禁用纯数字输入时的wilder补全
	cmd([[
		augroup WilderCustom
			autocmd!
			autocmd CmdlineChanged : call s:disable_wilder_for_numeric()
			autocmd CmdlineChanged : call s:enable_search_in_substitute()
		augroup END
	]])

	-- 在VimScript中定义禁用函数
	cmd([[
		function! s:disable_wilder_for_numeric()
			let l:cmdline = getcmdline()
			if l:cmdline =~# '^\d\+$'
				call wilder#disable()
			else
				call wilder#enable()
			endif
		endfunction
	]])

	-- 在替换命令中启用搜索补全
	cmd([[
		function! s:enable_search_in_substitute()
			let l:cmdline = getcmdline()
			" 检查是否是替换命令 s/ 并且在第一个/之后
			if l:cmdline =~# '^%%\?s/' && l:cmdline !~# '^%%\?s/[^/]*//'
				" 在替换模式的第一个/之后，光标位置在第二个/之前
				" 这时候应该启用搜索补全，但由于wilder没有直接的搜索管道切换
				" 我们可以通过其他方式实现
			endif
		endfunction
	]])

	-- 保留你原来的红色匹配高亮，只去掉边框，不改匹配色。
	highlight('WilderAccent', '#FF4500')
	highlight('WilderSelectedAccent', '#FF4500', '#4e4e4e')

	cmd("call wilder#set_option('noselect', 1)")
end

return M
