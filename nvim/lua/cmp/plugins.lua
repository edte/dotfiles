local M = {}

M.list = {

    -- cmp 补全基础插件
    {
        -- "hrsh7th/nvim-cmp",

        "xzbdmw/nvim-cmp",
        commit = "a08882abe1f900c0c7f516725d74c7d84faeaa79",

        config = function(_, opts)
            require("cmp.cmp").setup(opts)
        end,
        dependencies = {
            -- 下面是一堆cmp补全源
            {
                "hrsh7th/cmp-buffer",
            },
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
                "Snikimonkd/cmp-go-pkgs",
                -- event = { "LspAttach" },
                event = { "InsertEnter *.go" },
            },

            {
                "onsails/lspkind.nvim",
            },

            -- 单词补全
            {
                "uga-rosa/cmp-dictionary",
                event = { "InsertEnter" },
                config = function()
                    -- git clone https://github.com/skywind3000/vim-dict nvim/
                    local dict = {
                        ["*"] = { "/usr/share/dict/words" },
                        ["go"] = { NEOVIM_CONFIG_PATH .. "/lua/cmp/dict/go.dict" },
                        ["sh"] = { NEOVIM_CONFIG_PATH .. "/lua/cmp/dict/sh.dict" },
                        ["lua"] = { NEOVIM_CONFIG_PATH .. "/lua/cmp/dict/lua.dict" },
                        ["html"] = { NEOVIM_CONFIG_PATH .. "/lua/cmp/dict/html.dict" },
                        ["css"] = { NEOVIM_CONFIG_PATH .. "/lua/cmp/dict/css.dict" },
                        ["cpp"] = { NEOVIM_CONFIG_PATH .. "/lua/cmp/dict/cpp.dict" },
                        ["cmake"] = { NEOVIM_CONFIG_PATH .. "/lua/cmp/dict/cmake.dict" },
                        ["c"] = { NEOVIM_CONFIG_PATH .. "/lua/cmp/dict/c.dict" },
                    }

                    local function get_dict_path(file)
                        local paths = {}
                        if file:find(".*xmake.lua") then
                            paths = dict.xmake
                        else
                            paths = dict[vim.bo.filetype] or {}
                        end
                        vim.list_extend(paths, dict["*"])
                        return paths
                    end

                    Setup("cmp_dictionary", {
                        paths = get_dict_path(vim.fn.expand("%")),
                        exact_length = 2,
                        first_case_insensitive = false,
                    })

                    Autocmd("BufEnter", {
                        pattern = "*",
                        callback = function(ev)
                            require("cmp_dictionary").setup({ paths = get_dict_path(ev.file) })
                        end,
                    })
                end
            },

            -- nvim lua  源
            {
                "hrsh7th/cmp-nvim-lua",
                event = { "InsertEnter *.lua" },
            },

            {
                "tzachar/cmp-tabnine",
                build = "./install.sh",
                event = { "InsertEnter" },
                -- ft = { "lua", "go", "cpp" },
                config = function()
                    -- tabnine 设置，一个ai补全的
                    local tabnine = Require("cmp_tabnine.config")
                    if tabnine == nil then
                        return
                    end
                    tabnine:setup({
                        max_lines = 1000,
                        max_num_results = 20,
                        sort = true,
                        run_on_every_keystroke = true,
                        snippet_placeholder = "..",
                        ignored_file_types = {
                            -- default is not to ignore
                            -- uncomment to ignore in lua:
                            -- lua = true
                        },
                        show_prediction_strength = false,
                        min_percent = 0,
                    })
                end
            },

            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },

            -- 自定义代码片段
            {
                "L3MON4D3/LuaSnip",
                event = "InsertEnter",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                    require("luasnip.loaders.from_lua").load({ paths = NEOVIM_CONFIG_PATH .. "/lua/cmp/luasnippets" })
                end,
                dependencies = {
                    "rafamadriz/friendly-snippets",
                },
            },


        },
        event = { "InsertEnter" },
    },

    {
        "xzbdmw/colorful-menu.nvim",
        config = function()
            -- You don't need to set these options.
            require("colorful-menu").setup({
                ls = {
                    lua_ls = {
                        -- Maybe you want to dim arguments a bit.
                        arguments_hl = "@comment",
                    },
                    gopls = {
                        -- When true, label for field and variable will format like "foo: Foo"
                        -- instead of go's original syntax "foo Foo".
                        add_colon_before_type = false,
                    },
                    -- for lsp_config or typescript-tools
                    ts_ls = {
                        extra_info_hl = "@comment",
                    },
                    vtsls = {
                        extra_info_hl = "@comment",
                    },
                    ["rust-analyzer"] = {
                        -- Such as (as Iterator), (use std::io).
                        extra_info_hl = "@comment",
                    },
                    clangd = {
                        -- Such as "From <stdio.h>".
                        extra_info_hl = "@comment",
                    },
                    roslyn = {
                        extra_info_hl = "@comment",
                    },
                    basedpyright = {
                        -- It is usually import path such as "os"
                        extra_info_hl = "@comment",
                    },

                    -- If true, try to highlight "not supported" languages.
                    fallback = true,
                },
                -- If the built-in logic fails to find a suitable highlight group,
                -- this highlight is applied to the label.
                fallback_highlight = "@variable",
                -- If provided, the plugin truncates the final displayed text to
                -- this width (measured in display cells). Any highlights that extend
                -- beyond the truncation point are ignored. Default 60.
                max_width = 60,
            })
        end,
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

    -- cmp 替代品，暂时还是有些问题，一些cmp生态不咋支持，而且没搞懂怎么设置provider的kind
    -- {
    --     'saghen/blink.cmp',
    --
    --     dependencies = {
    --         {
    --             'saghen/blink.compat',
    --             -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    --             version = '*',
    --             -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    --             lazy = true,
    --             -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    --             opts = {
    --                 debug = true,
    --             },
    --         },
    --         {
    --             "tzachar/cmp-tabnine",
    --             build = "./install.sh",
    --             event = { "InsertEnter" },
    --             -- ft = { "lua", "go", "cpp" },
    --         },
    --         {
    --             "niuiic/blink-cmp-rg.nvim",
    --         },
    --
    --         {
    --             "hrsh7th/cmp-nvim-lua",
    --             event = { "InsertEnter *.lua" },
    --         },
    --
    --         -- 上下文语法补全
    --         {
    --             "ray-x/cmp-treesitter",
    --             event = { "InsertEnter" },
    --         },
    --         -- 自定义代码片段
    --         {
    --             "L3MON4D3/LuaSnip",
    --             event = "InsertEnter",
    --             config = function()
    --                 require("luasnip.loaders.from_vscode").lazy_load()
    --                 require("luasnip.loaders.from_lua").load({ paths = NEOVIM_CONFIG_PATH .. "/lua/cmp/luasnippets" })
    --             end,
    --             dependencies = {
    --                 "rafamadriz/friendly-snippets",
    --             },
    --         },
    --
    --         {
    --             "folke/lazydev.nvim",
    --             ft = "lua", -- only load on lua files
    --             opts = {
    --                 library = {
    --                     -- See the configuration section for more details
    --                     -- Load luvit types when the `vim.uv` word is found
    --                     { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    --                 },
    --             },
    --         },
    --         {
    --             "hrsh7th/cmp-nvim-lsp-signature-help",
    --             event = { "InsertEnter" },
    --         },
    --
    --     },
    --
    --     version = '*',
    --
    --     opts = {
    --
    --         keymap = {
    --             preset = 'default',
    --             ['<Enter>'] = { 'select_and_accept', "fallback" },
    --             ["<CR>"] = { "select_and_accept", "fallback" },
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
    --             nerd_font_variant = 'mono',
    --
    --             kind_icons = icon.lspkind,
    --         },
    --
    --         sources = {
    --             default = { 'lsp', 'path', 'snippets', 'luasnip', 'buffer', 'Tabnine', 'lazydev', "ripgrep", "nvim_lua", "nvim_lsp_signature_help" },
    --             cmdline = {},
    --             providers = {
    --                 lsp = {
    --                     name = 'LSP',
    --                     module = 'blink.cmp.sources.lsp',
    --                 },
    --                 snippets = {
    --                     min_keyword_length = 1, -- don't show when triggered manually, useful for JSON keys
    --                     score_offset = -1,
    --                     opts = {
    --                         search_paths = { NEOVIM_CONFIG_PATH .. "/lua/cmp/snippets/" },
    --                     },
    --                 },
    --                 path = {
    --                     opts = { get_cwd = vim.uv.cwd },
    --                 },
    --                 buffer = {
    --                     max_items = 4,
    --                     min_keyword_length = 4,
    --                     score_offset = -3,
    --                 },
    --                 Tabnine = {
    --                     name = 'cmp_tabnine',
    --                     module = 'blink.compat.source',
    --                     score_offset = -4,
    --
    --                     opts = {
    --                         max_lines = 1000,
    --                         max_num_results = 20,
    --                         sort = true,
    --                         run_on_every_keystroke = true,
    --                         snippet_placeholder = "..",
    --                         ignored_file_types = {
    --                         },
    --                         show_prediction_strength = true,
    --                         min_percent = 0,
    --
    --                     },
    --                 },
    --
    --                 lazydev = {
    --                     name = "LazyDev",
    --                     module = "lazydev.integrations.blink",
    --                     score_offset = 100, -- show at a higher priority than lsp
    --                 },
    --
    --                 ripgrep = {
    --                     module = "blink-cmp-rg",
    --                     name = "Ripgrep",
    --                     -- options below are optional, these are the default values
    --                     ---@type blink-cmp-rg.Options
    --                     opts = {
    --                         -- `min_keyword_length` only determines whether to show completion items in the menu,
    --                         -- not whether to trigger a search. And we only has one chance to search.
    --                         prefix_min_len = 3,
    --                         get_command = function(context, prefix)
    --                             return {
    --                                 "rg",
    --                                 "--no-config",
    --                                 "--json",
    --                                 "--word-regexp",
    --                                 "--ignore-case",
    --                                 "--",
    --                                 prefix .. "[\\w_-]+",
    --                                 vim.fs.root(0, ".git") or vim.fn.getcwd(),
    --                             }
    --                         end,
    --                         get_prefix = function(context)
    --                             return context.line:sub(1, context.cursor[2]):match("[%w_-]+$") or ""
    --                         end,
    --                     },
    --                 },
    --
    --                 nvim_lua = {
    --                     name = 'nvim_lua',
    --                     module = 'blink.compat.source',
    --                     score_offset = -7,
    --                 },
    --
    --                 treesitter = {
    --                     name = 'treesitter',
    --                     module = 'blink.compat.source',
    --                     score_offset = -8,
    --                 },
    --
    --                 nvim_lsp_signature_help = {
    --                     name = 'nvim_lsp_signature_help',
    --                     module = 'blink.compat.source',
    --                     score_offset = -9,
    --                 },
    --
    --             },
    --         },
    --
    --         completion = {
    --             accept = {
    --                 -- experimental auto-brackets support
    --                 auto_brackets = {
    --                     enabled = true,
    --                 },
    --             },
    --
    --             trigger = {
    --                 show_on_keyword = true,
    --                 show_on_trigger_character = true,
    --                 show_on_insert_on_trigger_character = true,
    --                 show_on_accept_on_trigger_character = true,
    --             },
    --             menu = {
    --                 border = 'single',
    --                 draw = {
    --                     treesitter = { 'lsp' },
    --                     columns = {
    --                         { "kind_icon" },
    --                         { "label" },
    --                         -- { "label_description" }
    --                     },
    --
    --                     components = {
    --                         label = {
    --                             width = { fill = true, max = 80 },
    --                             text = function(ctx)
    --                                 -- if ctx.source_name == "LSP" then
    --                                 --     log.error(ctx.item.detail)
    --                                 -- end
    --                                 if ctx.item.detail ~= nil then
    --                                     return ctx.label .. ctx.item.detail
    --                                 end
    --                                 return ctx.label
    --                             end,
    --                         },
    --                         label_description = {
    --                             width = { max = 50 },
    --                             text = function(ctx)
    --                                 -- if ctx.source_name == "LSP" then
    --                                 --     log.error(ctx.item)
    --                                 -- end
    --                                 return ctx.item.detail
    --                             end,
    --                         },
    --
    --                     },
    --                 },
    --                 auto_show = function(ctx)
    --                     return ctx.mode ~= "cmdline" and not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
    --                 end,
    --             },
    --             list = {
    --                 selection = function(ctx)
    --                     return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect'
    --                 end
    --             },
    --
    --             -- ghost_text = { enabled = true },
    --
    --             documentation = {
    --                 window = {
    --                     border = 'single'
    --                 },
    --                 auto_show = true,
    --                 auto_show_delay_ms = 200
    --             },
    --
    --         },
    --         signature = { enabled = true, window = { border = 'single' } },
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
    --     },
    -- },


}


return M
