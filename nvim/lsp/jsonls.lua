return {
	name = "jsonls",
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json" },
	single_file_support = true,
	root_markers = { ".git", "Makefile" },
	on_new_config = function(new_config)
		new_config.settings.json.schemas = new_config.settings.json.schemas or {}
		vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
	end,
	settings = {
		json = {
			validate = { enable = true },
			format = {
				enable = true,
			},
		},
	},
}
