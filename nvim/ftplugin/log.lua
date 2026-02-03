if not vim.g.log_loaded then
	vim.g.log_loaded = true
	vim.pack.add({
		'https://github.com/fei6409/log-highlight.nvim.git',
	}, { confirm = false })
end

require('log-highlight').setup({})
