local M = {}

M.list = {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		opts = { style = "moon" },
		config = function()
			cmd([[colorscheme tokyonight]])
		end,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter" },
		},
	},

	-- {
	--     "catppuccin/nvim",
	--     config = function()
	--         cmd([[colorscheme catppuccin]])
	--     end,
	-- },

	-- {
	--     "rebelot/kanagawa.nvim",
	--     config = function()
	--         cmd([[colorscheme kanagawa]])
	--     end,
	-- },

	-- 上方的tab栏
	-- 这个不支持git/lsp 告警啥的，也不支持icon的高亮，所以还是用buffeline吧
	-- {
	--     "echasnovski/mini.tabline",
	--     config = function()
	--         nmap("gn", "<cmd>bn<CR>")
	--         nmap("gp", "<cmd>bp<CR>")
	--
	--         local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
	--         if not has_devicons then return end
	--         local get_icon = function(name)
	--             return (devicons.get_icon(vim.fn.fnamemodify(name, ':t'), nil, { default = true }))
	--         end
	--
	--         require("mini.tabline").setup({
	--             format = function(buf_id, label)
	--                 if get_icon == nil then
	--                     return string.format('  %s  ', label)
	--                 end
	--                 return string.format('  %s %s  ', get_icon(vim.api.nvim_buf_get_name(buf_id)), label)
	--             end
	--         })
	--     end,
	-- },

	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "gp", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "gn", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		},
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				-- always_show_bufferline = true,
				diagnostics_indicator = function(_, _, diag)
					if diag.error or diag.warning then
						local ret = (diag.error or "") .. (diag.warning or "")
						return vim.trim(ret)
					end
					return ""
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
					{
						filetype = "snacks_layout_box",
					},
				},
			},
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
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
		name = "statusline",
		dir = "ui.statusline",
		virtual = true,
		config = function()
			require("ui.statusline")
		end,
	},

	-- 右边的滚动条
	{
		"lewis6991/satellite.nvim",
		opts = {
			handlers = {
				marks = {
					enable = false,
				},
			},
		},
	},

	-- 符号树状视图,按 S
	-- {
	--     "hedyhli/outline.nvim",
	--     lazy = true,
	--     cmd = { "Outline", "OutlineOpen" },
	--     keys = { -- Example mapping to toggle outline
	--         { "S", "<cmd>Outline<CR>", desc = "Toggle outline" },
	--     },
	--     opts = {
	--         outline_window = {
	--             auto_close = true,
	--             auto_jump = true,
	--             show_numbers = false,
	--             width = 35,
	--             wrap = true,
	--         },
	--         outline_items = {
	--             show_symbol_lineno = true,
	--             show_symbol_details = false,
	--         },
	--     },
	-- },

	-- wilder.nvim 插件，用于命令行补全，和 noice.nvim 冲突
	{
		"edte/wilder.nvim",
		event = "CmdlineEnter", -- 懒加载：首次进入cmdline时载入
		config = function()
			Setup("ui.wilder")
		end,
	},

	-- buffer 管理文件与目录树的结合
	{
		"echasnovski/mini.files",
		version = false,
		opts = {
			options = {
				use_as_default_explorer = true,
			},
			windows = {
				preview = true,
				width_focus = 30,
				width_preview = 30,
			},
		},
		keys = {
			{
				"<space>e",
				"<cmd>lua ToggleMiniFiles()<CR>",
				desc = "explorer",
			},
		},
		config = function()
			-- nvim-tree
			-- vim.g.loaded_netrw = 1
			-- vim.g.loaded_netrwPlugin = 1
			vim.opt.termguicolors = true

			vim.g.loaded_netrw = false -- or 1
			vim.g.loaded_netrwPlugin = false -- or 1

			Setup("mini.files")
		end,
	},

	-- 这个 Neovim 插件为 Neovim 提供交替语法突出显示（“彩虹括号”），由 Tree-sitter 提供支持。目标是拥有一个可破解的插件，允许全局和每个文件类型进行不同的查询和策略配置。用户可以通过自己的配置覆盖和扩展内置默认值。
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			highlight("RainbowRed", "#E06C75")
			highlight("RainbowYellow", "#E5C07B")
			highlight("RainbowBlue", "#61AFEF")
			highlight("RainbowOrange", "#D19A66")
			highlight("RainbowGreen", "#98C379")
			highlight("RainbowViolet", "#C678DD")
			highlight("RainbowCyan", "#56B6C2")

			require("rainbow-delimiters.setup").setup({
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				highlight = {
					"RainbowRed",
					"RainbowYellow",
					"RainbowBlue",
					"RainbowOrange",
					"RainbowGreen",
					"RainbowViolet",
					"RainbowCyan",
				},
			})
		end,
	},

	-- Whichkey
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("ui.whichkey")
		end,
		dependencies = {
			-- 更好的注释生成器。支持多种语言和注释约定。
			-- gcn 在内部快速生成注释
			{
				"danymat/neogen",
				after = "nvim-treesitter",
				keys = "gcn",
				config = function()
					require("neogen").setup({})
					nmap("gcn", "<cmd>lua require('neogen').generate()<CR>")
				end,
			},
		},
	},

	-- 一个微型 Neovim 插件，用于在视觉模式下突出显示与当前选择匹配的文本
	{
		"wurli/visimatch.nvim",
		opts = {
			chars_lower_limit = 3,
		},
	},

	-- Neovim 的通用日志语法突出显示和文件类型管理
	{
		"fei6409/log-highlight.nvim",
		ft = "log",
		config = function()
			require("log-highlight").setup({})
		end,
	},

	-- ui components
	{ "MunifTanjim/nui.nvim", lazy = true },

	-- 高度实验性的插件完全取代了消息，CMDline和PopupMenu的UI。
	-- {
	-- 	"folke/noice.nvim",
	-- 	event = "VeryLazy",
	-- 	keys = {
	-- 		{ "<space>n", "<cmd>message<cr>", desc = "message" },
	-- 	},
	-- 	opts = {
	-- 		views = {
	-- 			split = {
	-- 				backend = "split",
	-- 				enter = false,
	-- 				relative = "editor",
	-- 				position = "bottom",
	-- 				size = "40%",
	-- 				close = {
	-- 					keys = { "q", "<enter>", "<space>", "<esc>" },
	-- 				},
	-- 				win_options = {
	-- 					winhighlight = { Normal = "NoiceSplit", FloatBorder = "NoiceSplitBorder" },
	-- 					wrap = true,
	-- 				},
	-- 			},
	-- 			mini = {
	-- 				align = "message-left",
	-- 				timeout = 3000,
	-- 				position = {
	-- 					col = 0,
	-- 				},
	-- 			},
	-- 			confirm = {
	-- 				backend = "popup",
	-- 				relative = "editor",
	-- 				focusable = false,
	-- 				align = "center",
	-- 				enter = false,
	-- 				zindex = 210,
	-- 				format = { "{confirm}" },
	-- 				position = {
	-- 					row = "100%",
	-- 					col = "0%",
	-- 				},
	-- 				size = "auto",
	-- 			},
	-- 		},
	-- 		presets = {
	-- 			long_message_to_split = true,
	-- 			lsp_doc_border = true,
	-- 		},
	-- 		routes = {
	-- 			{ filter = { find = "E162" }, view = "mini" },
	-- 			{ filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
	-- 			{ filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
	-- 			{ filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
	-- 			{ filter = { event = "emsg", find = "E23" }, skip = true },
	-- 			{ filter = { event = "emsg", find = "E20" }, skip = true },
	-- 			{ filter = { find = "No signature help" }, skip = true },
	-- 			{ filter = { find = "E37" }, skip = true },
	-- 		},
	-- 		cmdline = {
	-- 			enabled = true,
	-- 			view = "cmdline",
	-- 			format = {
	-- 				cmdline = { pattern = "^:", icon = "" },
	-- 				search_down = false,
	-- 				search_up = false,
	-- 				filter = false,
	-- 				lua = false,
	-- 				input = false,
	-- 				help = false,
	-- 			},
	-- 		},
	-- 		messages = {
	-- 			enabled = true,
	-- 			view_search = false,
	-- 			view = "mini", -- default view for messages
	-- 			view_error = "mini", -- view for errors
	-- 			view_warn = "mini", -- view for warnings
	-- 			view_history = "messages", -- view for :messages
	-- 		},
	-- 		popupmenu = {
	-- 			enabled = false,
	-- 		},
	-- 		notify = {
	-- 			enabled = false,
	-- 			view = "notify",
	-- 		},
	-- 		health = { checker = false },
	-- 		lsp = {
	-- 			progress = {
	-- 				enabled = false,
	-- 			},
	-- 			override = {
	-- 				["vim.lsp.util.convert_input_to_markdown_lines"] = false,
	-- 				["vim.lsp.util.stylize_markdown"] = false,
	-- 				["cmp.entry.get_documentation"] = false,
	-- 			},
	-- 			hover = {
	-- 				enabled = false,
	-- 			},
	-- 			signature = {
	-- 				enabled = false,
	-- 			},
	-- 			message = {
	-- 				enabled = false,
	-- 			},
	-- 			health = {
	-- 				checker = true,
	-- 			},
	-- 		},
	-- 	},
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 	},
	-- },
}

return M
