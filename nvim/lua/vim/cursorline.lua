-- cursor word
-- 高亮当前光标下的单词
local MAX_LEN = 64

local function matchadd()
    local column = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local left = vim.fn.matchstr(line:sub(1, column + 1), [[\k*$]])
    local right = vim.fn.matchstr(line:sub(column + 1), [[^\k*]]):sub(2)
    local cursorword = left .. right

    if cursorword == vim.w.cursorword then
        return
    end

    vim.w.cursorword = cursorword

    if vim.w.cursorword_id then
        vim.fn.matchdelete(vim.w.cursorword_id)
        vim.w.cursorword_id = nil
    end

    if cursorword == "" or #cursorword > MAX_LEN or cursorword:find("[\192-\255]+") ~= nil then
        return
    end

    -- TODO: 在help文档中会报错，待优化
    vim.w.cursorword_id = vim.fn.matchadd("CursorWord", [[\<]] .. cursorword .. [[\>]], -1)
end

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.api.nvim_set_hl(0, "CursorWord", { underline = true })
        matchadd()
    end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = matchadd,
})
