local M = {}

M.list = {
    {
        name = "cursorline",
        dir = "vim.cursorline",
        virtual = true,
        config = function()
            require("vim.cursorline")
        end
    },

    -- 增强 Neovim 中宏的使用。
    {
        "chrisgrieser/nvim-recorder",
        event = "RecordingEnter",
        keys = {
            { "q", desc = " Start Recording" },
            { "Q", desc = " Play Recording" },
        },
        opts = {},
    },

    -- 使用“.”启用重复支持的插件映射
    {
        "tpope/vim-repeat",
        keys = { "." },
    },

    -- gx 打开 URL
    {
        "chrishrb/gx.nvim",
        keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
        cmd = { "Browse" },
        init = function()
            vim.g.netrw_nogx = 1 -- disable netrw gx
        end,
        dependencies = { "nvim-lua/plenary.nvim" },
        -- you can specify also another config if you want
        config = function()
            Require("gx").setup({
                open_browser_app = "open",              -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
                open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
                handlers = {
                    plugin = true,                      -- open plugin links in lua (e.g. packer, lazy, ..)
                    github = true,                      -- open github issues
                    brewfile = true,                    -- open Homebrew formulaes and casks
                    package_json = true,                -- open dependencies from package.json
                    search = true,                      -- search the web/selection on the web if nothing else is found
                },
                handler_options = {
                    search_engine = "google", -- you can select between google, bing, duckduckgo, and ecosia
                    -- search_engine = "https://search.brave.com/search?q=", -- or you can pass in a custom search engine
                },
            })
        end,
    },

    -- 长按j k 加速
    -- 卡顿
    -- {
    -- 	"rainbowhxch/accelerated-jk.nvim",
    -- 	keys = { "j", "k" },
    -- 	config = function()
    -- 		api.nvim_set_keymap("n", "j", "<Cmd>lua require'accelerated-jk'.move_to('j')<cr>", {})
    -- 		api.nvim_set_keymap("n", "k", "<Cmd>lua require'accelerated-jk'.move_to('k')<cr>", {})
    -- 		api.nvim_set_keymap("n", "h", "<Cmd>lua require'accelerated-jk'.move_to('h')<cr>", {})
    -- 		api.nvim_set_keymap("n", "l", "<Cmd>lua require'accelerated-jk'.move_to('l')<cr>", {})
    -- 		api.nvim_set_keymap("n", "e", "<Cmd>lua require'accelerated-jk'.move_to('e')<cr>", {})
    -- 		api.nvim_set_keymap("n", "b", "<Cmd>lua require'accelerated-jk'.move_to('b')<cr>", {})
    -- 	end,
    -- },

    -- 项目维度的替换插件
    -- normal 下按 \+r 生效
    {
        "MagicDuck/grug-far.nvim",
        cmd = "Replace",
        config = function()
            Setup("grug-far", {})
            -- require("grug-far").setup({})
            Cmd("command! -nargs=* Replace GrugFar")
        end,
    },

    -- 像蜘蛛一样使用 w、e、b 动作。按子词移动并跳过无关紧要的标点符号。
    {
        "chrisgrieser/nvim-spider",
        keys = { "w" },
        -- lazy = true,
        config = function()
            nmap("w", "<cmd>lua require('spider').motion('w')<CR>")
            nmap("e", "<cmd>lua require('spider').motion('e')<CR>")
            nmap("b", "<cmd>lua require('spider').motion('b')<CR>")
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

    -- 在 Vim 中，在字符上按 ga 显示其十进制、八进制和十六进制表示形式。 Characterize.vim 通过以下补充对其进行了现代化改造：
    -- Unicode 字符名称： U+00A9 COPYRIGHT SYMBOL
    -- Vim 二合字母（在 <C-K> 之后键入以插入字符）： Co , cO
    -- 表情符号代码：： :copyright:
    -- HTML 实体： &copy;
    {
        "tpope/vim-characterize",
        keys = "ga",
    },

    -- neovim 插件将文件路径和光标所在行复制到剪贴板
    {
        "diegoulloao/nvim-file-location",
        cmd = "Path",
        config = function()
            require("nvim-file-location").setup({
                -- keymap = 'yP',
                mode = "absolute",
                add_line = false,
                add_column = false,
                default_register = "*",
            })
            Cmd("command! Path lua NvimFileLocation.copy_file_location('absolute', false, false)<cr>")
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

    -- Neovim 动作速度极快！
    {
        "phaazon/hop.nvim",
        branch = "v2", -- optional but strongly recommended
        keys = "<M-m>",
        config = function()
            require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
            local hop = require("hop")
            vim.keymap.set("", "<M-m>", function()
                hop.hint_char1()
            end, { remap = true })
        end,
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

    -- vim undo tree
    {
        "mbbill/undotree",
        lazy = true,
        cmd = "UndotreeToggle",
    },

    -- vim match-up：更好的导航和突出显示匹配单词现代 matchit 和 matchparen。支持 vim 和 neovim + tree-sitter。
    {
        "andymass/vim-matchup",
        config = function()
        end,
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
            nmap("sx", "<cmd>lua require('substitute.exchange').operator()<cr>")

            -- 替换
            -- s{motion} 先按s，然后按文本对象就直接替换为默认寄存器里的内容
            nmap("s", "<cmd>lua require('substitute').operator()<cr>")
            xmap("s", "<cmd>lua require('substitute').visual()<cr>")
        end,
    },

    -- 高亮行尾空格，方便格式化
    {
        "echasnovski/mini.trailspace",
        version = false,
        config = function()
            require("mini.trailspace").setup()
        end,
    },

    -- 一个非常简单的插件，使 hlsearch 更加有用。
    -- {
    --     "romainl/vim-cool",
    --     keys = "/",
    -- },

    -- 在插入模式和命令行模式下提供emacs键位，比如c-a行首，c-e行尾，normal模式无效
    {
        "tpope/vim-rsi",
        event = { "InsertEnter", "CmdlineEnter" },
    },

    -- Neovim 中更好的快速修复窗口，抛光旧的快速修复窗口。
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        dependencies = {
            'junegunn/fzf',
            run = function()
                vim.fn['fzf#install']()
            end
        },
    },

    -- {
    --     'nullromo/go-up.nvim',
    --     opts = {}, -- specify options here
    --     config = function(_, opts)
    --         local goUp = require('go-up')
    --         goUp.setup(opts)
    --     end,
    -- },


    -- Neovim 插件，用于预览寄存器的内容
    -- 调用:Registers
    -- 按 " 在正常或可视模式下
    -- 按 Ctrl R 在插入模式下
    {
        "tversteeg/registers.nvim",
        cmd = "Registers",
        config = true,
        keys = {
            { "\"",    mode = { "n", "v" } },
            { "<C-R>", mode = "i" }
        },
        name = "registers",
    },



}

return M
