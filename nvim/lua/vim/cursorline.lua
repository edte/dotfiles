-- cursor word
-- 高亮当前光标下的单词
local MAX_LEN = 64

local function matchadd()
    if vim.bo.filetype == "" then
        return
    end

    -- 获取光标所在列和行内容
    local column = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local left = vim.fn.matchstr(line:sub(1, math.min(column + 1, #line)), [[\k*$]])
    local right = vim.fn.matchstr(line:sub(math.min(column + 1, #line)), [[^\k*]]):sub(2)

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

    -- 尝试添加高亮并捕获可能的错误
    local success, err = pcall(function()
        vim.w.cursorword_id = vim.fn.matchadd("CursorWord", [[\<]] .. cursorword .. [[\>]], -1)
    end)

    if not success then
        print("Error adding match: " .. err)
    end
end

Autocmd("VimEnter", {
    callback = function()
        vim.api.nvim_set_hl(0, "CursorWord", { underline = true })
        matchadd()
    end,
})

Autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = matchadd,
})
