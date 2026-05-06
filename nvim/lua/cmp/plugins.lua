local M = {}

M.list = {

	-- 自定义代码片段
	{
		'L3MON4D3/LuaSnip',
		lazy = true,
		event = 'InsertEnter',
		config = function()
			require('luasnip.loaders.from_lua').load({ paths = NEOVIM_CONFIG_PATH .. '/lua/cmp/luasnippets' })
		end,
		opts = {
			history = true,
			delete_check_events = 'TextChanged',
		},
	},

	-- 彩色补全
	{
		'xzbdmw/colorful-menu.nvim',
		event = { 'InsertEnter' },
		version = '*',
		config = function()
			require('colorful-menu').setup({})
		end,
	},

	-- ai代码补全
	{
		'edte/copilot',
	},

	-- Neovim 插件可快速插入日志语句并捕获日志输出
	-- glj	    :      在光标下方插入一条日志语句
	-- glk	    :      在光标上方插入一条日志语句
	-- glo	    :      在光标下方插入一条纯文本日志语句
	-- gl<S-o>	:      在光标上方插入一条纯文本日志语句
	-- gla      :      将日志目标添加到批处理中
	-- glb	    :      插入批处理日志语句
	{
		'Goose97/timber.nvim',
		version = '*', -- Use for stability; omit to use `main` branch for the latest features
		-- event = "VeryLazy",
		keys = 'gl',
		config = function()
			require('timber').setup({
				log_templates = {
					default = {
						lua = [[log.debug("%log_target", %log_target)]],
						go = [[log.Debug("%log_target:%+v", %log_target)]],
					},
				},
				batch_log_templates = {
					default = {
						go = [[log.Debug("%repeat<%log_target: %v><, >", %repeat<%log_target><, >)]],
						lua = [[log.debug(string.format("%repeat<%log_target=%s><, >", %repeat<%log_target><, >))]],
					},
				},
			})

			-- Patch: Nvim 0.11+ 下 treesitter query directive 的 `match` 参数类型从
			-- `table<integer, TSNode>` 改为 `table<integer, TSNode[]>`（节点数组）。
			-- timber.nvim 在 treesitter.lua 里为 predicate 写了 get_match_node 帮助函数来兼容新 API，
			-- 但 `make-logable-range!` / `make-log-target-range!` 两个 directive handler 漏掉了处理，
			-- 直接 match[id] 拿到的是数组，后续 node:range() 会抛
			-- "attempt to call method 'range' (a nil value)"。
			-- 这里在 setup 之后重新注册两个 handler，兼容新 API。
			-- 参考：~/.local/share/nvim/lazy/timber.nvim/lua/timber/actions/treesitter.lua:207-247
			local function get_node(match, id)
				local node = match[id]
				if type(node) == 'table' then
					node = node[1]
				end
				return node
			end

			vim.treesitter.query.add_directive('make-logable-range!', function(match, _, _, predicate, metadata)
				local node = get_node(match, predicate[2])
				if not node then
					return
				end
				local range_type = predicate[3]
				local start_adjust = tonumber(predicate[4]) or 0
				local end_adjust = tonumber(predicate[5]) or 0

				local start_row, _, end_row, _ = node:range()
				local adjusted_start_row = math.max(0, start_row + start_adjust)
				local adjusted_end_row = math.max(adjusted_start_row, end_row + 1 + end_adjust)

				local logable_ranges = metadata.logable_ranges or {}
				if range_type == 'outer' then
					table.insert(logable_ranges, { 0, adjusted_start_row })
					table.insert(logable_ranges, { adjusted_end_row, math.huge })
				elseif range_type == 'inner' then
					table.insert(logable_ranges, { adjusted_start_row, adjusted_end_row })
				elseif range_type == 'before' then
					table.insert(logable_ranges, { 0, adjusted_start_row })
				elseif range_type == 'after' then
					table.insert(logable_ranges, { adjusted_end_row, math.huge })
				end
				metadata.logable_ranges = logable_ranges
			end, { force = true })

			vim.treesitter.query.add_directive('make-log-target-range!', function(match, _, _, predicate, metadata)
				local start_node = get_node(match, predicate[2])
				local end_node = get_node(match, predicate[3])
				if not start_node or not end_node then
					return
				end
				metadata.log_target_range = { start_node, end_node }
			end, { force = true })
		end,
	},

	-- cmp 替代品，暂时还是有些问题，一些cmp生态不咋支持，而且没搞懂怎么设置provider的kind
	{
		'saghen/blink.cmp',

		event = { 'InsertEnter' },
		build = function()
			require('blink.cmp').build():wait(60000)
		end,

		dependencies = {
			{
				'niuiic/blink-cmp-rg.nvim',
			},

			{ 'edte/more-go.nvim' },

			-- 自定义代码片段
			{
				'L3MON4D3/LuaSnip',
				event = 'InsertEnter',
				config = function()
					require('luasnip.loaders.from_vscode').lazy_load()
					require('luasnip.loaders.from_lua').load({ paths = NEOVIM_CONFIG_PATH .. '/lua/cmp/luasnippets' })
				end,
			},
		},

		config = function()
			require('blink.cmp').setup({
				cmdline = { enabled = false },

				keymap = {
					preset = 'default',
					['<Enter>'] = { 'select_and_accept', 'fallback' },
					['<CR>'] = { 'select_and_accept', 'fallback' },
					['<Down>'] = { 'select_next', 'fallback' },
					['<Up>'] = { 'select_prev', 'fallback' },
					['<PageDown>'] = { 'scroll_documentation_down' },
					['<PageUp>'] = { 'scroll_documentation_up' },
				},

				appearance = {
					-- Sets the fallback highlight groups to nvim-cmp's highlight groups
					-- Useful for when your theme doesn't support blink.cmp
					-- will be removed in a future release
					use_nvim_cmp_as_default = true,
					-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = 'mono',

					-- 这里只能写死，能根据source来源和kind类型动态么？
					kind_icons = icon.kind,
				},

				sources = {
					per_filetype = {
						codecompanion = { 'codecompanion' },
					},

					default = { 'lsp', 'path', 'snippets', 'buffer', 'ripgrep', 'go_import' },

					providers = {
						codecompanion = {
							name = 'CodeCompanion',
							module = 'codecompanion.providers.completion.blink',
						},
						go_import = {
							name = 'Module',
							module = 'more-go.go-pkgs-blink',
						},
						lsp = {
							name = 'LSP',
							module = 'blink.cmp.sources.lsp',
						},
						snippets = {
							min_keyword_length = 1, -- don't show when triggered manually, useful for JSON keys
							score_offset = -1,
							opts = {
								search_paths = { NEOVIM_CONFIG_PATH .. '/lua/cmp/snippets/' },
							},
							-- 隐藏触发字符后的片段
							should_show_items = function(ctx)
								return ctx.trigger.initial_kind ~= 'trigger_character'
							end,
						},
						-- 从 cwd 而不是当前缓冲区的目录完成路径
						path = {
							opts = {
								get_cwd = function(_)
									return vim.fn.getcwd()
								end,
							},
						},
						buffer = {
							max_items = 4,
							min_keyword_length = 4,
							score_offset = -3,
						},

						ripgrep = {
							module = 'blink-cmp-rg',
							name = 'Ripgrep',
							-- options below are optional, these are the default values
							---@type blink-cmp-rg.Options
							opts = {
								-- `min_keyword_length` only determines whether to show completion items in the menu,
								-- not whether to trigger a search. And we only has one chance to search.
								prefix_min_len = 3,
								get_command = function(context, prefix)
									return {
										'rg',
										'--no-config',
										'--json',
										'--word-regexp',
										'--ignore-case',
										'--',
										prefix .. '[\\w_-]+',
										vim.fs.root(0, '.git') or vim.fn.getcwd(),
									}
								end,
								get_prefix = function(context)
									return context.line:sub(1, context.cursor[2]):match('[%w_-]+$') or ''
								end,
							},
						},
					},
				},

				completion = {
					accept = {
						-- experimental auto-brackets support
						auto_brackets = {
							enabled = true,
						},
					},

					keyword = { range = 'full' },
					list = { selection = { preselect = true, auto_insert = false } },
					trigger = {
						show_on_keyword = true,
						show_on_trigger_character = true,
						show_on_insert_on_trigger_character = true,
						show_on_accept_on_trigger_character = true,
					},
					menu = {
						border = 'single',
						draw = {
							treesitter = { 'lsp' },
							columns = { { 'kind_icon' }, { 'label', gap = 1 } },
							components = {
								label = {
									text = require('colorful-menu').blink_components_text,
									highlight = require('colorful-menu').blink_components_highlight,
								},
								kind_icon = {
									ellipsis = false,
									text = function(ctx)
										if vim.bo.filetype == 'go' then
											-- go 中非struct的type都是class，直接把这两都弄成一个icon
											if ctx.kind == 'Struct' or ctx.kind == 'Class' then
												ctx.kind_icon = icon.kind['Type'] or ''
											elseif ctx.source_name == 'nvim_lsp_signature_help' and ctx.kind == 'Text' then -- 参数提醒
												ctx.kind_icon = icon.kind['TypeParameter'] or ''
											elseif ctx.source_name == 'treesitter' and ctx.kind == 'Property' then -- treesitter提醒
												ctx.kind_icon = icon.kind['Treesitter'] or ''
											elseif ctx.source_name == 'cmp_tabnine' then
												ctx.kind_icon = icon.kind['TabNine'] or ''
											end
										end

										return ctx.kind_icon .. ctx.icon_gap
									end,
									highlight = function(ctx)
										-- log.error(ctx.source_name, ctx.kind)

										-- cmp icon highlight
										vim.cmd('highlight CmpItemKindFunction guifg=#CB6460')
										vim.cmd('highlight CmpItemKindInterface guifg=#659462')
										vim.cmd('highlight CmpItemKindConstant guifg=#BD805C')
										vim.cmd('highlight CmpItemKindVariable guifg=#BD805C')
										vim.cmd('highlight CmpItemKindStruct guifg=#6089EF')
										vim.cmd('highlight CmpItemKindClass guifg=#6089EF')
										vim.cmd('highlight CmpItemKindMethod guifg=#A25553')
										vim.cmd('highlight CmpItemKindField guifg=#BD805C')

										if ctx.kind == 'Function' then
											return 'CmpItemKindFunction'
										elseif ctx.kind == 'Interface' then
											return 'CmpItemKindInterface'
										elseif ctx.kind == 'Constant' then
											return 'CmpItemKindConstant'
										elseif ctx.kind == 'Variable' then
											return 'CmpItemKindVariable'
										elseif ctx.kind == 'Struct' then
											return 'CmpItemKindStruct'
										elseif ctx.kind == 'Class' then
											return 'CmpItemKindClass'
										elseif ctx.kind == 'Method' then
											return 'CmpItemKindMethod'
										elseif ctx.kind == 'Field' then
											return 'CmpItemKindField'
										end

										return ctx.kind_hl
									end,
								},
							},
						},
						auto_show = function(ctx)
							return ctx.mode ~= 'cmdline' and not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
						end,
					},
					documentation = {
						window = {
							border = 'single',
						},
						auto_show = false,
						auto_show_delay_ms = 200,
					},

					ghost_text = { enabled = false },
				},
				signature = {
					enabled = true,
					window = {
						border = 'single',
						show_documentation = false,
					},
				},
			})
		end,
	},
}

return M
