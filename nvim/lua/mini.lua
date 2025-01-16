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
        "gbprod/yanky.nvim",
        dependencies = {
            { "kkharji/sqlite.lua" }
        },
        opts = {
            ring = { storage = "sqlite" },
        },
        keys = {
            { "y", "<Plug>(YankyYank)",      mode = { "n", "x" }, desc = "Yank text" },
            { "p", "<Plug>(YankyPutAfter)",  mode = { "n", "x" }, desc = "Put yanked text after cursor" },
            { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
        },
    }
})
