local M = {}

M.list = {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,

        dependencies = {
            { "nvim-treesitter/nvim-treesitter" },
        },
    },

    -- {
    --     "catppuccin/nvim",
    --     config = function()
    --         vim.cmd([[colorscheme catppuccin]])
    --     end,
    -- },

    -- {
    --     "rebelot/kanagawa.nvim",
    --     config = function()
    --         vim.cmd([[colorscheme kanagawa]])
    --     end,
    -- },

    -- 上方的tab栏
    {
        dir = "ui.tabline",
        version = false,
        config = function()
            require("ui.tabline").setup()
        end,
    },


    -- 下方的状态栏
    {
        dir = "ui.statusline",
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


    -- 不是天空中的 UFO，而是 Neovim 中的超级折叠。 za
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        opts = require("ui.fold").Opts,
        init = require("ui.fold").init,
        config = require("ui.fold").config,
    },

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
        "gelguy/wilder.nvim",
        event = "CmdlineEnter", -- 懒加载：首次进入cmdline时载入
        config = function()
            try_require("ui.wilder").config()
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
                    local mf = try_require("mini.files")
                    if mf == nil then
                        return
                    end
                    if not mf.close() then
                        mf.open(vim.api.nvim_buf_get_name(0))
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

            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

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
            { "echasnovski/mini.icons", version = false },
            {
                "numToStr/Comment.nvim",
                event = "User FileOpened",
            },
        },
    },



    {
        dir = "ui.tmux",
        config = function()
            require("ui.tmux")
        end
    },
}

return M
