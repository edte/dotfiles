if vim.env.Test then
	return
end

-- 自动切换cwd（项目维度），方便各种插件使用，比如bookmark，arrow，telescope等等，
-- 包括 git，makefile，lsp根目录，兼容普通目录，即进入的那个目录
-- 这个必须在init插件加载之前load，不能放在plugin里，因为有的插件会依赖cwd

local M = {
	-- 配置通过lsp目录或者父目录找
	detection_methods = { "pattern", "lsp" },
	ignore_lsp = {},
	file2lsp = {
		go = "gopls",
	},
	patterns = {
		"Makefile",
		"makefile",
		".git",
		"LICENSE",
		-- "README.md",
		".gitignore",
		"main.go",
		-- "init.lua",
		"stylua.toml",
		"compile_commands.json",
		"main.cpp",
		"_darcs",
		".hg",
		".bzr",
		".svn",
		"package.json",
		"Cargo.toml",
	},
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
			return client.config.root_dir, client.name
		end
	end

	-- step3: 如果没有配置文件类型，就取所有lsp的root,并且排除掉ignore lsp
	for _, client in pairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.tbl_contains(filetypes, buf_ft) then
			if not vim.tbl_contains(M.ignore_lsp, client.name) then
				return client.config.root_dir, client.name
			end
		end
	end

	return nil
end

function M.find_pattern_root()
	-- 目录优先：从当前文件所在目录开始，逐级向上；
	-- 每一层目录内依次检查所有 patterns，命中即返回该目录。

	-- 获取起始目录：优先当前缓冲区文件目录，否则使用当前工作目录
	local buf_path = api.nvim_buf_get_name(0)
	local start_dir = buf_path ~= "" and vim.fs.dirname(buf_path) or vim.uv.cwd()

	if not start_dir or start_dir == "" then
		return nil
	end

	local dir = start_dir
	while dir and dir ~= "" do
		for _, pattern in ipairs(M.patterns) do
			local candidate = vim.fs.joinpath(dir, pattern)
			local stat = vim.uv.fs_stat(candidate)
			if stat then
				-- 返回匹配到的目录与命中的 pattern 名称
				return dir, pattern
			end
		end

		local parent = vim.fs.dirname(dir)
		if not parent or parent == "" or parent == dir then
			break
		end
		dir = parent
	end

	return nil
end

function M.get_project_root()
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
		if vim.uv.cwd() ~= dir then
			local scope_chdir = M.scope_chdir
			if scope_chdir == "global" then
				api.nvim_set_current_dir(dir)
			elseif scope_chdir == "tab" then
				cmd("tcd " .. dir)
			elseif scope_chdir == "win" then
				cmd("lcd " .. dir)
			else
				return
			end
		end
		return true
	end

	return false
end

M.set_pwd(M.get_project_root())

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("nvim_rooter", { clear = true }),
	nested = true,
	callback = function()
		-- 将当前工作目录更改为正在编辑的文件的目录
		-- cmd("cd %:p:h")
		M.set_pwd(M.get_project_root())
	end,
})
