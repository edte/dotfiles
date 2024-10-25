local M = {}

M.list = {

    -- cmp 补全基础插件
    {
        -- 高性能fork
        -- "yioneko/nvim-cmp",
        -- branch = "perf",

        "hrsh7th/nvim-cmp",
        config = function()
            require("cmp.completion").cmpConfig()
        end,
        event = { "InsertEnter" },
    },

    -- 下面是一堆cmp补全源
    {
        "cmp-nvim-lsp",
        event = { "InsertEnter" },
    },
    {
        "cmp_luasnip",
        event = { "InsertEnter" },
    },
    {
        url = "https://codeberg.org/FelipeLema/cmp-async-path",
        event = { "InsertEnter" },
    },
    {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        event = { "InsertEnter" },
    },
    -- 上下文语法补全
    {
        "ray-x/cmp-treesitter",
        event = { "InsertEnter" },
    },
    {
        "lukas-reineke/cmp-rg",
        event = { "InsertEnter" },
        lazy = true,
        enabled = function()
            return vim.fn.executable("rg") == 1
        end,
    },
    {
        "Snikimonkd/cmp-go-pkgs",
        event = { "InsertEnter *.go" },
    },

    -- 单词补全
    {
        "uga-rosa/cmp-dictionary",
        event = { "InsertEnter" },
    },

    -- nvim lua  源
    {
        "hrsh7th/cmp-nvim-lua",
        event = { "InsertEnter *.lua" },
    },

    -- 自定义代码片段
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = {
            "friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
                require("luasnip.loaders.from_lua").load({ paths = "./lua/snippets" })
            end,
        },
    },

    -- nvim lua API 的完整签名帮助、文档和补全
    {
        "folke/neodev.nvim",
        lazy = true,
        event = { "InsertEnter" },
    },

    -- Neovim Lua 插件自动管理字符对。 “mini.nvim” 库的一部分。
    {
        "echasnovski/mini.pairs",
        event = { "InsertEnter" },
        version = false,
        config = function()
            require("mini.pairs").setup()
        end,
    },

    -- TabNine ai 补全
    {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        event = { "InsertEnter" },
        -- ft = { "lua", "go", "cpp" },
    },

    -- ai代码补全
    {
        "edte/copilot",
    },

    -- Codeium ai补全
    {
        "Exafunction/codeium.nvim",
        event = { "InsertEnter" },
        config = function()
            require("codeium").setup({})
        end
    },

}

return M
