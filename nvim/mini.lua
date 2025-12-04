-- 最小配置

vim.pack.add({
	{ src = "https://github.com/folke/lazy.nvim.git", version = vim.version.range("*") },
})

require("lazy").setup({
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
			files = {
				options = {
					use_as_default_explorer = true,
				},
				windows = {
					preview = true,
					width_focus = 30,
					width_preview = 30,
				},
			},
		},
		keys = {
			{
				"t",
				function()
					require("mini.splitjoin").toggle()
				end,
			},

			{
				"<space>gd",
				function()
					require("mini.diff").toggle_overlay(0)
				end,
				desc = "diff",
			},
			{
				"<space>e",
				function()
					local mf = require("mini.files")
					if not mf.close() then
						local n = vim.api.nvim_buf_get_name(0)
						if n ~= "" then
							mf.open(n)
							mf.reveal_cwd()
						else
							mf.open()
							mf.reveal_cwd()
						end
					end
				end,
				desc = "explorer",
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

			require("mini.trailspace").setup()

			-- require("mini.icons").setup()

			-- vip 后接 gh / gH 可应用/重置当前段落中的块。同样的操作符形式 ghip / gHip 也可以实现，其优点是可点重复。
			-- gh_ / gH_ 应用/重置当前行（即使它不是完整的块）。
			-- ghgh / gHgh 应用/重置光标下的块范围。
			-- dgh 删除光标下的大块范围。
			-- [H / [h / ]h / ]H 将光标导航到当前缓冲区的第一个/上一个/下一个/最后一个块范围。
			require("mini.diff").setup({
				mappings = {
					-- Apply hunks inside a visual/operator region
					apply = "gB",
					-- Reset hunks inside a visual/operator region
					reset = "gb",
					-- Hunk range textobject to be used inside operator
					-- Works also in Visual mode if mapping differs from apply and reset
					textobject = "gb",
					-- Go to hunk range in corresponding direction
					goto_first = "[H",
					goto_prev = "[h",
					goto_next = "]h",
					goto_last = "]H",
				},
			})
			require("mini.ai").setup()
			require("mini.move").setup()
			require("mini.splitjoin").setup()

			-- mini.files git

			local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")
			local autocmd = vim.api.nvim_create_autocmd
			local _, MiniFiles = pcall(require, "mini.files")

			-- Cache for git status
			local gitStatusCache = {}
			local cacheTimeout = 2000 -- Cache timeout in milliseconds

			local function isSymlink(path)
				local stat = vim.loop.fs_lstat(path)
				return stat and stat.type == "link"
			end

			---@type table<string, {symbol: string, hlGroup: string}>
			---@param status string
			---@return string symbol, string hlGroup
			local function mapSymbols(status, is_symlink)
				local statusMap = {
					[" M"] = { symbol = "✹", hlGroup = "SnacksPickerGitStatusModified" }, -- Modified in the working directory
					["M "] = { symbol = "•", hlGroup = "SnacksPickerGitStatusModified" }, -- modified in index
					["MM"] = { symbol = "≠", hlGroup = "SnacksPickerGitStatusModified" }, -- modified in both working tree and index
					["A "] = { symbol = "+", hlGroup = "SnacksPickerGitStatusUntracked" }, -- Added to the staging area, new file
					["AA"] = { symbol = "≈", hlGroup = "SnacksPickerGitStatusUntracked" }, -- file is added in both working tree and index
					["D "] = { symbol = "-", hlGroup = "MiniDiffSignDelete" }, -- Deleted from the staging area
					["AM"] = { symbol = "⊕", hlGroup = "MiniTablineModifiedVisible" }, -- added in working tree, modified in index
					["AD"] = { symbol = "-•", hlGroup = "MiniTablineModifiedVisible" }, -- Added in the index and deleted in the working directory
					["R "] = { symbol = "→", hlGroup = "MiniTablineModifiedVisible" }, -- Renamed in the index
					["U "] = { symbol = "‖", hlGroup = "MiniTablineModifiedVisible" }, -- Unmerged path
					["UU"] = { symbol = "⇄", hlGroup = "SnacksPickerGitStatusUntracked" }, -- file is unmerged
					["UA"] = { symbol = "⊕", hlGroup = "SnacksPickerGitStatusUntracked" }, -- file is unmerged and added in working tree
					["??"] = { symbol = "?", hlGroup = "SnacksPickerGitStatusUntracked" }, -- Untracked files
					["!!"] = { symbol = "!", hlGroup = "MiniTablineModifiedVisible" }, -- Ignored files
				}

				local result = statusMap[status] or { symbol = "?", hlGroup = "NonText" }
				local gitSymbol = result.symbol
				local gitHlGroup = result.hlGroup

				local symlinkSymbol = is_symlink and "↩" or ""

				-- Combine symlink symbol with Git status if both exist
				local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub("^%s+", ""):gsub("%s+$", "")
				-- Change the color of the symlink icon from "MiniDiffSignDelete" to something else
				local combinedHlGroup = is_symlink and "MiniDiffSignDelete" or gitHlGroup

				return combinedSymbol, combinedHlGroup
			end

			---@param cwd string
			---@param callback function
			---@return nil
			local function fetchGitStatus(cwd, callback)
				-- 验证路径是否有效
				if not cwd or cwd == "" or vim.fn.isdirectory(cwd) == 0 then
					return
				end
				local function on_exit(content)
					if content.code == 0 then
						callback(content.stdout)
						vim.g.content = content.stdout
					end
				end
				vim.system({ "git", "status", "--ignored", "--porcelain" }, { text = true, cwd = cwd }, on_exit)
			end

			---@param str string|nil
			---@return string
			local function escapePattern(str)
				if not str then
					return ""
				end
				return (str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
			end

			---@param buf_id integer
			---@param gitStatusMap table
			---@return nil
			local function updateMiniWithGit(buf_id, gitStatusMap)
				local MiniFiles = require("mini.files")
				vim.schedule(function()
					local nlines = vim.api.nvim_buf_line_count(buf_id)
					local git_root = vim.fs.root(vim.uv.cwd(), ".git")
					local escapedcwd = escapePattern(git_root)
					if vim.fn.has("win32") == 1 then
						escapedcwd = escapedcwd:gsub("\\", "/")
					end

					for i = 1, nlines do
						local entry = MiniFiles.get_fs_entry(buf_id, i)
						if not entry then
							break
						end
						local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
						local status = gitStatusMap[relativePath]

						if status then
							local symbol, hlGroup = mapSymbols(status)
							vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
								-- NOTE: if you want the signs on the right uncomment those and comment
								-- the 3 lines after
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
				-- lua match is faster than vim.split (in my experience )
				for line in content:gmatch("[^\r\n]+") do
					local status, filePath = string.match(line, "^(..)%s+(.*)")
					-- Split the file path into parts
					local parts = {}
					for part in filePath:gmatch("[^/]+") do
						table.insert(parts, part)
					end
					-- Start with the root directory
					local currentKey = ""
					for i, part in ipairs(parts) do
						if i > 1 then
							-- Concatenate parts with a separator to create a unique key
							currentKey = currentKey .. "/" .. part
						else
							currentKey = part
						end
						-- If it's the last part, it's a file, so add it with its status
						if i == #parts then
							gitStatusMap[currentKey] = status
						else
							-- If it's not the last part, it's a directory. Check if it exists, if not, add it.
							if not gitStatusMap[currentKey] then
								gitStatusMap[currentKey] = status
							end
						end
					end
				end
				return gitStatusMap
			end

			---@param buf_id integer
			---@return nil

			local function updateGitStatus(buf_id)
				if not vim.fs.root(vim.uv.cwd(), ".git") then
					vim.notify("Not a valid git repo")
					return
				end
				-- 获取 mini.files 正在浏览的真实目录
				local entry = MiniFiles.get_fs_entry(buf_id, 1)
				if not entry or not entry.path then
					return
				end
				-- 从第一个条目的路径推断当前浏览目录
				local cwd = vim.fn.fnamemodify(entry.path, ":h")
				if vim.fn.isdirectory(cwd) == 0 then
					cwd = entry.path
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
				return vim.api.nvim_create_augroup("MiniFiles_" .. name, { clear = true })
			end

			autocmd("User", {
				group = augroup("start"),
				pattern = "MiniFilesExplorerOpen",
				-- pattern = { "minifiles" },
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()
					updateGitStatus(bufnr)
				end,
			})

			autocmd("User", {
				group = augroup("close"),
				pattern = "MiniFilesExplorerClose",
				callback = function()
					clearCache()
				end,
			})

			autocmd("User", {
				group = augroup("update"),
				pattern = "MiniFilesBufferUpdate",
				callback = function(sii)
					local bufnr = sii.data.buf_id
					local cwd = vim.fn.expand("%:p:h")
					if gitStatusCache[cwd] then
						updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
					end
				end,
			})
		end,
	},
})
