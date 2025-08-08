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
		"A7Lavinraj/fyler.nvim",
		dependencies = "echasnovski/mini.icons",
		cmd = { "Fyler" },
		keys = {
			{
				"<Space>e",
				"<CMD>Fyler kind=split_left_most<CR>",
				desc = "Open Fyler",
			},
		},
		opts = {
			mappings = {
				explorer = {
					["<Space>e"] = "CloseView",
				},
			},
			views = {
				explorer = {
					close_on_select = false,
					confirm_simple = true,
					default_explorer = true,
					win = {
						kind_presets = {
							split_left_most = {
								width = 0.15,
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
