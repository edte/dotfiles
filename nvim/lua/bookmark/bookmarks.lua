local M = {
    storage_dir = "",

    data = {
        marks = {},
        bookmarks = {},                  -- filename description fre id line updated_at line_md5
        bookmarks_groupby_filename = {}, -- group bookmarks by filename
        pwd = nil,
        data_filename = nil,
        loaded_data = false,
        ns_id = {},
    },

    window = {
        hl = {
            border = "TelescopeBorder",            -- border highlight
            cursorline = "guibg=Gray guifg=White", -- cursorline highlight
        },
        border_chars = {
            TOP_LEFT = "╭",
            TOP_RIGHT = "╮",
            MID_HORIZONTAL = "─",
            MID_VERTICAL = "│",
            BOTTOM_LEFT = "╰",
            BOTTOM_RIGHT = "╯",
        },
        default_opts = {
            relative = "editor",
            width = 80,
            height = 40,
            row = 5,
            col = 10,
            title = "test-title",
            options = {},
            border = true,
        },
    }
}


------------------------------ window ------------------------------------

local function generate_unique_id()
    local time = os.time()
    local random = math.random(100000, 999999)
    return tostring(time) .. tostring(random)
end

-- 递归查找 .git 目录
local function get_root_dir()
    -- 递归查找 .git 目录
    local function find_git_root(path)
        local git_path = path .. "/.git"
        local stat = vim.uv.fs_stat(git_path)
        if stat and stat.type == "directory" then
            return path
        else
            local parent_path = vim.fn.fnamemodify(path, ":h")
            if parent_path == path then
                return nil
            end
            return find_git_root(parent_path)
        end
    end

    -- FIX: 这里有时候会为nil
    local cwd = vim.uv.cwd()
    local git_root = find_git_root(cwd)
    if git_root then
        return git_root
    else
        return cwd
    end
end

function M.createTopLine(str, width)
    local len
    if str == nil then
        len = 2
    else
        len = #str + 2
    end

    local returnString = ""
    if len ~= 2 then
        returnString = returnString
            .. string.rep(M.window.border_chars.MID_HORIZONTAL, math.floor(width / 2 - len / 2))
            .. " "
            .. str
            .. " "
        local remaining = width - (len + math.floor(width / 2 - len / 2))
        returnString = returnString .. string.rep(M.window.border_chars.MID_HORIZONTAL, remaining)
    else
        returnString = returnString .. string.rep(M.window.border_chars.MID_HORIZONTAL, width)
    end

    return M.window.border_chars.TOP_LEFT .. returnString .. M.window.border_chars.TOP_RIGHT
end

function M.fill_border_data(buf, width, height, title)
    local topLine = M.createTopLine(title, width)
    local border_lines = {
        topLine
    }

    local middle_line = M.window.border_chars.MID_VERTICAL
        .. string.rep(" ", width)
        .. M.window.border_chars.MID_VERTICAL
    for _ = 1, height do
        border_lines[#border_lines + 1] = middle_line
    end

    border_lines[#border_lines + 1] = M.window.border_chars.BOTTOM_LEFT ..
        string.rep(M.window.border_chars.MID_HORIZONTAL, width) .. M.window.border_chars.BOTTOM_RIGHT


    Api.nvim_buf_set_lines(buf, 0, -1, false, border_lines)
end

local function create_win(row, col, width, height, relative, focusable, zindex)
    local buf = Api.nvim_create_buf(false, true)
    local options = {
        style = "minimal",
        relative = relative,
        width = width,
        height = height,
        row = row,
        col = col,
        focusable = focusable,
        zindex = zindex,
    }
    local win = Api.nvim_open_win(buf, false, options)

    return {
        buf = buf,
        win = win,
    }
end

function M.create_win(opts)
    opts.width = opts.width or M.window.default_opts.width
    opts.height = opts.height or M.window.default_opts.height
    opts.title = opts.title or M.window.default_opts.title
    opts.row = opts.row or M.window.default_opts.row
    opts.col = opts.col or M.window.default_opts.col
    opts.relative = opts.relative or "editor"

    if opts.focusable == nil then
        opts.focusable = true
    end
    if opts.border == nil then
        opts.border = M.window.default_opts.border
    end

    -- buf
    local win_buf_pair = create_win(
        opts.row,
        opts.col,
        opts.width,
        opts.height,
        opts.relative,
        opts.focusable,
        256
    )

    return win_buf_pair
end

function M.create_border(opts)
    local border_win_buf_pair = create_win(opts.row - 1,
        opts.col - 1,
        opts.width + 2,
        opts.height + 2,
        opts.relative,
        false,
        255
    )

    opts.border_highlight = opts.border_highlight or "Normal"
    Api.nvim_buf_set_option(border_win_buf_pair.buf, "bufhidden", "hide")
    local border_buf = border_win_buf_pair.buf
    M.fill_border_data(
        border_buf,
        opts.width,
        opts.height,
        opts.title
    )

    Api.nvim_win_set_option(
        border_win_buf_pair.win,
        "winhighlight",
        "Normal:" .. opts.border_highlight
    )

    return border_win_buf_pair
end

local focus_manager = (function()
    --- @alias WinType string
    --- @alias WinId integer
    local current_type = nil --- @type WinType | nil
    local win_types = {}     --- @type WinType[]
    local wins = {}          --- @type table<WinType, WinId>

    local function toogle()
        local next_type = nil
        for i, type in ipairs(win_types) do
            if type == current_type then
                local next_i = i + 1
                if next_i > #win_types then next_i = 1 end
                next_type = win_types[next_i]
                break
            end
        end

        if next_type == nil then next_type = win_types[1] end

        local next_win = wins[next_type]
        if next_win == nil then
            local msg = string.format("%s window not found", next_type)
            return
        end

        current_type = next_type
        Api.nvim_set_current_win(next_win)
    end

    return {
        toogle = toogle,
        update_current = function(type) current_type = type end,
        set = function(type, win) wins[type] = win end,
        register = function(type)
            local exist = vim.tbl_contains(win_types, type)
            if not exist
            then
                win_types[#win_types + 1] = type
            end
        end,
    }
end)()


function M.open_add_win(title)
    local ew = Api.nvim_get_option("columns")
    local eh = Api.nvim_get_option("lines")
    local width, height = 100, 1
    local options = {
        width = width,
        height = height,
        title = title,
        row = math.floor((eh - height) / 2),
        col = math.floor((ew - width) / 2),
        relative = "editor",
        border_highlight = M.window.hl.border,
    }

    local pairs = M.create_win(options)
    local border_pairs = M.create_border(options)
    Api.nvim_set_current_win(pairs.win)
    Api.nvim_win_set_option(pairs.win, 'winhighlight', 'Normal:normal')
    Api.nvim_buf_set_option(pairs.buf, 'filetype', 'bookmarks_input')
    cmd("startinsert")

    return {
        pairs = pairs,
        border_pairs = border_pairs
    }
end

function M.close_add_win(buf1, buf2)
    cmd(string.format("bwipeout! %d", buf1))
    cmd(string.format("bwipeout! %d", buf2))
end

------------------------------------bookmark ------------------------------------------

-- Add virtural text for bookmarks.
function M.set_marks(buf, marks)
    local file_name = Api.nvim_buf_get_name(buf)
    if M.data.marks[file_name] == nil then
        M.data.marks[file_name] = {}
    end

    -- 这段代码的作用是遍历 M.marks[file_name] 表中的所有扩展标记 ID，并使用 nvim_buf_del_extmark 函数删除这些扩展标记。让我们逐步解析这段代码：
    -- clear old ext
    for _, id in ipairs(M.data.marks[file_name]) do
        Api.nvim_buf_del_extmark(buf, M.data.ns_id, id)
    end

    vim.fn.sign_unplace("BookmarkSign", { buffer = buf })

    -- set new old ext
    for _, mark in ipairs(marks) do
        -- 如果书签行号超过文件总行数，跳过该书签。
        if mark.line > vim.fn.line("$") then
            goto continue
        end

        -- 使用 api.nvim_buf_set_extmark 设置扩展标记，位置在行末（virt_text_pos = "eol"），并且使用指定的高亮组。
        local ext_id = Api.nvim_buf_set_extmark(buf, M.data.ns_id, mark.line - 1, -1, {
            virt_text = { { '💡 ' .. mark.description, "bookmarks_virt_text_hl" } },
            virt_text_pos = "eol",
            hl_group = "bookmarks_virt_text_hl",
            hl_mode = "combine"
        })

        -- #M.data.marks[file_name] 返回 M.data.marks[file_name] 表的当前长度（即其中元素的数量）
        -- M.data.marks[file_name][#M.data.marks[file_name] + 1]：
        -- 这表示在 M.data.marks[file_name] 表的末尾添加一个新元素。
        -- 因为表的长度是 #M.data.marks[file_name]，所以新元素的位置是 #M.data.marks[file_name] + 1。
        -- 记录扩展标记的 ID。
        M.data.marks[file_name][#M.data.marks[file_name] + 1] = ext_id

        -- 使用 vim.fn.sign_place 在书签行位置放置标记。
        vim.fn.sign_place(0, "BookmarkSign", "BookmarkSign", buf, {
            lnum = mark.line,
        })

        M.data.bookmarks[mark.id].extmark_id = ext_id
        M.data.bookmarks[mark.id].buf_id = buf

        ::continue::
    end
end

-- 这个函数用于获取指定缓冲区中的所有书签行信息。
function M.get_buf_bookmark_lines(buf)
    local filename = Api.nvim_buf_get_name(buf)
    local lines = {}
    local group = M.data.bookmarks_groupby_filename[filename]

    if group == nil then
        return lines
    end

    local tmp = {}
    for _, each in pairs(group) do
        if M.data.bookmarks[each] ~= nil and tmp[M.data.bookmarks[each].line] == nil then
            lines[#lines + 1] = M.data.bookmarks[each]
            tmp[M.data.bookmarks[each].line] = true
        end
    end


    return lines
end

function M.add_bookmark()
    function M.handle_add(line, buf1, buf2, buf, rows)
        -- Get buf's filename.
        local filename = Api.nvim_buf_get_name(buf)
        if filename == nil or filename == "" then
            return
        end

        local input_line = vim.fn.line(".")

        -- Get bookmark's description.
        local description = Api.nvim_buf_get_lines(buf1, input_line - 1, input_line, false)[1] or ""

        -- Close description input box.
        if description == "" then
            M.close_add_win(buf1, buf2)
            M.set_marks(buf, M.get_buf_bookmark_lines(0))
            cmd("stopinsert")
            return
        end

        -- Save bookmark with description.
        -- Save bookmark as lua code.
        -- rows is the file's number..

        local id = generate_unique_id()
        local now = os.time()

        if M.data.bookmarks[id] ~= nil then --update description
            if description ~= nil then
                M.data.bookmarks[id].description = description
                M.data.bookmarks[id].updated_at = now
            end
        else -- new
            M.data.bookmarks[id] = {
                id = id,
                filename = filename,
                line = line,
                rows = rows, -- for fix
                description = description or "",
                updated_at = now,
                is_new = true,
            }

            if M.data.bookmarks_groupby_filename[filename] == nil then
                M.data.bookmarks_groupby_filename[filename] = { id }
            else
                M.data.bookmarks_groupby_filename[filename][#M.data.bookmarks_groupby_filename[filename] + 1] = id
            end
        end

        -- Close description input box.
        M.close_add_win(buf1, buf2)
        M.set_marks(buf, M.get_buf_bookmark_lines(0))
        cmd("stopinsert")
    end

    local line = vim.fn.line('.')
    local buf = Api.nvim_get_current_buf()
    local rows = vim.fn.line("$")

    --  Open the bookmark description input box.
    local title = "Input description:"
    local bufs_pairs = M.open_add_win(title)

    -- Press the esc key to cancel add bookmark.
    vim.keymap.set("n", "<ESC>",
        function() M.close_add_win(bufs_pairs.pairs.buf, bufs_pairs.border_pairs.buf) end,
        { desc = "bookmarks close add win", silent = true, buffer = bufs_pairs.pairs.buf }
    )

    -- Press the enter key to confirm add bookmark.
    vim.keymap.set("i", "<CR>",
        function() M.handle_add(line, bufs_pairs.pairs.buf, bufs_pairs.border_pairs.buf, buf, rows) end,
        { desc = "bookmarks confirm bookmarks", silent = true, noremap = true, buffer = bufs_pairs.pairs.buf }
    )
end

-- Delete bookmark.
function M.delete_bookmark()
    local line = vim.fn.line(".")
    local file_name = Api.nvim_buf_get_name(0)
    local buf = Api.nvim_get_current_buf()
    for k, v in pairs(M.data.bookmarks) do
        if v.line == line and file_name == v.filename then
            M.data.bookmarks[k] = nil
            M.set_marks(buf, M.get_buf_bookmark_lines(0))
            return
        end
    end
end

function M.jump_bookmark()
    local bookmarks = M.data.bookmarks

    local list = {}
    for _, bookmark in pairs(bookmarks) do
        list[#list + 1] = bookmark.description
    end


    local fzf = require("fzf-lua")
    fzf.fzf_exec(list, {
        prompt = "Bookmarks> ",
        previewer = function()
            local previewer = require("fzf-lua.previewer.builtin")
            local path = require("fzf-lua.path")

            -- https://github.com/ibhagwan/fzf-lua/wiki/Advanced#neovim-builtin-preview
            -- Can this be any simpler? Do I need a custom previewer?
            local MyPreviewer = previewer.buffer_or_file:extend()

            function MyPreviewer:new(o, op, fzf_win)
                MyPreviewer.super.new(self, o, op, fzf_win)
                setmetatable(self, MyPreviewer)
                return self
            end

            function MyPreviewer:parse_entry(entry_str)
                if entry_str == "" then
                    return {}
                end
                for _, bookmark in pairs(bookmarks) do
                    if entry_str == bookmark.description then
                        local entry = path.entry_to_file(bookmark.filename .. ":" .. bookmark.line, self.opts)
                        return entry or {}
                    end
                end
            end

            return MyPreviewer
        end,
        actions = {
            ["default"] = function(selected)
                local entry = selected[1]
                if not entry then
                    return
                end

                for _, bookmark in pairs(bookmarks) do
                    if entry == bookmark.description then
                        Api.nvim_command("edit " .. bookmark.filename)
                        Api.nvim_win_set_cursor(0, { bookmark.line, 0 })
                        zz()
                    end
                end
            end,
        },
    })
end

-- 写入书签到磁盘文件，下次加载时使用
function M.save_bookmarks()
    local local_str = ""
    for id, bookmark in pairs(M.data.bookmarks) do
        local tpl = [[
{
	_
}
]]

        if bookmark["extmark_id"] ~= nil then
            local extmark_pos

            -- 先检查缓冲区是否有效
            if Api.nvim_buf_is_valid(bookmark.buf_id) then
                extmark_pos = Api.nvim_buf_get_extmark_by_id(bookmark.buf_id, M.data.ns_id, bookmark.extmark_id, {})
            else
                log.error("Bookmark '" .. id .. "' is no longer valid.")
            end

            -- 检查 extmark 是否有效
            if not extmark_pos or #extmark_pos == 0 then
                log.debug("Bookmark '" .. id .. "' is no longer valid.")
                goto continue
            end

            M.data.bookmarks[id].line = extmark_pos[1] + 1
            M.data.bookmarks[id].rows = extmark_pos[2]
        end


        ::continue::

        local sub = "    "
        for k, v in pairs(bookmark) do
            if k ~= "is_new" and k ~= "extmark_id" and k ~= "buf_id" then
                if sub ~= "" then
                    sub = string.format("%s\n%s", sub, string.rep(" ", 4))
                end
                sub = sub .. "    "
                if type(v) == "number" or type(v) == "boolean" then
                    sub = sub .. string.format("%s = %s,", k, v)
                else
                    sub = sub .. string.format("%s = \"%s\",", k, v)
                end
            end
        end

        local subs = string.gsub(tpl, "_", sub)
        local_str = string.format("%s%s", local_str, subs)
    end


    if M.data.data_filename == nil then -- lazy load,
        return
    end

    if local_str == "" then
        if vim.loop.fs_stat(M.data.data_filename) then
            os.remove(M.data.data_filename)
        end
        return
    end

    -- 1.local bookmarks
    local local_fd = assert(io.open(M.data.data_filename, "w"))
    local_fd:write(local_str)
    local_fd:close()
end

-- 从磁盘文件恢复书签
function M.load_bookmarks()
    M.storage_dir = NEOVIM_BOOKMARKS_DATA

    if not vim.loop.fs_stat(M.storage_dir) then
        assert(os.execute("mkdir " .. M.storage_dir))
    end

    -- 当前项目目录
    local currentPath = string.gsub(get_root_dir(), "/", "_")
    if M.data.pwd ~= nil and currentPath ~= M.data.pwd then -- maybe change session
        M.save_bookmarks()
        M.data.bookmarks = {}
        M.data.loaded_data = false
    end


    if M.data.loaded_data == true then
        return
    end


    -- 基础目录+当前项目目录
    -- local bookmarks
    local data_filename = string.format("%s%s%s", M.storage_dir, "/", currentPath):gsub("%c", "")
    M.data.data_filename = data_filename
    M.data.pwd = currentPath
    M.data.loaded_data = true -- mark

    local file = io.open(data_filename, "r")
    if not file then
        return
    end

    local content = file:read("*all")
    file:close()


    for table_str in content:gmatch("{(.-)}") do
        local item = {}
        for key, value in table_str:gmatch('(%w+)%s*=%s*"?(.-)"?,?%s*\n') do
            if tonumber(value) then
                value = tonumber(value)
            elseif value == "true" then
                value = true
            elseif value == "false" then
                value = false
            end
            item[key] = value
        end

        M.data.bookmarks[item.id] = item

        if M.data.bookmarks_groupby_filename[item.filename] == nil then
            M.data.bookmarks_groupby_filename[item.filename] = {}
        end
        M.data.bookmarks_groupby_filename[item.filename][#M.data.bookmarks_groupby_filename[item.filename] + 1] = item
            .id
    end
end

function M.setup()
    M.data.ns_id = Api.nvim_create_namespace("bookmarks_marks")

    cmd("hi link bookmarks_virt_text_hl Comment")
    vim.fn.sign_define("BookmarkSign", { text = "󰃃" })

    cmd(string.format("highlight hl_bookmarks_csl %s", M.window.hl.cursorline))
    focus_manager.register("bookmarks")

    vim.keymap.set("n", "mo", function() M.jump_bookmark() end,
        { desc = "bookmarks jump", silent = true })

    -- add local bookmarks
    vim.keymap.set("n", "mm", function() M.add_bookmark() end,
        { desc = "bookmarks add", silent = true })

    local group_id = GroupId("bookmark_group", { clear = true })

    Autocmd({ "VimLeave", "BufWrite" }, {
        group = group_id,
        callback = M.save_bookmarks
    })

    Autocmd({ "BufWritePost" }, {
        group = group_id,
        callback = function()
            local buf = Api.nvim_get_current_buf()
            M.set_marks(buf, M.get_buf_bookmark_lines(buf))
        end
    })

    Autocmd({ "BufWinEnter" }, {
        group = group_id,
        callback = function()
            local buf = Api.nvim_get_current_buf()
            M.set_marks(buf, M.get_buf_bookmark_lines(buf))
        end
    })


    M.load_bookmarks()
end

return M
