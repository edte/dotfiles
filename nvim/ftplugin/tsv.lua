vim.api.nvim_buf_set_keymap(0, "n", "t", ":q<cr>", { noremap = true, silent = true, desc = "Jump to the next request" })

local NuiTable = require("nui.table")

function render_tsv_as_table()
	local lines = {}
	local headers = {}
	local data = {}

	-- Get the current buffer number
	local bufnr = vim.api.nvim_get_current_buf()

	-- Get the lines from the current buffer
	lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	if #lines == 1 then
		return
	end

	if #lines > 0 then
		headers = vim.split(lines[1], "\t")
		for i = 2, #lines do
			local row = {}
			local values = vim.split(lines[i], "\t")
			for j, header in ipairs(headers) do
				row[header] = values[j]
			end
			table.insert(data, row)
		end
	else
		log.error("Error: Current buffer is empty.")
		return
	end

	-- Clear the current buffer
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
end

render_tsv_as_table()
