local M = {}

M.list = {

	-- GitMessenger
	{
		"rhysd/git-messenger.vim",
		config = function()
			vim.cmd([[
	               let g:git_messenger_floating_win_opts = { 'border': 'single' }
	               let g:git_messenger_popup_content_margins = v:false
	               let g:git_messenger_date_format="%F %H:%M"
	               let g:git_messenger_no_default_mappings=v:true
	           ]])
		end,
	},

	-- Git blame
	-- FIX: 大文件会很慢，看异步咋优化，git-messenger.nvim 就很快
	{
		"edte/git-blame.nvim",
		lazy = true,
	},

	-- 单选项卡界面可轻松循环浏览任何 git rev 的所有修改文件的差异。
	-- {
	-- 	"sindrets/diffview.nvim",
	-- 	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	-- 	config = function()
	-- 		Setup("diffview", {
	-- 			view = {
	-- 				-- Configure the layout and behavior of different types of views.
	-- 				-- Available layouts:
	-- 				--  'diff1_plain'
	-- 				--    |'diff2_horizontal'
	-- 				--    |'diff2_vertical'
	-- 				--    |'diff3_horizontal'
	-- 				--    |'diff3_vertical'
	-- 				--    |'diff3_mixed'
	-- 				--    |'diff4_mixed'
	-- 				-- For more info, see |diffview-config-view.x.layout|.
	-- 				default = {
	-- 					-- Config for changed files, and staged files in diff views.
	-- 					layout = "diff2_horizontal",
	-- 					disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
	-- 					winbar_info = false, -- See |diffview-config-view.x.winbar_info|
	-- 				},
	-- 				merge_tool = {
	-- 					-- Config for conflicted files in diff views during a merge or rebase.
	-- 					--  ('diff1_plain'|'diff3_horizontal'|'diff3_vertical'|'diff3_mixed'|'diff4_mixed'|-
	-- 					layout = "diff3_horizontal",
	-- 					disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
	-- 					winbar_info = true, -- See |diffview-config-view.x.winbar_info|
	-- 				},
	-- 				file_history = {
	-- 					-- Config for changed files in file history views.
	-- 					layout = "diff2_horizontal",
	-- 					disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
	-- 					winbar_info = false, -- See |diffview-config-view.x.winbar_info|
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },

	-- Neovim 中可视化和解决合并冲突的插件
	-- GitConflictChooseOurs — 选择当前更改。
	-- GitConflictChooseTheirs — 选择传入的更改。
	-- GitConflictChooseBoth — 选择两项更改。
	-- GitConflictChooseNone — 不选择任何更改。
	-- GitConflictNextConflict — 移至下一个冲突。
	-- GitConflictPrevConflict — 移至上一个冲突。
	-- GitConflictListQf — 将所有冲突获取到快速修复
	--       A   ← base（共同祖先）
	--      / \
	--     B   C
	-- A：你们分开前的内容（base）
	-- B：你分支的内容（current/ours）
	-- C：同事分支的内容（incoming/theirs）
	-- c o — 选择我们的
	-- c t — 选择他们的
	-- c b — 选择两者
	-- c 0 — 不选择
	-- ] x — 移至上一个冲突
	-- [ x — 移至下一个冲突
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = function()
			-- vim.api.nvim_set_hl(0, "DiffText", { fg = "#ffffff", bg = "#1d3b40" })
			-- vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#ffffff", bg = "#1d3450" })

			vim.api.nvim_set_hl(0, "ConflictCurrent", { fg = "#ffffff", bg = "#1d3b40" })
			vim.api.nvim_set_hl(0, "ConflictBase", { fg = "#c8d3f5", bg = "#222436" })
			vim.api.nvim_set_hl(0, "ConflictIncoming", { fg = "#ffffff", bg = "#1d3450" })

			require("git-conflict").setup({
				highlights = {
					current = "ConflictCurrent",
					ancestor = "ConflictBase", -- base
					incoming = "ConflictIncoming",
				},
			})
		end,
	},

	-- Neovim的 lua 插件，用于为 git 主机网站生成可共享文件永久链接（带有行范围）
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		opts = {
			router = {
				browse = {
					["^git%.woa%.com"] = "https://git.woa.com/{_A.ORG}/{_A.REPO}/blob/{_A.REV}/{_A.FILE}#L{_A.LSTART}{_A.LEND > _A.LSTART and ('-' .. _A.LEND) or ''}",
				},
			},
		},
		keys = {
			{ "<space>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
			{ "<space>go", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
		},
	},
	{
		"esmuellert/vscode-diff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
		opts = {
			keymaps = {
				view = {
					quit = "q", -- Close diff tab
					toggle_explorer = "<space>e", -- Toggle explorer visibility (explorer mode only)
					next_hunk = "]h", -- Jump to next change
					prev_hunk = "[h", -- Jump to previous change
					next_file = "]f", -- Next file in explorer mode
					prev_file = "[f", -- Previous file in explorer mode
				},
				explorer = {
					select = "l", -- Open diff for selected file
					hover = "K", -- Show file diff preview
					refresh = "R", -- Refresh git status
				},
			},
		},
		keys = {
			{
				"<space>d",
				function()
					vim.cmd("CodeDiff")
				end,
				desc = "diff",
			},
		},
	},
}

return M
