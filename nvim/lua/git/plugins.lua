local M = {}

M.list = {
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		opts = {
			signcolumn = false,
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
		},
	},

	-- 单选项卡界面可轻松循环浏览任何 git rev 的所有修改文件的差异。
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		config = function()
			Setup("diffview", {
				view = {
					-- Configure the layout and behavior of different types of views.
					-- Available layouts:
					--  'diff1_plain'
					--    |'diff2_horizontal'
					--    |'diff2_vertical'
					--    |'diff3_horizontal'
					--    |'diff3_vertical'
					--    |'diff3_mixed'
					--    |'diff4_mixed'
					-- For more info, see |diffview-config-view.x.layout|.
					default = {
						-- Config for changed files, and staged files in diff views.
						layout = "diff2_horizontal",
						disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = false, -- See |diffview-config-view.x.winbar_info|
					},
					merge_tool = {
						-- Config for conflicted files in diff views during a merge or rebase.
						--  ('diff1_plain'|'diff3_horizontal'|'diff3_vertical'|'diff3_mixed'|'diff4_mixed'|-
						layout = "diff3_horizontal",
						disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = true, -- See |diffview-config-view.x.winbar_info|
					},
					file_history = {
						-- Config for changed files in file history views.
						layout = "diff2_horizontal",
						disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = false, -- See |diffview-config-view.x.winbar_info|
					},
				},
			})
		end,
	},

	-- Neovim 中可视化和解决合并冲突的插件
	-- GitConflictChooseOurs — 选择当前更改。
	-- GitConflictChooseTheirs — 选择传入的更改。
	-- GitConflictChooseBoth — 选择两项更改。
	-- GitConflictChooseNone — 不选择任何更改。
	-- GitConflictNextConflict — 移至下一个冲突。
	-- GitConflictPrevConflict — 移至上一个冲突。
	-- GitConflictListQf — 将所有冲突获取到快速修复

	-- c o — 选择我们的
	-- c t — 选择他们的
	-- c b — 选择两者
	-- c 0 — 不选择
	-- ] x — 移至上一个冲突
	-- [ x — 移至下一个冲突
	-- {
	-- 	"akinsho/git-conflict.nvim",
	-- 	-- cmd = {
	-- 	--     "GitConflictChooseOurs",
	-- 	--     "GitConflictChooseTheirs",
	-- 	--     "GitConflictChooseBoth",
	-- 	--     "GitConflictChooseNone",
	-- 	--     "GitConflictNextConflict",
	-- 	--     "GitConflictPrevConflict",
	-- 	--     "GitConflictListQf",
	-- 	-- },
	-- 	version = "*",
	-- 	config = true,
	-- },

	-- Neovim 逃亡风格 git Blame 插件
	{
		"FabijanZulj/blame.nvim",
		lazy = true,
		cmd = { "BlameToggle" },
		config = function()
			require("blame").setup()
		end,
		opts = {
			blame_options = { "-w" },
		},
	},

	-- Neovim的 lua 插件，用于为 git 主机网站生成可共享文件永久链接（带有行范围）
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		opts = {},
		keys = {
			{ "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
			{ "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
		},
	},
}

return M
