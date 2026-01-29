local M = {}

M.list = {

	{
		'akinsho/bufferline.nvim',
		event = 'VeryLazy',
		keys = {
			{ 'gp', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
			{ 'gn', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
		},
		opts = {
			options = {
				diagnostics = 'nvim_lsp',
				-- always_show_bufferline = true,
				diagnostics_indicator = function(_, _, diag)
					if diag.error or diag.warning then
						local ret = (diag.error or '') .. (diag.warning or '')
						return vim.trim(ret)
					end
					return ''
				end,
				offsets = {
					{
						filetype = 'neo-tree',
						text = 'Neo-tree',
						highlight = 'Directory',
						text_align = 'left',
					},
					{
						filetype = 'snacks_layout_box',
					},
				},
			},
		},
		config = function(_, opts)
			require('bufferline').setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
				callback = function()
					vim.schedule(function()
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},

	-- 下方的状态栏
	{
		name = 'statusline',
		dir = 'ui.statusline',
		virtual = true,
		config = function()
			require('ui.statusline')
		end,
	},

	-- 右边的滚动条
	{
		'lewis6991/satellite.nvim',
		opts = {
			handlers = {
				marks = {
					enable = false,
				},
				gitsigns = {
					enable = false,
				},
			},
		},
	},

	-- wilder.nvim 插件，用于命令行补全，和 noice.nvim 冲突
	{
		'edte/wilder.nvim',
		event = 'CmdlineEnter', -- 懒加载：首次进入cmdline时载入
		config = function()
			Setup('ui.wilder')
		end,
	},

	-- 这个 Neovim 插件为 Neovim 提供交替语法突出显示（“彩虹括号”），由 Tree-sitter 提供支持。目标是拥有一个可破解的插件，允许全局和每个文件类型进行不同的查询和策略配置。用户可以通过自己的配置覆盖和扩展内置默认值。
	{
		'HiPhish/rainbow-delimiters.nvim',
		event = { 'BufReadPost', 'BufNewFile', 'BufWritePre', 'VeryLazy' },
		config = function()
			local rainbow_delimiters = require('rainbow-delimiters')

			highlight('RainbowRed', '#E06C75')
			highlight('RainbowYellow', '#E5C07B')
			highlight('RainbowBlue', '#61AFEF')
			highlight('RainbowOrange', '#D19A66')
			highlight('RainbowGreen', '#98C379')
			highlight('RainbowViolet', '#C678DD')
			highlight('RainbowCyan', '#56B6C2')

			require('rainbow-delimiters.setup').setup({
				strategy = {
					[''] = rainbow_delimiters.strategy['global'],
					vim = rainbow_delimiters.strategy['local'],
				},
				query = {
					[''] = 'rainbow-delimiters',
					lua = 'rainbow-blocks',
				},
				priority = {
					[''] = 110,
					lua = 210,
				},
				highlight = {
					'RainbowRed',
					'RainbowYellow',
					'RainbowBlue',
					'RainbowOrange',
					'RainbowGreen',
					'RainbowViolet',
					'RainbowCyan',
				},
			})
		end,
	},

	-- 一个微型 Neovim 插件，用于在视觉模式下突出显示与当前选择匹配的文本
	{
		'prime-run/visimatch.nvim',
		event = 'ModeChanged *:v', -- 进入可视模式
		opts = {
			chars_lower_limit = 3,
		},
	},

	-- ui components
	{ 'MunifTanjim/nui.nvim', lazy = true },

	-- {
	-- 	"A7Lavinraj/fyler.nvim",
	-- 	dependencies = { "nvim-mini/mini.icons" },
	-- 	cmd = { "Fyler" },
	-- 	keys = {
	-- 		{
	-- 			"<space>e",
	-- 			function()
	-- 				require("fyler").toggle({
	-- 					kind = "split_left_most",
	-- 				})
	-- 			end,
	-- 		},
	-- 	},
	-- 	opts = {
	-- 		integrations = {
	-- 			-- icon = "nvim_web_devicons",
	-- 		},
	--
	-- 		mappings = {
	-- 			explorer = {
	-- 				["<CR>"] = "Select",
	-- 				["<C-t>"] = "SelectTab",
	-- 				["|"] = "SelectVSplit",
	-- 				["-"] = "SelectSplit",
	-- 				["h"] = "GotoParent",
	-- 				["="] = "GotoCwd",
	-- 			},
	-- 		},
	-- 		views = {
	-- 			explorer = {
	-- 				close_on_select = true,
	-- 				confirm_simple = true,
	-- 				default_explorer = true,
	-- 				win = {
	-- 					kind_presets = {
	-- 						split_left_most = {
	-- 							width = "0.15rel",
	-- 						},
	-- 					},
	-- 					win_opts = {
	-- 						number = false,
	-- 						relativenumber = false,
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
}

return M
