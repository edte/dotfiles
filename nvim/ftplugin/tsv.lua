-- 打开 .tsv 文件时自动启用 csvview 表格渲染
-- 兼容 kulala.nvim 的响应 buffer（filetype = "tsv.kulala_ui"）
vim.schedule(function()
	local ok, csvview = pcall(require, 'csvview')
	if not ok then return end

	local bufnr = vim.api.nvim_get_current_buf()

	-- kulala 会在 set_buffer_contents 里重设 filetype，触发 ftplugin 再跑。
	-- csvview.is_enabled 判的是异步 attach 完成后的状态，attach 过程中它仍是 false，
	-- 所以要自己加个 flag 防止重入。
	if vim.b[bufnr]._csvview_setup_done then return end
	vim.b[bufnr]._csvview_setup_done = true

	local ft = vim.bo[bufnr].filetype or ''
	local is_kulala = ft:find('kulala_ui', 1, true) ~= nil

	if is_kulala then
		local group = vim.api.nvim_create_augroup('kulala_window_closed', { clear = true })

		-- t 键：关闭响应浮窗但保留 buffer（不销毁 csvview 状态）
		-- 下次从 http 按 t 时直接用新浮窗复用这个 buffer，对齐/高亮瞬间可见
		vim.keymap.set('n', 't', function()
			-- 保存视图位置，下次复用时恢复
			local win = vim.api.nvim_get_current_win()
			if vim.api.nvim_win_get_buf(win) == bufnr then
				vim.b[bufnr]._kulala_view = vim.fn.winsaveview()
			end
			-- 标记本次关窗是主动 "隐藏"，WinClosed autocmd 不要删 buffer
			vim.b[bufnr]._kulala_hide = true
			-- 顺便关掉 csvview 的 sticky 子浮窗（避免残留干扰下次 redraw）
			pcall(function()
				require('csvview.sticky_header').close_header_win_for(win)
			end)
			pcall(vim.api.nvim_win_close, win, false)
		end, { buffer = bufnr, silent = true, nowait = true, desc = 'Hide kulala response (keep buffer)' })

		-- kulala 默认 <CR> 会 "跳回 http buffer 同时关浮窗"（jump_to_response），
		-- 用不上还容易误触——禁掉（用 <Nop>）
		vim.keymap.set('n', '<CR>', '<Nop>', { buffer = bufnr, silent = true, nowait = true, desc = 'Disabled kulala jump' })

		-- csvview sticky_header 子浮窗关闭不要删主 buffer（kulala 默认的 WinClosed
		-- 按 buffer 绑定，子浮窗关掉也会触发，导致主 buffer 被误删）
		-- 另外：t 键的 "隐藏不销毁" 也靠 vim.b._kulala_hide 标记跳过删除
		vim.api.nvim_create_autocmd('WinClosed', {
			group = group,
			buffer = bufnr,
			callback = function(args)
				local winid = tonumber(args.match)
				if winid and vim.w[winid].csvview_sticky_header_win then
					return
				end
				if vim.b[bufnr]._kulala_hide then
					vim.b[bufnr]._kulala_hide = nil
					return
				end
				if vim.fn.bufexists(bufnr) > 0 then
					vim.api.nvim_buf_delete(bufnr, { force = true })
				end
			end,
		})

		-- 离开 kulala buffer 时（例如 :Select 把当前窗口切到结果 buffer）
		-- 记录完整视图（光标 + topline + leftcol），方便后续从结果 buffer 按 q 时
		-- 恢复到完全一样的屏幕状态。
		vim.api.nvim_create_autocmd('BufLeave', {
			group = group,
			buffer = bufnr,
			callback = function()
				local win = vim.api.nvim_get_current_win()
				if vim.api.nvim_win_get_buf(win) == bufnr then
					vim.b[bufnr]._kulala_view = vim.fn.winsaveview()
				end
			end,
		})

		-- 浮窗真正显示时开启整行高亮
		-- 原因：
		-- 1. kulala 浮窗 style=minimal，Neovim 默认关 cursorline
		-- 2. plugin/autocmds.lua 的 WinLeave 里会主动把 cursorline 关掉
		-- 对策：同时监听 BufWinEnter/WinEnter/CursorMoved，只要光标在这个 buffer 里
		-- 且 cursorline 是关的，就强制打开。CursorMoved 作为兜底确保不被覆盖。
		local function force_cursorline()
			local win = vim.api.nvim_get_current_win()
			if vim.api.nvim_win_get_buf(win) ~= bufnr then return end
			if not vim.wo[win].cursorline then
				vim.wo[win].cursorline = true
			end
		end

		vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'CursorMoved' }, {
			group = group,
			buffer = bufnr,
			callback = force_cursorline,
		})
	end

	-- 普通 .tsv 文件：直接开 cursorline
	if not is_kulala then
		vim.opt_local.cursorline = true
	end

	-- kulala show_body 里 `vim.bo[buf].filetype = filetype` 会再次触发 ftplugin，
	-- 此处再判一次防止重复 enable 弹 "already attached" 通知
	if not csvview.is_enabled(bufnr) then
		csvview.enable(bufnr, {
			parser = { delimiter = '\t' },
			view = {
				header_lnum = 1,
				sticky_header = { enabled = true, separator = '─' },
			},
		})
	end

	-- rainbow_csv 分色 + :Select 支持
	-- 不能直接调 :RainbowDelim（会改 filetype 成 rcsv_XX_simple_，和 csvview 的
	-- sticky_header/对齐撞车导致首行错位）。
	-- 改为只跑 syntax 规则：rainbow_csv 启动时已经注册好 column0..N 的高亮链接，
	-- 我们只需要给 buffer 加上 "按 tab 切列" 的 syntax match 规则即可。
	pcall(function()
		local rb = require('rainbow_csv.fns')
		local syntax_lines = rb.generate_rainbow_syntax('\t')
		vim.cmd('syntax clear')
		for _, line in ipairs(syntax_lines) do
			vim.cmd(line)
		end
	end)
end)
