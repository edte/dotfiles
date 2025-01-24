local M = {}

M.list = {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            Cmd([[colorscheme tokyonight]])
        end,

        dependencies = {
            { "nvim-treesitter/nvim-treesitter" },
        },
    },

    -- {
    --     "catppuccin/nvim",
    --     config = function()
    --         Cmd([[colorscheme catppuccin]])
    --     end,
    -- },

    -- {
    --     "rebelot/kanagawa.nvim",
    --     config = function()
    --         Cmd([[colorscheme kanagawa]])
    --     end,
    -- },

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

    -- 右边的滚动条
    {
        "lewis6991/satellite.nvim",
        opts = {
            handlers = {
                marks = {
                    enable = false,
                },
            },
        },
    },


    -- -- 不是天空中的 UFO，而是 Neovim 中的超级折叠。 za
    -- {
    --     "kevinhwang91/nvim-ufo",
    --     dependencies = "kevinhwang91/promise-async",
    --     opts = require("ui.fold").Opts,
    --     init = require("ui.fold").init,
    --     config = require("ui.fold").config,
    -- },

    -- 左边的状态列
    {
        "luukvbaal/statuscol.nvim",
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup({
                -- relculright = true,
                segments = {
                    -- marks
                    { sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = false } },
                    -- 行号
                    { text = { builtin.lnumfunc } },
                    -- 折叠
                    { text = { builtin.foldfunc } },
                },
            })

            require("ui.fold").init()
        end,
    },

    --
    -- 符号树状视图,按 S
    {
        "hedyhli/outline.nvim",
        lazy = true,
        cmd = { "Outline", "OutlineOpen" },
        keys = { -- Example mapping to toggle outline
            { "S", "<cmd>Outline<CR>", desc = "Toggle outline" },
        },
        opts = {
            outline_window = {
                auto_close = true,
                auto_jump = true,
                show_numbers = false,
                width = 35,
                wrap = true,
            },
            outline_items = {
                show_symbol_lineno = true,
                show_symbol_details = false,
            },
        },
    },

    -- wilder.nvim 插件，用于命令行补全，和 noice.nvim 冲突
    {
        "edte/wilder.nvim",
        event = "CmdlineEnter", -- 懒加载：首次进入cmdline时载入
        config = function()
            Setup("ui.wilder")
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
        keys = {},
        config = function()
            -- nvim-tree
            -- vim.g.loaded_netrw = 1
            -- vim.g.loaded_netrwPlugin = 1
            vim.opt.termguicolors = true

            vim.g.loaded_netrw = false       -- or 1
            vim.g.loaded_netrwPlugin = false -- or 1

            Setup("mini.files")
        end,
    },

    -- alpha 是 Neovim 的快速且完全可编程的欢迎程序。
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("ui.dashboard").config()
        end,
    },

    -- Neovim Lua 插件可在缩进范围内可视化和操作。 “mini.nvim”库的一部分。
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        config = function()
            require("mini.indentscope").setup({
                draw = {
                    priority = 2,
                    animation = require("mini.indentscope").gen_animation.none(),
                },
            })

            -- do 删除
            vim.keymap.set("o", "o", function()
                local operator = vim.v.operator
                if operator == "d" then
                    local scope = MiniIndentscope.get_scope()
                    local top = scope.border.top
                    local bottom = scope.border.bottom
                    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                    local move = ""
                    if row == bottom then
                        move = "k"
                    elseif row == top then
                        move = "j"
                    end
                    local ns = vim.api.nvim_create_namespace("border")
                    vim.api.nvim_buf_add_highlight(0, ns, "Substitute", top - 1, 0, -1)
                    vim.api.nvim_buf_add_highlight(0, ns, "Substitute", bottom - 1, 0, -1)
                    vim.defer_fn(function()
                        vim.api.nvim_buf_set_text(0, top - 1, 0, top - 1, -1, {})
                        vim.api.nvim_buf_set_text(0, bottom - 1, 0, bottom - 1, -1, {})
                        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
                    end, 150)
                    return "<esc>" .. move
                else
                    return "o"
                end
            end, { expr = true })
        end,
        init = function()
            Autocmd("FileType", {
                pattern = {
                    "alpha",
                    "dashboard",
                    "fzf",
                    "help",
                    "lazy",
                    "lazyterm",
                    "mason",
                    "neo-tree",
                    "notify",
                    "toggleterm",
                    "Trouble",
                    "trouble",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
            require("mini.indentscope").setup({
                symbol = "│",
            })
        end,
    },

    -- 这个 Neovim 插件为 Neovim 提供交替语法突出显示（“彩虹括号”），由 Tree-sitter 提供支持。目标是拥有一个可破解的插件，允许全局和每个文件类型进行不同的查询和策略配置。用户可以通过自己的配置覆盖和扩展内置默认值。
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
        config = function()
            local rainbow_delimiters = require("rainbow-delimiters")

            highlight("RainbowRed", "#E06C75")
            highlight("RainbowYellow", "#E5C07B")
            highlight("RainbowBlue", "#61AFEF")
            highlight("RainbowOrange", "#D19A66")
            highlight("RainbowGreen", "#98C379")
            highlight("RainbowViolet", "#C678DD")
            highlight("RainbowCyan", "#56B6C2")

            require("rainbow-delimiters.setup").setup({
                strategy = {
                    [""] = rainbow_delimiters.strategy["global"],
                    vim = rainbow_delimiters.strategy["local"],
                },
                query = {
                    [""] = "rainbow-delimiters",
                    lua = "rainbow-blocks",
                },
                priority = {
                    [""] = 110,
                    lua = 210,
                },
                highlight = {
                    "RainbowRed",
                    "RainbowYellow",
                    "RainbowBlue",
                    "RainbowOrange",
                    "RainbowGreen",
                    "RainbowViolet",
                    "RainbowCyan",
                },
            })
        end,
    },

    -- Whichkey
    {
        "folke/which-key.nvim",
        config = function()
            require("ui.whichkey")
        end,
        dependencies = {
            -- Neovim 智能且强大的评论插件。支持 Treesitter、点重复、左右/上下运动、挂钩等
            -- gcc 行注释
            -- gbc 块注释
            -- gcO: Add comment on the line above
            -- gco: Add comment on the line below
            -- gcA: Add comment at the end of line
            -- gc+ 文本对象，直接 (), {} 等等
            {
                "numToStr/Comment.nvim",
                event = "User FileOpened",
                opts = {},
            },

            -- 更好的注释生成器。支持多种语言和注释约定。
            -- gcn 在内部快速生成注释
            {
                "danymat/neogen",
                after = "nvim-treesitter",
                keys = "gcn",
                config = function()
                    require("neogen").setup({})
                    nmap("gcn", "<cmd>lua require('neogen').generate()<CR>")
                end,
            },

        },
    },

    {
        name = "tmux",
        dir = "ui.tmux",
        virtual = true,
        config = function()
            require("ui.tmux")
        end
    },

    -- 一个微型 Neovim 插件，用于在视觉模式下突出显示与当前选择匹配的文本
    {
        "wurli/visimatch.nvim",
        opts = {
            chars_lower_limit = 3,
        }
    },

    -- Neovim 的通用日志语法突出显示和文件类型管理
    {
        'fei6409/log-highlight.nvim',
        config = function()
            require('log-highlight').setup {}
        end,
    },



}

return M
