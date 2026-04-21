if vim.g.ui_loaded then
	return
end
vim.g.ui_loaded = true

-- 加载tokyonight主题
vim.pack.add({
	{ src = 'https://github.com/folke/tokyonight.nvim.git' },
}, { confirm = false })

vim.cmd.colorscheme('tokyonight')

-- tiny-cmdline 维持自己的颜色，wilder 单独用下面几组高亮。
highlight('TinyCmdlineNormal', { fg = '#c8d3f5', bg = '#1f2335' })
highlight('TinyCmdlineBorder', { fg = '#7aa2f7', bg = '#1f2335' })
highlight('TinyCmdlineSelection', { fg = '#ffffff', bg = '#3b4261', bold = true })
highlight('TinyCmdlineScrollbar', { bg = '#2a2e42' })
highlight('TinyCmdlineThumb', { bg = '#7aa2f7' })

local function get_hl_hex(names, key, fallback)
	for _, name in ipairs(names) do
		local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
		if ok and type(hl) == 'table' and hl[key] then
			return string.format('#%06x', hl[key])
		end
	end

	return fallback
end

local wilder_bg = get_hl_hex({ 'NormalFloat', 'Pmenu', 'Normal' }, 'bg', '#24283b')
local wilder_border = get_hl_hex({ 'FloatBorder', 'WinSeparator' }, 'fg', '#414868')

highlight('WilderThemeNormal', { fg = '#c8d3f5', bg = wilder_bg })
highlight('WilderThemeSelection', { fg = '#ffffff', bg = '#3b4261', bold = true })
highlight('WilderThemeScrollbar', { bg = '#2a2e42' })
highlight('WilderThemeThumb', { bg = '#7aa2f7' })
highlight('WilderThemeBorder', { fg = wilder_border, bg = wilder_bg })

-- 统一设置行号颜色
for _, hl_group in ipairs({ 'LineNr', 'LineNrAbove', 'LineNrBelow' }) do
	vim.api.nvim_set_hl(0, hl_group, { fg = '#808080' })
end

-- 分屏分隔线颜色（更醒目）
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#565f89', bg = 'NONE' })

-------------------------------------------------- StatusLine -----------------------------------------------------------------------------
local statusline_augroup = GroupId('native_statusline', { clear = true })

-- Cache for git commands with longer TTL
local git_cache = {}
local cache_time = {}
local cache_ttl = 5 -- seconds, increased to reduce frequency

-- Flag to disable statusline updates during exit
local is_exiting = false

vim.api.nvim_create_autocmd('VimLeavePre', {
	callback = function()
		is_exiting = true
	end,
})

local function cached_system_call(key, cmd, fallback_cmd)
	-- Never execute during exit to avoid blocking
	if is_exiting then
		return git_cache[key] or ''
	end

	local now = vim.fn.localtime()
	if git_cache[key] and (now - (cache_time[key] or 0)) < cache_ttl then
		return git_cache[key]
	end

	local result = vim.fn.system(cmd):gsub('%c', '')
	-- If result is empty and we have a fallback, try that
	if result == '' and fallback_cmd then
		result = vim.fn.system(fallback_cmd):gsub('%c', '')
	end

	git_cache[key] = result
	cache_time[key] = now
	return result
end

local function getProjectName()
	if is_exiting then
		return git_cache['project_name'] or ''
	end

	if vim.env.TMUX ~= nil then
		local result = vim.fn.system({ 'tmux', 'display-message', '-p', '#W' }):gsub('%c', '')
		git_cache['project_name'] = result
		return result
	end

	if cached_system_call('git_toplevel', [[git rev-parse --show-toplevel 2> /dev/null]]) == '' then
		local result = vim.fn.system('basename $(pwd)'):gsub('%c', '')
		git_cache['project_name'] = result
		return result
	end

	local res =
		cached_system_call('git_remote', [[git config --local remote.origin.url|sed -n 's#.*/\([^.]*\)\.git#\1#p']])
	if res ~= '' then
		git_cache['project_name'] = res
		return res
	end

	local result = vim.fn.system([[ TOP=$(git rev-parse --show-toplevel); echo ${TOP##*/} ]]):gsub('%c', '')
	git_cache['project_name'] = result
	return result
end

-- LSP clients attached to buffer

local function get_lsp()
	if is_exiting then
		return '[null]'
	end

	local current_buf = api.nvim_get_current_buf()

	local clients = vim.lsp.get_clients({ bufnr = current_buf })
	if next(clients) == nil then
		return '[null]'
	end

	local c = {}
	for _, client in pairs(clients) do
		c[#c + 1] = client.name
	end
	local rsp = '[' .. table.concat(c, ',') .. ']'
	return rsp
end

local function get_file()
	local fname = vim.fn.expand('%:t')
	if fname == '' then
		return vim.bo.filetype
	end
	return fname .. ' -> ' .. vim.bo.filetype .. ' '
end

local function get_branch()
	if is_exiting then
		return git_cache['git_branch'] or ''
	end

	local res = cached_system_call('git_branch', 'git branch --show-current')
	if res == '致命错误：不是 git 仓库（或者任何父目录）：.git' then
		return ''
	end
	if res == '' then
		res = cached_system_call('git_head', 'git rev-parse HEAD')
	end
	git_cache['git_branch'] = res
	return res
end

local function get_time()
	return os.date('%H:%M', os.time())
end

Autocmd({ 'WinEnter', 'BufEnter', 'FileType' }, {
	group = statusline_augroup,
	pattern = '*',
	callback = function()
		if is_exiting then
			return
		end

		if vim.bo.filetype == 'minifiles' or vim.bo.filetype == 'alpha' then
			vim.o.laststatus = 0
			return
		end
		vim.o.laststatus = 3

		StatusLine.project_name = '%#StatusLineProject#' .. getProjectName()
		StatusLine.file = '%#StatusLineFilename#' .. get_file()
		StatusLine.branch = '%#StatusLineGitBranch#' .. icons.git.Branch .. ' ' .. get_branch()
		StatusLine.time = '%#StatusLineTime#' .. get_time()
	end,
})

-- cmdheight =0 之后，进入insert模式,statusline会消失,所以需要手动重绘
-- cmd([[
-- autocmd InsertEnter * lua vim.schedule(function() cmd('redraw') end)
-- ]])

Autocmd('InsertEnter', {
	group = GroupId('status_insert_redraw', { clear = true }),
	pattern = '*',
	callback = function()
		if is_exiting then
			return
		end
		vim.schedule(function()
			cmd('redraw')
		end)
	end,
})

Autocmd('LspProgress', {
	group = statusline_augroup,
	desc = 'Update LSP progress in statusline',
	pattern = { 'begin', 'report', 'end' },
	callback = function(args)
		if is_exiting then
			return
		end

		if not (args.data and args.data.client_id) then
			return
		end

		lsp_progress = {
			client = vim.lsp.get_client_by_id(args.data.client_id),
			kind = args.data.params.value.kind,
			message = args.data.params.value.message,
			percentage = args.data.params.value.percentage,
			title = args.data.params.value.title,
		}

		if lsp_progress.kind == 'end' then
			lsp_progress.title = nil
			vim.defer_fn(function()
				if not is_exiting then
					vim.cmd.redrawstatus()
				end
			end, 500)
		else
			vim.cmd.redrawstatus()
		end

		StatusLine.lsp_clients = '%#StatusLineLSP#' .. get_lsp()
	end,
})

StatusLine = {
	project_name,
	file,
	branch,
	diagnostics,
	get_lsp,
	time,
}

-- 定义高亮组
highlight('StatusLineProject', { fg = '#D3869B', bg = '#1E1E2E', bold = true })
highlight('StatusLineFilename', { fg = '#83A598', bg = '#1E1E2E', bold = true })
highlight('StatusLineGitBranch', { fg = '#8EC07C', bg = '#1E1E2E', bold = true })
highlight('StatusLineLSP', { fg = '#7AA2F7', bg = '#1E1E2E', bold = true })
highlight('StatusLineTime', { fg = '#D5C4A1', bg = '#1E1E2E', bold = true })

StatusLine.active = function()
	if is_exiting then
		return ''
	end

	StatusLine.lsp_clients = '%#StatusLineLSP#' .. get_lsp()

	local statusline = {
		StatusLine.project_name or '',
		icons.ui.DividerRight,
		StatusLine.file or '',
		icons.ui.DividerRight,
		StatusLine.branch or '',
		'%=',
		StatusLine.lsp_clients or '',
		icons.ui.DividerLeft,
		StatusLine.time or '',
	}

	return table.concat(statusline)
end

vim.opt.statusline = '%!v:lua.StatusLine.active()'

----------------------------------------------------bufferline -----------------------------------------------------------------------------
vim.pack.add({
	{ src = 'https://github.com/akinsho/bufferline.nvim.git' },
}, { confirm = false })

require('bufferline').setup({
	options = {
		diagnostics = 'nvim_lsp',
		-- always_show_bufferline = true,
		diagnostics_indicator = function(_, _, diag)
			if diag.error or diag.warning then
				local ret = (diag.error or '') .. (diag.warning or '')
				return vim.trim(ret)
			end
			return ''
		end,
		offsets = {
			{
				filetype = 'neo-tree',
				text = 'Neo-tree',
				highlight = 'Directory',
				text_align = 'left',
			},
			{
				filetype = 'snacks_layout_box',
			},
		},
	},
})

-- Fix bufferline when restoring a session
vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
	callback = function()
		vim.schedule(function()
			pcall(nvim_bufferline)
		end)
	end,
})

--------------------------------------------右边滚动条-----------------------------------------------------
vim.pack.add({
	{ src = 'https://github.com/lewis6991/satellite.nvim.git' },
}, { confirm = false })

require('satellite').setup({
	handlers = {
		marks = {
			enable = false,
		},
		gitsigns = {
			enable = false,
		},
		search = {
			enable = false,
		},
	},
})

vim.o.cmdheight = 0

vim.pack.add({ 'https://github.com/rachartier/tiny-cmdline.nvim' })
require('tiny-cmdline').setup({
	native_types = {},
})

-- ── ui2 消息系统（仿 snacks.notifier 样式）───────────────────────────

local ui2 = require('vim._core.ui2')
local ui2_msgs = require('vim._core.ui2.messages')

-- 不需要在 msg 窗口显示的消息类型
local IGNORED_KINDS = {
	bufwrite = true,
	[''] = true,
	empty = true,
	search_count = true,
	search_cmd = true,
}

-- 跳过匹配这些模式的消息（文件写入、undo 行数等噪音）
local SKIP_PATTERNS = {
	'%d+L, %d+B',
	'; after #%d+',
	'; before #%d+',
	'%d fewer lines',
	'%d more lines',
	'%d lines yanked',
	'%d+ buffers? deleted',
	'%d+ buffers? unloaded',
	'%d+ buffers? wiped out',
}

-- kind → { title_text, highlight_group }
local KIND_TITLES = {
	emsg = { '  ', 'DiagnosticError' },
	echoerr = { '  ', 'DiagnosticError' },
	lua_error = { '  ', 'DiagnosticError' },
	rpc_error = { '  ', 'DiagnosticError' },
	wmsg = { '  ', 'DiagnosticWarn' },
	echo = { '  ', 'DiagnosticInfo' },
	echomsg = { '  ', 'DiagnosticInfo' },
	lua_print = { '  ', 'DiagnosticInfo' },
	search_cmd = { '  ', 'DiagnosticInfo' },
	search_count = { '  ', 'DiagnosticInfo' },
	undo = { '  ', 'DiagnosticInfo' },
	shell_out = { '  ', 'DiagnosticInfo' },
	shell_err = { '  ', 'DiagnosticError' },
	shell_cmd = { '  ', 'DiagnosticInfo' },
	quickfix = { '  ', 'DiagnosticInfo' },
	progress = { '  ', 'DiagnosticInfo' },
	typed_cmd = { '  ', 'DiagnosticInfo' },
	list_cmd = { '  ', 'DiagnosticInfo' },
	verbose = { '  ', 'DiagnosticInfo' },
}

local last_title = nil
local last_hl = 'DiagnosticInfo'

local function content_to_text(content)
	if type(content) ~= 'table' then
		return tostring(content or '')
	end
	local parts = {}
	for _, chunk in ipairs(content) do
		if type(chunk) == 'table' and chunk[2] then
			parts[#parts + 1] = chunk[2]
		end
	end
	return table.concat(parts)
end

local function should_skip(kind, content)
	if IGNORED_KINDS[kind] then
		return true
	end
	local text = content_to_text(content)
	for _, pat in ipairs(SKIP_PATTERNS) do
		if text:find(pat) then
			return true
		end
	end
	return false
end

local function resolve_title(kind, content)
	local entry = KIND_TITLES[kind]
	if entry then
		return entry[1], entry[2]
	end
	local text = vim.trim(content_to_text(content)):gsub('\n.*', '')
	if #text > 40 then
		text = text:sub(1, 37) .. '…'
	end
	return text ~= '' and '  ' or '  ', 'DiagnosticInfo'
end

local function set_msg_winhighlight(win)
	vim.api.nvim_set_option_value(
		'winhighlight',
		('Normal:Normal,NormalNC:Normal,NormalFloat:Normal,FloatBorder:%s,FloatTitle:%s'):format(last_hl, last_hl),
		{ scope = 'local', win = win }
	)
end

local function override_msg_win()
	local win = ui2.wins and ui2.wins.msg
	if not (win and vim.api.nvim_win_is_valid(win)) then
		return
	end
	if vim.api.nvim_win_get_config(win).hide then
		return
	end
	pcall(vim.api.nvim_win_set_config, win, {
		relative = 'editor',
		anchor = 'NE',
		row = 1,
		col = vim.o.columns - 1,
		border = 'rounded',
		style = 'minimal',
		title = last_title and { { last_title, last_hl } } or nil,
		title_pos = last_title and 'center' or nil,
	})
	set_msg_winhighlight(win)
end

local function override_pager_win()
	local win = ui2.wins and ui2.wins.pager
	if not (win and vim.api.nvim_win_is_valid(win)) then
		return
	end
	if vim.api.nvim_win_get_config(win).hide then
		return
	end
	local height = vim.api.nvim_win_get_height(win)
	pcall(vim.api.nvim_win_set_config, win, {
		border = 'rounded',
		height = height,
		style = 'minimal',
		title = last_title and { { last_title, last_hl } } or nil,
		title_pos = last_title and 'center' or nil,
	})
	set_msg_winhighlight(win)
end

local function override_dialog_win()
	-- 故意留空：dialog 窗口（confirm/askyesno 等 modal 提示）的位置、高度、
	-- border 由 ui2 原生 set_pos 计算（见 messages.lua 的 win_row_height / set_top_bot_spill），
	-- 这里再覆盖一次会导致 cmdline 的 prompt 文本和 confirm_sub 的按钮拆分到不同窗口。
end

ui2.enable({
	enable = true,
	msg = {
		targets = {
			[''] = 'msg',
			empty = 'msg',
			bufwrite = 'msg',
			echo = 'msg',
			echomsg = 'msg',
			shell_ret = 'msg',
			undo = 'msg',
			wmsg = 'msg',
			completion = 'msg',
			confirm = 'dialog',
			confirm_sub = 'dialog',
			echoerr = 'msg',
			emsg = 'msg',
			list_cmd = 'pager',
			lua_error = 'msg',
			lua_print = 'msg',
			progress = 'msg',
			quickfix = 'msg',
			rpc_error = 'msg',
			search_cmd = 'msg',
			search_count = 'msg',
			shell_cmd = 'msg',
			shell_err = 'msg',
			shell_out = 'msg',
			typed_cmd = 'msg',
			verbose = 'pager',
			wildlist = 'msg',
		},
		cmd = { height = 0.5 },
		dialog = { height = 0.5 },
		msg = { height = 0.5, timeout = 5000 },
		pager = { height = 0.8 },
	},
})

-- wrap set_pos: 所有窗口位置/样式的唯一入口
local orig_set_pos = ui2_msgs.set_pos
ui2_msgs.set_pos = function(tgt)
	orig_set_pos(tgt)
	-- dialog 窗口（confirm 等 modal）完全由 ui2 原生定位，这里不做任何覆盖
	if tgt == 'dialog' then
		return
	end
	if tgt == 'msg' or tgt == nil then
		override_msg_win()
		return
	end
	if tgt == 'pager' then
		override_pager_win()
		return
	end
end

-- wrap msg_show: 消息过滤 + title 跟踪
local orig_msg_show = ui2_msgs.msg_show
ui2_msgs.msg_show = function(kind, content, replace_last, history, append, id, trigger)
	-- confirm / confirm_sub 是 ui2 已经在内部路由到 dialog 的 modal 消息（见 messages.lua:412）
	-- 直接交给原生实现，避免被 should_skip 过滤或走我们自定义的 title/路由逻辑
	if kind == 'confirm' or kind == 'confirm_sub' then
		return orig_msg_show(kind, content, replace_last, history, append, id, trigger)
	end

	if should_skip(kind, content) then
		return
	end
	local title, hl = resolve_title(kind, content)
	last_title, last_hl = title, hl

	local tgt = ui2.cfg.msg.targets[kind]
		or (trigger ~= '' and ui2.cfg.msg.targets[trigger])
		or ui2.cfg.msg.targets[trigger]
		or ui2.cfg.msg.target

	ui2_msgs.show_msg(tgt, kind, content, replace_last, append, id)
	ui2_msgs.set_pos(tgt)
end

-- wrap show_msg: 大消息自动转 pager
local orig_show_msg = ui2_msgs.show_msg
ui2_msgs.show_msg = function(tgt, kind, content, replace_last, append, id)
	-- dialog 目标（confirm 等）保持原生渲染，不做尺寸重路由
	if tgt == 'dialog' then
		return orig_show_msg(tgt, kind, content, replace_last, append, id)
	end
	if tgt == 'msg' then
		local text = content_to_text(content)
		local width = 0
		for _, line in ipairs(vim.split(text, '\n')) do
			width = math.max(width, vim.api.nvim_strwidth(line))
		end
		local lines = #vim.split(text, '\n')
		if width > math.floor(vim.o.columns * 0.75) or lines > 20 then
			vim.schedule(function()
				ui2_msgs.show_msg('pager', kind, content, replace_last, append, id)
				ui2_msgs.set_pos('pager')
			end)
			return
		end
	end
	orig_show_msg(tgt, kind, content, replace_last, append, id)
end
