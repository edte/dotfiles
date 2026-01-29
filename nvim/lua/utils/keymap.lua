local M = {}

--- 统一键映射设置函数
--- @param mode string 模式（n, i, v, c, x）
--- @param lhs string 左边键位
--- @param rhs string|function 右边命令或函数
--- @param opts table|nil 选项
M.keymap = function(mode, lhs, rhs, opts)
	if opts == nil then
		opts = { noremap = true, silent = true }
	end

	if type(rhs) == 'string' then
		vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
		return
	end

	if type(rhs) == 'function' then
		vim.keymap.set(mode, lhs, rhs, opts)
		return
	end

	log.error('rhs type error', type(rhs))
end

M.nmap = function(lhs, rhs, opts)
	M.keymap('n', lhs, rhs, opts)
end -- Normal 模式映射
M.cmap = function(lhs, rhs, opts)
	M.keymap('c', lhs, rhs, opts)
end -- Command 模式映射
M.vmap = function(lhs, rhs, opts)
	M.keymap('v', lhs, rhs, opts)
end -- Visual 模式映射
M.imap = function(lhs, rhs, opts)
	M.keymap('i', lhs, rhs, opts)
end -- Insert 模式映射
M.xmap = function(lhs, rhs, opts)
	M.keymap('x', lhs, rhs, opts)
end -- Visual Line 模式映射

return M
