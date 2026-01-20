if vim.g.vim_loaded then
	return
end
vim.g.vim_loaded = true

vim.treesitter.start()

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/lua_ls.lua
vim.lsp.config("vimls", {
	name = "vimls",
	cmd = { "vim-language-server", "--stdio" },
	filetypes = { "vim" },
	root_markers = { ".git", "Makefile" },
	on_attach = function(client, buf)
		vim.lsp.inlay_hint.enable(true, { bufnr = buf })
	end,
	init_options = {
		{
			diagnostic = {
				enable = true,
			},
			indexes = {
				count = 3,
				gap = 100,
				projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
				runtimepath = true,
			},
			isNeovim = true,
			iskeyword = "@,48-57,_,192-255,-#",
			runtimepath = "",
			suggest = {
				fromRuntimepath = true,
				fromVimruntime = true,
			},
			vimruntime = "",
		},
	},
	single_file_support = true,
})

vim.lsp.enable("vimls")
