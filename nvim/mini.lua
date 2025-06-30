-- 最小配置

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"olimorris/codecompanion.nvim",

		config = function()
			require("codecompanion").setup({
				language = "Chinese",

				display = {
					action_palette = {
						width = 95,
						height = 10,
						prompt = "Prompt ", -- Prompt used for interactive LLM calls
						provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
						opts = {
							show_default_actions = true, -- Show the default actions in the action palette?
							show_default_prompt_library = true, -- Show the default prompt library in the action palette?
						},
					},
				},

				adapters = {
					deepseek = function()
						return require("codecompanion.adapters").extend("deepseek", {
							env = {
								api_key = "DEEPSEEK_API_KEY",
							},
							url = "https://api.lkeap.cloud.tencent.com/v1/chat/completions",
							schema = {
								model = {
									default = "deepseek-v3",
									choices = {
										["deepseek-v3"] = { opts = { can_reason = true, can_use_tools = false } },
										["deepseek-r1"] = { opts = { can_use_tools = false } },
									},
								},
							},
						})
					end,
				},

				strategies = {
					chat = { adapter = "deepseek" },
					inline = { adapter = "deepseek" },
					agent = { adapter = "deepseek" },
				},
			})

			vim.keymap.set({ "n" }, "<space>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
			vim.keymap.set({ "v" }, "<space>a", "<cmd>CodeCompanion <cr>", { noremap = true, silent = true })
			vim.cmd([[cab c CodeCompanion]])
		end,

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
})
