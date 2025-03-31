local M = {}

M.list = {
    {
        "nvim-treesitter/nvim-treesitter",
        cmd = {
            "TSInstall",
            "TSUninstall",
            "TSUpdate",
            "TSUpdateSync",
            "TSInstallInfo",
            "TSInstallSync",
            "TSInstallFromGrammar",
            "TSBufToggle",
        },
        event = "User FileOpened",
        config = function()
            local r = Require("text.treesitter")
            if r ~= nil then
                r.config()
            end
        end,
    },

    -- 语法感知文本对象、选择、移动、交换和查看支持。
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- keys = { "[m", "]m", "[[", "]]", "[]", "][" },
    },

    {
        "David-Kunz/treesitter-unit",
        event = { "User FileOpened" },
        after = "nvim-treesitter",
    },

    -- 显示代码上下文,包含函数签名
    -- 只能从下面固定多少个，而不是从上面固定，所以如果套太多层，函数名会显示不出来
    {
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        event = "BufRead",
    },

    -- -- 使用treesitter自动关闭并自动重命名html标签
    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "vue" },
        config = function()
            Setup("nvim-ts-autotag")
        end,
    },

    -- 如果打开的文件很大，此插件会自动禁用某些功能。文件大小和要禁用的功能是可配置的。
    -- {
    -- 	"lunarvim/bigfile.nvim",
    -- 	config = function()
    -- 		require("text.bigfile").config()
    -- 	end,
    -- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- 	event = { "FileReadPre", "BufReadPre", "User FileOpened" },
    -- },

    -- Neovim Lua 插件用于拆分和连接参数。 “mini.nvim” 库的一部分。
    {
        "echasnovski/mini.splitjoin",
        init = function()
            nmap("t", "<cmd>lua require('mini.splitjoin').toggle()<CR>")
        end,
        cmd = { "P" },
        version = false,
        config = function()
            require("mini.splitjoin").setup({
                mappings = {
                    toggle = "P",
                },
            })
        end,
    },

    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("fzf-lua").setup({
                "telescope",
                fzf_opts = { ["--cycle"] = "" },
                winopts = {
                    fullscreen = true,
                },
            })
        end,
    },

    -- fzflua 查看插件
    -- require("fzf-lua-lazy").search()
    {
        url = "https://github.com/edte/fzf-lua-lazy.nvim.git",
        lazy = true,
    },

    {
        'echasnovski/mini.align',
        version = false,
        config = function()
            require('mini.align').setup({
                mappings = {
                    start = 'aa',
                },
            }
            )
        end
    },


    -- 使用 Treesitter 突出显示参数的定义和用法
    {
        'm-demare/hlargs.nvim',
        config = function()
            require('hlargs').setup()
        end
    },
    {
        'aaronik/treewalker.nvim',

        -- The following options are the defaults.
        -- Treewalker aims for sane defaults, so these are each individually optional,
        -- and setup() does not need to be called, so the whole opts block is optional as well.
        opts = {
            -- Whether to briefly highlight the node after jumping to it
            highlight = true,

            -- How long should above highlight last (in ms)
            highlight_duration = 250,

            -- The color of the above highlight. Must be a valid vim highlight group.
            -- (see :h highlight-group for options)
            highlight_group = 'CursorLine',
        },
        config = function()
            vim.keymap.set({ 'n', 'v' }, '<C-k>', '<cmd>Treewalker Up<cr>', { silent = true })
            vim.keymap.set({ 'n', 'v' }, '<C-j>', '<cmd>Treewalker Down<cr>', { silent = true })
            -- vim.keymap.set({ 'n', 'v' }, '<C-h>', '<cmd>Treewalker Left<cr>', { silent = true })
            -- vim.keymap.set({ 'n', 'v' }, '<C-l>', '<cmd>Treewalker Right<cr>', { silent = true })
        end,
    },


}

return M
