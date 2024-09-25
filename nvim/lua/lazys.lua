-- lazy.nvim 插件管理器安装
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- 组装插件列表

local modules = {
    "base.plugins",
    "ui.plugins",
    "bookmark.plugins",
    "vim.plugins",
    "text.plugins",
    "cmp.plugins",
    "lsp.plugins",
    "git.plugins",
    "components.plugins",
}

local plugins_list = {}

-- 遍历每个模块
for _, module_name in ipairs(modules) do
    local module = try_require(module_name)
    if module == nil then
        return
    end
    -- 遍历模块中的每个插件
    for _, plugin in ipairs(module.list) do
        table.insert(plugins_list, plugin)
    end
end

-- 开发安装插件
require("lazy").setup({
    -- 导入你的插件
    spec = plugins_list,
    -- -- 在此配置任何其他设置。请参阅文档了解更多详细信息。
    -- 安装插件时将使用的颜色方案。
    install = { colorscheme = { "tokyonight" } },
    --自动检查插件更新
    -- checker = { enabled = true },
})
