if vim.g.help_loaded then
	return
end
vim.g.help_loaded = true

vim.opt_local.number = true

-- https://github.com/OXY2DEV/helpview.nvim
vim.pack.add({
	'https://github.com/OXY2DEV/helpview.nvim.git',
}, { confirm = false })

require('helpview').setup({})

-- 延迟渲染，等 treesitter 解析完成
vim.defer_fn(function()
	local buf = vim.api.nvim_get_current_buf()
	if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
		pcall(require('helpview').render, buf)
	end
end, 50)
