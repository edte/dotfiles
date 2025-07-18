return {
	name = "asm_lsp",
	cmd = { "asm-lsp" },
	{ "asm", "vmasm" },
	root_markers = { ".asm-lsp.toml", ".git" },
	on_attach = function(client, buf)
		vim.lsp.inlay_hint.enable(true, { bufnr = buf })
	end,
	single_file_support = true,
}
