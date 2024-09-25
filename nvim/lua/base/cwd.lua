-- 自动切换cwd（项目维度），方便各种插件使用，比如bookmark，arrow，telescope等等，
-- 包括 git，makefile，lsp根目录，兼容普通目录，即进入的那个目录
-- 这个必须在init插件加载之前load，不能放在plugin里，因为有的插件会依赖cwd

local M = {
	exclude_filetypes = {
		["help"] = true,
		["nofile"] = true,
		["NvimTree"] = true,
		["dashboard"] = true,
		["TelescopePrompt"] = true,
	},
	silent_chdir = true,
	-- detection_methods = { "lsp", "pattern" },
	detection_methods = { "pattern" },
	ignore_lsp = {},
	file2lsp = {
		go = "gopls",
	},
	patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "makefile" },
	-- What scope to change the directory, valid options are
	-- * global (default)
	-- * tab
	-- * win
	scope_chdir = "global",
}

function M.find_lsp_root()
	local buf_ft = vim.bo.filetype

	-- step1: 没有 attch lsp，就直接返回
	local clients = vim.lsp.get_clients()
	if next(clients) == nil then
		return nil
	end

	-- step2: 如果有配置文件类型取啥lsp，就从对应里的取
	for _, client in pairs(clients) do
		if client.name == M.file2lsp[buf_ft] then
			print(client.config.root_dir, client.name)
			return client.config.root_dir, client.name
		end
	end

	-- step3: 如果没有配置文件类型，就取所有lsp的root,并且排除掉ignore lsp
	for _, client in pairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.tbl_contains(filetypes, buf_ft) then
			if not vim.tbl_contains(M.ignore_lsp, client.name) then
				-- print(client.config.root_dir, client.name)
				return client.config.root_dir, client.name
			end
		end
	end

	return nil
end

function M.find_pattern_root()
	local search_dir = vim.fn.expand("%:p:h", true)
	if vim.fn.has("win32") > 0 then
		search_dir = search_dir:gsub("\\", "/")
	end

	local last_dir_cache = ""
	local curr_dir_cache = {}

	local function get_parent(path)
		path = path:match("^(.*)/")
		if path == "" then
			path = "/"
		end
		return path
	end

	local function get_files(file_dir)
		last_dir_cache = file_dir
		curr_dir_cache = {}

		local dir = vim.loop.fs_scandir(file_dir)
		if dir == nil then
			return
		end

		while true do
			local file = vim.loop.fs_scandir_next(dir)
			if file == nil then
				return
			end

			table.insert(curr_dir_cache, file)
		end
	end

	local function is(dir, identifier)
		dir = dir:match(".*/(.*)")
		return dir == identifier
	end

	local function sub(dir, identifier)
		local path = get_parent(dir)
		while true do
			if is(path, identifier) then
				return true
			end
			local current = path
			path = get_parent(path)
			if current == path then
				return false
			end
		end
	end

	local function child(dir, identifier)
		local path = get_parent(dir)
		return is(path, identifier)
	end

	local function has(dir, identifier)
		if last_dir_cache ~= dir then
			get_files(dir)
		end
		local pattern = M.globtopattern(identifier)
		for _, file in ipairs(curr_dir_cache) do
			if file:match(pattern) ~= nil then
				return true
			end
		end
		return false
	end

	local function match(dir, pattern)
		local first_char = pattern:sub(1, 1)
		if first_char == "=" then
			return is(dir, pattern:sub(2))
		elseif first_char == "^" then
			return sub(dir, pattern:sub(2))
		elseif first_char == ">" then
			return child(dir, pattern:sub(2))
		else
			return has(dir, pattern)
		end
	end

	-- breadth-first search
	while true do
		for _, pattern in ipairs(M.patterns) do
			local exclude = false
			if pattern:sub(1, 1) == "!" then
				exclude = true
				pattern = pattern:sub(2)
			end
			if match(search_dir, pattern) then
				if exclude then
					break
				else
					return search_dir, "pattern " .. pattern
				end
			end
		end

		local parent = get_parent(search_dir)
		if parent == search_dir or parent == nil then
			return nil
		end

		search_dir = parent
	end
end

function M.globtopattern(g)
	-- Some useful references:
	-- - apr_fnmatch in Apache APR.  For example,
	--   http://apr.apache.org/docs/apr/1.3/group__apr__fnmatch.html
	--   which cites POSIX 1003.2-1992, section B.6.

	local p = "^" -- pattern being built
	local i = 0 -- index in g
	local c -- char at index i in g.

	-- unescape glob char
	local function unescape()
		if c == "\\" then
			i = i + 1
			c = g:sub(i, i)
			if c == "" then
				p = "[^]"
				return false
			end
		end
		return true
	end

	-- escape pattern char
	local function escape(cc)
		return cc:match("^%w$") and cc or "%" .. cc
	end

	-- Convert tokens at end of charset.
	local function charset_end()
		while 1 do
			if c == "" then
				p = "[^]"
				return false
			elseif c == "]" then
				p = p .. "]"
				break
			else
				if not unescape() then
					break
				end
				local c1 = c
				i = i + 1
				c = g:sub(i, i)
				if c == "" then
					p = "[^]"
					return false
				elseif c == "-" then
					i = i + 1
					c = g:sub(i, i)
					if c == "" then
						p = "[^]"
						return false
					elseif c == "]" then
						p = p .. escape(c1) .. "%-]"
						break
					else
						if not unescape() then
							break
						end
						p = p .. escape(c1) .. "-" .. escape(c)
					end
				elseif c == "]" then
					p = p .. escape(c1) .. "]"
					break
				else
					p = p .. escape(c1)
					i = i - 1 -- put back
				end
			end
			i = i + 1
			c = g:sub(i, i)
		end
		return true
	end

	-- Convert tokens in charset.
	local function charset()
		i = i + 1
		c = g:sub(i, i)
		if c == "" or c == "]" then
			p = "[^]"
			return false
		elseif c == "^" or c == "!" then
			i = i + 1
			c = g:sub(i, i)
			if c == "]" then
				-- ignored
			else
				p = p .. "[^"
				if not charset_end() then
					return false
				end
			end
		else
			p = p .. "["
			if not charset_end() then
				return false
			end
		end
		return true
	end

	-- Convert tokens.
	while 1 do
		i = i + 1
		c = g:sub(i, i)
		if c == "" then
			p = p .. "$"
			break
		elseif c == "?" then
			p = p .. "."
		elseif c == "*" then
			p = p .. ".*"
		elseif c == "[" then
			if not charset() then
				break
			end
		elseif c == "\\" then
			i = i + 1
			c = g:sub(i, i)
			if c == "" then
				p = p .. "\\$"
				break
			end
			p = p .. escape(c)
		else
			p = p .. escape(c)
		end
	end
	return p
end

function M.get_project_root()
	-- returns project root, as well as method
	for _, detection_method in ipairs(M.detection_methods) do
		if detection_method == "lsp" then
			local root, lsp_name = M.find_lsp_root()
			if root ~= nil then
				return root, '"' .. lsp_name .. '"' .. " lsp"
			end
		elseif detection_method == "pattern" then
			local root, method = M.find_pattern_root()
			if root ~= nil then
				return root, method
			end
		end
	end
end

function M.set_pwd(dir, method)
	if dir ~= nil then
		if vim.fn.getcwd() ~= dir then
			local scope_chdir = M.scope_chdir
			if scope_chdir == "global" then
				vim.api.nvim_set_current_dir(dir)
			elseif scope_chdir == "tab" then
				vim.cmd("tcd " .. dir)
			elseif scope_chdir == "win" then
				vim.cmd("lcd " .. dir)
			else
				return
			end

			if M.silent_chdir == false then
				vim.notify("Set CWD to " .. dir .. " using " .. method)
			end
		end
		return true
	end

	return false
end

local function setup()
	local root, method = M.get_project_root()
	M.set_pwd(root, method)
end

local group_id = GroupId("nvim_rooter", { clear = true })

Autocmd("BufEnter", {
	group = group_id,
	nested = true,
	callback = function()
		-- 将当前工作目录更改为正在编辑的文件的目录
		-- vim.cmd("cd %:p:h")
		setup()
	end,
})

setup()
