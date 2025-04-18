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

-- workaround for gopls not supporting semanticTokensProvider
-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
vim.api.nvim_create_autocmd({ "LspAttach" }, {
	group = vim.api.nvim_create_augroup("go_semanticTokens", { clear = true }),

	pattern = { "*.go" },
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
			local semantic = client.config.capabilities.textDocument.semanticTokens
			client.server_capabilities.semanticTokensProvider = {
				full = true,
				legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
				range = true,
			}
		end
	end,
})

-- 显示lsp加载进度
-- vim.api.nvim_create_autocmd("LspProgress", {
-- 	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
-- 	callback = function(ev)
-- 		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
-- 		vim.notify(vim.lsp.status(), "info", {
-- 			id = "lsp_progress",
-- 			title = "LSP Progress",
-- 			opts = function(notif)
-- 				notif.icon = ev.data.params.value.kind == "end" and " "
-- 					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
-- 			end,
-- 		})
-- 	end,
-- })
