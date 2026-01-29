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
				'luadoc',
				'luap',
				'markdown',
				'markdown_inline',
				'printf',
				'python',
				'query',
				'regex',
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
		end,
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
