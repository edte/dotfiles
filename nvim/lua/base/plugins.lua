local M = {}

M.list = {
    -- TODO: 这里 gf 跳对应文件的目录时，要全屏
    -- Neovim 的现代插件管理器
    -- https://github.com/folke/lazy.nvim
    -- https://lazy.folke.io/spec
    {
        "folke/lazy.nvim",
        tag = "v11.14.1",
    },
    -- 管理cwd
    {
        name = "cwd",
        dir = "base.cwd",
        config = function()
            require("base.cwd").setup()
        end,
    },
}

return M
