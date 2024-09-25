local M = {}

M.list = {
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
        event = "User FileOpened",
        cmd = "Gitsigns",
        config = function()
            require("gitsigns").setup({
                signcolumn = false,
            })
        end,
    },

    -- 单选项卡界面可轻松循环浏览任何 git rev 的所有修改文件的差异。
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen" },
        config = function()
            local r = try_require("git.git")
            if r ~= nil then
                r.diffConfig()
            end
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
        cmd = {
            "GitConflictChooseOurs",
            "GitConflictChooseTheirs",
            "GitConflictChooseBoth",
            "GitConflictChooseNone",
            "GitConflictNextConflict",
            "GitConflictPrevConflict",
            "GitConflictListQf",
        },
        version = "*",
        config = true,
    },


    {
        "echasnovski/mini-git",
        version = false,
        main = "mini.git",
        cmd = { "Git" },
        config = function()
            require("mini.git").setup()

            -- local rhs = "<Cmd>lua require('mini.git').show_at_cursor()<CR>"
        end,
    },

    -- lua MiniDiff.toggle_overlay()
    -- {
    -- 	"echasnovski/mini.diff",
    -- 	version = false,
    -- 	config = function()
    -- 		require("mini.diff").setup()
    -- 	end,
    -- },
}

return M
