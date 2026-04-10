local M = {}

M.list = {
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		branch = 'main',
		config = function()
			-- 让 codecompanion filetype 使用 markdown parser
			-- 这样 markview 才能正确渲染 markdown 内容
			vim.treesitter.language.register('markdown', 'codecompanion')

			-- lsp高亮的优先级要低于 treesitter
			vim.highlight.priorities.semantic_tokens = 95 -- default is 125
			vim.highlight.priorities.treesitter = 100 -- default is 100

			-- 移除注释中的标点符号高亮 (如 // 中的斜杠)
			vim.api.nvim_set_hl(0, '@punctuation.delimiter.comment', {})
			vim.api.nvim_set_hl(0, '@number.comment', {})

			-- 注册 OXY2DEV 的 comment parser
			-- 支持注释内 markdown、引号文本、@提及、issue 引用、URL 等高亮
			require('nvim-treesitter.parsers').comment = {
				install_info = {
					url = 'https://github.com/OXY2DEV/tree-sitter-comment',
					branch = 'main',
					queries = 'queries/',
				},
			}
			vim.api.nvim_create_autocmd('User', {
				pattern = 'TSUpdate',
				callback = function()
					require('nvim-treesitter.parsers').comment = {
						install_info = {
							url = 'https://github.com/OXY2DEV/tree-sitter-comment',

							branch = 'main', -- only needed if different from default branch
							queries = 'queries/',
						},
					}
				end,
			})

			require('nvim-treesitter').install({
				'bash',
				'c',
				'cpp',
				'diff',
				'go',
				'gomod',
				'gowork',
				'gosum',
				'html',
				'http',
				'javascript',
				'jsdoc',
				'json',
				'lua',
				'latex',
				'luadoc',
				'luap',
				'markdown',
				'markdown_inline',
				'printf',
				'python',
				'query',
				'regex',
				'sql',
				'toml',
				'tsx',
				'typescript',
				'vim',
				'vimdoc',
				'xml',
				'yaml',
				'git_config',
				'gitcommit',
				'git_rebase',
				'gitignore',
				'gitattributes',
			})

			require('nvim-treesitter').setup({
				install_dir = vim.fn.stdpath('data') .. '/site',
			})
		end,
	},

	{
		'utilyre/sentiment.nvim',
		version = '*',
		event = 'VeryLazy', -- keep for lazy loading
		opts = {
			-- config
		},
		init = function()
			-- `matchparen.vim` needs to be disabled manually in case of lazy loading
			vim.g.loaded_matchparen = 1
		end,
	},
	{
		'saghen/blink.pairs',
		version = '*', -- (recommended) only required with prebuilt binaries

		-- download prebuilt binaries from github releases
		dependencies = 'saghen/blink.download',
		-- OR build from source, requires nightly:
		-- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		--- @module 'blink.pairs'
		--- @type blink.pairs.Config
		opts = {
			mappings = {
				-- you can call require("blink.pairs.mappings").enable()
				-- and require("blink.pairs.mappings").disable()
				-- to enable/disable mappings at runtime
				enabled = true,
				cmdline = true,
				-- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
				-- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
				disabled_filetypes = {},
				wrap = {
					-- move closing pair via motion
					['<C-b>'] = 'motion',
					-- move opening pair via motion
					['<C-S-b>'] = 'motion_reverse',
					-- set to 'treesitter' or 'treesitter_reverse' to use treesitter instead of motions
					-- set to nil, '' or false to disable the mapping
					-- normal_mode = {} <- for normal mode mappings, only supports 'motion' and 'motion_reverse'
				},
				-- see the defaults:
				-- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L52
				pairs = {},
			},
			highlights = {
				enabled = true,
				-- requires require('vim._extui').enable({}), otherwise has no effect
				cmdline = true,
				-- set to { 'BlinkPairs' } to disable rainbow highlighting
				groups = { 'BlinkPairsOrange', 'BlinkPairsPurple', 'BlinkPairsBlue' },
				unmatched_group = 'BlinkPairsUnmatched',

				-- highlights matching pairs under the cursor
				matchparen = {
					enabled = true,
					-- known issue where typing won't update matchparen highlight, disabled by default
					cmdline = false,
					-- also include pairs not on top of the cursor, but surrounding the cursor
					include_surrounding = false,
					group = 'BlinkPairsMatchParen',
					priority = 250,
				},
			},
			debug = false,
		},
	},

	-- 显示代码上下文,包含函数签名
	-- 只能从下面固定多少个，而不是从上面固定，所以如果套太多层，函数名会显示不出来
	{
		'nvim-treesitter/nvim-treesitter-context',
		config = function()
			require('treesitter-context').setup({
				max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 1, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				multiline_threshold = 3, -- Maximum number of lines to show for a single context
				trim_scope = 'inner', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
				zindex = 1, -- The Z-index of the context window
			})
		end,
	},

	-- 使用 Treesitter 突出显示参数的定义和用法
	{
		'm-demare/hlargs.nvim',
		config = function()
			require('hlargs').setup()
		end,
	},
	{
		'aaronik/treewalker.nvim',

		-- The following options are the defaults.
		-- Treewalker aims for sane defaults, so these are each individually optional,
		-- and setup() does not need to be called, so the whole opts block is optional as well.
		opts = {
			-- Whether to briefly highlight the node after jumping to it
			highlight = true,

			-- How long should above highlight last (in ms)
			highlight_duration = 250,

			-- The color of the above highlight. Must be a valid vim highlight group.
			-- (see :h highlight-group for options)
			highlight_group = 'CursorLine',
		},
		keys = {
			{ '<c-k>', '<cmd>Treewalker Up<cr>', mode = { 'n', 'v' }, desc = 'up' },
			{ '<c-j>', '<cmd>Treewalker Down<cr>', mode = { 'n', 'v' }, desc = 'down' },
			-- { "<left>", "<cmd>Treewalker Left<cr>", mode = { "n", "v" }, desc = "down" },
			-- { "<right>", "<cmd>Treewalker Right<cr>", mode = { "n", "v" }, desc = "down" },
		},
	},
}

return M
