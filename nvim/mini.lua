-- 最小配置

-- mini config
-- debug
vim.lsp.config("lua_ls", {
	name = "lua_ls",
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	on_attach = function(client, buf)
		vim.lsp.inlay_hint.enable(true, { bufnr = buf })
	end,
	single_file_support = true,
	root_markers = { ".git", "Makefile" },

	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "require" },
			},
			runtime = {
				version = "LuaJIT",
			},
			hint = {
				enable = true, -- necessary
				arrayIndex = "Enable",
				await = true,
				paramName = "All",
				paramType = true,
				-- semicolon = "All",
				setType = true,
			},
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	},
	handlers = {
		["textDocument/definition"] = function(err, result, ctx, config)
			if type(result) == "table" then
				result = { result[1] }
			end
			vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
		end,
	},
})

vim.lsp.enable("lua_ls")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"edte/lsp-hover.nvim",
		opts = {},
	},
})
