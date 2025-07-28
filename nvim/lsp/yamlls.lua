return {
	name = "yamlls",
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
	root_markers = { ".git" },
	on_attach = function(client, buf)
		vim.lsp.inlay_hint.enable(true, { bufnr = buf })
	end,
	single_file_support = true,

	settings = {
		yaml = {
			schemas = {
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json"] = "/*.k8s.yaml",
			},
		},
	},
}
