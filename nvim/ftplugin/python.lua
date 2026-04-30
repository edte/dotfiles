if not vim.g.python_loaded then
	vim.g.python_loaded = true

	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#basedpyright
	vim.lsp.config('basedpyright', {
		name = 'basedpyright',
		cmd = { 'basedpyright-langserver', '--stdio' },
		filetypes = { 'python' },
		root_markers = {
			'pyproject.toml',
			'setup.py',
			'setup.cfg',
			'requirements.txt',
			'Pipfile',
			'pyrightconfig.json',
			'.git',
		},
		on_attach = function(client, buf)
			vim.lsp.inlay_hint.enable(true, { bufnr = buf })
		end,
		single_file_support = true,
		settings = {
			basedpyright = {
				analysis = {
					autoImportCompletions = true,
					diagnosticMode = 'openFilesOnly', -- 只分析打开的文件，性能更好
					typeCheckingMode = 'standard', -- off, basic, standard, strict
				},
			},
		},
	})
end

vim.lsp.enable('basedpyright')
vim.treesitter.start()
