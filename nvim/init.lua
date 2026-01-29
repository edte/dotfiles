-- 核心模块加载
local modules = { 'alias', 'lazys' }
for _, module in ipairs(modules) do
	require(module)
end

vim.cmd.source(vim.fn.stdpath('config') .. '/lua/vim/match.vim')

-- 启动nvim mcp，搞一个panel启动实例给模型用就行，正常注释
-- vim.fn.serverstart("/tmp/nvim.sock")
