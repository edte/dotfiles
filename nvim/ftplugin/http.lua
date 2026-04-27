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

	-- 关掉 rainbow_csv 的 :Select / :Update 命令行列名提示条
	-- （输入 Select 后底部弹的 NR a1 a2 ... 提示）
	-- 注意：这个函数既有改 statusline 的副作用，又负责返回命令名给 cnoreabbrev 展开，
	-- 所以不能返回空字符串（会把 Select 吃掉），只返回 eval_value 跳过副作用即可
	local rb = require('rainbow_csv.fns')
	rb.set_statusline_columns = function(eval_value)
		return eval_value
	end

	-- rainbow_csv 查询结果默认写磁盘并 :edit，会越积越多。
	-- 结果路径：
	--   - 源表：~/.rainbow_csv_storage/tmp_table_*.txt
	--   - 查询结果：$TMPDIR/tmp_table_*.txt.txt  (vim_rbql.py 用 tempfile.gettempdir)
	-- 这里 hook：
	--   - 打开结果 buffer 后转 scratch (nofile) 并删磁盘文件
	--   - 绑 buffer-local q：关结果 + 重新弹 kulala 响应浮窗
	local storage_dir = vim.fn.expand('$HOME') .. '/.rainbow_csv_storage/*.txt'
	local tmpdir = vim.fn.resolve(vim.fn.expand('$TMPDIR')):gsub('/$', '')
	vim.api.nvim_create_autocmd('BufReadPost', {
		group = vim.api.nvim_create_augroup('rainbow_csv_scratch', { clear = true }),
		pattern = { storage_dir, tmpdir .. '/tmp_table_*.txt*' },
		callback = function(args)
			local path = vim.api.nvim_buf_get_name(args.buf)
			vim.bo[args.buf].buftype = 'nofile'
			vim.bo[args.buf].bufhidden = 'wipe'
			vim.bo[args.buf].swapfile = false
			pcall(vim.fn.delete, path)

			-- q = 关结果 buffer 并重新打开 kulala 响应浮窗
			vim.keymap.set('n', 'q', function()
				-- 拿 kulala 响应 buffer 上次离开时的完整视图状态
				-- （winsaveview 包括光标 + topline + leftcol + curswant，恢复后屏幕位置一致）
				local saved_view
				local ok_ui, ui = pcall(require, 'kulala.ui')
				if ok_ui then
					local kbuf = ui.get_kulala_buffer()
					if kbuf and vim.api.nvim_buf_is_valid(kbuf) then
						saved_view = vim.b[kbuf]._kulala_view
					end
				end

				vim.api.nvim_buf_delete(args.buf, { force = true })
				if ok_ui then pcall(ui.show_body) end

				-- 恢复视图（覆盖 kulala 硬编码的 4G）
				if saved_view and ok_ui then
					vim.schedule(function()
						local kbuf = ui.get_kulala_buffer()
						local win = kbuf and vim.fn.win_findbuf(kbuf)[1]
						if win and vim.api.nvim_win_is_valid(win) then
							vim.api.nvim_win_call(win, function()
								vim.fn.winrestview(saved_view)
							end)
						end
					end)
				end
			end, { buffer = args.buf, silent = true, nowait = true, desc = 'Close query result and return to kulala' })
		end,
	})
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
-- 已有 kulala buffer → 直接开新浮窗复用（不调 show_body 重写内容，
-- csvview 状态/metrics/sticky header 全保留，瞬间可见）。
-- 没 buffer 才调 show_body 建。
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

	-- 有 kulala buffer 且合法：复用
	local buf = ui.get_kulala_buffer()
	if buf and vim.api.nvim_buf_is_valid(buf) then
		-- 如果已经有浮窗在展示，直接聚焦过去
		local existing_win = vim.fn.win_findbuf(buf)[1]
		if existing_win and vim.api.nvim_win_is_valid(existing_win) then
			vim.api.nvim_set_current_win(existing_win)
			return
		end

		-- 没浮窗 → 新开一个 minimal float 指向这个 buf（和 kulala 默认浮窗配置一致）
		local width = vim.o.columns
		local height = vim.o.lines
		local win = vim.api.nvim_open_win(buf, true, {
			relative = 'editor',
			width = width,
			height = height,
			row = 0,
			col = 0,
			style = 'minimal',
			border = 'none',
			zindex = 50,
		})

		-- 恢复上次视图位置（winsaveview 包含 cursor/topline/leftcol）
		local view = vim.b[buf]._kulala_view
		if view then
			vim.api.nvim_win_call(win, function()
				vim.fn.winrestview(view)
			end)
		end

		-- 触发 csvview sticky_header 按新 winid 重绘
		vim.schedule(function()
			pcall(function()
				require('csvview.sticky_header').redraw()
			end)
		end)
		return
	end

	-- 首次展示
	ui.show_body()
end, vim.tbl_extend('force', opts, { desc = 'Show / reuse kulala response body' }))

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
