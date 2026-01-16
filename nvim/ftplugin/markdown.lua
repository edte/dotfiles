if vim.g.md_loaded then
	return
end
vim.g.md_loaded = true

vim.pack.add({
	"https://github.com/OXY2DEV/markview.nvim.git",
})

require("markview").setup({
	preview = {
		filetypes = { "markdown", "norg", "rmd", "org", "vimwiki", "codecompanion" },
		-- 默认 ignore_buftypes = { "nofile" }，但 codecompanion 的 buftype 是 nofile
		-- 所以需要设置为空，让 condition 函数来控制
		ignore_buftypes = {},
		condition = function(buffer)
			local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt
			-- codecompanion 的 buftype 是 nofile，需要特殊处理
			if ft == "codecompanion" then
				return true
			elseif bt == "nofile" then
				return false
			else
				return true
			end
		end,
		-- 关闭 hybrid_mode，使用 conceal 隐藏原始标记
		hybrid_mode = false,
		enable_hybrid_mode = false,
		-- 在这些模式下启用渲染（隐藏 ###  等标记）
		modes = { "n", "no", "c" },
		-- 光标所在行显示原始标记，其他行渲染
		edit_range = { 1, 0 },
	},
	max_length = 99999,
})

-- 修复：懒加载后立即渲染当前 buffer
vim.schedule(function()
	local buf = vim.api.nvim_get_current_buf()
	if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
		pcall(require("markview").render, buf)
	end
end)

-- 修复：对后续创建的 codecompanion buffer 也进行 attach 和渲染
vim.api.nvim_create_autocmd("FileType", {
	pattern = "codecompanion",
	callback = function(ev)
		-- 延迟执行，等 buffer 完全初始化
		vim.defer_fn(function()
			local buf = ev.buf
			if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
				return
			end

			local ok, state = pcall(require, "markview.state")
			if not ok then
				return
			end

			-- 如果还没有 attach，手动 attach
			if not state.vars.attached_buffers[buf] then
				pcall(state.attach, buf)
			end

			-- 安全渲染
			pcall(require("markview").render, buf)

			-- 设置 conceallevel 以隐藏原始标记
			local wins = vim.fn.win_findbuf(buf)
			for _, win in ipairs(wins) do
				if vim.api.nvim_win_is_valid(win) then
					vim.wo[win].conceallevel = 2
					vim.wo[win].concealcursor = "nc"
				end
			end
		end, 100)
	end,
})

vim.lsp.config("marksman", {
	name = "marksman",
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "codecompanion" },
	single_file_support = true,
	root_markers = { ".git", "Makefile" },
})

vim.lsp.config("markdown-oxide", {
	name = "markdown-oxide",
	cmd = { "markdown-oxide" },
	filetypes = { "markdown", "codecompanion" },
	single_file_support = true,
	root_markers = { ".git", "Makefile" },
})

vim.lsp.enable("marksman")

vim.lsp.enable("markdown-oxide")
