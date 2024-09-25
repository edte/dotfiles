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
        "edte/bookmarks.nvim",
        -- keys = { "mm", "mo", "mD" },
        branch = "main",
        dependencies = {
            "nvim-web-devicons",
        },
        init = function()
            keymap("n", "mm", function()
                print("test")
                require 'bookmarks'.add_bookmarks(false)
            end)
            keymap("n", "mo", "<cmd>lua require'bookmarks'.list_bookmarks_fzflua()<cr>")
            keymap("n", "mD", "<cmd>lua require'bookmarks.list'.delete_on_virt()<cr>")
        end,
        config = function()
            require("bookmarks").setup({
                storage_dir = "",        -- Default path: vim.fn.stdpath("data").."/bookmarks,  if not the default directory, should be absolute path",
                mappings_enabled = true, -- If the value is false, only valid for global keymaps: toggle、add、delete_on_virt、show_desc
                keymap = {
                    toggle = " mt",      -- Toggle bookmarks(global keymap)
                    close = "<esc>",     -- close bookmarks (buf keymap)
                },
                fix_enable = true,
                fzflua = false,
            })
        end,
    },



})
