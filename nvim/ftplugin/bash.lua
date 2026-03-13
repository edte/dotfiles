vim.treesitter.start()

if not vim.g.bash_loaded then
	vim.g.bash_loaded = true

	vim.lsp.config('bashls', {
		name = 'bashls',
		cmd = { 'bash-language-server', 'start' },
		filetypes = { 'sh', 'zsh', 'bash', 'tmux' },
		root_markers = { '.git', 'Makefile' },
		single_file_support = true,
	})
end

vim.lsp.enable('bashls')

dofile(vim.fn.stdpath('config') .. '/ftplugin/markdown.lua')
