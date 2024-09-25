local a = vim.api

local Mark = {
    -- 基本结构：self.buffers是一个以bufnr索引的表数组，其中每个表有以下键：
    -- placed_marks：缓冲区中当前放置/注册标记的表。按标记名称索引，包含有关标记位置和标记 ID 的信息。
    -- marks_by_line：带有标记的行表。按行号索引，并包含当前在该行上设置的所有标记的数组。
    -- lower_available_mark：可用的下一个最低字母标记。
    buffers = {},
    opt = {
        priority = { 10, 10, 10 },
    },
    builtin_marks = {},

    sign_cache = {},

    builtin_marks_cache = {
        ["."] = true,
        ["^"] = true,
        ["`"] = true,
        ["'"] = true,
        ['"'] = true,
        ["<"] = true,
        [">"] = true,
        ["["] = true,
        ["]"] = true,
        ["0"] = true,
        ["1"] = true,
        ["2"] = true,
        ["3"] = true,
        ["4"] = true,
        ["5"] = true,
        ["6"] = true,
        ["7"] = true,
        ["8"] = true,
        ["9"] = true,
    },

}


function Mark:register_mark(mark, line, col, bufnr)
    col = col or 1
    bufnr = bufnr or a.nvim_get_current_buf()
    local buffer = self.buffers[bufnr]

    if not buffer then
        return
    end

    if buffer.placed_marks[mark] then
        -- mark already exists: remove it first
        self:delete_mark(mark, false)
    end

    if buffer.marks_by_line[line] then
        table.insert(buffer.marks_by_line[line], mark)
    else
        buffer.marks_by_line[line] = { mark }
    end
    buffer.placed_marks[mark] = { line = line, col = col, id = -1 }

    local id = mark:byte() * 100
    buffer.placed_marks[mark].id = id

    -- add sign
    local sign_name = "Marks_" .. mark
    if not Mark.sign_cache[sign_name] then
        Mark.sign_cache[sign_name] = true
        vim.fn.sign_define(sign_name, {
            text = mark,
            texthl = "Identifier",
        })
    end
    vim.fn.sign_place(id, "MarkSigns", sign_name, bufnr, { lnum = line, priority = 10 })

    --
    if not Mark.is_lower(mark) or
        mark:byte() > buffer.lowest_available_mark:byte() then
        return
    end

    while self.buffers[bufnr].placed_marks[mark] do
        mark = string.char(mark:byte() + 1)
    end
    self.buffers[bufnr].lowest_available_mark = mark
end

function Mark:place_mark_cursor()
    local err, mark = pcall(function()
        return string.char(vim.fn.getchar())
    end)
    if not err then
        return
    end

    if Mark.is_valid_mark(mark) then
        local bufnr = a.nvim_get_current_buf()

        local pos = a.nvim_win_get_cursor(0)
        Mark:register_mark(mark, pos[1], pos[2], bufnr)
        vim.cmd("normal! m" .. mark)
    end

    vim.cmd("normal! m" .. mark)
end

function Mark:delete_mark(mark, clear)
    if clear == nil then
        clear = true
    end
    local bufnr = a.nvim_get_current_buf()
    local buffer = self.buffers[bufnr]

    if (not buffer) or (not buffer.placed_marks[mark]) then
        return
    end

    if buffer.placed_marks[mark].id ~= -1 then
        vim.fn.sign_unplace("MarkSigns", { buffer = bufnr, id = buffer.placed_marks[mark].id })
    end

    local line = buffer.placed_marks[mark].line
    for key, tmp_mark in pairs(buffer.marks_by_line[line]) do
        if tmp_mark == mark then
            buffer.marks_by_line[line][key] = nil
            break
        end
    end

    if vim.tbl_isempty(buffer.marks_by_line[line]) then
        buffer.marks_by_line[line] = nil
    end

    buffer.placed_marks[mark] = nil

    if clear then
        vim.cmd("delmark " .. mark)
    end


    -- only adjust lowest_available_mark if it is lowercase
    if not Mark.is_lower(mark) then
        return
    end

    if mark:byte() < buffer.lowest_available_mark:byte() then
        buffer.lowest_available_mark = mark
    end
end

function Mark:delete_line_marks()
    local bufnr = a.nvim_get_current_buf()
    local pos = a.nvim_win_get_cursor(0)

    if not Mark.buffers[bufnr].marks_by_line[pos[1]] then
        return
    end

    -- delete_mark modifies the table, so make a copy
    local copy = vim.tbl_values(Mark.buffers[bufnr].marks_by_line[pos[1]])
    for _, mark in pairs(copy) do
        Mark:delete_mark(mark)
    end
end

function Mark:refresh(force)
    force = force or false
    local bufnr = a.nvim_get_current_buf()

    if not Mark.buffers[bufnr] then
        Mark.buffers[bufnr] = {
            placed_marks = {},
            marks_by_line = {},
            lowest_available_mark = "a"
        }
    end

    -- first, remove all marks that were deleted
    for mark, _ in pairs(Mark.buffers[bufnr].placed_marks) do
        if a.nvim_buf_get_mark(bufnr, mark)[1] == 0 then
            Mark.delete_mark(mark, false)
        end
    end

    local mark
    local pos
    local cached_mark

    -- uppercase marks
    for _, data in ipairs(vim.fn.getmarklist()) do
        mark = data.mark:sub(2, 3)
        pos = data.pos
        cached_mark = Mark.buffers[bufnr].placed_marks[mark]

        if Mark.is_upper(mark) and pos[1] == bufnr and (force or not cached_mark or
                pos[2] ~= cached_mark.line) then
            Mark:register_mark(mark, pos[2], pos[3], bufnr)
        end
    end

    -- lowercase
    for _, data in ipairs(vim.fn.getmarklist("%")) do
        mark = data.mark:sub(2, 3)
        pos = data.pos
        cached_mark = Mark.buffers[bufnr].placed_marks[mark]

        if Mark.is_lower(mark) and (force or not cached_mark or
                pos[2] ~= cached_mark.line) then
            Mark:register_mark(mark, pos[2], pos[3], bufnr)
        end
    end

    -- builtin marks
    for _, char in pairs(Mark.builtin_marks) do
        pos = vim.fn.getpos("'" .. char)
        cached_mark = Mark.buffers[bufnr].placed_marks[char]
        -- check:
        -- mark located in current buffer? (0-9 marks return absolute bufnr instead of 0)
        -- valid (lnum != 0)
        -- force is true, or first time seeing mark, or mark line position has changed
        if (pos[1] == 0 or pos[1] == bufnr) and pos[2] ~= 0 and
            (force or not cached_mark or
                pos[2] ~= cached_mark.line) then
            Mark:register_mark(char, pos[2], pos[3], bufnr)
        end
    end
end

function Mark.is_valid_mark(char)
    return Mark.is_letter(char) or Mark.builtin_marks[char]
end

function Mark.is_letter(char)
    return Mark.is_upper(char) or Mark.is_lower(char)
end

function Mark.is_upper(char)
    return (65 <= char:byte() and char:byte() <= 90)
end

function Mark.is_lower(char)
    return (97 <= char:byte() and char:byte() <= 122)
end

function Mark.setup()
    -- 设置快捷键
    -- keymap("n", "m", Mark.place_mark_cursor)
    keymap("n", "md", Mark.delete_line_marks)

    local augroup = GroupId("Marks_autocmds", { clear = true })

    -- 当一个缓冲区被打开时，刷新与该缓冲区相关的标记数据
    Autocmd("BufEnter", {
        group = augroup,
        pattern = "*",
        callback = function()
            Mark.refresh(true)
        end,
    })

    -- 当一个缓冲区被删除时，清理与该缓冲区相关的标记数据。
    Autocmd("BufDelete", {
        group = augroup,
        pattern = "*",
        callback = function()
            local bufnr = tonumber(vim.fn.expand("<abuf>"))
            if not bufnr then
                return
            end
            Mark.buffers[bufnr] = nil
        end,
    })

    -- 定时刷新标记数据
    vim.loop.new_timer():start(0, 150, vim.schedule_wrap(Mark.refresh))
end

return Mark
