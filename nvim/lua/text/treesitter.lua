local M = {}

M.config = function()
	vim.g.skip_ts_context_commentstring_module = true

	local config = try_require("nvim-treesitter.configs")
	if config == nil then
		return
	end

	-- TSBufToggle highlight

	-- TODO: 这里go不能自动高亮
	config.setup({
		ensure_installed = { "go", "cpp", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
		auto_install = true,
		indent = {
			enable = true,
		},

		-- 启用增量选择,
		incremental_selection = {
			enable = false,
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<CR>",
				node_decremental = "<BS>",
				scope_incremental = "<TAB>",
			},
		},

		highlight = {
			enable = true,
			-- additional_vim_regex_highlighting = false,
			language_tree = true,
			is_supported = function()
				-- Since `ibhagwan/fzf-lua` returns `bufnr/path` like `117/lua/plugins/colors.lua`.
				local cur_path = (vim.fn.expand("%"):gsub("^%d+/", ""))
				if
					cur_path:match("term://")
					or vim.fn.getfsize(cur_path) > 1024 * 1024 -- file size > 1 MB.
					or vim.fn.strwidth(vim.fn.getline(".")) > 300 -- width > 300 chars.
				then
					return false
				end
				return true
			end,
		},
		-- gf 跳函数开头
		textobjects = {
			-- 文本对象：移动
			move = {
				enable = true,
				set_jumps = true,

				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = { query = "@class.outer", desc = "Next class start" },
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},

			-- 文本对象：选择
			select = {
				enable = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					-- You can optionally set descriptions to the mappings (used in the desc parameter of
					-- nvim_buf_set_keymap) which plugins like which-key display
					["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
					-- You can also use captures from other query groups like `locals.scm`
					["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
				},
			},

			-- 文本对象：交换
			swap = {
				enable = false,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
		},

		matchup = {
			enable = true, -- mandatory, false will disable the whole extension
		},
	})

	local context = try_require("treesitter-context")
	if context == nil then
		return
	end
	context.setup({
		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
		max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
		min_window_height = 1, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
		line_numbers = true,
		multiline_threshold = 1, -- Maximum number of lines to show for a single context
		trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
		mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
		-- Separator between context and content. Should be a single character string, like '-'.
		-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
		separator = nil,
		zindex = 1, -- The Z-index of the context window
		on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
	})

	-- 跳转到上下文（向上）
	vim.keymap.set("n", "[c", function()
		require("treesitter-context").go_to_context(vim.v.count1)
	end, { silent = true })

	-- 一个微型 Neovim 插件，用于处理树木保护单位。一个单元被定义为一个包含其所有子节点的树节点。它允许您快速选择、拉取、删除或替换特定于语言的范围。

	-- 对于内部选择，将选择光标下的主节点。对于外部选择，选择下一个节点。

	local unit = try_require("treesitter-unit")
	if unit == nil then
		return
	end

	vim.api.nvim_set_keymap("x", "iu", '<cmd>lua require"treesitter-unit".select()<CR>', { noremap = true })
	vim.api.nvim_set_keymap("x", "au", '<cmd>lua require"treesitter-unit".select(true)<CR>', { noremap = true })
	vim.api.nvim_set_keymap("o", "iu", '<cmd><c-u>lua require"treesitter-unit".select()<CR>', { noremap = true })
	vim.api.nvim_set_keymap("o", "au", '<cmd><c-u>lua require"treesitter-unit".select(true)<CR>', { noremap = true })
end

return M
