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
	-- {
	-- 	"echasnovski/mini.hipatterns",
	-- 	version = false,
	-- 	config = function()
	-- 		require("components.todo").setup()
	-- 	end,
	-- },

	-- Neovim 中人类可读的内联 cron 表达式
	-- 	{
	-- 		"fabridamicelli/cronex.nvim",
	-- 		opts = {},
	-- 		ft = { "go" },
	-- 		config = function()
	-- 			require("cronex").setup({
	-- 				explainer = {
	-- 					cmd = "hcron",
	-- 					args = { "-24-hour", "-locale", "zh_CN" },
	-- 				},
	--
	-- 				format = function(s)
	-- 					return require("cronex.format").all_after_colon(s)
	-- 				end,
	-- 			})
	--
	-- 			cmd([[
	-- augroup input_method
	--   autocmd!
	--   autocmd InsertEnter * :CronExplainedEnable
	--   autocmd InsertLeave * :CronExplainedEnable
	-- augroup END
	-- ]])
	--
	-- 			cmd("CronExplainedEnable")
	-- 		end,
	-- 	},

	-- 翻译插件
	{
		cmd = { "Translate" },
		"uga-rosa/translate.nvim",
	},

	-- markdown预览
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown", "norg", "rmd", "org", "vimwiki", "codecompanion" },

		branch = "dev",

		opts = {
			preview = {
				ignore_buftypes = {},
				filetypes = { "markdown", "norg", "rmd", "org", "vimwiki", "codecompanion" },
			},
			max_length = 99999,
		},

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
	{ --${conf, mini.sessions}
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
						vim.cmd([[silent! loadview]])
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
					vim.cmd([[silent! mkview]])
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

	{ --${conf, snacks.nvim}
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
			-- Snacks.notifier.show_history() 查询snacks notify history历史
			notify = { enabled = true },
			picker = {
				enabled = true,
				formatters = {
					file = {
						truncate = 60, -- truncate the file path to (roughly) this length
					},
				},
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
			scroll = { enabled = false },
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

	-- mini 全家桶
	{ --${conf, mini}
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		opts = {
			diff = {
				view = {
					style = "sign",
					signs = {
						add = "▎",
						change = "▎",
						delete = "",
					},
				},
			},
			ai = function()
				local ai = require("mini.ai")

				local function ai_buffer(ai_type)
					local start_line, end_line = 1, vim.fn.line("$")
					if ai_type == "i" then
						-- Skip first and last blank lines for `i` textobject
						local first_nonblank, last_nonblank =
							vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
						-- Do nothing for buffer with all blanks
						if first_nonblank == 0 or last_nonblank == 0 then
							return { from = { line = start_line, col = 1 } }
						end
						start_line, end_line = first_nonblank, last_nonblank
					end

					local to_col = math.max(vim.fn.getline(end_line):len(), 1)
					return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
				end

				return {
					n_lines = 500,
					custom_textobjects = {
						o = ai.gen_spec.treesitter({ -- code block
							a = { "@block.outer", "@conditional.outer", "@loop.outer" },
							i = { "@block.inner", "@conditional.inner", "@loop.inner" },
						}),
						f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
						c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
						t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
						d = { "%f[%d]%d+" }, -- digits
						e = { -- Word with case
							{
								"%u[%l%d]+%f[^%l%d]",
								"%f[%S][%l%d]+%f[^%l%d]",
								"%f[%P][%l%d]+%f[^%l%d]",
								"^[%l%d]+%f[^%l%d]",
							},
							"^().*()$",
						},
						g = ai_buffer, -- buffer
						u = ai.gen_spec.function_call(), -- u for "Usage"
						U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
					},
				}
			end,
		},
		keys = {
			{
				"<space>gd",
				function()
					require("mini.diff").toggle_overlay(0)
				end,
				desc = "diff",
			},
		},
		version = false,
		config = function()
			-- mini.hipatterns
			-- 高亮todo
			local make_pattern_in_comment = function(pattern)
				return function(buf_id)
					local cs = vim.bo[buf_id].commentstring
					if cs == nil or cs == "" then
						cs = "# %s"
					end

					-- Extract left and right part relative to '%s'
					local left, right = cs:match("^(.*)%%s(.-)$")
					left, right = vim.trim(left), vim.trim(right)
					-- General ideas:
					-- - Line is commented if it has structure
					-- "whitespace - comment left - anything - comment right - whitespace"
					-- - Highlight pattern only if it is to the right of left comment part
					--   (possibly after some whitespace)
					-- Example output for '/* %s */' commentstring: '^%s*/%*%s*()TODO().*%*/%s*'
					return string.format("^%%s*%s%%s*()%s().*%s%%s*$", vim.pesc(left), pattern, vim.pesc(right))
				end
			end

			-- 创建高亮组
			highlight("HG_TODO_LIST_WARN", { italic = true, bold = true, bg = "#ffc777", fg = "#222436" })
			highlight("HG_TODO_LIST_FIX", { italic = true, bold = true, bg = "#c53b53", fg = "#222436" })
			highlight("HG_TODO_LIST_NOTE", { italic = true, bold = true, bg = "#4fd6be", fg = "#222436" })
			highlight("HG_TODO_LIST_TODO", { italic = true, bold = true, bg = "#0db9d7", fg = "#222436" })

			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					fix = { pattern = make_pattern_in_comment("FIX:"), group = "HG_TODO_LIST_FIX" },
					warn = { pattern = make_pattern_in_comment("WARN:"), group = "HG_TODO_LIST_WARN" },
					todo = { pattern = make_pattern_in_comment("TODO:"), group = "HG_TODO_LIST_TODO" },
					note = { pattern = make_pattern_in_comment("NOTE:"), group = "HG_TODO_LIST_NOTE" },

					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})

			-- mini.pairs
			-- 括号补全
			local opts = {
				modes = { insert = true, command = true, terminal = false },
				-- skip autopair when next character is one of these
				skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
				-- skip autopair when the cursor is inside these treesitter nodes
				skip_ts = { "string" },
				-- skip autopair when next character is closing pair
				-- and there are more closing pairs than opening pairs
				skip_unbalanced = true,
				-- better deal with markdown code blocks
				markdown = true,
			}

			local pairs = require("mini.pairs")
			pairs.setup({})
			local open = pairs.open
			pairs.open = function(pair, neigh_pattern)
				if vim.fn.getcmdline() ~= "" then
					return open(pair, neigh_pattern)
				end
				local o, c = pair:sub(1, 1), pair:sub(2, 2)
				local line = vim.api.nvim_get_current_line()
				local cursor = vim.api.nvim_win_get_cursor(0)
				local next = line:sub(cursor[2] + 1, cursor[2] + 1)
				local before = line:sub(1, cursor[2])
				if o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
					return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
				end
				if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
					return o
				end
				if opts.skip_ts and #opts.skip_ts > 0 then
					local ok, captures =
						pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
					for _, capture in ipairs(ok and captures or {}) do
						if vim.tbl_contains(opts.skip_ts, capture.capture) then
							return o
						end
					end
				end
				if opts.skip_unbalanced and next == c and c ~= o then
					local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
					local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
					if count_close > count_open then
						return o
					end
				end
				return open(pair, neigh_pattern)
			end

			-- mini.trailspace
			-- 高亮行尾空格，方便格式化
			require("mini.trailspace").setup()

			local diff = require("mini.diff")
			diff.setup({
				-- Disabled by default
				source = diff.gen_source.none(),
			})

			require("mini.ai").setup({})
		end,
	},

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- CodeCompanion 是一种生产力工具，可简化您在 Neovim 中使用 LLM 进行开发的方式。
	-- 🎯 命令
	-- :CodeCompanionHistory - 打开历史浏览器
	-- :CodeCompanionSummaries - 浏览所有摘要
	-- ⌨️ 聊天缓冲区键盘映射
	-- 历史管理：
	--
	-- gh - 打开历史浏览器（可通过 opts.keymap 自定义）
	-- sc - 手动保存当前聊天（可通过 opts.save_chat_keymap 自定义）
	-- 摘要系统：
	--
	-- gcs - 生成当前聊天摘要（可通过 opts.summary.create_summary_keymap 自定义）
	-- gbs - 浏览已保存的摘要（可通过 opts.summary.browse_summaries_keymap 自定义）

	{
		"olimorris/codecompanion.nvim",

		config = function()
			require("codecompanion").setup({
				opts = {
					language = "中文",
				},
				extensions = {
					history = {
						enabled = true,
						opts = {
							-- Keymap to open history from chat buffer (default: gh)
							keymap = "gh",
							-- Keymap to save the current chat manually (when auto_save is disabled)
							save_chat_keymap = "sc",
							-- Save all chats by default (disable to save only manually using 'sc')
							auto_save = true,
							-- Number of days after which chats are automatically deleted (0 to disable)
							expiration_days = 0,
							-- Picker interface (auto resolved to a valid picker)
							picker = "default", --- ("telescope", "snacks", "fzf-lua", or "default")
							---Optional filter function to control which chats are shown when browsing
							chat_filter = nil, -- function(chat_data) return boolean end
							-- Customize picker keymaps (optional)
							picker_keymaps = {
								rename = { n = "r", i = "<M-r>" },
								delete = { n = "d", i = "<M-d>" },
								duplicate = { n = "<C-y>", i = "<C-y>" },
							},
							---Automatically generate titles for new chats
							auto_generate_title = true,
							title_generation_opts = {
								---Adapter for generating titles (defaults to current chat adapter)
								adapter = nil, -- "copilot"
								---Model for generating titles (defaults to current chat model)
								model = nil, -- "gpt-4o"
								---Number of user prompts after which to refresh the title (0 to disable)
								refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
								---Maximum number of times to refresh the title (default: 3)
								max_refreshes = 3,
								format_title = function(original_title)
									-- this can be a custom function that applies some custom
									-- formatting to the title.
									return original_title
								end,
							},
							---On exiting and entering neovim, loads the last chat on opening chat
							continue_last_chat = false,
							---When chat is cleared with `gx` delete the chat from history
							delete_on_clearing_chat = false,
							---Directory path to save the chats
							dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
							---Enable detailed logging for history extension
							enable_logging = false,

							-- Summary system
							summary = {
								-- Keymap to generate summary for current chat (default: "gcs")
								create_summary_keymap = "gcs",
								-- Keymap to browse summaries (default: "gbs")
								browse_summaries_keymap = "gbs",

								generation_opts = {
									adapter = nil, -- defaults to current chat adapter
									model = nil, -- defaults to current chat model
									context_size = 90000, -- max tokens that the model supports
									include_references = true, -- include slash command content
									include_tool_outputs = true, -- include tool execution results
									system_prompt = nil, -- custom system prompt (string or function)
									format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
								},
							},

							-- Memory system (requires VectorCode CLI)
							memory = {
								-- Automatically index summaries when they are generated
								auto_create_memories_on_summary_generation = true,
								-- Path to the VectorCode executable
								vectorcode_exe = "vectorcode",
								-- Tool configuration
								tool_opts = {
									-- Default number of memories to retrieve
									default_num = 10,
								},
								-- Enable notifications for indexing progress
								notify = true,
								-- Index all existing memories on startup
								-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
								index_on_startup = false,
							},
						},
					},
				},
				display = {
					action_palette = {
						width = 95,
						height = 10,
						prompt = "Prompt ", -- Prompt used for interactive LLM calls
						provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
						opts = {
							show_default_actions = true, -- Show the default actions in the action palette?
							show_default_prompt_library = true, -- Show the default prompt library in the action palette?
						},
					},
				},
				adapters = {
					deepseek = function()
						return require("codecompanion.adapters").extend("deepseek", {
							env = {
								api_key = "DEEPSEEK_API_KEY",
							},
							url = "https://api.lkeap.cloud.tencent.com/v1/chat/completions",
							schema = {
								model = {
									default = "deepseek-v3",
									choices = {
										["deepseek-v3"] = { opts = { can_reason = true, can_use_tools = false } },
										["deepseek-r1"] = { opts = { can_use_tools = false } },
									},
								},
							},
						})
					end,
				},
				strategies = {
					chat = { adapter = "deepseek" },
					inline = { adapter = "deepseek" },
					agent = { adapter = "deepseek" },
				},
			})

			vim.keymap.set({ "n" }, "<space>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
			vim.keymap.set({ "v" }, "<space>a", "<cmd>CodeCompanion <cr>", { noremap = true, silent = true })
			vim.cmd([[cab c CodeCompanion]])
		end,

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/codecompanion-history.nvim",
			{
				"Davidyz/VectorCode",
				version = "*", -- optional, depending on whether you're on nightly or release
				dependencies = { "nvim-lua/plenary.nvim" },
				cmd = "VectorCode", -- if you're lazy-loading VectorCode
			},
		},
	},
}

return M
