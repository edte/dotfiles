-- cursor word
-- 高亮当前光标下的单词
local MAX_LEN = 64

local function matchadd()
    if vim.bo.filetype == "" then
        return
    end

    -- step1: 获取当前光标位置的单词
    local column = Api.nvim_win_get_cursor(0)[2]
    local line = Api.nvim_get_current_line()
    local left = vim.fn.matchstr(line:sub(1, math.min(column + 1, #line)), [[\k*$]])
    local right = vim.fn.matchstr(line:sub(math.min(column + 1, #line)), [[^\k*]]):sub(2)

    local cursorword = left .. right

    -- step2: 如果单词没有变化，则不需要更新
    if cursorword == vim.w.cursorword then
        return
    end

    vim.w.cursorword = cursorword

    -- step3: 如果高亮已经存在，则删除
    if vim.w.cursorword_id then
        vim.fn.matchdelete(vim.w.cursorword_id)
        vim.w.cursorword_id = nil
    end

    -- step4: 如果单词为空，或者单词过长，或者包含非ASCII字符，则不需要更新
    if cursorword == "" or #cursorword > MAX_LEN or cursorword:find("[\192-\255]+") ~= nil then
        return
    end

    -- 尝试添加高亮并捕获可能的错误
    local success, err = pcall(function()
        vim.w.cursorword_id = vim.fn.matchadd("CursorWord", [[\<]] .. cursorword .. [[\>]], -1)
    end)

    if not success then
        log.error("Error adding match: " .. err)
    end
end

Autocmd({ "VimEnter" }, {
    callback = function()
        highlight("CursorWord", { underline = true })
        matchadd()
    end,
})

Autocmd({ "CursorMoved", "CursorMovedI" }, {
    callback = matchadd,
})
