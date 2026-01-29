if vim.g.bash_loaded then
	return
end
vim.g.bash_loaded = true

vim.treesitter.start()

vim.lsp.config('bashls', {
	name = 'bashls',
	cmd = { 'bash-language-server', 'start' },
	filetypes = { 'sh', 'zsh', 'bash', 'tmux' },
	root_markers = { '.git', 'Makefile' },
	single_file_support = true,
})

vim.lsp.enable('bashls')

dofile(vim.fn.stdpath('config') .. '/ftplugin/markdown.lua')
