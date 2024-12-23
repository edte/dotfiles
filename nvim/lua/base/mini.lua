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
        'echasnovski/mini.sessions',
        event = { "VimEnter", "VimLeavePre" },
        config = function()
            require('mini.sessions').setup({
                -- Whether to read default session if Neovim opened without file arguments
                autoread = true,

                -- Whether to write currently read session before quitting Neovim
                autowrite = true,

                -- Directory where global sessions are stored (use `''` to disable)
                -- directory = --<"session" subdir of user data directory from |stdpath()|>,

                -- File for local session (use `''` to disable)
                file = 'Session.vim',

                -- Whether to force possibly harmful actions (meaning depends on function)
                force = { read = true, write = true, delete = true },

                -- Hook functions for actions. Default `nil` means 'do nothing'.
                hooks = {
                    -- Before successful action
                    pre = { read = nil, write = nil, delete = nil },
                    -- After successful action
                    post = { read = nil, write = nil, delete = nil },
                },

                -- Whether to print session path after action
                verbose = { read = true, write = true, delete = true },
            })
        end
    },
})
