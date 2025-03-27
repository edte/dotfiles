local requires = {
    -- 最小配置，用于测试
    -- "mini",

    -- 常用配置
    "alias",
    "options",
    "autocmds",
    "commands",
    "keymaps",
    "cwd",
    "lazys",
}

for _, r in ipairs(requires) do
    require(r)
end

vim.lsp.enable({ "gopls" })
