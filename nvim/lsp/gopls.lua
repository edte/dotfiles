-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#custom-configuration
return {
	name = "gopls",
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gosum", "gotmpl", "gowork" },
	root_markers = { ".git", "Makefile" },
	on_attach = function(client, buf)
		vim.lsp.inlay_hint.enable(true, { bufnr = buf })
	end,
	single_file_support = true,
	settings = {
		gopls = {
			analyses = {
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			-- 这个参数打开后，补全的时候会把参数名字和类型一起补全
			usePlaceholders = false,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			semanticTokens = true,
			gofumpt = true,
			-- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
			hints = {
				rangeVariableTypes = true, -- 范围变量类型
				constantValues = true, -- 常数值
				assignVariableTypes = true, -- 分配变量类型
				compositeLiteralFields = true, -- 复合文字字段
				compositeLiteralTypes = true, -- 复合文字类型
				parameterNames = true, -- 参数名称
				functionTypeParameters = true, -- 函数类型参数
			},
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
		},
	},
}
