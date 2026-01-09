if vim.g.kulala_loaded then
	return
end
vim.g.kulala_loaded = true

vim.pack.add({
	{ src = "https://github.com/mistweaverco/kulala.nvim" },
})

require("kulala").setup({
	default_view = "body",
	display_mode = "float",
	winbar = false,
	ui = {
		show_request_summary = false,
	},
	infer_content_type = false,
	contenttypes = {
		["application/csv"] = {
			ft = "csv",
			formatter = function(body)
				return body
			end,
			pathresolver = function(body, path)
				return body
			end,
		},
		["text/csv"] = {
			ft = "csv",
			formatter = function(body)
				return body
			end,
			pathresolver = function(body, path)
				return body
			end,
		},
		["text/tsv"] = {
			ft = "tsv",
			formatter = function(body)
				return body
			end,
			pathresolver = function(body, path)
				return body
			end,
		},
	},
})

local opts = { buffer = true, silent = true }

vim.keymap.set("n", "<CR>", function()
	require("kulala").run()
end, vim.tbl_extend("force", opts, { desc = "Execute the request" }))

vim.keymap.set("n", "[[", function()
	require("kulala").jump_prev()
end, vim.tbl_extend("force", opts, { desc = "Jump to the previous request" }))

vim.keymap.set("n", "]]", function()
	require("kulala").jump_next()
end, vim.tbl_extend("force", opts, { desc = "Jump to the next request" }))

vim.keymap.set("n", "t", function()
	require("kulala.ui").show_body()
end, vim.tbl_extend("force", opts, { desc = "Show response body" }))
