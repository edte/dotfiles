-- JCE LSP: all features (highlighting, folding, completion, etc.) via jce-lsp

vim.lsp.start({
	name = 'jce-lsp',
	cmd = { 'jce-lsp', '--strict' },
	root_dir = vim.fs.root(0, { '.git' }) or vim.fn.getcwd(),
})

-- LSP-based folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
vim.wo.foldlevel = 99
vim.wo.foldtext = ''

-- Range formatting (visual mode)
vim.keymap.set('v', '<space>lf', function()
	vim.lsp.buf.format({ async = true })
end, { buffer = true, desc = 'LSP range format' })

-- Disable treesitter textobjects for jce (no treesitter parser available)
vim.b.ts_highlight = false
vim.keymap.set({ 'n', 'x', 'o' }, ']m', ']m', { buffer = true })
vim.keymap.set({ 'n', 'x', 'o' }, '[m', '[m', { buffer = true })
