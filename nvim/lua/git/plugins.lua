local M = {}

M.list = {
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
        -- event = "User FileOpened",
        -- cmd = "Gitsigns",
        config = function()
            Setup("gitsigns", {
                signcolumn = false,
            })
        end,
    },

    -- 单选项卡界面可轻松循环浏览任何 git rev 的所有修改文件的差异。
    {
        "sindrets/diffview.nvim",
        -- cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        config = function()
            Setup("git.git", {})
        end,
    },

    -- Neovim 中可视化和解决合并冲突的插件
    -- GitConflictChooseOurs — 选择当前更改。
    -- GitConflictChooseTheirs — 选择传入的更改。
    -- GitConflictChooseBoth — 选择两项更改。
    -- GitConflictChooseNone — 不选择任何更改。
    -- GitConflictNextConflict — 移至下一个冲突。
    -- GitConflictPrevConflict — 移至上一个冲突。
    -- GitConflictListQf — 将所有冲突获取到快速修复

    -- c o — 选择我们的
    -- c t — 选择他们的
    -- c b — 选择两者
    -- c 0 — 不选择
    -- ] x — 移至上一个冲突
    -- [ x — 移至下一个冲突
    {
        "akinsho/git-conflict.nvim",
        -- cmd = {
        --     "GitConflictChooseOurs",
        --     "GitConflictChooseTheirs",
        --     "GitConflictChooseBoth",
        --     "GitConflictChooseNone",
        --     "GitConflictNextConflict",
        --     "GitConflictPrevConflict",
        --     "GitConflictListQf",
        -- },
        version = "*",
        config = true,
    },


    {
        "echasnovski/mini-git",
        version = false,
        main = "mini.git",
        cmd = { "Git" },
        config = function()
            Setup("mini.git")
        end,
    },

    -- lua MiniDiff.toggle_overlay()
    {
        "echasnovski/mini.diff",
        version = false,
        config = function()
            Setup("mini.diff")
            Cmd("command! Diff lua MiniDiff.toggle_overlay()")
        end,
    },

    -- Neovim 逃亡风格 git Blame 插件
    {
        "FabijanZulj/blame.nvim",
        lazy = true,
        cmd = { "BlameToggle" },
        config = function()
            require('blame').setup()
        end,
        opts = {
            blame_options = { '-w' },
        },
    },

    -- Neovim的 lua 插件，用于为 git 主机网站生成可共享文件永久链接（带有行范围）
    {
        "linrongbin16/gitlinker.nvim",
        cmd = "GitLink",
        opts = {},
        keys = {
            { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
        },
    },

}

return M
