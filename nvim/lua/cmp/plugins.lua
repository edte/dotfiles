local M = {}

M.list = {

	{
		"cmp-nvim-lsp",
		event = { "InsertEnter" },
	},
	{
		"cmp_luasnip",
		event = { "InsertEnter" },
	},
	{
		url = "https://codeberg.org/FelipeLema/cmp-async-path",
		event = { "InsertEnter" },
	},
	{
		"hrsh7th/cmp-nvim-lsp-signature-help",
		event = { "InsertEnter" },
	},
	-- 上下文语法补全
	{
		"ray-x/cmp-treesitter",
		event = { "InsertEnter" },
	},
	{
		"lukas-reineke/cmp-rg",
		event = { "InsertEnter" },
		lazy = true,
		enabled = function()
			return vim.fn.executable("rg") == 1
		end,
	},
	{
		"Snikimonkd/cmp-go-pkgs",
		event = { "InsertEnter *.go" },
	},

	-- 单词补全
	{
		"uga-rosa/cmp-dictionary",
		event = { "InsertEnter" },
	},

	-- nvim lua  源
	{
		"hrsh7th/cmp-nvim-lua",
		event = { "InsertEnter *.lua" },
	},

	-- TabNine ai 补全
	{
		"tzachar/cmp-tabnine",
		build = "./install.sh",
		event = { "InsertEnter" },
		-- ft = { "lua", "go", "cpp" },
	},

	{
		"yioneko/nvim-cmp",
		branch = "perf",
		config = function()
			require("cmp.completion").cmpConfig()
		end,
		event = { "InsertEnter" },
	},

	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		dependencies = {
			"friendly-snippets",
		},
	},
	{ "rafamadriz/friendly-snippets", lazy = true },
	{
		"folke/neodev.nvim",
		lazy = true,
		event = { "InsertEnter" },
	},

	-- 语言字典补全
	{
		"skywind3000/vim-dict",
		event = { "InsertEnter" },
	},

	{
		"edte/copilot",
		ft = { "lua", "go", "cpp" },
	},

	-- Neovim Lua 插件自动管理字符对。 “mini.nvim” 库的一部分。
	{
		"echasnovski/mini.pairs",
		event = { "InsertEnter" },
		version = false,
		config = function()
			require("mini.pairs").setup()
		end,
	},
}

return M
