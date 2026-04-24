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

		-- t 键：完全销毁响应 buffer（等价于 kulala 默认的 q）
		-- 下次从 http buffer 按 t 时走 show_body 完全重建，避免复用 buffer 导致
		-- csvview 渲染状态和新浮窗 winid 对不上的错乱。
		vim.keymap.set('n', 't', function()
			require('kulala.ui').close_kulala_buffer()
		end, { buffer = bufnr, silent = true, nowait = true, desc = 'Close kulala response' })

		-- csvview sticky_header 子浮窗关闭不要删主 buffer（kulala 默认的 WinClosed
		-- 按 buffer 绑定，子浮窗关掉也会触发，导致主 buffer 被误删）
		vim.api.nvim_create_autocmd('WinClosed', {
			group = group,
			buffer = bufnr,
			callback = function(args)
				local winid = tonumber(args.match)
				if winid and vim.w[winid].csvview_sticky_header_win then
					return
				end
				if vim.fn.bufexists(bufnr) > 0 then
					vim.api.nvim_buf_delete(bufnr, { force = true })
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
end)
