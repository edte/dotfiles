local M = {}

M.config = function()
	try_require("bigfile").setup({
		-- detect long python files
		pattern = function(bufnr, filesize_mib)
			-- you can't use `nvim_buf_line_count` because this runs on BufReadPre
			local file_contents = vim.fn.readfile(vim.api.nvim_buf_get_name(bufnr))
			local file_length = #file_contents
			local filetype = vim.filetype.match({ buf = bufnr })
			-- print(file_length)
			-- 2000 行开启大文件检测
			if file_length > 2500 then
				return true
			end
		end,
	})
end

return M
