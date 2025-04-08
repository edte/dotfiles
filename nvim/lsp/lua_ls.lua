-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/lua_ls.lua
return {
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
}
