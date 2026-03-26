-- ============================ 文件类型配置 ============================

-- 设置 Brewfile 文件类型为 bash
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
	pattern = { 'Brewfile', '*.Brewfile' },
	callback = function()
		vim.bo.filetype = 'bash'
	end,
})

vim.filetype.add({
	filename = {
		['kitty.conf'] = 'kitty',
	},
	extension = {
		jce = 'jce',
		tmux = 'bash',
		sh = 'bash',
		zsh = 'bash',
		codecompanion = 'codecompanion',
		log = 'log',
	},
	pattern = {
		['.*/kitty/.*%.conf'] = 'kitty',
	},
})
