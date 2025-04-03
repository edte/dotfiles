-- 最小配置
vim.opt.foldcolumn = "1"
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.foldmethod = 'expr'
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldexpr = 'v:lua.vim.lsp.foldexpr()'
vim.opt.foldtext = ""

vim.o.sessionoptions = vim.o.sessionoptions:gsub('args', '')

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

})
