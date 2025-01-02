local M = {}

M.list = {
    -- {
    --     'saghen/blink.cmp',
    --
    --     version = 'v0.*',
    --
    --     opts = {
    --         highlight = {
    --             use_nvim_cmp_as_default = true,
    --         },
    --
    --         keymap = {
    --             preset = 'default',
    --             ['<Enter>'] = { 'select_and_accept', "fallback" },
    --             ["<CR>"] = { "select_and_accept", "fallback" },
    --             ["<Tab>"] = { "select_next", "fallback" },
    --             ["<S-Tab>"] = { "select_prev", "fallback" },
    --             ["<Down>"] = { "select_next", "fallback" },
    --             ["<Up>"] = { "select_prev", "fallback" },
    --             ["<PageDown>"] = { "scroll_documentation_down" },
    --             ["<PageUp>"] = { "scroll_documentation_up" },
    --         },
    --
    --         appearance = {
    --             -- Sets the fallback highlight groups to nvim-cmp's highlight groups
    --             -- Useful for when your theme doesn't support blink.cmp
    --             -- will be removed in a future release
    --             use_nvim_cmp_as_default = true,
    --             -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    --             -- Adjusts spacing to ensure icons are aligned
    --             nerd_font_variant = 'mono'
    --         },
    --
    --         sources = {
    --             default = { 'lsp', 'path', 'snippets', 'luasnip', 'buffer' },
    --             providers = {
    --                 snippets = {
    --                     min_keyword_length = 1, -- don't show when triggered manually, useful for JSON keys
    --                     score_offset = -1,
    --                 },
    --                 path = {
    --                     opts = { get_cwd = vim.uv.cwd },
    --                 },
    --                 buffer = {
    --                     fallback_for = {}, -- disable being fallback for LSP
    --                     max_items = 4,
    --                     min_keyword_length = 4,
    --                     score_offset = -3,
    --                 },
    --             },
    --         },
    --
    --         snippets = {
    --             expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
    --             active = function(filter)
    --                 if filter and filter.direction then
    --                     return require('luasnip').jumpable(filter.direction)
    --                 end
    --                 return require('luasnip').in_snippet()
    --             end,
    --             jump = function(direction) require('luasnip').jump(direction) end,
    --         },
    --
    --         signature = { enabled = true },
    --
    --         windows = {
    --             documentation = {
    --                 border = vim.g.borderStyle,
    --                 min_width = 15,
    --                 max_width = 45, -- smaller, due to https://github.com/Saghen/blink.cmp/issues/194
    --                 max_height = 10,
    --                 auto_show = true,
    --                 auto_show_delay_ms = 250,
    --             },
    --             autocomplete = {
    --                 border = vim.g.borderStyle,
    --                 min_width = 10,               -- max_width controlled by draw-function
    --                 max_height = 10,
    --                 cycle = { from_top = false }, -- cycle at bottom, but not at the top
    --                 draw = function(ctx)
    --                     -- https://github.com/Saghen/blink.cmp/blob/9846c2d2bfdeaa3088c9c0143030524402fffdf9/lua/blink/cmp/types.lua#L1-L6
    --                     -- https://github.com/Saghen/blink.cmp/blob/9846c2d2bfdeaa3088c9c0143030524402fffdf9/lua/blink/cmp/windows/autocomplete.lua#L298-L349
    --                     -- differentiate LSP snippets from user snippets and emmet snippets
    --                     local source, client = ctx.item.source_id, ctx.item.client_id
    --                     if
    --                         client and vim.lsp.get_client_by_id(client).name == "emmet_language_server"
    --                     then
    --                         source = "emmet"
    --                     end
    --
    --                     local sourceIcons = { snippets = "󰩫", buffer = "󰦨", emmet = "" }
    --                     local icon = sourceIcons[source] or ctx.kind_icon
    --
    --                     return {
    --                         {
    --                             " " .. ctx.item.label .. " ",
    --                             fill = true,
    --                             hl_group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
    --                             max_width = 40,
    --                         },
    --                         { icon .. " ", hl_group = "BlinkCmpKind" .. ctx.kind },
    --                     }
    --                 end,
    --             },
    --         },
    --
    --         kind_icons = {
    --             Text = "",
    --             Method = "󰊕",
    --             Function = "󰊕",
    --             Constructor = "",
    --             Field = "󰇽",
    --             Variable = "󰂡",
    --             Class = "󰜁",
    --             Interface = "",
    --             Module = "",
    --             Property = "󰜢",
    --             Unit = "",
    --             Value = "󰎠",
    --             Enum = "",
    --             Keyword = "󰌋",
    --             Snippet = "󰒕",
    --             Color = "󰏘",
    --             Reference = "",
    --             File = "",
    --             Folder = "󰉋",
    --             EnumMember = "",
    --             Constant = "󰏿",
    --             Struct = "",
    --             Event = "",
    --             Operator = "󰆕",
    --             TypeParameter = "󰅲",
    --         },
    --     },
    -- },


    -- cmp 补全基础插件
    {
        -- 高性能fork
        -- "yioneko/nvim-cmp",
        -- branch = "perf",

        "hrsh7th/nvim-cmp",
        config = function()
            require("cmp.cmp").setup()
        end,
        event = { "InsertEnter" },
    },

    -- 下面是一堆cmp补全源
    {
        "hrsh7th/cmp-nvim-lsp",
        event = { "InsertEnter" },
    },
    {
        "saadparwaiz1/cmp_luasnip",
        event = { "InsertEnter" },
    },
    {
        "edte/cmp-async-path",
        event = { "InsertEnter" },
    },
    {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        event = { "InsertEnter" },
    },
    -- -- 上下文语法补全
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
        name = "cmp-go-pkgs",
        dir = "cmp.cmp-go-pkgs",
        virtual = true,
        event = { "InsertEnter *.go" },
        config = function()
            require("cmp.cmp_go_pkgs").new()
        end
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
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_lua").load({ paths = NEOVIM_CONFIG_PATH .. "/lua/cmp/snippets" })
        end,
        dependencies = {
            "rafamadriz/friendly-snippets",
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

    -- ai代码补全
    {
        "edte/copilot",
    },


    {
        "tpope/vim-endwise",
    },

    {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        event = { "InsertEnter" },
        -- ft = { "lua", "go", "cpp" },
    },

}

return M
