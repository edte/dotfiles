vim.lsp.config("sqls", {
	name = "sqls",
	cmd = { "sqls" },
	filetypes = { "sql", "mysql" },
	single_file_support = true,
	root_markers = { ".git", "Makefile" },
})

vim.lsp.enable("sqls")
vim.treesitter.start()
