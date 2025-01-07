local M = {}

M.list = {
    -- 展示颜色
    -- TODO: cmp 集成
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function()
            local r = Require("colorizer")
            if r == nil then
                return
            end

            r.setup({
                filetypes = {
                    "*", -- Highlight all files, but customize some others.
                    cmp_docs = { always_update = true },
                },
                RGB = true,      -- #RGB hex codes
                RRGGBB = true,   -- #RRGGBB hex codes
                names = true,    -- "Name" codes like Blue or blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                AARRGGBB = true, -- 0xAARRGGBB hex codes
                rgb_fn = true,   -- CSS rgb() and rgba() functions
                hsl_fn = true,   -- CSS hsl() and hsla() functions
                css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
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
    -- 		local r = Require("components.cron")
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

    -- {
    --     "3rd/image.nvim",
    --     ft = "markdown", -- If you decide to lazy-load anyway
    --     opts = {}
    -- },

    -- 一些文件用了x权限，忘记用sudo打开但是又编辑过文件了，用这个插件可以保存，或者直接打开新的文件
    -- 比如 /etc/hosts 文件
    {
        "lambdalisue/vim-suda",
        cmd = { "SudaRead", "SudaWrite" },
        config = function()
            Cmd("let g:suda_smart_edit = 1")
            Cmd("let g:suda#noninteractive = 1")
        end
    },

    -- 最精美的 Neovim 色彩工具
    { "nvzone/volt", lazy = true },
    {
        "nvzone/minty",
        cmd = { "Shades", "Huefy" },
    },


    -- 自动保存会话
    -- 保存目录是：（不知道哪里配置的）
    -- /Users/edte/.local/state/nvim/view
    {
        name = "sessions",
        dir = "components.sessions",
        virtual = true,
        config = function()
            Require("components.session").setup()

            local function GetPath()
                local dir, _ = vim.fn.getcwd():gsub('/', '_')
                return dir
            end

            Api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    if vim.fn.argc(-1) == 0 then
                        MiniSessions.read(GetPath())
                    end
                end,
                nested = true,
            })
            Api.nvim_create_autocmd("VimLeavePre", {
                callback = function()
                    MiniSessions.write(GetPath())
                end,
            })
        end
    },



}
return M
