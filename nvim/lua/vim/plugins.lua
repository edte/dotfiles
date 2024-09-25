local M = {}

M.list = {
    {
        dir = "vim.cursorline",
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
            try_require("gx").setup({
                open_browser_app = "open",  -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
                open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
                handlers = {
                    plugin = true,          -- open plugin links in lua (e.g. packer, lazy, ..)
                    github = true,          -- open github issues
                    brewfile = true,        -- open Homebrew formulaes and casks
                    package_json = true,    -- open dependencies from package.json
                    search = true,          -- search the web/selection on the web if nothing else is found
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
    -- 		vim.api.nvim_set_keymap("n", "j", "<Cmd>lua require'accelerated-jk'.move_to('j')<cr>", {})
    -- 		vim.api.nvim_set_keymap("n", "k", "<Cmd>lua require'accelerated-jk'.move_to('k')<cr>", {})
    -- 		vim.api.nvim_set_keymap("n", "h", "<Cmd>lua require'accelerated-jk'.move_to('h')<cr>", {})
    -- 		vim.api.nvim_set_keymap("n", "l", "<Cmd>lua require'accelerated-jk'.move_to('l')<cr>", {})
    -- 		vim.api.nvim_set_keymap("n", "e", "<Cmd>lua require'accelerated-jk'.move_to('e')<cr>", {})
    -- 		vim.api.nvim_set_keymap("n", "b", "<Cmd>lua require'accelerated-jk'.move_to('b')<cr>", {})
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
            cmd("command! -nargs=* Replace GrugFar")
        end,
    },

    -- 像蜘蛛一样使用 w、e、b 动作。按子词移动并跳过无关紧要的标点符号。
    {
        "chrisgrieser/nvim-spider",
        keys = { "w" },
        -- lazy = true,
        config = function()
            keymap("", "w", "<cmd>lua require('spider').motion('w')<CR>")
            keymap("", "e", "<cmd>lua require('spider').motion('e')<CR>")
            keymap("", "b", "<cmd>lua require('spider').motion('b')<CR>")
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
            -- vim.api.nvim_del_keymap("n", "t")
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

    -- 一个实用插件，可扩展 Lua 文件中的“gf”功能。
    -- gf 打开文件
    {
        "sam4llis/nvim-lua-gf",
        keys = "gf",
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
            cmd("command! Path lua NvimFileLocation.copy_file_location('absolute', false, false)<cr>")
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
            local r = try_require("vim.dial")
            if r ~= nil then
                r.dialConfig()
            end
        end,
    },

    -- Neovim Lua 插件用于扩展和创建 `a`/`i` 文本对象。 “mini.nvim”库的一部分。
    {
        "echasnovski/mini.ai",
        version = false,
        config = function()
            require("mini.ai").setup({})
        end,
    },

    -- 轻松添加/更改/删除周围的分隔符对。用Lua ❤️ 编写。
    --add:    ys{motion}{char},
    --delete: ds{char},
    --change: cs{target}{replacement},

    --     Old text                    Command         New text
    -- --------------------------------------------------------------------------------
    --     surr*ound_words             ysiw)           (surround_words)
    --     *make strings               ys$"            "make strings"
    --     [delete ar*ound me!]        ds]             delete around me!
    --     remove <b>HTML t*ags</b>    dst             remove HTML tags
    --     'change quot*es'            cs'"            "change quotes"
    --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    --     delete(functi*on calls)     dsf             function calls
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        keys = { "ys", "ds", "cs" },
        config = function()
            try_require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
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
        keys = "%",
        config = function()
            vim.api.nvim_set_hl(0, "OffScreenPopup", { fg = "#fe8019", bg = "#3c3836", italic = true })
            vim.g.matchup_matchparen_offscreen = {
                method = "popup",
                highlight = "OffScreenPopup",
            }
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
        keys = { "s", "sx", "sxc" },
        config = function()
            require("substitute").setup()

            -- s<motion>，将动作提供的文本对象替换为默认寄存器
            keymap("n", "s", "<cmd>lua require('substitute').operator()<cr>")
            keymap("n", "ss", "<cmd>lua require('substitute').line()<cr>")
            -- keymap("n", "S", "<cmd>lua require('substitute').eol()<cr>")

            -- sx{motion}，按两次即可交换，支持 .
            -- sxc 取消
            keymap("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>")
            keymap("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>")
            keymap("n", "sxc", "<cmd>lua require('substitute.exchange').cancel()<cr>")

            keymap("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>")
            keymap("x", "s", "<cmd>lua require('substitute').visual()<cr>")
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
}

return M
