local M = {}

M.list = {

	-- Neovim 中人类可读的内联 cron 表达式
	-- {
	-- 	'fabridamicelli/cronex.nvim',
	-- 	opts = {},
	-- 	ft = { 'go' },
	-- 	config = function()
	-- 		require('cronex').setup({
	-- 			explainer = {
	-- 				cmd = 'hcron',
	-- 				args = { '-24-hour', '-locale', 'zh_CN' },
	-- 			},
	--
	-- 			format = function(s)
	-- 				return require('cronex.format').all_after_colon(s)
	-- 			end,
	-- 		})
	--
	-- 		-- 		cmd([[
	-- 		-- augroup input_method
	-- 		--   autocmd!
	-- 		--   autocmd InsertEnter * :CronExplainedEnable
	-- 		--   autocmd InsertLeave * :CronExplainedEnable
	-- 		-- augroup END
	-- 		-- ]])
	--
	-- 		cmd('CronExplainedEnable')
	-- 	end,
	-- },

	-- 自动保存会话
	-- 保存目录是：（不知道哪里配置的）
	-- /Users/edte/.local/state/nvim/view
	{ --${conf, mini.sessions}
		'echasnovski/mini.sessions',
		config = function()
			require('mini.sessions').setup({
				autoread = false,
				autowrite = false,
				verbose = { read = false, write = false, delete = false },
			})

			local function GetPath()
				local dir, _ = vim.fn.getcwd():gsub('/', '_'):gsub('%.', '-')
				return dir
			end

			vim.api.nvim_create_autocmd('VimEnter', {
				callback = function()
					if vim.fn.argc(-1) == 0 then
						local session_name = GetPath()
						if MiniSessions.detected[session_name] then
							-- Session exists, read it
							MiniSessions.read(session_name)
							vim.cmd([[silent! loadview]])
						else
							-- First time in this directory, create empty session
							MiniSessions.write(session_name)
						end
					end
				end,
				nested = true,
			})
			vim.api.nvim_create_autocmd('VimLeavePre', {
				callback = function()
					-- Set flag to prevent slow operations during exit
					vim.g.is_exiting = true
					if vim.fn.argc(-1) > 0 then
						cmd('argdelete *')
					end

					-- Save session asynchronously to avoid blocking exit
					vim.schedule(function()
						MiniSessions.write(GetPath())
					end)
					-- Save view to restore cursor position
					vim.cmd([[silent! mkview]])
				end,
			})
		end,
	},

	-- cp 选择颜色
	{
		'edte/colortils.nvim',
		keys = { 'cp' },
		config = function()
			nmap('cp', '<cmd>Colortils<CR>')
			require('colortils').setup({
				mappings = {
					replace_default_format = '<cr>',
				},
			})
			highlight('ColortilsCurrentLine', '#B81C15')
		end,
	},

	-- Screencast your keys in Neovim
	{
		'NStefan002/screenkey.nvim',
		cmd = 'Screenkey',
		version = '*', -- or branch = "dev", to use the latest commit
	},

	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,
		init = function()
			highlight('SnacksPickerMatch', { italic = true, bold = true, bg = '#ffc777', fg = '#222436' })
		end,
		keys = {
			{
				'<space>.',
				function()
					Snacks.scratch()
				end,
				desc = 'scratch',
			},
			-- do 删除范围上下两行
			{
				'o',
				mode = 'o',
				desc = 'delete scope',
				function()
					local operator = vim.v.operator
					if operator == 'd' then
						local res
						require('snacks').scope.get(function(scope)
							res = scope
						end)
						local top = res.from
						local bottom = res.to
						local row, col = unpack(vim.api.nvim_win_get_cursor(0))
						_ = col
						local move = ''
						if row == bottom then
							move = 'k'
						elseif row == top then
							move = 'j'
						end
						local bufnr = vim.api.nvim_get_current_buf()
						local ns = vim.api.nvim_create_namespace('border')
						vim.hl.range(bufnr, ns, 'Substitute', { top - 1, 0 }, { top - 1, -1 })
						vim.hl.range(bufnr, ns, 'Substitute', { bottom - 1, 0 }, { bottom - 1, -1 })
						vim.defer_fn(function()
							if not vim.api.nvim_buf_is_valid(bufnr) then
								return
							end
							if not vim.bo[bufnr].modifiable then
								vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
								return
							end
							vim.api.nvim_buf_set_text(bufnr, top - 1, 0, top - 1, -1, {})
							vim.api.nvim_buf_set_text(bufnr, bottom - 1, 0, bottom - 1, -1, {})
							vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
						end, 150)
						return '<esc>' .. move
					else
						return 'o'
					end
				end,
			},

			{
				'<M-n>',
				mode = { 'n', 'i' },
				function()
					Snacks.terminal.toggle('zsh')
				end,
				desc = 'Toggle floating terminal',
			},
			{
				'<m-n>',
				mode = { 't' },
				function()
					Snacks.terminal.toggle('zsh')
				end,
				ft = 'snacks_terminal',
				desc = 'Toggle terminal',
			},
			-- {
			-- 	'<space>h',
			-- 	mode = 'n',
			-- 	function()
			-- 		Snacks.notifier.show_history()
			-- 	end,
			-- 	desc = 'show history',
			-- },
		},
		opts = {
			animate = { enabled = false },
			bigfile = { enabled = false },
			buffdelete = { enabled = true },
			dashboard = { enabled = false },
			debug = { enabled = false },
			dim = { enabled = false },
			explorer = { enabled = false },
			git = { enabled = false },
			gitbrowser = { enabled = false },
			image = {
				enabled = true,
				force = true, -- try displaying the image, even if the terminal does not support it
				doc = {
					max_width = 50,
					max_height = 80,
				},
			},
			indent = { enabled = true },
			input = { enabled = true },
			layout = { enable = true },
			lazygit = { enabled = false },
			notifier = { enabled = false },
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
							['<Esc>'] = { 'close', mode = { 'n', 'i' } },
						},
					},
					list = {
						keys = {
							['<Esc>'] = { 'close', mode = { 'n', 'i' } },
						},
					},
					preview = {
						keys = {
							['<Esc>'] = { 'close', mode = { 'n', 'i' } },
						},
					},
				},
			},
			profiler = { enabled = true },
			quickfile = { enabled = true },
			rename = { enabled = true },
			scope = { enabled = false },
			scratch = { enabled = true },
			scroll = { enabled = false },
			statuscolumn = {
				enabled = true,
				left = { 'mark' }, -- priority of signs on the left (high to low)
				right = { 'fold' }, -- priority of signs on the right (high to low)
				folds = {
					open = true, -- show open fold icons
					git_hl = false, -- use Git Signs hl for fold icons
				},
				git = {
					-- patterns to match Git signs
					patterns = { 'MiniDiffSign' },
				},
				refresh = 50, -- refresh at most every 50ms
			},
			styles = {
				input = {
					relative = 'cursor',
				},
				terminal = {
					width = 0,
					height = 0,
					border = 'none',
					position = 'float',
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
			require('snacks').setup(opts)

			_G.dd = function(...)
				Snacks.debug.inspect(...)
			end
			_G.bt = function()
				Snacks.debug.backtrace()
			end
			vim.print = _G.dd

			vim.api.nvim_create_autocmd('User', {
				pattern = 'MiniFilesActionRename',
				callback = function(event)
					Snacks.rename.on_rename_file(event.data.from, event.data.to)
				end,
			})
		end,
	},

	{
		'nvim-tree/nvim-web-devicons',
		lazy = true,
	},

	-- mini 全家桶
	{ --${conf, mini}
		'echasnovski/mini.nvim',
		event = 'VeryLazy',
		opts = {
			diff = {
				view = {
					style = 'sign',
					signs = {
						add = '▎',
						change = '▎',
						delete = '',
					},
				},
			},
			files = {},
		},
		keys = {
			{
				't',
				function()
					require('mini.splitjoin').toggle()
				end,
			},

			{
				'<space>gd',
				function()
					require('mini.diff').toggle_overlay(0)
				end,
				desc = 'diff',
			},
			{
				'<space>e',
				function()
					local mf = require('mini.files')
					if not mf.close() then
						local n = api.nvim_buf_get_name(0)
						if n ~= '' and vim.uv.fs_stat(n) then
							mf.open(n)
						else
							mf.open(vim.uv.cwd())
						end
						mf.reveal_cwd()
					end
				end,
				desc = 'explorer',
			},
		},
		version = false,
		config = function()
			-- mini.hipatterns
			-- 高亮todo
			local make_pattern_in_comment = function(pattern)
				return function(buf_id)
					local cs = vim.bo[buf_id].commentstring
					if cs == nil or cs == '' then
						cs = '# %s'
					end

					-- Extract left and right part relative to '%s'
					local left, right = cs:match('^(.*)%%s(.-)$')
					left, right = vim.trim(left), vim.trim(right)
					-- General ideas:
					-- - Line is commented if it has structure
					-- "whitespace - comment left - anything - comment right - whitespace"
					-- - Highlight pattern only if it is to the right of left comment part
					--   (possibly after some whitespace)
					-- Example output for '/* %s */' commentstring: '^%s*/%*%s*()TODO().*%*/%s*'
					return string.format('^%%s*%s%%s*()%s().*%s%%s*$', vim.pesc(left), pattern, vim.pesc(right))
				end
			end

			-- 创建高亮组
			highlight('HG_TODO_LIST_WARN', { italic = true, bold = true, bg = '#ffc777', fg = '#222436' })
			highlight('HG_TODO_LIST_FIX', { italic = true, bold = true, bg = '#c53b53', fg = '#222436' })
			highlight('HG_TODO_LIST_NOTE', { italic = true, bold = true, bg = '#4fd6be', fg = '#222436' })
			highlight('HG_TODO_LIST_TODO', { italic = true, bold = true, bg = '#0db9d7', fg = '#222436' })

			-- Git 状态高亮组
			highlight('HG_GIT_MODIFIED', { bold = true, fg = '#ffc777' }) -- Modified
			highlight('HG_GIT_ADDED', { bold = true, fg = '#B3F6C0' }) -- Added
			highlight('HG_GIT_DELETED', { bold = true, fg = '#c53b53' }) -- Deleted
			highlight('HG_GIT_UNTRACKED', { bold = true, fg = '#545C7E' }) -- Untracked
			highlight('HG_GIT_RENAMED', { bold = true, fg = '#65BCFF' }) -- Renamed
			highlight('HG_GIT_UNMERGED', { bold = true, fg = '#ff9e64' }) -- Unmerged
			highlight('HG_GIT_SYMLINK', { bold = true, fg = '#c53b53' }) -- Symlink

			local hipatterns = require('mini.hipatterns')
			hipatterns.setup({
				highlighters = {
					fix = { pattern = make_pattern_in_comment('FIX:'), group = 'HG_TODO_LIST_FIX' },
					warn = { pattern = make_pattern_in_comment('WARN:'), group = 'HG_TODO_LIST_WARN' },
					todo = { pattern = make_pattern_in_comment('TODO:'), group = 'HG_TODO_LIST_TODO' },
					note = { pattern = make_pattern_in_comment('NOTE:'), group = 'HG_TODO_LIST_NOTE' },

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
				skip_ts = { 'string' },
				-- skip autopair when next character is closing pair
				-- and there are more closing pairs than opening pairs
				skip_unbalanced = true,
				-- better deal with markdown code blocks
				markdown = true,
			}

			local mini_pairs = require('mini.pairs')
			mini_pairs.setup({})
			local open = mini_pairs.open
			mini_pairs.open = function(pair, neigh_pattern)
				if vim.fn.getcmdline() ~= '' then
					return open(pair, neigh_pattern)
				end
				local o, c = pair:sub(1, 1), pair:sub(2, 2)
				local line = vim.api.nvim_get_current_line()
				local cursor = vim.api.nvim_win_get_cursor(0)
				local next = line:sub(cursor[2] + 1, cursor[2] + 1)
				local before = line:sub(1, cursor[2])
				if o == '`' and vim.bo.filetype == 'markdown' and before:match('^%s*``') then
					return '`\n```' .. vim.api.nvim_replace_termcodes('<up>', true, true, true)
				end
				if opts.skip_next and next ~= '' and next:match(opts.skip_next) then
					return o
				end
				if opts.skip_ts and #opts.skip_ts > 0 then
					local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
					for _, capture in ipairs(ok and captures or {}) do
						if vim.tbl_contains(opts.skip_ts, capture.capture) then
							return o
						end
					end
				end
				if opts.skip_unbalanced and next == c and c ~= o then
					local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), '')
					local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), '')
					if count_close > count_open then
						return o
					end
				end
				return open(pair, neigh_pattern)
			end

			require('mini.trailspace').setup()

			-- require("mini.icons").setup()

			-- vip 后接 gh / gH 可应用/重置当前段落中的块。同样的操作符形式 ghip / gHip 也可以实现，其优点是可点重复。
			-- gh_ / gH_ 应用/重置当前行（即使它不是完整的块）。
			-- ghgh / gHgh 应用/重置光标下的块范围。
			-- dgh 删除光标下的大块范围。
			-- [H / [h / ]h / ]H 将光标导航到当前缓冲区的第一个/上一个/下一个/最后一个块范围。
			require('mini.diff').setup({
				mappings = {
					-- Apply hunks inside a visual/operator region
					apply = 'gB',
					-- Reset hunks inside a visual/operator region
					reset = 'gb',
					-- Hunk range textobject to be used inside operator
					-- Works also in Visual mode if mapping differs from apply and reset
					textobject = 'gb',
					-- Go to hunk range in corresponding direction
					goto_first = '[H',
					goto_prev = '[h',
					goto_next = ']h',
					goto_last = ']H',
				},
			})
			require('mini.move').setup()
			require('mini.splitjoin').setup()
			require('mini.files').setup({
				options = {
					use_as_default_explorer = true,
				},
				mappings = {
					synchronize = '',
				},
				windows = {
					preview = true,
				},
			})

			-- mini.files git
			-- https://www.reddit.com/r/neovim/comments/1c37m7c/is_there_a_way_to_get_the_minifiles_plugin_to/
			-- https://gist.github.com/bassamsdata/eec0a3065152226581f8d4244cce9051#file-notes-md

			local nsMiniFiles = vim.api.nvim_create_namespace('mini_files_git')
			local autocmd = vim.api.nvim_create_autocmd
			local _, MiniFiles = pcall(require, 'mini.files')

			-- Cache for git status
			local gitStatusCache = {}
			local cacheTimeout = 2000 -- Cache timeout in milliseconds

			-- 防止文件描述符耗尽的保护机制
			local pendingRequests = {} -- 追踪进行中的请求
			local maxConcurrent = 3 -- 最大并发数
			local activeCount = 0 -- 当前活跃的请求数
			local requestQueue = {} -- 请求队列
			local debounceTimers = {} -- 防抖定时器

			local function isSymlink(path)
				local stat = vim.loop.fs_lstat(path)
				return stat and stat.type == 'link'
			end

			local function isMiniFilesBuffer(buf_id)
				return buf_id and vim.api.nvim_buf_is_valid(buf_id) and vim.bo[buf_id].filetype == 'minifiles'
			end

			---@type table<string, {symbol: string, hlGroup: string}>
			---@param status string
			---@return string symbol, string hlGroup
			local function mapSymbols(status, is_symlink)
				local statusMap = {
					[' M'] = { symbol = 'M', hlGroup = 'HG_GIT_MODIFIED' }, -- Modified in the working directory
					['M '] = { symbol = 'M', hlGroup = 'HG_GIT_MODIFIED' }, -- modified in index
					['MM'] = { symbol = 'M', hlGroup = 'HG_GIT_MODIFIED' }, -- modified in both working tree and index
					['A '] = { symbol = 'A', hlGroup = 'HG_GIT_ADDED' }, -- Added to the staging area, new file
					['AA'] = { symbol = '≈', hlGroup = 'HG_GIT_ADDED' }, -- file is added in both working tree and index
					['D '] = { symbol = 'D', hlGroup = 'HG_GIT_DELETED' }, -- Deleted from the staging area
					['AM'] = { symbol = 'A', hlGroup = 'HG_GIT_MODIFIED' }, -- added in working tree, modified in index
					['AD'] = { symbol = 'A•', hlGroup = 'HG_GIT_DELETED' }, -- Added in the index and deleted in the working directory
					['R '] = { symbol = 'R', hlGroup = 'HG_GIT_RENAMED' }, -- Renamed in the index
					['U '] = { symbol = 'U', hlGroup = 'HG_GIT_UNMERGED' }, -- Unmerged path
					['UU'] = { symbol = 'U', hlGroup = 'HG_GIT_UNMERGED' }, -- file is unmerged
					['UA'] = { symbol = 'U', hlGroup = 'HG_GIT_UNMERGED' }, -- file is unmerged and added in working tree
					['??'] = { symbol = '?', hlGroup = 'HG_GIT_UNTRACKED' }, -- Untracked files
				}

				local result = statusMap[status] or { symbol = '?', hlGroup = 'NonText' }
				local gitSymbol = result.symbol
				local gitHlGroup = result.hlGroup

				local symlinkSymbol = is_symlink and '↩' or ''

				-- Combine symlink symbol with Git status if both exist
				local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub('^%s+', ''):gsub('%s+$', '')
				-- Use custom symlink highlight group
				local combinedHlGroup = is_symlink and 'HG_GIT_SYMLINK' or gitHlGroup

				return combinedSymbol, combinedHlGroup
			end

			---@param cwd string
			---@param callback function
			---@return nil
			local function fetchGitStatus(cwd, callback)
				-- 验证路径是否有效
				if not cwd or cwd == '' or vim.fn.isdirectory(cwd) == 0 then
					return
				end

				-- 如果已有相同目录的请求在进行中，跳过
				if pendingRequests[cwd] then
					return
				end

				-- 处理队列中的下一个请求
				local function processQueue()
					if activeCount >= maxConcurrent or #requestQueue == 0 then
						return
					end
					local next_request = table.remove(requestQueue, 1)
					if next_request then
						next_request()
					end
				end

				-- 实际执行 git status 的函数
				local function doFetch()
					-- 再次检查，防止队列等待期间状态变化
					if pendingRequests[cwd] then
						processQueue()
						return
					end

					pendingRequests[cwd] = true
					activeCount = activeCount + 1

					local function on_exit(content)
						pendingRequests[cwd] = nil
						activeCount = activeCount - 1

						if content.code == 0 then
							callback(content.stdout)
						end

						-- 处理队列中的下一个请求
						vim.schedule(processQueue)
					end

					vim.system({ 'git', 'status', '--porcelain' }, { text = true, cwd = cwd }, on_exit)
				end

				-- 如果并发数未满，直接执行；否则加入队列
				if activeCount < maxConcurrent then
					doFetch()
				else
					table.insert(requestQueue, doFetch)
				end
			end

			---@param str string|nil
			---@return string
			local function escapePattern(str)
				if not str then
					return ''
				end
				return (str:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])', '%%%1'))
			end

			---@param buf_id integer
			---@param gitStatusMap table
			---@return nil
			local function updateMiniWithGit(buf_id, gitStatusMap)
				local MiniFiles = require('mini.files')
				vim.schedule(function()
					-- 检查 buffer 是否有效，防止 buffer 被删除后继续操作
					if not vim.api.nvim_buf_is_valid(buf_id) then
						return
					end

					-- 二次检查：确保这是一个 mini.files 缓冲区
					if not isMiniFilesBuffer(buf_id) then
						return
					end

					local nlines = vim.api.nvim_buf_line_count(buf_id)
					local uv = vim.uv or vim.loop
					local source = (uv and uv.cwd and uv.cwd()) or vim.fn.getcwd()
					if not source or source == '' then
						return
					end
					local git_root = vim.fs.root(source, '.git')
					if not git_root or git_root == '' then
						return
					end
					local escapedcwd = escapePattern(git_root)
					if vim.fn.has('win32') == 1 then
						escapedcwd = escapedcwd:gsub('\\', '/')
					end

					for i = 1, nlines do
						local entry = MiniFiles.get_fs_entry(buf_id, i)
						if not entry then
							break
						end
						local relativePath = entry.path:gsub('^' .. escapedcwd .. '/', '')
						local status = gitStatusMap[relativePath]

						if status then
							local is_symlink = isSymlink(entry.path)
							local symbol, hlGroup = mapSymbols(status, is_symlink)
							vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
								-- NOTE: 如果您想要右侧的符号，请取消注释并注释后面的 3 行
								-- virt_text = { { symbol, hlGroup } },
								-- virt_text_pos = "right_align",
								sign_text = symbol,
								sign_hl_group = hlGroup,
								priority = 2,
							})
							local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
							-- Find the name position accounting for potential icons
							local nameStartCol = line:find(vim.pesc(entry.name)) or 0

							if nameStartCol > 0 then
								vim.api.nvim_buf_add_highlight(
									buf_id,
									nsMiniFiles,
									hlGroup,
									i - 1,
									nameStartCol - 1,
									nameStartCol + #entry.name - 1
								)
							end
						else
						end
					end
				end)
			end

			-- Thanks for the idea of gettings https://github.com/refractalize/oil-git-status.nvim signs for dirs
			---@param content string
			---@return table
			local function parseGitStatus(content)
				local gitStatusMap = {}
				-- Priority map for directory status (higher value = higher priority)
				local statusPriority = {
					['D '] = 90, -- Deleted (most critical)
					['UU'] = 85, -- Unmerged (both added)
					['U '] = 85, -- Unmerged
					['UA'] = 85, -- Unmerged and added
					['MM'] = 80, -- Modified in both
					['AM'] = 75, -- Added then modified
					['AD'] = 80, -- Added then deleted
					['R '] = 70, -- Renamed
					['M '] = 65, -- Modified in index
					[' M'] = 60, -- Modified in working directory
					['A '] = 50, -- Added
					['AA'] = 50, -- Both added
					['??'] = 30, -- Untracked
					['!!'] = 10, -- Ignored
				}
				-- lua match is faster than vim.split (in my experience )
				for line in content:gmatch('[^\r\n]+') do
					local status, filePath = string.match(line, '^(..)%s+(.*)')

					-- Handle rename case: "R  oldname -> newname"
					-- For rename, we need to use the new name (after ->)
					if status == 'R ' and filePath and filePath:find('->') then
						filePath = filePath:match('%s*->%s*(.+)$') or filePath
					end

					if filePath then
						-- Split the file path into parts
						local parts = {}
						for part in filePath:gmatch('[^/]+') do
							table.insert(parts, part)
						end
						-- Start with the root directory
						local currentKey = ''
						for i, part in ipairs(parts) do
							if i > 1 then
								-- Concatenate parts with a separator to create a unique key
								currentKey = currentKey .. '/' .. part
							else
								currentKey = part
							end
							-- If it's the last part, it's a file, so add it with its status
							if i == #parts then
								gitStatusMap[currentKey] = status
							else
								-- If it's not the last part, it's a directory.
								-- Use priority to keep the most important status
								if not gitStatusMap[currentKey] then
									gitStatusMap[currentKey] = status
								else
									-- Compare priorities and update if current status has higher priority
									local currentPriority = statusPriority[gitStatusMap[currentKey]] or 0
									local newPriority = statusPriority[status] or 0
									if newPriority > currentPriority then
										gitStatusMap[currentKey] = status
									end
								end
							end
						end
					end
				end
				return gitStatusMap
			end

			---@param buf_id integer
			---@return nil

			local function updateGitStatus(buf_id)
				-- Skip git status updates during exit to avoid blocking
				if vim.g.is_exiting then
					return
				end

				-- 首先检查缓冲区是否有效
				if not vim.api.nvim_buf_is_valid(buf_id) then
					return
				end

				if not MiniFiles or not isMiniFilesBuffer(buf_id) then
					return
				end

				-- 获取 mini.files 正在浏览的真实目录
				local ok, entry = pcall(MiniFiles.get_fs_entry, buf_id, 1)
				if not ok or not entry or not entry.path then
					return
				end
				-- 从第一个条目的路径推断当前浏览目录
				local cwd = vim.fn.fnamemodify(entry.path, ':h')
				if vim.fn.isdirectory(cwd) == 0 then
					cwd = entry.path
				end
				-- Guard against nil/empty source for vim.fs.root()
				local uv = vim.uv or vim.loop
				local source = cwd or (uv and uv.cwd and uv.cwd()) or vim.fn.getcwd()
				if not source or source == '' then
					return
				end
				if not vim.fs.root(source, '.git') then
					return
				end
				local currentTime = os.time()
				if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
					updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
				else
					fetchGitStatus(cwd, function(content)
						local gitStatusMap = parseGitStatus(content)
						gitStatusCache[cwd] = {
							time = currentTime,
							statusMap = gitStatusMap,
						}
						updateMiniWithGit(buf_id, gitStatusMap)
					end)
				end
			end

			---@return nil
			local function clearCache()
				gitStatusCache = {}
			end

			local function augroup(name)
				return vim.api.nvim_create_augroup('MiniFiles_' .. name, { clear = true })
			end

			autocmd('User', {
				group = augroup('start'),
				pattern = 'MiniFilesExplorerOpen',
				-- pattern = { "minifiles" },
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()
					-- 确保缓冲区有效且是 mini.files 缓冲区
					if vim.api.nvim_buf_is_valid(bufnr) and isMiniFilesBuffer(bufnr) then
						updateGitStatus(bufnr)
					end
				end,
			})

			autocmd('User', {
				group = augroup('close'),
				pattern = 'MiniFilesExplorerClose',
				callback = function()
					clearCache()
					-- 清理所有防抖定时器
					for bufnr, timer_id in pairs(debounceTimers) do
						vim.fn.timer_stop(timer_id)
						debounceTimers[bufnr] = nil
					end
					-- 清空请求队列
					requestQueue = {}
				end,
			})

			autocmd('User', {
				group = augroup('update'),
				pattern = 'MiniFilesBufferUpdate',
				callback = function(sii)
					local bufnr = sii.data.buf_id

					-- 检查缓冲区是否仍然有效
					if not vim.api.nvim_buf_is_valid(bufnr) then
						return
					end

					-- 防抖：取消之前的定时器
					if debounceTimers[bufnr] then
						vim.fn.timer_stop(debounceTimers[bufnr])
						debounceTimers[bufnr] = nil
					end

					-- 设置新的定时器，100ms 后执行
					debounceTimers[bufnr] = vim.fn.timer_start(100, function()
						debounceTimers[bufnr] = nil

						-- 检查 buffer 是否仍然有效
						if not vim.api.nvim_buf_is_valid(bufnr) then
							return
						end

						-- 从 mini.files 缓冲区获取当前浏览的目录
						local entry = MiniFiles.get_fs_entry(bufnr, 1)
						if not entry or not entry.path then
							return
						end
						local cwd = vim.fn.fnamemodify(entry.path, ':h')
						if vim.fn.isdirectory(cwd) == 0 then
							cwd = entry.path
						end
						if gitStatusCache[cwd] then
							updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
						else
							-- 如果缓存中没有，主动查询
							fetchGitStatus(cwd, function(content)
								local gitStatusMap = parseGitStatus(content)
								gitStatusCache[cwd] = {
									time = os.time(),
									statusMap = gitStatusMap,
								}
								updateMiniWithGit(bufnr, gitStatusMap)
							end)
						end
					end)
				end,
			})

			-- 监听文件操作事件，清理对应目录的缓存
			autocmd('User', {
				group = augroup('actions'),
				pattern = {
					'MiniFilesActionCreate',
					'MiniFilesActionDelete',
					'MiniFilesActionRename',
					'MiniFilesActionCopy',
					'MiniFilesActionMove',
				},
				callback = function(event)
					local data = event.data
					-- 获取文件所在的目录
					local from_dir = data.from and vim.fn.fnamemodify(data.from, ':h') or nil
					local to_dir = data.to and vim.fn.fnamemodify(data.to, ':h') or nil

					-- 清理相关目录的缓存
					if from_dir then
						gitStatusCache[from_dir] = nil
					end
					if to_dir and to_dir ~= from_dir then
						gitStatusCache[to_dir] = nil
					end

					-- 重新更新当前 mini.files 缓冲区的显示
					local bufnr = (data and data.buf_id) or vim.api.nvim_get_current_buf()
					-- 确保缓冲区有效
					if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
						updateGitStatus(bufnr)
					end
				end,
			})

			-- Window width based on the offset from the center, i.e. center window
			-- is 60, then next over is 20, then the rest are 10.
			-- Can use more resolution if you want like { 60, 20, 20, 10, 5 }
			-- 聚焦窗口用亮色边框，非聚焦窗口用暗色边框
			highlight('MiniFilesBorderFocused', { fg = '#82aaff' })
			highlight('MiniFilesBorderUnfocused', { fg = '#2f334d' })

			local widths = { 60, 30, 20, 10, 5 }

			local ensure_center_layout = function(ev)
				-- Check if the buffer still exists before accessing state
				if not vim.api.nvim_buf_is_valid(ev.data.buf_id) then
					return
				end

				-- Check if the window is still valid
				if not vim.api.nvim_win_is_valid(ev.data.win_id) then
					return
				end

				-- 使用 pcall 包装，防止 mini.files 内部错误
				local ok, state = pcall(MiniFiles.get_explorer_state)
				if not ok or state == nil then
					return
				end

				-- Compute "depth offset" - how many windows are between this and focused
				local path_this = vim.api.nvim_buf_get_name(ev.data.buf_id):match('^minifiles://%d+/(.*)$')
				local depth_this
				for i, path in ipairs(state.branch) do
					if path == path_this then
						depth_this = i
					end
				end
				if depth_this == nil then
					return
				end
				local depth_offset = depth_this - state.depth_focus

				-- Adjust config of this event's window
				local i = math.abs(depth_offset) + 1
				local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
				win_config.width = i <= #widths and widths[i] or widths[#widths]

				win_config.col = math.ceil(0.5 * (vim.o.columns - widths[1]))
				for j = 1, math.abs(depth_offset) do
					local sign = depth_offset == 0 and 0 or (depth_offset > 0 and 1 or -1)
					-- widths[j+1] for the negative case because we don't want to add the center window's width
					local prev_win_width = (sign == -1 and widths[j + 1]) or widths[j] or widths[#widths]
					-- Add an extra +2 each step to account for the border width
					win_config.col = win_config.col + sign * (prev_win_width + 2)
				end

				win_config.height = depth_offset == 0 and 25 or 20
				win_config.row = math.ceil(0.5 * (vim.o.lines - win_config.height))
				local hl = depth_offset == 0 and 'MiniFilesBorderFocused' or 'MiniFilesBorderUnfocused'
				win_config.border = {
					{ '🭽', hl },
					{ '▔', hl },
					{ '🭾', hl },
					{ '▕', hl },
					{ '🭿', hl },
					{ '▁', hl },
					{ '🭼', hl },
					{ '▏', hl },
				}
				vim.api.nvim_win_set_config(ev.data.win_id, win_config)
			end

			vim.api.nvim_create_autocmd('User', { pattern = 'MiniFilesWindowUpdate', callback = ensure_center_layout })

			-- 让 mini.files buffer 支持 :w / :wq / :q 操作
			vim.api.nvim_create_autocmd('User', {
				pattern = 'MiniFilesBufferCreate',
				callback = function(ev)
					local buf_id = ev.data.buf_id
					vim.keymap.set('n', '~', function()
						require('mini.files').set_branch({ vim.uv.cwd() })
					end, { buffer = buf_id, desc = 'Go to cwd' })
					vim.keymap.set('ca', 'w', function()
						if vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'w' then
							-- 绕过 confirm 弹窗，直接应用文件系统操作
							return 'lua (function() local mf = require("mini.files") local old = vim.fn.confirm vim.fn.confirm = function() return 1 end mf.synchronize() vim.fn.confirm = old end)()'
						end
						return 'w'
					end, { buffer = buf_id, expr = true })
					vim.keymap.set('ca', 'q', function()
						if vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'q' then
							return 'lua require("mini.files").close()'
						end
						return 'q'
					end, { buffer = buf_id, expr = true })
					vim.keymap.set('ca', 'wq', function()
						if vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'wq' then
							return 'lua (function() local mf = require("mini.files") local old = vim.fn.confirm vim.fn.confirm = function() return 1 end mf.synchronize() vim.fn.confirm = old mf.close() end)()'
						end
						return 'wq'
					end, { buffer = buf_id, expr = true })
				end,
			})

			-- mini-cmdline
			-- require("mini.cmdline").setup()

			-- require('mini.cursorword').setup()

			require('mini.git').setup()
		end,
	},

	-- library used by other plugins
	{ 'nvim-lua/plenary.nvim', lazy = true },

	-- 看小说专用
	{
		'edte/novel.nvim',
		dependencies = {
			'folke/snacks.nvim', -- optional for snacks picker
		},
		keys = {
			{
				'<space>bb',
				function()
					require('biquge').toggle()
				end,
				desc = 'Toggle',
			},
			{
				'<space>bt',
				function()
					require('biquge').toc()
				end,
				desc = 'Toc',
			},
			{
				'<space>bn',
				function()
					require('biquge').next_chap()
				end,
				desc = 'Next chapter',
			},
			{
				'<space>bp',
				function()
					require('biquge').prev_chap()
				end,
				desc = 'Previous chapter',
			},
			{
				'<space>bs',
				function()
					require('biquge').star()
				end,
				desc = 'Star current book',
			},
			{
				'<space>bl',
				function()
					require('biquge').bookshelf()
				end,
				desc = 'Bookshelf',
			},

			{
				'<space>b/',
				function()
					require('biquge').search()
				end,
				desc = 'Search online',
			},
			{
				'<space>bf',
				function()
					require('biquge').local_search()
				end,
				desc = 'Open local file',
			},
			{
				'<space>bd',
				function()
					require('biquge').local_browse()
				end,
				desc = 'Browse local directory',
			},

			{
				'<M-d>',
				function()
					require('biquge').scroll(2)
				end,
				desc = 'Scroll down',
			},
			{
				'<M-u>',
				function()
					require('biquge').scroll(-2)
				end,
				desc = 'Scroll up',
			},
			{
				'<space>br',
				function()
					require('biquge').resume_last_reading()
				end,
				desc = 'Resume last reading',
			},
			{
				'<space>bh',
				function()
					require('biquge').reading_history()
				end,
				desc = 'Reading history',
			},
		},
		opts = {},
	},

	-- 翻译
	-- {
	-- 	"edte/comment-translate.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	config = function()
	-- 		require("comment-translate").setup({
	-- 			target_language = "zh",
	-- 			-- translate_service = "codebuddy",
	-- 			hover = {
	-- 				loading = false, -- 关闭加载动画
	-- 			},
	-- 		})
	-- 	end,
	-- },

	{
		'minigian/juan-logs.nvim',
		build = function(plugin)
			local path = plugin.dir .. '/build.lua'
			if vim.fn.filereadable(path) == 1 then
				dofile(path)
			end
		end,
		-- You can use `build = "cargo build --release"` if you have `cargo` in your system
		config = function()
			require('juanlog').setup({
				threshold_size = 1024 * 1024 * 10, -- 1MB
				mode = 'dynamic',
				lazy = true, -- background indexing. prevents neovim from freezing on 50GB files
				patterns = { '*.log', '*.csv', '*.json' }, -- Use the plugin for these filetypes
				enable_custom_statuscol = true, -- fakes absolute line numbers
				syntax = false, -- set to true to enable native vim syntax (can be slow on huge files)
			})
		end,
	},

	-- llm
	{
		'olimorris/codecompanion.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-treesitter/nvim-treesitter',
			'ravitemer/codecompanion-history.nvim',
		},
		cmd = { 'CodeCompanion', 'CodeCompanionChat' },
		keys = {
			{
				'<space>a',
				'<cmd>CodeCompanionChat Toggle<cr>',
				mode = { 'n', 'v' },
				desc = 'CodeCompanionChat Toggle',
			},
			{
				'ga',
				'<cmd>CodeCompanionChat Add<cr>',
				mode = { 'v', 'n' },
				desc = 'CodeCompanionChat Add',
			},
			{
				'gh',
				'<cmd>CodeCompanionHistory<cr>',
				mode = 'n',
				desc = 'CodeCompanion History',
			},
		},
		init = function()
			-- Expand 'cc' into 'CodeCompanion' in the command line
			vim.cmd([[cab cc CodeCompanion]])
		end,
		config = function()
			-- local has_title_api_key = vim.env.DEEPSEEK_API_KEY ~= nil and vim.env.DEEPSEEK_API_KEY ~= ''
			local has_title_api_key = false

			require('codecompanion').setup({
				opts = {
					log_level = 'DEBUG', -- TRACE|DEBUG|ERROR|INFO
					language = '中文',
				},

				interactions = {
					chat = {
						adapter = 'codebuddy',
						roles = {
							llm = function(adapter)
								return '  Assistant'
							end,

							user = '  User',
						},

						tools = {
							['cmd_runner'] = {
								opts = {
									require_approval_before = false,
									require_cmd_approval = false,
									allowed_in_yolo_mode = true,
								},
							},
						},

						-- /file /buffer 的 picker 固定走 snacks，避免默认自动探测到 mini.pick
						slash_commands = {
							buffer = { opts = { provider = 'snacks' } },
							file = { opts = { provider = 'snacks' } },
							help = { opts = { provider = 'snacks' } },
							symbols = { opts = { provider = 'snacks' } },
						},
					},
					inline = { adapter = 'codebuddy' },

					background = {
						chat = {
							callbacks = {
								['on_ready'] = {
									actions = {
										'interactions.background.builtin.chat_make_title',
									},
									-- Enable "on_ready" callback which contains the title generation action
									enabled = false,
								},
							},
							opts = {
								-- Enable background interactions generally
								enabled = false,
							},
						},
					},
				},

				adapters = {
					acp = {
						codebuddy = function()
							local helpers = require('codecompanion.adapters.acp.helpers')
							return {
								name = 'codebuddy',
								formatted_name = 'CodeBuddy',
								type = 'acp',
								roles = {
									llm = 'assistant',
									user = 'user',
								},
								opts = {
									vision = true,
								},
								commands = {
									default = {
										-- "env",
										-- "-u",
										-- "TMUX",
										-- "-u",
										-- "TERM_PROGRAM",
										-- "-u",
										-- "TERM_PROGRAM_VERSION",
										'codebuddy',
										'--acp',
										'--permission-mode',
										'bypassPermissions',
										'--dangerously-skip-permissions',
									},
								},
								defaults = {
									mcpServers = {},
									timeout = 20000,
									auth_method = nil,
								},
								parameters = {
									protocolVersion = 1,
									clientCapabilities = {
										fs = { readTextFile = true, writeTextFile = true },
									},
									clientInfo = {
										name = 'CodeCompanion.nvim',
										version = '1.0.0',
									},
								},
								handlers = {
									setup = function(self)
										vim.env.HOME = vim.env.HOME or os.getenv('HOME')
										return true
									end,
									auth = function(self)
										return true
									end,
									form_messages = function(self, messages, capabilities)
										return helpers.form_messages(self, messages, capabilities)
									end,
									on_exit = function(self, code) end,
								},
								-- 修复 Inline 策略崩溃的问题：添加缺失的方法
								map_schema_to_params = function(self)
									return {
										parameters = self.parameters,
									}
								end,
								-- 还需要这个方法
								map_roles = function(self, messages)
									local helpers = require('codecompanion.adapters.acp.helpers')
									-- 需要根据 capabilities 调整，这里简化处理
									return messages
								end,
								schema = {
									model = {
										default = 'codebuddy',
									},
								},
							}
						end,

						codex = function()
							return require('codecompanion.adapters').extend('codex', {
								defaults = {
									auth_method = 'chatgpt', -- "openai-api-key"|"codex-api-key"|"chatgpt"
								},
								env = {
									-- OPENAI_API_KEY = 'my-api-key',
								},
							})
						end,
					},
					http = {
						tencent_deepseek = function()
							local endpoint = vim.env.OPENAI_BASE_URL or ''
							endpoint = endpoint:gsub('/+$', '')

							return require('codecompanion.adapters').extend('openai', {
								name = 'tencent_deepseek',
								formatted_name = 'Tencent DeepSeek',
								url = endpoint ~= '' and endpoint or 'https://api.lkeap.cloud.tencent.com/v1/chat/completions',
								env = {
									api_key = 'DEEPSEEK_API_KEY',
								},
								schema = {
									model = {
										default = 'deepseek-v3',
									},
								},
							})
						end,
					},
				},

				display = {
					action_palette = {
						width = 95,
						height = 10,
						prompt = 'Prompt ', -- Prompt used for interactive LLM calls
						provider = 'default', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
						opts = {
							show_preset_actions = true, -- Show the default actions in the action palette?
							show_default_prompt_library = true, -- Show the default prompt library in the action palette?
							title = 'CodeCompanion actions', -- The title of the action palette
						},
					},
					chat = {
						intro_message = '',
						auto_scroll = true,
						show_context = false, -- 隐藏上下文显示
						prompt_decorator = function(message, adapter, context)
							return string.format([[<prompt>%s</prompt>]], message)
						end,
						window = {
							layout = 'vertical', -- float|vertical|horizontal|buffer
						},
					},

					diff = {
						enabled = false,
					},
				},

				extensions = {
					history = {
						enabled = true,
						opts = {
							-- Keymap to open history from chat buffer (default: gh)
							keymap = 'gh',
							-- Keymap to save the current chat manually (when auto_save is disabled)
							save_chat_keymap = 'sc',
							-- Save all chats by default (disable to save only manually using 'sc')
							auto_save = true,
							-- Number of days after which chats are automatically deleted (0 to disable)
							expiration_days = 0,
							-- Picker interface (auto resolved to a valid picker)
							picker = 'snacks', --- ("telescope", "snacks", "fzf-lua", or "default")
							---Optional filter function to control which chats are shown when browsing
							chat_filter = function(chat_data)
								return chat_data.cwd == vim.fn.getcwd()
							end,
							-- Customize picker keymaps (optional)
							picker_keymaps = {
								rename = { n = 'r', i = '<M-r>' },
								delete = { n = 'd', i = '<M-d>' },
								duplicate = { n = '<C-y>', i = '<C-y>' },
							},
							---Automatically generate titles for new chats
							auto_generate_title = has_title_api_key, -- 使用 API Key 时启用
							title_generation_opts = {
								---Adapter for generating titles (defaults to current chat adapter)
								adapter = 'tencent_deepseek', -- 使用 HTTP 适配器而不是 ACP，避免加载 Copilot
								---Model for generating titles (defaults to current chat model)
								model = 'deepseek-v3',
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
							dir_to_save = vim.fn.stdpath('data') .. '/codecompanion-history',
							---Enable detailed logging for history extension
							enable_logging = false,

							-- Summary system
							summary = {
								-- Keymap to generate summary for current chat (default: "gcs")
								create_summary_keymap = 'gcs',
								-- Keymap to browse summaries (default: "gbs")
								browse_summaries_keymap = 'gbs',

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
								vectorcode_exe = 'vectorcode',
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
			})

			-- ACP permission requests (g1/g2/g3/g4) are handled by CodeCompanion.
			-- For CodeBuddy in ACP mode, auto-accept to avoid interactive diff prompts.
			local ok, request_permission = pcall(require, 'codecompanion.interactions.chat.acp.request_permission')
			if ok and request_permission then
				request_permission.confirm = function(_, request)
					local function pick_option_id(kinds)
						for _, kind in ipairs(kinds) do
							for _, opt in ipairs(request.options or {}) do
								if opt.kind == kind and opt.optionId then
									return opt.optionId
								end
							end
						end
						return nil
					end

					local option_id = pick_option_id({ 'allow_always', 'allow_once', 'reject_once' })
					if option_id then
						return request.respond(option_id, false)
					end

					return request.respond(nil, true)
				end
			end
		end,
	},
}

return M
