-- 打开 .tsv 文件时自动启用 csvview 表格渲染
-- 兼容 kulala.nvim 的响应 buffer（filetype = "tsv.kulala_ui"）
vim.schedule(function()
	local ok, csvview = pcall(require, 'csvview')
	if not ok then return end

	local bufnr = vim.api.nvim_get_current_buf()
	if csvview.is_enabled(bufnr) then return end

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
	end

	csvview.enable(bufnr, {
		parser = { delimiter = '\t' },
		view = {
			header_lnum = 1,
			sticky_header = { enabled = true, separator = '─' },
		},
	})
end)
