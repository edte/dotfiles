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
        "neovim/nvim-lspconfig",
        config = function()
            require("lspconfig").gopls.setup({})
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
    },

    {
        "saghen/blink.cmp",
        dependencies = {
            "edte/blink-go-import.nvim",
            ft = "go",
            config = function()
                require("blink-go-import").setup()
            end
        },
        opts = {
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer', "go_pkgs", },
                providers = {
                    go_pkgs = {
                        module = "blink-go-import",
                        name = "Import",
                    }
                }
            }
        }
    }
})
