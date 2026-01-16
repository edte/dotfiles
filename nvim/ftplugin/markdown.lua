if vim.g.md_loaded then
	return
end
vim.g.md_loaded = true

vim.lsp.config("marksman", {
	name = "marksman",
	cmd = { "marksman", "server" },
	filetypes = { "markdown" },
	single_file_support = true,
	root_markers = { ".git", "Makefile" },
})

vim.lsp.config("markdown-oxide", {
	name = "markdown-oxide",
	cmd = { "markdown-oxide" },
	filetypes = { "markdown" },
	single_file_support = true,
	root_markers = { ".git", "Makefile" },
})

vim.lsp.enable("marksman")

vim.lsp.enable("markdown-oxide")
