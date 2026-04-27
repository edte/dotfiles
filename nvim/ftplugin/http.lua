if not vim.g.kulala_loaded then
	vim.g.kulala_loaded = true

	-- 同步加载，避免 keymap 触发时 kulala 还没进 package.path 的 race
	vim.pack.add({
		{ src = 'https://github.com/mistweaverco/kulala.nvim' },
	}, { confirm = false })

	require('kulala').setup({
		default_view = 'body',
		display_mode = 'float',
		winbar = false,
		ui = {
			show_request_summary = false,
			win_opts = {
				width = vim.o.columns,
				-- 撑满 editor 区。vim.o.lines 是整屏高，laststatus=3 的 lualine
				-- 本身在 editor 区之外；实际 editor 区 = lines - (cmdheight ~= 0 and cmdheight or 0) - 1
				-- 但实测 height = lines - 1 会露底一行（http buffer 当前行），用 lines 让 nvim 自动 clamp
				height = vim.o.lines,
				row = 0,
				col = 0,
				border = 'none',
				-- zindex 调高避免被其他浮窗/插件的 UI 元素叠加
				zindex = 100,
			},
			disable_news_popup = true,
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

	-- kulala 在响应 buffer 顶部加 "? - help" 虚拟文本（即便 winbar=false 也加）
	-- 把 toggle_winbar_tab 替换成空实现彻底关掉
	local winbar_mod = require('kulala.ui.winbar')
	winbar_mod.toggle_winbar_tab = function() end
end

vim.treesitter.start()

local opts = { buffer = true, silent = true }

-- 安全调用 kulala，即便偶发加载异常也能给出明确提示而不是 stacktrace
local function safe_call(mod, fn)
	return function()
		local ok, m = pcall(require, mod)
		if not ok then
			vim.notify('kulala not loaded yet, retry in a moment', vim.log.levels.WARN)
			return
		end
		m[fn]()
	end
end

vim.keymap.set('n', '<CR>', safe_call('kulala', 'run'), vim.tbl_extend('force', opts, { desc = 'Execute the request' }))
vim.keymap.set('n', '[[', safe_call('kulala', 'jump_prev'), vim.tbl_extend('force', opts, { desc = 'Jump to the previous request' }))
vim.keymap.set('n', ']]', safe_call('kulala', 'jump_next'), vim.tbl_extend('force', opts, { desc = 'Jump to the next request' }))

-- t: 展示响应 body。必须真有响应才打开，否则 kulala 会渲染空壳 + 内部 nil 崩。
-- t: 展示响应 body。
-- tsv.kulala_ui buffer 里再按 t 会销毁响应 buffer（见 ftplugin/tsv.lua），
-- 所以这里 t 一定是"首次/重新打开"，直接走 show_body。
vim.keymap.set('n', 't', function()
	local ok_ui, ui = pcall(require, 'kulala.ui')
	local ok_db, db = pcall(require, 'kulala.db')
	if not (ok_ui and ok_db) then
		vim.notify('kulala not loaded yet', vim.log.levels.WARN)
		return
	end
	local responses = db.global_update().responses or {}
	if #responses == 0 then
		vim.notify('No response yet, press <CR> to send request first', vim.log.levels.INFO)
		return
	end
	ui.show_body()
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
			-- 折叠创建完成后，强制展开所有折叠
			vim.opt_local.foldlevel = 99
			-- 兜底：用 normal! zR 强制打开所有折叠（即便被其它 autocmd 改过）
			pcall(vim.cmd, 'normal! zR')
		end, 50)
	end,
})

-- 添加命令手动刷新折叠
vim.api.nvim_buf_create_user_command(0, 'HttpFold', create_http_folds, { desc = 'Create HTTP request folds' })
