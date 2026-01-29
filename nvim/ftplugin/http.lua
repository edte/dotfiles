if not vim.g.lua_loaded then
	vim.g.lua_loaded = true

	vim.pack.add({
		{ src = 'https://github.com/mistweaverco/kulala.nvim' },
	}, { confirm = false })
end

vim.treesitter.start()

require('kulala').setup({
	default_view = 'body',
	display_mode = 'float',
	winbar = false,
	ui = {
		show_request_summary = false,
	},
	infer_content_type = false,
	contenttypes = {
		['application/csv'] = {
			ft = 'csv',
			formatter = function(body)
				return body
			end,
			pathresolver = function(body, path)
				return body
			end,
		},
		['text/csv'] = {
			ft = 'csv',
			formatter = function(body)
				return body
			end,
			pathresolver = function(body, path)
				return body
			end,
		},
		['text/tsv'] = {
			ft = 'tsv',
			formatter = function(body)
				return body
			end,
			pathresolver = function(body, path)
				return body
			end,
		},
	},
})

local opts = { buffer = true, silent = true }

vim.keymap.set('n', '<CR>', function()
	require('kulala').run()
end, vim.tbl_extend('force', opts, { desc = 'Execute the request' }))

vim.keymap.set('n', '[[', function()
	require('kulala').jump_prev()
end, vim.tbl_extend('force', opts, { desc = 'Jump to the previous request' }))

vim.keymap.set('n', ']]', function()
	require('kulala').jump_next()
end, vim.tbl_extend('force', opts, { desc = 'Jump to the next request' }))

vim.keymap.set('n', 't', function()
	require('kulala.ui').show_body()
end, vim.tbl_extend('force', opts, { desc = 'Show response body' }))

-- 设置折叠 - 使用手动折叠
vim.opt_local.foldmethod = 'manual'
vim.opt_local.foldenable = true
vim.opt_local.foldlevel = 99
vim.opt_local.foldlevelstart = 99

-- 自动创建折叠
local function create_http_folds()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local fold_start = 1

	for i, line in ipairs(lines) do
		if line:match('^###') then
			-- 找到分隔符，创建上一个块的折叠
			if i > fold_start + 1 then
				pcall(vim.cmd, string.format('%d,%dfold', fold_start, i - 1))
			end
			fold_start = i + 1
		end
	end

	-- 创建最后一个块的折叠
	if fold_start < #lines then
		pcall(vim.cmd, string.format('%d,%dfold', fold_start, #lines))
	end
end

-- 使用 autocmd 确保在所有插件初始化后创建折叠
vim.api.nvim_create_autocmd('BufWinEnter', {
	buffer = 0,
	once = true,
	callback = function()
		-- 延迟执行以确保 kulala 初始化完成，并重新设置 foldmethod
		vim.defer_fn(function()
			vim.opt_local.foldmethod = 'manual'
			vim.opt_local.foldenable = true
			create_http_folds()
			-- 折叠创建完成后，设置 foldlevel 为 99 以展开所有折叠
			vim.opt_local.foldlevel = 99
		end, 50)
	end,
})

-- 添加命令手动刷新折叠
vim.api.nvim_buf_create_user_command(0, 'HttpFold', create_http_folds, { desc = 'Create HTTP request folds' })
