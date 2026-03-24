vim.api.nvim_buf_set_keymap(0, "n", "t", ":q<cr>", { noremap = true, silent = true, desc = "Jump to the next request" })

local NuiTable = require("nui.table")

function render_tsv_as_table()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	if #lines <= 1 then
		return
	end

	local headers = vim.split(lines[1], "\t")
	local data = {}

	for i = 2, #lines do
		local row = {}
		local values = vim.split(lines[i], "\t")
		for j, header in ipairs(headers) do
			row[header] = values[j] or ""
		end
		table.insert(data, row)
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

	local tbl = NuiTable({
		bufnr = bufnr,
		columns = vim.tbl_map(function(header)
			return {
				align = "center",
				accessor_key = header,
				header = header,
			}
		end, headers),
		data = data,
	})

	tbl:render()

	-- 允许横向滚动查看所有列
	vim.schedule(function()
		for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
			vim.api.nvim_set_option_value("wrap", false, { win = win })
		end
	end)
end

render_tsv_as_table()
