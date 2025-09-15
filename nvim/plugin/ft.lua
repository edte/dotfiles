-- ============================ 文件类型配置 ============================

-- 设置 Brewfile 文件类型为 bash
Autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "Brewfile", "*.Brewfile" },
	callback = function()
		vim.bo.filetype = "bash"
	end,
})
