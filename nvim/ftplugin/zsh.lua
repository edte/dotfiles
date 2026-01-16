if vim.g.zsh_loaded then
	return
end
vim.g.zsh_loaded = true

vim.lsp.config("bashls", {
	name = "bashls",
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "zsh", "bash", "tmux" },
	root_markers = { ".git", "Makefile" },
	single_file_support = true,
})

vim.lsp.enable("bashls")

vim.lsp.start(vim.lsp.config.bashls)
