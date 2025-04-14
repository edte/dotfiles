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

	-- 左边的状态列
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				-- relculright = true,
				segments = {
					-- marks
					{ sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = false } },
					-- 行号
					{ text = { builtin.lnumfunc } },
					-- 折叠
					{ text = { builtin.foldfunc } },
				},
			})
		end,
	},

	--
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

	-- Neovim Lua 插件可在缩进范围内可视化和操作。 “mini.nvim”库的一部分。
	{
		"echasnovski/mini.indentscope",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		version = false, -- wait till new 0.7.0 release to put it back on semver
		config = function()
			require("mini.indentscope").setup({
				draw = {
					priority = 2,
					animation = require("mini.indentscope").gen_animation.none(),
				},
			})

			-- do 删除
			vim.keymap.set("o", "o", function()
				local operator = vim.v.operator
				if operator == "d" then
					local scope = MiniIndentscope.get_scope()
					local top = scope.border.top
					local bottom = scope.border.bottom
					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					_ = col
					local move = ""
					if row == bottom then
						move = "k"
					elseif row == top then
						move = "j"
					end
					local ns = vim.api.nvim_create_namespace("border")
					vim.hl.range(0, ns, "Substitute", { top - 1, 0 }, { top - 1, -1 })
					vim.hl.range(0, ns, "Substitute", { bottom - 1, 0 }, { bottom - 1, -1 })
					vim.defer_fn(function()
						vim.api.nvim_buf_set_text(0, top - 1, 0, top - 1, -1, {})
						vim.api.nvim_buf_set_text(0, bottom - 1, 0, bottom - 1, -1, {})
						vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
					end, 150)
					return "<esc>" .. move
				else
					return "o"
				end
			end, { expr = true })
		end,
		init = function()
			Autocmd("FileType", {
				pattern = {
					"alpha",
					"dashboard",
					"fzf",
					"help",
					"lazy",
					"lazyterm",
					"mason",
					"neo-tree",
					"notify",
					"toggleterm",
					"Trouble",
					"trouble",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
			require("mini.indentscope").setup({
				symbol = "│",
				options = { try_as_border = true },
			})
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
	-- 			split = { enter = true },
	-- 			mini = { win_options = { winblend = 100 } },
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
	-- 			enabled = false,
	-- 			view_search = false,
	-- 		},
	-- 		popupmenu = {
	-- 			enabled = false,
	-- 		},
	-- 		notify = {
	-- 			enabled = false,
	-- 			view = "notify",
	-- 		},
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
