local M = {}

M.config = function()
    Require("bigfile").setup({
        -- detect long python files
        pattern = function(bufnr, filesize_mib)
            -- you can't use `nvim_buf_line_count` because this runs on BufReadPre
            local file_contents = vim.fn.readfile(Api.nvim_buf_get_name(bufnr))
            local file_length = #file_contents
            local filetype = vim.filetype.match({ buf = bufnr })
            -- 2000 行开启大文件检测
            if file_length > 2500 then
                return true
            end
        end,
    })
end

return M
