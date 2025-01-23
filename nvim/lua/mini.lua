-- 最小配置

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
        -- event = "User FileOpened",
        -- cmd = "Gitsigns",
        config = function()
            require("gitsigns").setup({
                signcolumn = false,
                diff_opts = {
                    vertical = true,
                },
            })
        end,
    },
})
