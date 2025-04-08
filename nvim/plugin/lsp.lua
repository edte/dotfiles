-- 根据语言启动 lsp

local M = {
	lua_ls = { "lua" },
	gopls = { "go" },
	clangd = { "cpp", "c" },
	jsonls = { "json" },
	vimls = { "vim" },
	-- bashls = { "zsh", "sh", "bash" }, -- -- bashls不能这样，不知道为啥
}

for k, v in pairs(M) do
	Autocmd("FileType", {
		pattern = v,
		callback = function()
			vim.lsp.enable({ k })
		end,
		group = GroupId("lsp_enable_" .. k, { clear = true }),
	})
end

vim.lsp.enable({ "bashls" })

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd(string.format("e %s", vim.lsp.get_log_path()))
end, {
	desc = "Opens the Nvim LSP client log.",
})

-- TODO: 这里待弄成 lspconfig 分支 a89de2e0 的格式
-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("check vim.lsp")
end, {
	desc = "Displays attached, active, and configured language servers",
})
