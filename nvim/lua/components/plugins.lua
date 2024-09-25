local M = {}

M.list = {
    -- 展示颜色
    -- TODO: cmp 集成
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function()
            local r = try_require("colorizer")
            if r == nil then
                return
            end

            r.setup({
                filetypes = {
                    "*", -- Highlight all files, but customize some others.
                    cmp_docs = { always_update = true },
                },
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = true, -- "Name" codes like Blue or blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                AARRGGBB = true, -- 0xAARRGGBB hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            })
        end,
    },

    --TODO:
    --FIX:
    --NOTE:
    --WARN:
    {
        "echasnovski/mini.hipatterns",
        version = false,
        config = function()
            require("components.todo").config()
        end,
    },

    -- Neovim 中人类可读的内联 cron 表达式
    -- {
    -- 	"fabridamicelli/cronex.nvim",
    -- 	opts = {},
    -- 	ft = { "go" },
    -- 	config = function()
    -- 		local r = try_require("components.cron")
    -- 		if r ~= nil then
    -- 			r.cronConfig()
    -- 		end
    -- 	end,
    -- },

    -- 翻译插件
    {
        cmd = { "Translate" },
        "uga-rosa/translate.nvim",
    },

    -- markdown预览
    {
        "OXY2DEV/markview.nvim",
        -- lazy = false, -- Recommended
        ft = "markdown", -- If you decide to lazy-load anyway

        dependencies = {
            -- You will not need this if you installed the
            -- parsers manually
            -- Or if the parsers are in your $RUNTIMEPATH

            "nvim-tree/nvim-web-devicons",

            -- Otter.nvim 为其他文档中嵌入的代码提供 lsp 功能和代码补全源
            {
                "jmbuhr/otter.nvim",
                ft = "markdown", -- If you decide to lazy-load anyway
                dependencies = {
                    "nvim-treesitter/nvim-treesitter",
                },
                opts = {},
            },
        },
        config = function()
            require("markview").setup({})
        end,
    },

    -- precognition.nvim - 预识别使用虚拟文本和装订线标志来显示可用的动作。
    -- Precognition toggle
    -- {
    -- 	"tris203/precognition.nvim",
    -- 	opts = {},
    -- },

    -- Neovim 插件帮助您建立良好的命令工作流程并戒掉坏习惯
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("hardtime").setup({
                disable_mouse = false,
                restricted_keys = {
                    ["j"] = {},
                    ["k"] = {},
                },
                disabled_keys = {
                    ["<Up>"] = {},
                    ["<Down>"] = {},
                    ["<Left>"] = {},
                    ["<Right>"] = {},
                },
            })
        end,
    },

    -- 使用 curl 运行请求，使用 jq 格式化，并根据您自己的工作流程保存命令
    -- 这些命令将打开 curl.nvim 选项卡。在左侧缓冲区中，您可以粘贴或写入 curl 命令，然后按 Enter 键，命令将执行，并且输出将在最右侧的缓冲区中显示和格式化。
    -- 如果您愿意，您可以选择右侧缓冲区中的文本，并使用 jq 对其进行过滤，即 ggVG! jq '{query goes here}'
    {
        "oysandvik94/curl.nvim",
        cmd = { "CurlOpen" },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = true,
    },

    -- 跟踪在 Neovim 中编码所花费的时间
    -- {
    -- 	"ptdewey/pendulum-nvim",
    -- 	config = function()
    -- 		require("pendulum").setup({
    -- 			log_file = vim.fn.expand("$HOME/Documents/my_custom_log.csv"),
    -- 			timeout_len = 300, -- 5 minutes
    -- 			timer_len = 60, -- 1 minute
    -- 			gen_reports = true, -- Enable report generation (requires Go)
    -- 			top_n = 10, -- Include top 10 entries in the report
    -- 		})
    -- 	end,
    -- },
}

return M
