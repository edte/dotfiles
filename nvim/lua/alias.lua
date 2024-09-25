-- 各种常用函数的别名

-- 使用 pcall 和 require 尝试加载包
function try_require(package_name)
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
        print("Error loading package " .. package_name .. ": " .. package)
        return
    end

    -- 检查包是否具有 'setup' 函数
    if type(package.setup) ~= "function" then
        print("Error: package " .. package_name .. " does not have a 'setup' function")
        return
    end

    -- 调用包的 'setup' 函数进行设置
    package.setup(options)
end

local opt = {
    noremap = true,
    silent = true,
}

function keymap(mode, lhs, rhs)
    if type(rhs) == "string" then
        vim.api.nvim_set_keymap(mode, lhs, rhs, opt)
        return
    end

    vim.keymap.set(mode, lhs, rhs, opt)
end

Command = vim.api.nvim_create_user_command

cmd = vim.cmd

Autocmd = vim.api.nvim_create_autocmd
GroupId = vim.api.nvim_create_augroup

Del_cmd = vim.api.nvim_del_user_command

user_config_path = vim.call("stdpath", "config")
user_config_init = vim.call("stdpath", "config") .. "/init.lua"

icon = require("icons")

function isModuleAvailable(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == "function" then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

function ToggleMiniFiles()
    local mf = require("mini.files")
    if not mf.close() then
        mf.open(vim.api.nvim_buf_get_name(0))
        mf.reveal_cwd()
    end
end

get_listed_bufs = function()
    return vim.tbl_filter(function(bufnr)
        return vim.api.nvim_buf_get_option(bufnr, "buflisted")
    end, vim.api.nvim_list_bufs())
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
