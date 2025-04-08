return {
	name = "jsonls",
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json" },
	single_file_support = true,
	root_markers = { ".git", "Makefile" },
	settings = {
		json = {
			-- schemas = require('schemastore').json.schemas(),
			validate = { enable = true },
			format = {
				enable = true,
			},
		},
	},
}
