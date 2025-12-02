-- 最小配置

vim.pack.add({
	{ src = "https://github.com/folke/lazy.nvim.git", version = vim.version.range("*") },
})

require("lazy").setup({
	{
		"A7Lavinraj/fyler.nvim",
		dependencies = { "nvim-mini/mini.icons" },
		cmd = { "Fyler" },
		keys = {
			{
				"<space>e",
				function()
					require("fyler").toggle({
						kind = "split_left_most",
					})
				end,
			},
		},
		opts = {
			integrations = {
				-- icon = "nvim_web_devicons",
			},

			mappings = {
				explorer = {
					["<CR>"] = "Select",
					["<C-t>"] = "SelectTab",
					["|"] = "SelectVSplit",
					["-"] = "SelectSplit",
					["h"] = "GotoParent",
					["="] = "GotoCwd",
				},
			},
			views = {
				explorer = {
					close_on_select = true,
					confirm_simple = true,
					default_explorer = true,
					win = {
						kind_presets = {
							split_left_most = {
								width = "0.15rel",
							},
						},
						win_opts = {
							number = false,
							relativenumber = false,
						},
					},
				},
			},
		},
	},
})
