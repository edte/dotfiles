local M = {}

M.list = {

	-- wilder.nvim 插件，用于命令行补全，和 noice.nvim 冲突
	{
		'edte/wilder.nvim',
		event = 'CmdlineEnter', -- 懒加载：首次进入cmdline时载入
		config = function()
			Setup('vim.wilder')
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

	-- yanky.nvim的目标是改进 Neovim 的 yank 和 put 功能。
	{
		'gbprod/yanky.nvim',
		dependencies = {
			{ 'kkharji/sqlite.lua' },
		},
		opts = {
			ring = {
				storage = 'sqlite',
				update_register_on_cycle = true,
			},
			highlight = {
				on_put = true,
				on_yank = true,
				timer = 100,
			},
		},
		keys = {
			{ 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
			-- { "p", "<Plug>(YankyPutAfter)", mode = { "n" }, desc = "Put yanked text after cursor" },
			{ 'p', '<Plug>(YankyPutBefore)', mode = { 'x' }, desc = 'Put yanked text before cursor' },
		},
	},

	-- 增强 Neovim 中宏的使用。
	{
		'chrisgrieser/nvim-recorder',
		event = 'RecordingEnter',
		keys = {
			{ 'q', desc = ' Start Recording' },
			{ 'Q', desc = ' Play Recording' },
		},
		opts = {},
	},

	-- gx 打开 URL
	{
		'chrishrb/gx.nvim',
		keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
		cmd = { 'Browse' },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		dependencies = { 'nvim-lua/plenary.nvim' },
		-- you can specify also another config if you want
		config = function()
			Require('gx').setup({
				open_browser_app = 'open', -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
				open_browser_args = { '--background' }, -- specify any arguments, such as --background for macOS' "open".
				handlers = {
					plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
					github = true, -- open github issues
					brewfile = true, -- open Homebrew formulaes and casks
					package_json = true, -- open dependencies from package.json
					search = true, -- search the web/selection on the web if nothing else is found
				},
				handler_options = {
					search_engine = 'google', -- you can select between google, bing, duckduckgo, and ecosia
					-- search_engine = "https://search.brave.com/search?q=", -- or you can pass in a custom search engine
				},
			})
		end,
	},

	-- 项目维度的替换插件
	-- normal 下按 \+r 生效
	{
		'MagicDuck/grug-far.nvim',
		opts = { headerMaxWidth = 80 },
		cmd = 'GrugFar',
		keys = {
			{
				'<space>sr',
				function()
					local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
					require('grug-far').open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
						},
					})
				end,
				mode = { 'n', 'v' },
				desc = 'replace',
			},
		},
	},

	-- 像蜘蛛一样使用 w、e、b 动作。按子词移动并跳过无关紧要的标点符号。
	{
		'chrisgrieser/nvim-spider',
		keys = { 'w' },
		-- lazy = true,
		config = function()
			nmap('w', "<cmd>lua require('spider').motion('w')<CR>")
			nmap('e', "<cmd>lua require('spider').motion('e')<CR>")
			nmap('b', "<cmd>lua require('spider').motion('b')<CR>")
		end,
	},

	-- Neovim 中 vimdoc/帮助文件的装饰
	-- https://github.com/OXY2DEV/helpview.nvim
	{
		'OXY2DEV/helpview.nvim',
		lazy = true,
		event = 'CmdlineEnter',
		-- ft = "help",

		dependencies = {
			'nvim-treesitter/nvim-treesitter',
		},
	},

	-- 扩展递增/递减 ctrl+x/a
	{
		'monaqa/dial.nvim',
		keys = { '<C-a>', '<C-x>' },
		opts = {},
		config = function()
			local r = Require('vim.dial')
			if r ~= nil then
				r.dialConfig()
			end
		end,
	},

	-- 添加、删除、替换、查找、突出显示周围（如一对括号、引号等）。
	-- 使用sa添加周围环境（在视觉模式或运动模式下）。
	-- 用sd删除周围的内容。
	-- 将周围替换为sr 。
	-- 使用sf或sF查找周围环境（向右或向左移动光标）。
	-- 用sh突出显示周围。
	-- 使用sn更改相邻线的数量（请参阅 |MiniSurround-algorithm|）。
	{
		'echasnovski/mini.surround',
		version = false,
		keys = { 'sa', 'sd', 'sr', 'sh' },
		config = function()
			require('mini.surround').setup({
				-- Number of lines within which surrounding is searched
				n_lines = 100,
				mappings = {
					add = 'sa', -- Add surrounding in Normal and Visual modes
					delete = 'sd', -- Delete surrounding
					replace = 'sr', -- Replace surrounding
					highlight = 'sh', -- Highlight surrounding
					find = '', -- Find surrounding (to the right)
					find_left = '', -- Find surrounding (to the left)
					update_n_lines = '', -- Update `n_lines`
					suffix_last = '', -- Suffix to search with "prev" method
					suffix_next = '', -- Suffix to search with "next" method
				},
			})
		end,
	},

	-- Neovim 插件引入了新的操作员动作来快速替换和交换文本。
	{ --${conf, substitute.nvim}
		'gbprod/substitute.nvim',
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = { 's', 'sx' },
		config = function()
			require('substitute').setup({
				on_substitute = require('yanky.integration').substitute(),
			})

			-- 交换
			-- sx{motion}，按两次即可交换，支持 .
			nmap('sx', "<cmd>lua require('substitute.exchange').operator()<cr>")

			-- 替换
			-- s{motion} 先按s，然后按文本对象就直接替换为默认寄存器里的内容
			nmap('s', "<cmd>lua require('substitute').operator()<cr>")
			xmap('s', "<cmd>lua require('substitute').visual()<cr>")
		end,
	},

	{
		'stevearc/quicker.nvim',
		ft = 'qf',
		opts = {
			opts = {
				number = true,
				wrap = true,
			},
			keys = {
				{ '>', "<cmd>lua require('quicker').expand()<CR>", desc = 'Expand quickfix content' },
				{ '<', "<cmd>lua require('quicker').collapse()<CR>", desc = 'Collapse quickfix content' },
			},
		},
	},

	-- 增强 quickfix 窗口功能
	{
		'kevinhwang91/nvim-bqf',
		ft = 'qf',
		opts = {},
	},

	-- Neovim 插件，用于预览寄存器的内容
	-- 调用:Registers
	-- 按 " 在正常或可视模式下
	-- 按 Ctrl R 在插入模式下
	{
		'tversteeg/registers.nvim',
		cmd = 'Registers',
		config = true,
		keys = {
			{ '"', mode = { 'n', 'v' } },
			{ '<C-R>', mode = 'i' },
		},
		name = 'registers',
	},

	-- nvim-hlslens 帮助您更好地浏览匹配的信息，在匹配的实例之间无缝跳转。
	{ --${conf, nvim-hlslens}
		'kevinhwang91/nvim-hlslens',
		keys = { 'n', 'N', '*', '#', 'g*', 'g#', '/', '?' },
		config = function()
			require('hlslens').setup()

			nmap('n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]])
			nmap('N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]])
			nmap('*', [[*<Cmd>lua require('hlslens').start()<CR>]])
			nmap('#', [[#<Cmd>lua require('hlslens').start()<CR>]])
			nmap('g*', [[g*<Cmd>lua require('hlslens').start()<CR>]])
			nmap('g#', [[g#<Cmd>lua require('hlslens').start()<CR>]])
		end,
	},

	-- numb.nvim 是一个 Neovim 插件，可以以非侵入性的方式查看缓冲区的行。
	{
		'nacro90/numb.nvim',
		event = { 'CmdlineEnter' },
		config = function()
			require('numb').setup()
		end,
	},

	-- 快速添加括号或者引号，v模式选中再按就行，比surroud的sd好用很多，比较常用
	{
		'edte/visual-surround.nvim',
		event = 'ModeChanged *:v', -- 进入可视模式
		config = function()
			require('visual-surround').setup({})
		end,
	},

	-- 一个非常轻量级的插件（~ 120loc），可突出显示您在命令行中输入的范围。
	{ --${conf, range-highlight}
		'pipoprods/range-highlight.nvim',
		event = { 'CmdlineEnter' },
		config = function()
			require('range-highlight').setup({
				excluded = { cmd = { 'substitute' } },
			})
		end,
	},

	{
		'abecodes/tabout.nvim',
		lazy = false,
		config = function()
			require('tabout').setup({
				tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
				backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
				act_as_tab = true, -- shift content if tab out is not possible
				act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
				default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
				default_shift_tab = '<C-d>', -- reverse shift default action,
				enable_backwards = true, -- well ...
				completion = false, -- if the tabkey is used in a completion pum
				tabouts = {
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = '`', close = '`' },
					{ open = '(', close = ')' },
					{ open = '[', close = ']' },
					{ open = '{', close = '}' },
				},
				ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
				exclude = {}, -- tabout will ignore these filetypes
			})
		end,
		opt = true, -- Set this to true if the plugin is optional
		event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
		priority = 1000,
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
