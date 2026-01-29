if vim.g.ui_loaded then
	return
end
vim.g.ui_loaded = true

-- 加载tokyonight主题
vim.pack.add({
	{ src = 'https://github.com/folke/tokyonight.nvim.git' },
}, { confirm = false })

vim.cmd.colorscheme('tokyonight')

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
		StatusLine.file,
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
	},
})
