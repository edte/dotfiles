-- 核心模块加载
local modules = { 'alias', 'lazys' }
for _, module in ipairs(modules) do
	require(module)
end

vim.cmd.source(vim.fn.stdpath('config') .. '/lua/vim/match.vim')

-- 启动固定 socket 给外部客户端连接。
-- Neovim 0.12 即使未显式 --listen，也会先分配一个临时 servername，
-- 所以不能再用空字符串判断是否需要注册固定地址。
do
	local mcp_server_addr = '/tmp/nvim'
	local current_server = vim.v.servername
	local ok, result = pcall(vim.fn.serverstart, mcp_server_addr)

	if not ok then
		vim.schedule(function()
			-- vim.notify(
			-- 	string.format('nvim mcp server start skipped: %s (%s)', mcp_server_addr, tostring(result)),
			-- 	vim.log.levels.WARN
			-- )
		end)
	elseif result == mcp_server_addr and current_server ~= mcp_server_addr then
		vim.g.mcp_server_addr = mcp_server_addr
	end
end
