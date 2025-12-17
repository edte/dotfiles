local M = {}

M.list = {

    {
		"folke/tokyonight.nvim",
		lazy = true,
		opts = { style = "moon" },
	},


    -- 上方的tab栏
    {
        name = "tabline",
        dir = "ui.tabline",
        virtual = true,
        config = function()
            require("ui.tabline").setup()
        end,
    },


    -- 下方的状态栏
    {
        name = "statusline",
        dir = "ui.statusline",
        virtual = true,
        config = function()
            require("ui.statusline")
        end,
    },




    -- wilder.nvim 插件，用于命令行补全，和 noice.nvim 冲突
    {
        "gelguy/wilder.nvim",
        event = "CmdlineEnter", -- 懒加载：首次进入cmdline时载入
        config = function()
            Require("ui.wilder").config()
        end,
    },

    -- buffer 管理文件与目录树的结合
    {
        "echasnovski/mini.files",
        version = false,
        opts = {
            options = {
                use_as_default_explorer = false,
            },
            -- Customization of explorer windows
            windows = {
                -- Maximum number of windows to show side by side
                max_number = math.huge,
                -- Whether to show preview of file/directory under cursor
                preview = false,
                -- Width of focused window
                width_focus = 200,
                -- Width of non-focused window
                width_nofocus = 100,
            },
        },
        keys = {
            {
                "<space>e",
                function()
                    local mf = Require("mini.files")
                    if mf == nil then
                        return
                    end
                    if not mf.close() then
                        mf.open(Api.nvim_buf_get_name(0))
                        mf.reveal_cwd()
                    end
                end,
            },
        },
        config = function()
            -- nvim-tree
            -- vim.g.loaded_netrw = 1
            -- vim.g.loaded_netrwPlugin = 1
            vim.opt.termguicolors = true

            vim.g.loaded_netrw = false       -- or 1
            vim.g.loaded_netrwPlugin = false -- or 1
        end,
    },

    -- alpha 是 Neovim 的快速且完全可编程的欢迎程序。



    -- Whichkey
    {
        "folke/which-key.nvim",
        config = function()
            require("ui.whichkey")
        end,
        dependencies = {
        },
    },

}

return M
