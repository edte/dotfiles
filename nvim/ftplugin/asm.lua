if vim.g.asm_loaded then
	return
end
vim.g.asm_loaded = true

vim.lsp.config("asm_lsp", {
	name = "asm_lsp",
	cmd = { "asm-lsp" },
	filetypes = { "asm", "s", "S" },
	root_markers = { ".asm-lsp.toml", ".git" },
	on_attach = function(client, buf)
		vim.lsp.inlay_hint.enable(true, { bufnr = buf })
	end,
	single_file_support = true,
})

vim.lsp.enable("asm_lsp")

vim.lsp.start(vim.lsp.config.asm_lsp)
