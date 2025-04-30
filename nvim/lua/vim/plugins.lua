local M = {}

M.list = {
	-- yanky.nvim的目标是改进 Neovim 的 yank 和 put 功能。
	{
		"gbprod/yanky.nvim",
		dependencies = {
			{ "kkharji/sqlite.lua" },
		},
		opts = {
			ring = { storage = "sqlite" },
			highlight = {
				on_put = true,
				on_yank = true,
				timer = 100,
			},
		},
		keys = {
			{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
		},
	},

	-- 增强 Neovim 中宏的使用。
	{
		"chrisgrieser/nvim-recorder",
		event = "RecordingEnter",
		keys = {
			{ "q", desc = " Start Recording" },
			{ "Q", desc = " Play Recording" },
		},
		opts = {},
	},

	-- 使用“.”启用重复支持的插件映射
	{
		"tpope/vim-repeat",
		keys = { "." },
		event = "VeryLazy",
	},

	-- gx 打开 URL
	{
		"chrishrb/gx.nvim",
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
		-- you can specify also another config if you want
		config = function()
			Require("gx").setup({
				open_browser_app = "open", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
				open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
				handlers = {
					plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
					github = true, -- open github issues
					brewfile = true, -- open Homebrew formulaes and casks
					package_json = true, -- open dependencies from package.json
					search = true, -- search the web/selection on the web if nothing else is found
				},
				handler_options = {
					search_engine = "google", -- you can select between google, bing, duckduckgo, and ecosia
					-- search_engine = "https://search.brave.com/search?q=", -- or you can pass in a custom search engine
				},
			})
		end,
	},

	-- 项目维度的替换插件
	-- normal 下按 \+r 生效
	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<space>sr",
				function()
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					require("grug-far").open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "replace",
			},
		},
	},

	-- 像蜘蛛一样使用 w、e、b 动作。按子词移动并跳过无关紧要的标点符号。
	{
		"chrisgrieser/nvim-spider",
		keys = { "w" },
		-- lazy = true,
		config = function()
			nmap("w", "<cmd>lua require('spider').motion('w')<CR>")
			nmap("e", "<cmd>lua require('spider').motion('e')<CR>")
			nmap("b", "<cmd>lua require('spider').motion('b')<CR>")
		end,
	},

	-- 在 Vim 中，在字符上按 ga 显示其十进制、八进制和十六进制表示形式。 Characterize.vim 通过以下补充对其进行了现代化改造：
	-- Unicode 字符名称： U+00A9 COPYRIGHT SYMBOL
	-- Vim 二合字母（在 <C-K> 之后键入以插入字符）： Co , cO
	-- 表情符号代码：： :copyright:
	-- HTML 实体： &copy;
	{
		"tpope/vim-characterize",
		keys = "ga",
	},

	-- neovim 插件将文件路径和光标所在行复制到剪贴板
	{
		"diegoulloao/nvim-file-location",
		cmd = "Path",
		config = function()
			require("nvim-file-location").setup({
				-- keymap = 'yP',
				mode = "absolute",
				add_line = false,
				add_column = false,
				default_register = "*",
			})
			cmd("command! Path lua NvimFileLocation.copy_file_location('absolute', false, false)<cr>")
		end,
	},

	-- Neovim 中 vimdoc/帮助文件的装饰
	-- https://github.com/OXY2DEV/helpview.nvim
	{
		"OXY2DEV/helpview.nvim",
		lazy = true,
		event = "CmdlineEnter",
		-- ft = "help",

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},

	-- Neovim 动作速度极快！
	{
		"edte/hop.nvim",
		keys = "f",
		config = function()
			require("hop").setup({
				jump_on_sole_occurrence = true,
				create_hl_autocmd = false,
			})
			vim.keymap.set("", "f", function()
				require("hop").hint_patterns()
			end, { remap = true })
		end,
	},

	-- 扩展递增/递减 ctrl+x/a
	{
		"monaqa/dial.nvim",
		keys = { "<C-a>", "<C-x>" },
		opts = {},
		config = function()
			local r = Require("vim.dial")
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
		"echasnovski/mini.surround",
		version = false,
		keys = { "sa", "sd", "sr", "sh" },
		config = function()
			require("mini.surround").setup({
				-- Number of lines within which surrounding is searched
				n_lines = 100,
				mappings = {
					add = "sa", -- Add surrounding in Normal and Visual modes
					delete = "sd", -- Delete surrounding
					replace = "sr", -- Replace surrounding
					highlight = "sh", -- Highlight surrounding
					find = "", -- Find surrounding (to the right)
					find_left = "", -- Find surrounding (to the left)
					update_n_lines = "", -- Update `n_lines`
					suffix_last = "", -- Suffix to search with "prev" method
					suffix_next = "", -- Suffix to search with "next" method
				},
			})
		end,
	},

	-- vim undo tree
	{
		"mbbill/undotree",
		lazy = true,
		cmd = "UndotreeToggle",
	},

	-- Neovim 插件引入了新的操作员动作来快速替换和交换文本。
	{
		"gbprod/substitute.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = { "s", "sx" },
		config = function()
			require("substitute").setup({
				on_substitute = require("yanky.integration").substitute(),
			})

			-- 交换
			-- sx{motion}，按两次即可交换，支持 .
			nmap("sx", "<cmd>lua require('substitute.exchange').operator()<cr>")

			-- 替换
			-- s{motion} 先按s，然后按文本对象就直接替换为默认寄存器里的内容
			nmap("s", "<cmd>lua require('substitute').operator()<cr>")
			xmap("s", "<cmd>lua require('substitute').visual()<cr>")
		end,
	},

	-- 在插入模式和命令行模式下提供emacs键位，比如c-a行首，c-e行尾，normal模式无效
	{
		"tpope/vim-rsi",
		event = { "InsertEnter", "CmdlineEnter" },
	},

	-- Neovim 中更好的快速修复窗口，抛光旧的快速修复窗口。
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		dependencies = {
			"junegunn/fzf",
			run = function()
				vim.fn["fzf#install"]()
			end,
		},
	},

	-- Neovim 插件，用于预览寄存器的内容
	-- 调用:Registers
	-- 按 " 在正常或可视模式下
	-- 按 Ctrl R 在插入模式下
	{
		"tversteeg/registers.nvim",
		cmd = "Registers",
		config = true,
		keys = {
			{ '"', mode = { "n", "v" } },
			{ "<C-R>", mode = "i" },
		},
		name = "registers",
	},

	-- nvim-hlslens 帮助您更好地浏览匹配的信息，在匹配的实例之间无缝跳转。
	{
		"kevinhwang91/nvim-hlslens",
		keys = { "n", "N", "*", "#", "g*", "g#", "/", "?" },
		config = function()
			require("hlslens").setup()

			nmap("n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]])
			nmap("N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]])
			nmap("*", [[*<Cmd>lua require('hlslens').start()<CR>]])
			nmap("#", [[#<Cmd>lua require('hlslens').start()<CR>]])
			nmap("g*", [[g*<Cmd>lua require('hlslens').start()<CR>]])
			nmap("g#", [[g#<Cmd>lua require('hlslens').start()<CR>]])
		end,
	},

	-- numb.nvim 是一个 Neovim 插件，可以以非侵入性的方式查看缓冲区的行。
	{
		"nacro90/numb.nvim",
		event = { "CmdlineEnter" },
		config = function()
			require("numb").setup()
		end,
	},

	-- 向任意方向移动任意选择
	{
		"echasnovski/mini.move",
		keys = {
			{ "<M-h>" },
			{ "<M-l>" },
			{ "<M-j>" },
			{ "<M-k>" },
		},
		opts = {},
	},

	-- 快速添加括号或者引号，v模式选中再按就行，比surroud的sd好用很多，比较常用
	{
		"NStefan002/visual-surround.nvim",
		event = "ModeChanged *:v", -- 进入可视模式
		config = function()
			require("visual-surround").setup({})
		end,
	},

	-- 行内支持 % 跳转引号
	-- 跨行不支持
	{
		"airblade/vim-matchquote",
		keys = "%",
	},

	-- 一个非常轻量级的插件（~ 120loc），可突出显示您在命令行中输入的范围。
	{
		"winston0410/range-highlight.nvim",
		event = { "CmdlineEnter" },
		config = function()
			require("range-highlight").setup({
				excluded = { cmd = { "substitute" } },
			})
		end,
	},
}

return M
