if vim.g.kitty_loaded then
	return
end
vim.g.kitty_loaded = true

vim.lsp.config('kitty-lsp', {
	name = 'kitty-lsp',
	cmd = { 'kitty-lsp', '--stdio' },
	filetypes = { 'kitty' },
	root_markers = { '.git', 'Makefile' },
	single_file_support = true,
})

vim.lsp.enable('kitty-lsp')
