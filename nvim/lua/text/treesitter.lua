local M = {}

M.config = function()
	vim.g.skip_ts_context_commentstring_module = true

	local config = Require("nvim-treesitter.configs")
	if config == nil then
		return
	end

	-- TSBufToggle highlight

	config.setup({
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"diff",
			"go",
			"gomod",
			"gowork",
			"gosum",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"json5",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
			"git_config",
			"gitcommit",
			"git_rebase",
			"gitignore",
			"gitattributes",
		},
		auto_install = true,
		indent = {
			enable = true,
		},

		-- 启用增量选择,
		incremental_selection = {
			enable = false,
			keymaps = {
				init_selection = "<CR>",
				scope_incremental = "<TAB>",
				node_incremental = "<CR>",
				node_decremental = "<BS>",
			},
		},

		highlight = {
			enable = true,
			-- additional_vim_regex_highlighting = false,
			language_tree = true,
			is_supported = function()
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
					-- ["]m"] = "@function.outer",
					["]]"] = { query = "@class.outer", desc = "Next class start" },
				},
				goto_next_end = {
					["]m"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					-- ["[M"] = "@function.outer",
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

	Setup("treesitter-context", {
		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
		max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
		min_window_height = 1, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
		line_numbers = true,
		multiline_threshold = 3, -- Maximum number of lines to show for a single context
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
end

return M
