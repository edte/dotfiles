-- utils alias

------------------------------------------------- var --------------------------------------------------
_G.NEOVIM_CONFIG_PATH = vim.fn.stdpath('config')
_G.NEOVIM_SESSION_DATA = vim.fn.stdpath('data') .. '/session'
_G.NEOVIM_BOOKMARKS_DATA = vim.fn.stdpath("data") .. "/bookmarks"
_G.NEOVIM_LAZY_DATA = vim.fn.stdpath("data") .. "/lazy"
_G.NEOVIM_UNDO_DATA = vim.fn.stdpath("state") .. "/undo"
_G.NEOVIM_SWAP_DATA = vim.fn.stdpath("state") .. "/swap"
_G.NEOVIM_BACKUP_DATA = vim.fn.stdpath("state") .. "/backup"

_G.log = require("utils.log")
_G.json = require "utils.json"
_G.Api = vim.api
_G.Command = vim.api.nvim_create_user_command
_G.Cmd = vim.cmd
_G.Autocmd = vim.api.nvim_create_autocmd
_G.GroupId = vim.api.nvim_create_augroup
_G.Del_cmd = vim.api.nvim_del_user_command
_G.icon = require("utils.icons")
_G.icons = require("utils.icons")

_G.project_files = function()
    local ret = vim.fn.system("git rev-parse --show-toplevel 2> /dev/null")
    if ret == "" then
        require("fzf-lua").files()
    else
        require("fzf-lua").git_files()
    end
end

_G.compare_to_clipboard = function()
    local ftype = Api.nvim_eval("&filetype")
    Cmd(string.format(
        [[
  execute "normal! \"xy"
  vsplit
  enew
  normal! P
  setlocal buftype=nowrite
  set filetype=%s
  diffthis
  execute "normal! \<C-w>\<C-w>"
  enew
  set filetype=%s
  normal! "xP
  diffthis
  ]],
        ftype,
        ftype
    ))
end

-- 使用 pcall 和 require 尝试加载包
function Require(package_name)
    local status, plugin = pcall(require, package_name)
    if not status then
        -- 如果加载失败，打印错误信息
        print("require " .. plugin)
        return nil
    else
        -- 如果加载成功，返回包
        return plugin
    end
end

function Setup(package_name, options)
    -- 尝试加载包，捕获加载过程中的错误
    local success, package = pcall(require, package_name)

    if not success then
        -- 如果加载失败，打印错误信息
        vim.notify("Error loading package " .. package_name .. ": " .. package, vim.log.levels.ERROR)
        return
    end

    -- 检查包是否具有 'setup' 函数
    if type(package.setup) ~= "function" then
        vim.notify("Error: package " .. package_name .. " does not have a 'setup' function", vim.log.levels.ERROR)
        return
    end

    -- 调用包的 'setup' 函数进行设置
    package.setup(options)
end

function Keymap(mode, lhs, rhs)
    if type(rhs) == "string" then
        Api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true, })
        return
    end

    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, })
end

function ToggleMiniFiles()
    local mf = require("mini.files")
    if not mf.close() then
        mf.open(Api.nvim_buf_get_name(0))
        mf.reveal_cwd()
    end
end

---
-- @function: 打印table的内容，递归
-- @param: tbl 要打印的table
-- @param: level 递归的层数，默认不用传值进来
-- @param: filteDefault 是否过滤打印构造函数，默认为是
-- @return: return
function Print(tbl, level, filteDefault)
    if type(tbl) ~= "table" then
        print(tbl)
        return
    end

    if tbl == nil then
        return
    end

    local msg = ""
    filteDefault = filteDefault or true --默认过滤关键字（DeleteMe, _class_type）
    level = level or 1
    local indent_str = ""
    for i = 1, level do
        indent_str = indent_str .. "  "
    end

    print(indent_str .. "{")
    for k, v in pairs(tbl) do
        if filteDefault then
            if k ~= "_class_type" and k ~= "DeleteMe" then
                local item_str = string.format("%s%s = %s", indent_str .. " ", tostring(k), tostring(v))
                print(item_str)
                if type(v) == "table" then
                    Print(v, level + 1)
                end
            end
        else
            local item_str = string.format("%s%s = %s", indent_str .. " ", tostring(k), tostring(v))
            print(item_str)
            if type(v) == "table" then
                Print(v, level + 1)
            end
        end
    end
    print(indent_str .. "}")
end

function Json(tbl, level, filteDefault)
    local s = ""

    if type(tbl) ~= "table" then
        s = s .. json.encode(tbl)
        return
    end

    if tbl == nil then
        return
    end

    local msg = ""
    filteDefault = filteDefault or true --默认过滤关键字（DeleteMe, _class_type）
    level = level or 1
    local indent_str = ""
    for i = 1, level do
        indent_str = indent_str .. "  "
    end

    s = s .. indent_str .. "{"
    for k, v in pairs(tbl) do
        if filteDefault then
            if k ~= "_class_type" and k ~= "DeleteMe" then
                local item_str = string.format("%s%s = %s", indent_str .. " ", tostring(k), tostring(v))
                s = s .. item_str
                if type(v) == "table" then
                    Json(v, level + 1)
                end
            end
        else
            local item_str = string.format("%s%s = %s", indent_str .. " ", tostring(k), tostring(v))
            s = s .. item_str
            if type(v) == "table" then
                Json(v, level + 1)
            end
        end
    end
    s = s .. indent_str .. "}"
end

--  字符串扩展方法 split_b，用于将字符串按照指定的分隔符 sep 进行分割，并返回一个包含切割结果的表
function string:split_b(sep)
    local cuts = {}
    for v in string.gmatch(self, "[^'" .. sep .. "']+") do
        cuts[#cuts + 1] = v
    end

    return cuts
end

-- 递归查找 .git 目录
function get_root_dir()
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
        -- print(git_root)
        return git_root
    else
        -- print(cwd)
        return cwd
    end
end

function generate_unique_id()
    local time = os.time()
    local random = math.random(100000, 999999)
    return tostring(time) .. tostring(random)
end

function tprint(tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint .. k .. "= "
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent - 2) .. "}"
    return toprint
end

function file_exists(name)
    local f = io.open(name, "r")
    return f ~= nil and io.close(f)
end

function GetPath()
    local dir, _ = vim.fn.getcwd():gsub('/', '_')
    return dir
end

_G.get_function_arguments = function()
    -- Create the params for the LSP request
    local params = vim.lsp.util.make_position_params()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    -- Debugging information
    print("Cursor position: row =", row, "col =", col)
    print("Initial params: ", vim.inspect(params))
    -- Adjust the position if the cursor is at the beginning of the line
    if col == 0 then
        params.position.character = 1
    end
    -- Debugging information
    print("Adjusted params: ", vim.inspect(params))
    -- -- Ensure the LSP client is attached
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        print("No LSP client attached")
        return
    else
        print("LSP client attached")
    end
    -- -- Check if the client supports signatureHelp
    local client = clients[1]
    if not client.server_capabilities.signatureHelpProvider then
        print("LSP server does not support signatureHelp")
        return
    else
        print("LSP server supports signatureHelp")
    end
    -- Send the LSP request
    local result = vim.lsp.buf_request_sync(0, "textDocument/signatureHelp", params, 10000)
    print("Result: ", vim.inspect(result))
end

function utf8len(input)
    local len  = string.len(input)                   --这里获取到的长度为字节数，如示例长度为：21，而我们肉眼看到的长度应该是15（包含空格）
    local left = len                                 --将字节长度赋值给将要使用的变量，作为判断退出while循环的字节长度
    local cnt  = 0                                   --将要返回的字符长度
    local arr  = { 0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc } --用来判断是否满足字节长度的列表
    while left ~= 0 do                               --遍历每一个字符
        --获取字节的ASCII值，这里的 “-” 代表反向对应的索引，-left：input反着第left
        --假设字符串字符input长度是：21，left的值是：21，那string.byte(input, -left)就是第一个字节的ASCII值
        local tmp = string.byte(input, -left) --看上面两行
        local i   = #arr                      --获取判断列表的长度，同时作为字节长度
        while arr[i] do                       --循环判定列表
            if tmp >= arr[i] then             --判定当前 “字符” 的 头“字节” ACSII值符合的范围
                left = left - i               --字符串字节长度 -i，也就是 减去字节长度
                break                         --结束判断
            end
            i = i - 1                         --每次判断失败都说明不符合当前字节长度
        end
        cnt = cnt + 1                         --“字符” 长度+1
    end
    return cnt                                --返回 “字符” 长度
end

function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function string.ends(String, End)
    return End == '' or string.sub(String, -string.len(End)) == End
end
