local NuiTable = require("nui.table")

local function render_csv_as_table()
	local lines = {}
	local headers = {}
	local data = {}

	-- Get the current buffer number
	local bufnr = vim.api.nvim_get_current_buf()

	-- Get the lines from the current buffer
	local buffer_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	for _, line in ipairs(buffer_lines) do
		table.insert(lines, vim.split(line, ","))
	end

	if #lines > 0 then
		headers = lines[1]
		for i = 2, #lines do
			local row = {}
			for j, header in ipairs(headers) do
				row[header] = lines[i][j]
			end
			table.insert(data, row)
		end
	end

	-- Clear the current buffer
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

	-- Calculate max_width per column to fit all columns in one screen
	local win_width = vim.api.nvim_win_get_width(0)
	local col_count = #headers
	local separator_width = col_count + 1 -- border chars between columns
	local max_col_width = col_count > 0 and math.floor((win_width - separator_width) / col_count) or win_width

	local tbl = NuiTable({
		bufnr = bufnr,
		columns = vim.tbl_map(function(header)
			return {
				align = "center",
				accessor_key = header,
				header = header,
				max_width = max_col_width,
			}
		end, headers),
		data = data,
	})

	tbl:render()
end

render_csv_as_table()
