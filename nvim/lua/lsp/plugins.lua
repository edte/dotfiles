local M = {}

M.list = {
	-- go 插件
	{
		"ray-x/go.nvim",
		ft = "go",
		config = function()
			require("go").setup({
				diagnostic = false,
			})

			Command("GoAddTagEmpty", function()
				vim.api.nvim_command(":GoAddTag json -add-options json=")
			end, { nargs = "*" })

			Autocmd("BufWritePost", {
				group = GroupId("go_auto_import", { clear = true }),
				nested = true,
				callback = function()
					cmd("GoImports")
				end,
			})
		end,
	},

	{
		"TheNoeTrevino/no-go.nvim",
		ft = "go",
		config = function()
			vim.highlight.priorities.semantic_tokens = 95 -- default is 125
			vim.highlight.priorities.treesitter = 100 -- default is 100
			require("no-go").setup({
				identifiers = { "err", "error" }, -- Customize which identifiers to collapse
				-- look at the default config for more details
				highlight_group = "LspInlayHint",
				fold_imports = true,
			})
		end,
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

				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
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
				-- jq -c 压缩
				-- jq -c . a.json
				json = { "jq" },
				cpp = { lsp_format = "never" },
				zsh = { "shfmt", lsp_format = "never" },
				bash = { "shfmt", lsp_format = "never" },
				toml = { "taplo", lsp_format = "never" },
				http = { "kulala" },
				rust = { "rustfmt" },
				["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
				["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
			},
			format_on_save = {
				timeout_ms = 200,
			},
		},
	},

	-- Clanalphagd 针对 neovim 的 LSP 客户端的不合规范的功能。使用 https://sr.ht/~p00f/clangd_extensions.nvim 代替
	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
		ft = { "cpp", "h" },
		opts = {
			inlay_hints = {
				inline = false,
			},
			ast = {
				--These require codicons (https://github.com/microsoft/vscode-codicons)
				role_icons = {
					type = "",
					declaration = "",
					expression = "",
					specifier = "",
					statement = "",
					["template argument"] = "",
				},
				kind_icons = {
					Compound = "",
					Recovery = "",
					TranslationUnit = "",
					PackExpansion = "",
					TemplateTypeParm = "",
					TemplateTemplateParm = "",
					TemplateParamObject = "",
				},
			},
		},

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

	-- Neovim 插件，用于显示 JB 的 IDEA 等函数的引用和定义信息。
	{
		"edte/codelens.nvim",
		ft = { "lua", "go", "cpp" },
		opts = {},
	},

	-- K 的语法高亮插件
	{
		"edte/lsp-hover.nvim",
		-- keys = "K",
		opts = {},
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

	-- 从你的代码库中学习的导入选择器
	{
		"piersolenski/import.nvim",
		dependencies = {
			"folke/snacks.nvim",
		},
		opts = {
			picker = "snacks",
			insert_at_top = false,
		},
		keys = {
			{
				"<space>i",
				function()
					require("import").pick()
				end,
				desc = "Import",
			},
		},
	},

	{
		"piersolenski/wtf.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			popup_type = "popup",
			provider = "deepseek",
			providers = {
				deepseek = {
					url = "https://api.lkeap.cloud.tencent.com/v1/chat/completions",
					model_id = "deepseek-v3",
				},
			},

			language = "中文",
			search_engine = "google",
		},
		keys = {
			{
				"<space>wd",
				mode = { "n", "x" },
				function()
					require("wtf").diagnose()
				end,
				desc = "Debug diagnostic with AI",
			},
			{
				"<space>wf",
				mode = { "n", "x" },
				function()
					require("wtf").fix()
				end,
				desc = "Fix diagnostic with AI",
			},
			{
				mode = { "n" },
				"<space>wg",
				function()
					require("wtf").search()
				end,
				desc = "Search diagnostic with Google",
			},
			{
				mode = { "n" },
				"<space>wh",
				function()
					require("wtf").history()
				end,
				desc = "Populate the quickfix list with previous chat history",
			},
		},
	},
}

return M
