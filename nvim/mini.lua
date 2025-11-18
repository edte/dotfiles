-- 最小配置

vim.pack.add({
	{ src = "https://github.com/folke/lazy.nvim.git", version = vim.version.range("*") },
})

require("lazy").setup({
	{
		"TheNoeTrevino/no-go.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },

		ft = "go",
		config = function()
			vim.highlight.priorities.semantic_tokens = 95 -- default is 125
			vim.highlight.priorities.treesitter = 100 -- default is 100
			require("no-go").setup({
				identifiers = { "err", "error" }, -- Customize which identifiers to collapse
			})
		end,
	},
})
