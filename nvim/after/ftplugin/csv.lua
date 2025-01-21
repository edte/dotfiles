local NuiTable = require("nui.table")

local function render_csv_as_table()
    local lines = {}
    local headers = {}
    local data = {}

    -- Get the current buffer's file path
    local file_path = vim.api.nvim_buf_get_name(0)

    for line in io.lines(file_path) do
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

    -- Use the current buffer number
    local bufnr = vim.api.nvim_get_current_buf()

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

render_csv_as_table()
