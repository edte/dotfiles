-- 最小配置

vim.pack.add({
	{ src = "https://github.com/folke/lazy.nvim.git", version = vim.version.range("*") },
}, { confirm = false })

require("lazy").setup({})
