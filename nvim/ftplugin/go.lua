if vim.g.jce_loaded then
	return
end
vim.g.jce_loaded = true

vim.pack.add({
	"https://github.com/ray-x/go.nvim.git",
	"https://github.com/edte/no-go.nvim.git",
})

require("go").setup({
	diagnostic = false,
})

Command("GoAddTagEmpty", function()
	vim.api.nvim_command(":GoAddTag json -add-options json=")
end, { nargs = "*" })

Autocmd("BufWritePost", {
	group = GroupId("go_auto_import", { clear = true }),
	nested = true,
	callback = function()
		cmd("GoImports")
	end,
})

vim.highlight.priorities.semantic_tokens = 95 -- default is 125
vim.highlight.priorities.treesitter = 100 -- default is 100

require("no-go").setup({
	identifiers = { "err", "error" }, -- Customize which identifiers to collapse
	-- look at the default config for more details
	highlight_group = "LspInlayHint",
	fold_imports = true,
})
