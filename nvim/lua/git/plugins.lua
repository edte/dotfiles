local M = {}

M.list = {

	-- Git blame
	{
		'edte/git-blame.nvim',
		lazy = true,
	},

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
		'akinsho/git-conflict.nvim',
		version = '*',
		config = function()
			-- vim.api.nvim_set_hl(0, "DiffText", { fg = "#ffffff", bg = "#1d3b40" })
			-- vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#ffffff", bg = "#1d3450" })

			vim.api.nvim_set_hl(0, 'ConflictCurrent', { fg = '#ffffff', bg = '#1d3b40' })
			vim.api.nvim_set_hl(0, 'ConflictBase', { fg = '#c8d3f5', bg = '#222436' })
			vim.api.nvim_set_hl(0, 'ConflictIncoming', { fg = '#ffffff', bg = '#1d3450' })

			require('git-conflict').setup({
				highlights = {
					current = 'ConflictCurrent',
					ancestor = 'ConflictBase', -- base
					incoming = 'ConflictIncoming',
				},
			})
		end,
	},

	-- Neovim的 lua 插件，用于为 git 主机网站生成可共享文件永久链接（带有行范围）
	{
		'linrongbin16/gitlinker.nvim',
		cmd = 'GitLink',
		opts = {
			router = {
				browse = {
					['^git%.woa%.com'] = "https://git.woa.com/{_A.ORG}/{_A.REPO}/blob/{_A.REV}/{_A.FILE}#L{_A.LSTART}{_A.LEND > _A.LSTART and ('-' .. _A.LEND) or ''}",
				},
			},
		},
		keys = {
			{ '<space>gy', '<cmd>GitLink<cr>', mode = { 'n', 'v' }, desc = 'Yank git link' },
			{ '<space>go', '<cmd>GitLink!<cr>', mode = { 'n', 'v' }, desc = 'Open git link' },
		},
	},

	-- Neovim 插件，用于查看选定行的 Git 历史记录。在可视化模式下选择一个范围，即可查看其提交演变过程。使用 diffview.nvim 浏览提交、复制 SHA 值并打开完整的差异比较。
	{
		'zenangst/gitlineage.nvim',
		branch = 'fix/file-not-tracked-by-git',
		config = function()
			require('gitlineage').setup({
				keymap = '<space>gh',
				keys = {
					close = '<Esc>',
					next_commit = '<C-n>',
					prev_commit = '<C-p>',
					yank_commit = 'y',
					open_diff = 'd',
				},
			})
		end,
	},

	{
		'esmuellert/codediff.nvim',
		dependencies = { 'MunifTanjim/nui.nvim' },
		cmd = 'CodeDiff',
		opts = {
			highlights = {
				line_delete = "#460000",       -- 删除行背景 (70,0,0)
				line_insert = "#002900",       -- 新增行背景 (0,41,0)
				line_delete_emph = "#460000",  -- 纯删除行背景（跟 line_delete 一样）
				line_insert_emph = "#002900",  -- 纯新增行背景（跟 line_insert 一样）
				char_delete = "#9e0001",       -- 字符级删除高亮 (158,0,1)
				char_insert = "#006200",       -- 字符级新增高亮 (0,98,0)
			},
			explorer = {
				focus_on_select = true, -- 按 l 选文件后自动跳到 diff buffer
			},
			keymaps = {
				view = {
					quit = 'q', -- Close diff tab
					toggle_explorer = '<space>e', -- Toggle + focus explorer
					focus_explorer = false, -- 禁用，toggle 自带 focus
					next_hunk = ']h', -- Jump to next change
					prev_hunk = '[h', -- Jump to previous change
					next_file = ']f', -- Next file in explorer mode
					prev_file = '[f', -- Previous file in explorer mode
				},
				explorer = {
					select = 'l', -- Open diff for selected file
					hover = 'K', -- Show file diff preview
					refresh = 'R', -- Refresh git status
				},
				conflict = {
					accept_incoming = 'ct', -- Accept incoming (theirs/left) change
					accept_current = 'co', -- Accept current (ours/right) change
					accept_this = 'ca',
					accept_both = 'cb', -- Accept both changes (incoming first)
					discard = 'cx', -- Discard both, keep base
					next_conflict = ']x', -- Jump to next conflict
					prev_conflict = '[x', -- Jump to previous conflict
				},
			},
		},
		keys = {
			{
				'<space>d',
				function()
					-- 监听 diff 打开事件，自动隐藏 explorer
					local group = vim.api.nvim_create_augroup('CodeDiffAutoHideExplorer', { clear = true })
					vim.api.nvim_create_autocmd('User', {
						group = group,
						pattern = 'CodeDiffOpen',
						once = true,
						callback = function(ev)
							vim.schedule(function()
								local tabpage = ev.data and ev.data.tabpage or vim.api.nvim_get_current_tabpage()
								local lifecycle = require('codediff.ui.lifecycle')
								local explorer = lifecycle.get_explorer(tabpage)
								if explorer and not explorer.is_hidden then
									require('codediff.ui.explorer').toggle_visibility(explorer)
								end
							end)
						end,
					})
					vim.cmd('CodeDiff')
				end,
				desc = 'diff',
			},
		},
	},
}

return M
