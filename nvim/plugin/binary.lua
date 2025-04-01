-- 这些文件只用用mac的open打开
local open_files = {
    "pdf", "jpg", "jpeg", "webp", "png", "mp3", "mp4",
    "xls", "xlsx", "xopp", "gif", "doc", "docx", "mov"
}

for _, ext in ipairs(open_files) do
    vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
        pattern = "*." .. ext,
        group = vim.api.nvim_create_augroup("binFiles", { clear = true }),
        callback = function()
            -- Get the current buffer number before opening the file
            local prev_buf = vim.fn.bufnr('%')

            -- Get the full path of the current file
            local fn = vim.fn.expand('%:p')

            -- Open the file using xdg-open
            vim.fn.jobstart('open "' .. fn .. '"')

            -- Switch back to the previous buffer
            if vim.fn.buflisted(prev_buf) == 1 then
                vim.api.nvim_set_current_buf(prev_buf)
            end

            -- Optionally close the current buffer if you want
            vim.api.nvim_buf_delete(0, { force = true })
        end
    })
end


-- 这些文件用xxd打开
local xxd_files = {
    "bin", "dmg", "exe", "a", "so", "o", ""
}

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = "*",
    group = vim.api.nvim_create_augroup("xxd_binFiles", { clear = true }),
    callback = function()
        local exetension = vim.fn.expand("%:e")
        for _, filetype in ipairs(xxd_files) do
            if filetype == exetension then
                vim.cmd([[silent %!xxd  -c 32]])
                return
            end
        end
    end
})
