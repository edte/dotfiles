local M = {}

M.list = {
	-- 展示颜色
	-- TODO: cmp 集成
	{
		"NvChad/nvim-colorizer.lua",
		event = "VeryLazy",
		config = function()
			local r = Require("colorizer")
			if r == nil then
				return
			end

			r.setup({
				filetypes = {
					"*", -- Highlight all files, but customize some others.
					cmp_docs = { always_update = true },
				},
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" codes like Blue or blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				AARRGGBB = true, -- 0xAARRGGBB hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},

	--TODO:
	--FIX:
	--NOTE:
	--WARN:
	{
		"echasnovski/mini.hipatterns",
		version = false,
		config = function()
			require("components.todo").setup()
		end,
	},

	-- Neovim 中人类可读的内联 cron 表达式
	-- {
	-- 	"fabridamicelli/cronex.nvim",
	-- 	opts = {},
	-- 	ft = { "go" },
	-- 	config = function()
	-- 		local r = Require("components.cron")
	-- 		if r ~= nil then
	-- 			r.cronConfig()
	-- 		end
	-- 	end,
	-- },

	-- 翻译插件
	{
		cmd = { "Translate" },
		"uga-rosa/translate.nvim",
	},

	-- markdown预览
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown", "Avante" },

		branch = "dev",

		dependencies = {
			-- You will not need this if you installed the
			-- parsers manually
			-- Or if the parsers are in your $RUNTIMEPATH

			"nvim-tree/nvim-web-devicons",

			-- Otter.nvim 为其他文档中嵌入的代码提供 lsp 功能和代码补全源
			{
				"jmbuhr/otter.nvim",
				ft = "markdown", -- If you decide to lazy-load anyway
				dependencies = {
					"nvim-treesitter/nvim-treesitter",
				},
				opts = {},
			},
		},
		config = function()
			require("markview").setup({})
		end,
	},

	-- precognition.nvim - 预识别使用虚拟文本和装订线标志来显示可用的动作。
	-- Precognition toggle
	-- {
	-- 	"tris203/precognition.nvim",
	-- 	opts = {},
	-- },

	-- 跟踪在 Neovim 中编码所花费的时间
	-- {
	-- 	"ptdewey/pendulum-nvim",
	-- 	config = function()
	-- 		require("pendulum").setup({
	-- 			log_file = vim.fn.expand("$HOME/Documents/my_custom_log.csv"),
	-- 			timeout_len = 300, -- 5 minutes
	-- 			timer_len = 60, -- 1 minute
	-- 			gen_reports = true, -- Enable report generation (requires Go)
	-- 			top_n = 10, -- Include top 10 entries in the report
	-- 		})
	-- 	end,
	-- },

	-- 图片预览
	-- {
	--     "3rd/image.nvim",
	--     -- ft = "markdown", -- If you decide to lazy-load anyway
	--     opts = {
	--         max_height_window_percentage = 80,
	--         max_width_window_percentage = 80,
	--         window_overlap_clear_enabled = false,
	--         editor_only_render_when_focused = false,
	--         tmux_show_only_in_active_window = true,
	--     }
	-- },

	-- 一些文件用了x权限，忘记用sudo打开但是又编辑过文件了，用这个插件可以保存，或者直接打开新的文件
	-- 比如 /etc/hosts 文件
	{
		"lambdalisue/vim-suda",
		cmd = { "SudaRead", "SudaWrite" },
		config = function()
			cmd("let g:suda_smart_edit = 1")
			cmd("let g:suda#noninteractive = 1")
		end,
	},

	-- 最精美的 Neovim 色彩工具
	{ "nvzone/volt", lazy = true },
	{
		"nvzone/minty",
		cmd = { "Shades", "Huefy" },
	},

	-- 自动保存会话
	-- 保存目录是：（不知道哪里配置的）
	-- /Users/edte/.local/state/nvim/view
	{
		"echasnovski/mini.sessions",
		config = function()
			require("mini.sessions").setup({
				autoread = false,
				autowrite = false,
				verbose = { read = false, write = false, delete = false },
			})

			local function GetPath()
				local dir, _ = vim.fn.getcwd():gsub("/", "_"):gsub("%.", "-")
				return dir
			end

			-- FIX: 这里如果打开了一个没有打开过的session，会报错，看能不能提前判断一下
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.fn.argc(-1) == 0 then
						MiniSessions.read(GetPath())
					end
				end,
				nested = true,
			})
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					if vim.fn.argc(-1) > 0 then
						cmd("argdelete *")
					end

					MiniSessions.write(GetPath())
				end,
			})
		end,
	},

	-- cp 选择颜色
	{
		"edte/colortils.nvim",
		keys = { "cp" },
		config = function()
			nmap("cp", "<cmd>Colortils<CR>")
			require("colortils").setup()
			highlight("ColortilsCurrentLine", "#A10000")
		end,
	},

	-- 📸 功能丰富的快照插件，可以为 Neovim 制作漂亮的代码快照
	{
		"mistricky/codesnap.nvim",
		build = "make",
		keys = {
			{ "<leader>c", "<cmd>CodeSnap<cr>", mode = "x", desc = "snapshot" },
		},
	},

	-- Screencast your keys in Neovim
	{
		"NStefan002/screenkey.nvim",
		cmd = "Screenkey",
		version = "*", -- or branch = "dev", to use the latest commit
	},

	-- neovim 交互式数据库客户端
	{
		"kndndrj/nvim-dbee",
		ft = "sql",
		dependencies = {
			{
				"MunifTanjim/nui.nvim",
				config = function()
					local NuiTable = require("nui.table")

					function render_tsv_as_table()
						local lines = {}
						local headers = {}
						local data = {}

						-- Get the current buffer number
						local bufnr = vim.api.nvim_get_current_buf()

						-- Get the filetype of the current buffer
						local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

						-- Check if the filetype is tsv
						if filetype ~= "tsv" then
							log.error("Error: Current buffer is not a TSV file.")
							return
						end

						-- Get the lines from the current buffer
						lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

						-- log.error(vim.api.nvim_buf_get_option("0", {"filetype"}), lines, #lines)

						if #lines == 1 then
							return
						end

						if #lines > 0 then
							headers = vim.split(lines[1], "\t")
							for i = 2, #lines do
								local row = {}
								local values = vim.split(lines[i], "\t")
								for j, header in ipairs(headers) do
									row[header] = values[j]
								end
								table.insert(data, row)
							end
						else
							log.error("Error: Current buffer is empty.")
							return
						end

						-- Clear the current buffer
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

						local tbl = NuiTable({
							bufnr = bufnr,
							columns = vim.tbl_map(function(header)
								return {
									align = "center",
									accessor_key = header,
									header = header,
								}
							end, headers),
							data = data,
						})

						tbl:render()
					end
				end,
			},
		},
		build = function()
			-- Install tries to automatically detect the install method.
			-- if it fails, try calling it with one of these parameters:
			--    "curl", "wget", "bitsadmin", "go"
			require("dbee").install()
		end,
		config = function()
			require("dbee").setup( --[[optional config]])
		end,
	},

	-- http 请求
	{
		"mistweaverco/kulala.nvim",
		tag = "v4.10.0",
		ft = "http",
		opts = {
			default_view = "body",
			display_mode = "float",
			winbar = false,
			ui = {
				show_request_summary = false,
			},
			contenttypes = {
				["application/csv"] = {
					ft = "csv",
					formatter = function(body)
						return body
					end,
					pathresolver = function(body, path)
						return body
					end,
				},
				["text/csv"] = {
					ft = "csv",
					formatter = function(body)
						return body
					end,
					pathresolver = function(body, path)
						return body
					end,
				},
				["text/tsv"] = {
					ft = "tsv",
					formatter = function(body)
						return body
					end,
					pathresolver = function(body, path)
						return body
					end,
				},
			},
		},
	},

	-- 轻松将图像嵌入到任何标记语言中，例如 LaTeX、Markdown 或 Typst
	{
		"HakonHarnes/img-clip.nvim",
		cmd = "PasteImage",
		opts = {},
	},

	-- 局部run代码
	{
		"michaelb/sniprun",
		branch = "master",
		cmd = "SnipRun",

		build = "sh install.sh",
		-- do 'sh install.sh 1' if you want to force compile locally
		-- (instead of fetching a binary from the github release). Requires Rust >= 1.65

		config = function()
			require("sniprun").setup({
				display = {
					"VirtualText", --# display results as virtual text
					"Terminal", --# display ok results as virtual text (multiline is shortened)
				},
				display_options = {
					terminal_position = "horizontal", --# or "horizontal", to open as horizontal split instead of vertical split
					terminal_height = 5, --# change the terminal display option height (if horizontal)
				},
			})
		end,
	},

	-- 用于 Lua 开发和 Neovim 探索的便捷便签本/REPL/调试控制台
	{
		"yarospace/lua-console.nvim",
		lazy = true,
		keys = "&",
		opts = {
			buffer = {
				result_prefix = "=> ",
				save_path = vim.fn.stdpath("state") .. "/lua-console.lua",
				autosave = true, -- autosave on console hide / close
				load_on_start = true, -- load saved session on start
				preserve_context = true, -- preserve results between evaluations
			},
			window = {
				border = "double", -- single|double|rounded
				height = 0.6, -- percentage of main window
			},
			mappings = {
				toggle = "&",
				attach = "<c-\\>",
				quit = "q",
				eval = "<CR>",
				eval_buffer = "<S-CR>",
				open = "gf",
				messages = "M",
				save = "S",
				load = "L",
				resize_up = "<C-Up>",
				resize_down = "<C-Down>",
				help = "?",
			},
		},
	},

	-- 像使用 Cursor AI IDE 一样使用 Neovim！
	-- {
	--     "yetone/avante.nvim",
	--     event = "VeryLazy",
	--     lazy = false,
	--     version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
	--     opts = {
	--         provider = "deepseek",
	--         vendors = {
	--             deepseek = {
	--                 __inherited_from = "openai",
	--                 api_key_name = "DEEPSEEK_API_KEY",
	--                 endpoint = "https://api.lkeap.cloud.tencent.com/v1",
	--                 model = "deepseek-r1",
	--             },
	--         },
	--     },
	--     -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	--     build = "make",
	--     -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	--     dependencies = {
	--         "stevearc/dressing.nvim",
	--         "nvim-lua/plenary.nvim",
	--         "MunifTanjim/nui.nvim",
	--     },
	-- },

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		init = function()
			highlight("SnacksPickerMatch", { italic = true, bold = true, bg = "#ffc777", fg = "#222436" })
		end,
		keys = {
			{
				"<space>.",
				function()
					Snacks.scratch()
				end,
				desc = "scratch",
			},
			-- do 删除范围上下两行
			{
				"o",
				mode = "o",
				desc = "delete scope",
				function()
					local operator = vim.v.operator
					if operator == "d" then
						local res
						require("snacks").scope.get(function(scope)
							res = scope
						end)
						local top = res.from
						local bottom = res.to
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
				end,
			},

			{
				"<M-n>",
				mode = { "n", "i" },
				function()
					Snacks.terminal.toggle("zsh")
				end,
				desc = "Toggle floating terminal",
			},
			{
				"<m-n>",
				mode = { "t" },
				function()
					Snacks.terminal.toggle("zsh")
				end,
				ft = "snacks_terminal",
				desc = "Toggle terminal",
			},
		},
		opts = {
			animate = { enabled = true },
			bigfile = { enabled = true },
			buffdelete = { enabled = true },
			dashboard = { enabled = false },
			debug = { enabled = false },
			dim = { enabled = false },
			explorer = { enabled = false },
			git = { enabled = false },
			gitbrowser = { enabled = false },
			image = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			layout = { enable = true },
			lazygit = { enabled = false },
			notifier = { enabled = true },
			notify = { enabled = true },
			picker = {
				enabled = true,
				win = {
					input = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },
						},
					},
					list = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },
						},
					},
					preview = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },
						},
					},
				},
			},
			profiler = { enabled = true },
			quickfile = { enabled = true },
			rename = { enabled = true },
			scope = { enabled = true },
			scratch = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = {
				enabled = true,
				left = { "mark" }, -- priority of signs on the left (high to low)
				right = { "fold" }, -- priority of signs on the right (high to low)
				folds = {
					open = true, -- show open fold icons
					git_hl = false, -- use Git Signs hl for fold icons
				},
				git = {
					-- patterns to match Git signs
					patterns = { "MiniDiffSign" },
				},
				refresh = 50, -- refresh at most every 50ms
			},
			styles = {
				input = {
					relative = "cursor",
				},
			},
			terminal = {
				enabled = true,
			},
			toggle = { enabled = false },
			health = { enabled = true },
			words = { enabled = true },
		},
		config = function(_, opts)
			require("snacks").setup(opts)

			_G.dd = function(...)
				Snacks.debug.inspect(...)
			end
			_G.bt = function()
				Snacks.debug.backtrace()
			end
			vim.print = _G.dd

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesActionRename",
				callback = function(event)
					Snacks.rename.on_rename_file(event.data.from, event.data.to)
				end,
			})
		end,
	},

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },
}

return M
