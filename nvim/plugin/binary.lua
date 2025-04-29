if vim.env.Test then
	return
end

-- 这些文件只用用mac的open打开
local open_files = {
	"pdf",
	"jpg",
	"jpeg",
	"webp",
	"png",
	"mp3",
	"mp4",
	"xls",
	"xlsx",
	"xopp",
	"gif",
	"doc",
	"docx",
	"mov",
	"png",
}

for _, ext in ipairs(open_files) do
	vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
		pattern = "*." .. ext,
		group = vim.api.nvim_create_augroup("binFiles_" .. ext, { clear = true }),
		callback = function()
			print("fuck")
			-- Get the current buffer number before opening the file
			local prev_buf = vim.fn.bufnr("%")

			-- Get the full path of the current file
			local fn = vim.fn.expand("%:p")

			-- Open the file using xdg-open
			vim.fn.jobstart('open "' .. fn .. '"')

			-- Switch back to the previous buffer
			if vim.fn.buflisted(prev_buf) == 1 then
				vim.api.nvim_set_current_buf(prev_buf)
			end

			-- Optionally close the current buffer if you want
			vim.api.nvim_buf_delete(0, { force = true })
		end,
	})
end

-- 这些文件用xxd打开
local xxd_files = {
	"bin",
	"dmg",
	"exe",
	"a",
	"so",
	"o",
	"",
	"p12",
	"p8",
	"scel",
}

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = "*",
	group = vim.api.nvim_create_augroup("xxd_binFiles", { clear = true }),
	callback = function()
		local current_file = vim.fn.expand("%:p")
		if vim.fn.isdirectory(current_file) == 1 then
			return
		end

		local name = vim.fs.basename(vim.fn.expand("%"))
		if
			name == "Makefile"
			or name == ".gitignore"
			or name == "makefile"
			or name == ".clangd"
			or name == "LICENSE"
			or name == ".gitattributes"
			or name == ".editorconfig"
			or name == ".bash_profile"
			or name == ".zshrc"
			or name == ".bashrc"
			or name == "tags"
			or name == ".ignore"
		then
			return
		end

		if vim.bo.filetype == "qf" then
			return
		end

		local exetension = vim.fn.expand("%:e")
		for _, filetype in ipairs(xxd_files) do
			if filetype == exetension then
				vim.cmd([[silent %!xxd  -c 32]])
				return
			end
		end
	end,
})

-- 打开目录显示下面的文件
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	pattern = "*",
	group = vim.api.nvim_create_augroup("list_directory_files", { clear = true }),
	callback = function()
		local current_file = vim.fn.expand("%:p")
		if vim.fn.isdirectory(current_file) == 1 then
			local files = vim.fn.readdir(current_file)
			local directories = {}
			local regular_files = {}

			for _, file in ipairs(files) do
				local file_path = current_file .. "/" .. file
				if vim.fn.isdirectory(file_path) == 1 then
					table.insert(directories, file .. "/")
				else
					table.insert(regular_files, file)
				end
			end

			-- 对目录和文件分别排序
			table.sort(directories)
			table.sort(regular_files)

			-- 合并目录和文件
			local display_lines = {}
			for _, dir in ipairs(directories) do
				table.insert(display_lines, dir)
			end
			for _, file in ipairs(regular_files) do
				table.insert(display_lines, file)
			end

			-- 清空当前 buffer
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
			-- 在 buffer 中显示文件名
			vim.api.nvim_buf_set_lines(0, 0, -1, false, display_lines)
		end
	end,
})
