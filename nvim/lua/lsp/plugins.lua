local M = {}

M.list = {
	-- 一个 Neovim 插件，提供与jsonls和yamlls一起使用的SchemaStore目录。
	{
		"b0o/schemastore.nvim",
	},

	-- go 插件
	{
		"ray-x/go.nvim",
		ft = "go",
		config = function()
			require("go").setup({
				diagnostic = false,
			})

			Command("GoAddTagEmpty", function()
				Api.nvim_command(":GoAddTag json -add-options json=")
			end, { nargs = "*" })

			Autocmd("BufWritePost", {
				group = GroupId("go_auto_import", { clear = true }),
				nested = true,
				callback = function()
					cmd("GoImports")
				end,
			})

			require("lsp.go-return").setup({})

			require("lsp.go-show").setup({
				-- Whether to display the package name along with the type name (i.e., builtins.error vs error)
				display_package = false,
				-- The namespace to use for the extmarks (no real reason to change this except for testing)
				namespace_name = "goplements",
				-- The highlight group to use (if you want to change the default colors)
				-- The default links to DiagnosticHint
				highlight = "Goplements",
			})
		end,
	},

	-- GoImplOpen
	{
		"fang2hou/go-impl.nvim",
		-- ft = "go",
		cmd = "GoImplOpen",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"ibhagwan/fzf-lua",
			"nvim-lua/plenary.nvim",
		},
		opts = {},
	},

	-- 显示更漂亮的诊断消息的 Neovim 插件。在光标所在位置显示诊断消息，并带有图标和颜色。
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		-- event = "LspAttach", -- Or `LspAttach`
		priority = 3000, -- needs to be loaded in first
		branch = "main",
		init = function()
			vim.diagnostic.config({
				virtual_text = false,
				update_in_insert = true,
				virtual_lines = {
					-- only_current_line = true,
					highlight_whole_line = false,
				},
			})
		end,
		config = function()
			-- Default configuration
			require("tiny-inline-diagnostic").setup({
				preset = "ghost", -- Can be: "modern", "classic", "minimal", "ghost", "simple", "nonerdfont", "amongus"

				options = {
					-- Throttle the update of the diagnostic when moving cursor, in milliseconds.
					-- You can increase it if you have performance issues.
					-- Or set it to 0 to have better visuals.
					throttle = 0,

					-- The minimum length of the message, otherwise it will be on a new line.
					softwrap = 30,

					-- If multiple diagnostics are under the cursor, display all of them.
					multiple_diag_under_cursor = true,

					-- Enable diagnostic message on all lines.
					multilines = true,

					-- Show all diagnostics on the cursor line.
					show_all_diags_on_cursorline = true,

					-- Enable diagnostics on Insert mode. You should also se the `throttle` option to 0, as some artefacts may appear.
					enable_on_insert = true,
				},
			})
		end,
	},

	-- 适用于 Neovim 的轻量级但功能强大的格式化程序插件
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		lazy = true,
		opts = {
			formatters = {
				kulala = {
					command = "kulala-fmt",
					args = { "$FILENAME" },
					stdin = false,
				},
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				go = { "goimports-reviser" },
				lua = { "stylua" },
				-- cargo install sleek
				sql = { "sleek" },
				json = { "jq" },
				cpp = { lsp_format = "never" },
				zsh = { "shfmt", lsp_format = "never" },
				bash = { "shfmt", lsp_format = "never" },
				toml = { "taplo", lsp_format = "never" },
				http = { "kulala" },
				rust = { "rustfmt" },
			},
			format_on_save = {
				timeout_ms = 200,
			},
		},
	},

	-- Clanalphagd 针对 neovim 的 LSP 客户端的不合规范的功能。使用 https://sr.ht/~p00f/clangd_extensions.nvim 代替
	{
		"p00f/clangd_extensions.nvim",
		ft = { "cpp", "h" },
		config = function()
			local clangd = Require("clangd_extensions")
			if clangd == nil then
				return
			end
			clangd.setup()
		end,
	},

	-- jce 高亮
	{
		"edte/jce-highlight",
		ft = { "jce" },
	},

	-- Neovim 插件添加了对使用内置 LSP 的文件操作的支持
	{
		"antosha417/nvim-lsp-file-operations",
		ft = { "vue" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		config = function()
			require("lsp-file-operations").setup()

			local lspconfig = require("lspconfig")
			lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
				capabilities = vim.tbl_deep_extend(
					"force",
					vim.lsp.protocol.make_client_capabilities(),
					--     -- returns configured operations if setup() was already called
					--     -- or default operations if not
					require("lsp-file-operations").default_capabilities()
				),
			})
		end,
	},

	-- 基于 Neovim 的命令预览功能的增量 LSP 重命名。
	-- {
	--     "smjonas/inc-rename.nvim",
	--     -- cmd = "IncRename",
	--     config = function()
	--         require("inc_rename").setup({})
	--     end,
	-- },

	-- 用于实时预览 lsp 重命名的 neovim 插件
	-- {
	--     "saecki/live-rename.nvim",
	--     config = function()
	--         local live_rename = require("live-rename")
	--         vim.keymap.set("n", "R", live_rename.map({ text = "", insert = true }), { desc = "LSP rename" })
	--     end
	-- },

	-- Neovim 插件，用于显示 JB 的 IDEA 等函数的引用和定义信息。
	{
		name = "codeLens",
		dir = "lsp.codelens",
		virtual = true,
		ft = { "lua", "go", "cpp" },
		config = function()
			require("lsp.codelens").setup()
		end,
	},

	-- 一个漂亮的窗口，用于在一个地方预览、导航和编辑 LSP 位置，其灵感来自于 vscode 的 peek 预览。
	{
		"dnlhc/glance.nvim",
		config = function()
			require("glance").setup()
		end,
		cmd = "Glance",
	},

	-- 基于 Martin Fowler 的 Refactoring 书籍的 Refactoring 库
	{
		"ThePrimeagen/refactoring.nvim",
		cmd = { "Refactor" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = true,
		config = function()
			require("refactoring").setup({})
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		ft = { "rust" },
	},

	{
		name = "hover",
		dir = "lsp.lsp_hover",
		virtual = true,
		config = function()
			require("lsp.lsp_hover").setup()
		end,
	},

	-- 灵活而时尚的模糊拾音器，LSP符号导航器等。由Zed的启发，由内置Selecta提供支持。
	{
		"bassamsdata/namu.nvim",
		config = function()
			require("namu").setup({
				-- Enable the modules you want
				namu_symbols = {
					enable = true,
					options = {
						AllowKinds = {
							default = {
								"Function",
								"Method",
								-- "Class",
								-- "Module",
								-- "Property",
								-- "Variable",
							},
							go = {
								"Function",
								"Method",
								-- "Struct",
								-- "Field",
								-- "Interface",
								-- "Constant",
								-- "Property",
							},
						},
					}, -- here you can configure namu
				},
				-- Optional: Enable other modules if needed
				colorscheme = {
					enable = false,
					options = {
						-- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
						persist = true, -- very efficient mechanism to Remember selected colorscheme
						write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
					},
				},
				ui_select = { enable = false }, -- vim.ui.select() wrapper
			})
			-- === Suggested Keymaps: ===
			vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
				desc = "Jump to LSP symbol",
				silent = true,
			})
		end,
	},

	-- Neovim 的异步 linter 插件对内置语言服务器协议支持进行了补充
	{
		"mfussenegger/nvim-lint",
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		opts = {
			-- Event to trigger linters
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				fish = { "fish" },
				sql = { "sqlfluff" },
				markdown = { "markdownlint-cli2" },
				cmake = { "cmakelint" },
				zsh = { "shellcheck" },
				sh = { "shellcheck" },
				json = { "jsonlint" },
			},
			-- LazyVim extension to easily override linter options
			-- or add custom linters.
			---@type table<string,table>
			linters = {
				-- -- Example of using selene only when a selene.toml file is present
				-- selene = {
				--   -- `condition` is another LazyVim extension that allows you to
				--   -- dynamically enable/disable linters based on the context.
				--   condition = function(ctx)
				--     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
				--   end,
				-- },
			},
		},
		config = function(_, opts)
			local N = {}

			local lint = require("lint")
			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
					if type(linter.prepend_args) == "table" then
						lint.linters[name].args = lint.linters[name].args or {}
						vim.list_extend(lint.linters[name].args, linter.prepend_args)
					end
				else
					lint.linters[name] = linter
				end
			end
			lint.linters_by_ft = opts.linters_by_ft

			function N.debounce(ms, fn)
				local timer = vim.uv.new_timer()
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack(argv))
					end)
				end
			end

			function N.lint()
				-- Use nvim-lint's logic first:
				-- * checks if linters exist for the full filetype first
				-- * otherwise will split filetype by "." and add all those linters
				-- * this differs from conform.nvim which only uses the first filetype that has a formatter
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)

				-- Create a copy of the names table to avoid modifying the original.
				names = vim.list_extend({}, names)

				-- Add fallback linters.
				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				-- Add global linters.
				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				-- Filter out linters that don't exist or don't match the condition.
				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					if not linter then
						log.error("Linter not found: " .. name, { title = "nvim-lint" })
					end
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				-- Run linters.
				if #names > 0 then
					lint.try_lint(names)
				end
			end

			vim.api.nvim_create_autocmd(opts.events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = N.debounce(100, N.lint),
			})
		end,
	},
}

return M
