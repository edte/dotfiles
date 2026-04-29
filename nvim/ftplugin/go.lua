-- 避免在 FileType 回调里直接修改 runtimepath，nvim 0.12-dev 下会触发崩溃
local function setup_go_once()
	if vim.g.go_loaded then
		return
	end
	vim.g.go_loaded = true

	vim.pack.add({
		'https://github.com/ray-x/go.nvim.git',
		'https://github.com/ray-x/guihua.lua.git',
		'https://github.com/edte/no-go.nvim.git',
		'https://github.com/edte/more-go.nvim.git',
		'https://github.com/olexsmir/gopher.nvim.git',
	}, { confirm = false })

	-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#custom-configuration
	local gomodcache = vim.fn.trim(vim.fn.system('go env GOMODCACHE'))

	vim.lsp.config('gopls', {
		name = 'gopls',
		cmd = { 'gopls' },
		filetypes = { 'go', 'gomod', 'gosum', 'gotmpl', 'gowork' },
		root_dir = function(bufnr, on_dir)
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			-- 模块缓存中的文件：复用已有 gopls 的 root，避免启动新实例
			if gomodcache ~= '' and bufname:find(gomodcache, 1, true) then
				for _, client in ipairs(vim.lsp.get_clients({ name = 'gopls' })) do
					if client.root_dir then
						on_dir(client.root_dir)
						return
					end
				end
			end
			-- 普通文件：标准查找 go.mod
			local root = vim.fs.root(bufnr, { 'go.mod', '.git', 'Makefile' })
			if root then
				on_dir(root)
			end
		end,
		on_attach = function(client, buf)
			vim.lsp.inlay_hint.enable(true, { bufnr = buf })
		end,
		single_file_support = false,
		settings = {
			gopls = {
				analyses = {
					nilness = true,
					unusedparams = true,
					unusedwrite = true,
					useany = true,
				},
				usePlaceholders = true, -- 这个参数打开后，补全的时候会把参数名字和类型一起补全
				completeUnimported = true,
				staticcheck = true,
				directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
				semanticTokens = true,
				gofumpt = true,
				-- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
				hints = {
					rangeVariableTypes = true, -- 范围变量类型
					constantValues = true, -- 常数值
					assignVariableTypes = true, -- 分配变量类型
					compositeLiteralFields = true, -- 复合文字字段
					compositeLiteralTypes = true, -- 复合文字类型
					parameterNames = true, -- 参数名称
					functionTypeParameters = true, -- 函数类型参数
				},
				codelenses = {
					gc_details = false,
					generate = true,
					regenerate_cgo = true,
					run_govulncheck = true,
					test = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
			},
		},
	})

	-- 确保 go.nvim 的 lua 路径被正确添加到 package.path
	local go_nvim_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/go.nvim/lua'
	if not package.path:find(go_nvim_path, 1, true) then
		package.path = package.path .. ';' .. go_nvim_path .. '/?.lua;' .. go_nvim_path .. '/?/init.lua'
	end

	require('go').setup({
		diagnostic = false,
	})

	vim.api.nvim_create_user_command('GoAddTagEmpty', function()
		vim.api.nvim_command(':GoAddTag json -add-options json=')
	end, { nargs = '*' })

	vim.api.nvim_create_autocmd('BufWritePost', {
		group = vim.api.nvim_create_augroup('go_auto_import', { clear = true }),
		nested = true,
		callback = function()
			cmd('GoImports')
		end,
	})

	require('no-go').setup({
		identifiers = { 'err', 'error' }, -- Customize which identifiers to collapse
		-- look at the default config for more details
		highlight_group = 'LspInlayHint',
		fold_imports = true,
	})

	require('more-go').setup()
	require('gopher').setup()
	vim.lsp.enable('gopls')
end

vim.schedule(setup_go_once)

-- 清除 LSP semantic token 对 comment 的高亮，让 treesitter 的 @comment.todo 等生效
vim.api.nvim_set_hl(0, '@lsp.type.comment.go', {})
vim.treesitter.start()

vim.cmd([[cab goget GoGet]])

dofile(vim.fn.stdpath('config') .. '/ftplugin/markdown.lua')
