local M = {}

M.list = {
    -- {
    --     name = "cursorline",
    --     dir = "vim.cursorline",
    --     virtual = true,
    --     config = function()
    --         require("vim.cursorline")
    --     end
    -- },



    -- 像蜘蛛一样使用 w、e、b 动作。按子词移动并跳过无关紧要的标点符号。
    {
        "chrisgrieser/nvim-spider",
        keys = { "w" },
        -- lazy = true,
        config = function()
            Keymap("", "w", "<cmd>lua require('spider').motion('w')<CR>")
            Keymap("", "e", "<cmd>lua require('spider').motion('e')<CR>")
            Keymap("", "b", "<cmd>lua require('spider').motion('b')<CR>")
        end,
    },

    -- Vim 的扩展 f、F、t 和 T 键映射。
    {
        "rhysd/clever-f.vim",
        keys = { "f" },
        config = function()
            vim.g.clever_f_across_no_line = 1
            vim.g.clever_f_mark_direct = 1
            vim.g.clever_f_smart_case = 1
            vim.g.clever_f_fix_key_direction = 1
            vim.g.clever_f_show_prompt = 1
            -- api.nvim_del_keymap("n", "t")
        end,
    },


    -- Neovim 中 vimdoc/帮助文件的装饰
    -- https://github.com/OXY2DEV/helpview.nvim
    {
        "OXY2DEV/helpview.nvim",
        lazy = true,
        event = "CmdlineEnter",
        -- ft = "help",

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },


    -- 扩展递增/递减 ctrl+x/a
    {
        "monaqa/dial.nvim",
        keys = { "<C-a>", "<C-x>" },
        opts = {},
        config = function()
            local r = Require("vim.dial")
            if r ~= nil then
                r.dialConfig()
            end
        end,
    },

    -- Neovim Lua 插件用于扩展和创建 `a`/`i` 文本对象。 “mini.nvim”库的一部分。
    -- |Key|     Name      |   Example line   |   a    |   i    |   2a   |   2i   |
    -- |---|---------------|-1234567890123456-|--------|--------|--------|--------|
    -- | ( |  Balanced ()  | (( *a (bb) ))    |        |        |        |        |
    -- | [ |  Balanced []  | [[ *a [bb] ]]    | [2;12] | [4;10] | [1;13] | [2;12] |
    -- | { |  Balanced {}  | {{ *a {bb} }}    |        |        |        |        |
    -- | < |  Balanced <>  | << *a <bb> >>    |        |        |        |        |
    -- |---|---------------|-1234567890123456-|--------|--------|--------|--------|
    -- | ) |  Balanced ()  | (( *a (bb) ))    |        |        |        |        |
    -- | ] |  Balanced []  | [[ *a [bb] ]]    |        |        |        |        |
    -- | } |  Balanced {}  | {{ *a {bb} }}    | [2;12] | [3;11] | [1;13] | [2;12] |
    -- | > |  Balanced <>  | << *a <bb> >>    |        |        |        |        |
    -- | b |  Alias for    | [( *a {bb} )]    |        |        |        |        |
    -- |   |  ), ], or }   |                  |        |        |        |        |
    -- |---|---------------|-1234567890123456-|--------|--------|--------|--------|
    -- | " |  Balanced "   | "*a" " bb "      |        |        |        |        |
    -- | ' |  Balanced '   | '*a' ' bb '      |        |        |        |        |
    -- | ` |  Balanced `   | `*a` ` bb `      | [1;4]  | [2;3]  | [6;11] | [7;10] |
    -- | q |  Alias for    | '*a' " bb "      |        |        |        |        |
    -- |   |  ", ', or `   |                  |        |        |        |        |
    -- |---|---------------|-1234567890123456-|--------|--------|--------|--------|
    -- | ? |  User prompt  | e*e o e o o      | [3;5]  | [4;4]  | [7;9]  | [8;8]  |
    -- |   |(typed e and o)|                  |        |        |        |        |
    -- |---|---------------|-1234567890123456-|--------|--------|--------|--------|
    -- | t |      Tag      | <x><y>*a</y></x> | [4;12] | [7;8]  | [1;16] | [4;12] |
    -- |---|---------------|-1234567890123456-|--------|--------|--------|--------|
    -- | f | Function call | f(a, g(*b, c) )  | [6;13] | [8;12] | [1;15] | [3;14] |
    -- |---|---------------|-1234567890123456-|--------|--------|--------|--------|
    -- | a |   Argument    | f(*a, g(b, c) )  | [3;5]  | [3;4]  | [5;14] | [7;13] |
    -- |---|---------------|-1234567890123456-|--------|--------|--------|--------|
    -- |   |    Default    |                  |        |        |        |        |
    -- |   |   (digits,    | aa_*b__cc___     | [4;7]  | [4;5]  | [8;12] | [8;9]  |
    -- |   | punctuation,  | (example for _)  |        |        |        |        |
    -- |   | or whitespace)|                  |        |        |        |        |
    -- |---|---------------|-1234567890123456-|--------|--------|--------|--------|
    {
        "echasnovski/mini.ai",
        version = false,
        config = function()
            require("mini.ai").setup({})
        end,
    },

    -- 添加、删除、替换、查找、突出显示周围（如一对括号、引号等）。
    -- 使用sa添加周围环境（在视觉模式或运动模式下）。
    -- 用sd删除周围的内容。
    -- 将周围替换为sr 。
    -- 使用sf或sF查找周围环境（向右或向左移动光标）。
    -- 用sh突出显示周围。
    -- 使用sn更改相邻线的数量（请参阅 |MiniSurround-algorithm|）。
    {
        'echasnovski/mini.surround',
        version = false,
        keys = { "sa", "sd", "sr", "sh" },
        config = function()
            require('mini.surround').setup({
                mappings = {
                    add = 'sa',          -- Add surrounding in Normal and Visual modes
                    delete = 'sd',       -- Delete surrounding
                    replace = 'sr',      -- Replace surrounding
                    highlight = 'sh',    -- Highlight surrounding
                    find = '',           -- Find surrounding (to the right)
                    find_left = '',      -- Find surrounding (to the left)
                    update_n_lines = '', -- Update `n_lines`
                    suffix_last = '',    -- Suffix to search with "prev" method
                    suffix_next = '',    -- Suffix to search with "next" method
                },
            })
        end
    },


    -- Neovim 插件引入了新的操作员动作来快速替换和交换文本。
    {
        "gbprod/substitute.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = { "s", "sx" },
        config = function()
            require("substitute").setup()

            -- 交换
            -- sx{motion}，按两次即可交换，支持 .
            Keymap("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>")

            -- 替换
            -- s{motion} 先按s，然后按文本对象就直接替换为默认寄存器里的内容
            Keymap("n", "s", "<cmd>lua require('substitute').operator()<cr>")
            Keymap("x", "s", "<cmd>lua require('substitute').visual()<cr>")
        end,
    },



}

return M
