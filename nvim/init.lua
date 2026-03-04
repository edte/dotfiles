-- 核心模块加载
local modules = { 'alias', 'lazys' }
for _, module in ipairs(modules) do
	require(module)
end

vim.cmd.source(vim.fn.stdpath('config') .. '/lua/vim/match.vim')

-- 启动 nvim mcp：固定地址给面板实例用；冲突时不阻断普通编辑启动
if vim.v.servername == '' then
	local mcp_server_addr = '/tmp/nvim.sock'
	local ok, err = pcall(vim.fn.serverstart, mcp_server_addr)
	if not ok then
		vim.schedule(function()
			vim.notify(
				string.format('nvim mcp server start skipped: %s (%s)', mcp_server_addr, tostring(err)),
				vim.log.levels.WARN
			)
		end)
	end
end
