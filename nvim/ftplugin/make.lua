vim.lsp.config('autotools-language-server', {
	cmd = { 'autotools-language-server' },
	filetypes = { 'config', 'automake', 'make' },
	single_file_support = true,
	root_markers = { '.git', 'Makefile' },
})
vim.lsp.enable('autotools-language-server')
