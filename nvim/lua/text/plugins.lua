local M = {}

M.list = {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts_extend = { "ensure_installed" },
		-- init = function(plugin)
		-- 	-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
		-- 	-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
		-- 	-- no longer trigger the **nvim-treesitter** module to be loaded in time.
		-- 	-- Luckily, the only things that those plugins need are the custom queries, which we make available
		-- 	-- during startup.
		-- 	require("lazy.core.loader").add_to_rtp(plugin)
		-- 	require("nvim-treesitter.query_predicates")
		-- end,
		config = function()
			local r = Require("text.treesitter")
			if r ~= nil then
				r.config()
			end
		end,
	},

	-- 语法感知文本对象、选择、移动、交换和查看支持。
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	event = "VeryLazy",
	-- 	enabled = true,
	-- 	config = function()
	-- 		-- If treesitter is already loaded, we need to run config again for textobjects
	-- 		if is_loaded("nvim-treesitter") then
	-- 			local opts = get_opts("nvim-treesitter")
	-- 			require("nvim-treesitter.configs").setup({
	-- 				textobjects = opts.textobjects,
	-- 			})
	-- 		end
	--
	-- 		-- When in diff mode, we want to use the default
	-- 		-- vim text objects c & C instead of the treesitter ones.
	-- 		local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
	-- 		local configs = require("nvim-treesitter.configs")
	-- 		for name, fn in pairs(move) do
	-- 			if name:find("goto") == 1 then
	-- 				move[name] = function(q, ...)
	-- 					if vim.wo.diff then
	-- 						local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
	-- 						for key, query in pairs(config or {}) do
	-- 							if q == query and key:find("[%]%[][cC]") then
	-- 								vim.cmd("normal! " .. key)
	-- 								return
	-- 							end
	-- 						end
	-- 					end
	-- 					return fn(q, ...)
	-- 				end
	-- 			end
	-- 		end
	-- 	end,
	-- },

	-- 显示代码上下文,包含函数签名
	-- 只能从下面固定多少个，而不是从上面固定，所以如果套太多层，函数名会显示不出来
	{
		"nvim-treesitter/nvim-treesitter-context",
		after = "nvim-treesitter",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	},

	-- 使用 Treesitter 突出显示参数的定义和用法
	{
		"m-demare/hlargs.nvim",
		config = function()
			require("hlargs").setup()
		end,
	},
	{
		"aaronik/treewalker.nvim",

		-- The following options are the defaults.
		-- Treewalker aims for sane defaults, so these are each individually optional,
		-- and setup() does not need to be called, so the whole opts block is optional as well.
		opts = {
			-- Whether to briefly highlight the node after jumping to it
			highlight = true,

			-- How long should above highlight last (in ms)
			highlight_duration = 250,

			-- The color of the above highlight. Must be a valid vim highlight group.
			-- (see :h highlight-group for options)
			highlight_group = "CursorLine",
		},
		keys = {
			{ "<c-k>", "<cmd>Treewalker Up<cr>", mode = { "n", "v" }, desc = "up" },
			{ "<c-j>", "<cmd>Treewalker Down<cr>", mode = { "n", "v" }, desc = "down" },
			-- { "<left>", "<cmd>Treewalker Left<cr>", mode = { "n", "v" }, desc = "down" },
			-- { "<right>", "<cmd>Treewalker Right<cr>", mode = { "n", "v" }, desc = "down" },
		},
	},
}

return M
