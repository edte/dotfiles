-- 最大高亮单词长度
local MAX_LEN = 64
local ns = vim.api.nvim_create_namespace('cursorword') -- 使用命名空间管理高亮

-- 高亮当前光标下的单词（支持打开的所有window）
local function matchadd()
    if vim.bo.filetype == "" then
        return
    end

    -- step1: 获取当前光标位置的单词
    local column = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local left = vim.fn.matchstr(line:sub(1, math.min(column + 1, #line)), [[\k*$]])
    local right = vim.fn.matchstr(line:sub(math.min(column + 1, #line)), [[^\k*]]):sub(2)
    local cursorword = left .. right

    -- step2: 如果单词没有变化，则不需要更新
    if cursorword == vim.g.cursorword_global then
        return
    end

    -- step3: 存储全局光标单词
    vim.g.cursorword_global = cursorword

    -- step4: 清理所有窗口旧高亮
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1) -- 清除命名空间高亮
        vim.fn.clearmatches(win)                         -- 清除窗口匹配项
    end

    -- step5: 如果单词为空，或者单词过长，或者包含非ASCII字符，则不需要更新
    if cursorword == "" or #cursorword > MAX_LEN or cursorword:find("[\192-\255]+") ~= nil then
        return
    end

    local pattern = [[\<]] .. cursorword .. [[\>]]

    -- 为所有窗口的对应缓冲区添加高亮
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)


        if vim.bo[buf].filetype ~= "" then
            -- 添加两种高亮（命名空间+matchadd双保险）
            vim.api.nvim_buf_add_highlight(
                buf, ns, "CursorWord",
                0, 0, -1
            )
            vim.fn.matchadd("CursorWord", pattern, -1, -1, { window = win })
        end
    end
end

-- 定义高亮组
vim.api.nvim_set_hl(0, "CursorWord", { underline = true })

-- 自动命令
vim.api.nvim_create_autocmd(
    { "CursorMoved", "CursorMovedI" },
    { callback = matchadd }
)

vim.api.nvim_create_autocmd(
    "VimEnter",
    { callback = matchadd }
)
