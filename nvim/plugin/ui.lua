if vim.g.ui_loaded then
	return
end
vim.g.ui_loaded = true

-- 加载tokyonight主题
vim.pack.add({
	{ src = 'https://github.com/folke/tokyonight.nvim.git' },
}, { confirm = false })

vim.cmd.colorscheme('tokyonight')

-- 统一设置行号颜色
for _, hl_group in ipairs({ 'LineNr', 'LineNrAbove', 'LineNrBelow' }) do
	vim.api.nvim_set_hl(0, hl_group, { fg = '#808080' })
end

-- 分屏分隔线颜色（更醒目）
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#565f89', bg = 'NONE' })
