local M = {}

M.list = {
    -- cmp 补全基础插件
    {
        "hrsh7th/nvim-cmp",
        config = function()
            require("cmp.cmp").setup()
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
            -- 路径补全，还是有用的
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

            -- go 导包
            {
                name = "cmp-go-pkgs",
                dir = "cmp.cmp_go_pkgs",
                virtual = true,
                ft = "go",

                config = function()
                    require("cmp.cmp_go_pkgs").new()
                    require("cmp").register_source("go_pkgs", require("cmp.cmp_go_pkgs"))
                    vim.api.nvim_create_user_command("CurNode", function(c)
                        require("cmp_go_pkgs.source").kek(c)
                    end, {})
                end
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
                    -- require("luasnip.loaders.from_vscode").lazy_load()
                    require("luasnip.loaders.from_lua").load({ paths = NEOVIM_CONFIG_PATH .. "/lua/cmp/luasnippets" })
                end,
                dependencies = {
                    -- "rafamadriz/friendly-snippets",
                },
            },


        },
        event = { "InsertEnter" },
    },

    -- 彩色补全
    {
        "xzbdmw/colorful-menu.nvim",
        version = "*",
        config = function()
            require("colorful-menu").setup({})
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

    -- Neovim 插件可快速插入日志语句并捕获日志输出
    -- glj	    :      在光标下方插入一条日志语句
    -- glk	    :      在光标上方插入一条日志语句
    -- glo	    :      在光标下方插入一条纯文本日志语句
    -- gl<S-o>	:      在光标上方插入一条纯文本日志语句
    -- gla      :      将日志目标添加到批处理中
    -- glb	    :      插入批处理日志语句
    {
        "Goose97/timber.nvim",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("timber").setup({
                log_templates = {
                    default = {
                        lua = [[log.debug("%log_target", %log_target)]],
                    },
                },
            })
        end
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
    --             -- dependencies = {
    --             --     "rafamadriz/friendly-snippets",
    --             -- },
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
    --         -- {
    --         --     name = "blink-go-pkgs",
    --         --     dir = "cmp.blink-go-pkgs",
    --         --     virtual = true,
    --         --     ft = "go",
    --         --     config = function()
    --         --         require("cmp.blink-go-pkgs")
    --         --     end
    --         -- },
    --
    --         {
    --             "edte/blink-go-import.nvim",
    --             ft = "go",
    --             config = function()
    --                 require("blink-go-import").setup()
    --             end
    --         },
    --
    --     },
    --
    --     opts = function()
    --         require("blink.cmp").setup({
    --             keymap = {
    --                 preset = 'default',
    --                 ['<Enter>'] = { 'select_and_accept', "fallback" },
    --                 ["<CR>"] = { "select_and_accept", "fallback" },
    --                 ["<Down>"] = { "select_next", "fallback" },
    --                 ["<Up>"] = { "select_prev", "fallback" },
    --                 ["<PageDown>"] = { "scroll_documentation_down" },
    --                 ["<PageUp>"] = { "scroll_documentation_up" },
    --             },
    --
    --             appearance = {
    --                 -- Sets the fallback highlight groups to nvim-cmp's highlight groups
    --                 -- Useful for when your theme doesn't support blink.cmp
    --                 -- will be removed in a future release
    --                 use_nvim_cmp_as_default = true,
    --                 -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    --                 -- Adjusts spacing to ensure icons are aligned
    --                 nerd_font_variant = 'mono',
    --
    --                 -- 这里只能写死，能根据source来源和kind类型动态么？
    --                 kind_icons = icon.kind,
    --             },
    --
    --             sources = {
    --                 default = { 'lsp', 'path', 'snippets', 'buffer', 'Tabnine', 'lazydev', "ripgrep", "nvim_lua", "go_import", "signature" },
    --                 cmdline = {},
    --                 providers = {
    --                     signature = {
    --                         name = 'nvim_lsp_signature_help',
    --                         module = 'blink.compat.source',
    --                         score_offset = -9,
    --                     },
    --
    --
    --                     go_import = {
    --                         name = 'Module',
    --                         module = 'blink-go-import',
    --                     },
    --                     lsp = {
    --                         name = 'LSP',
    --                         module = 'blink.cmp.sources.lsp',
    --                     },
    --                     snippets = {
    --                         min_keyword_length = 1, -- don't show when triggered manually, useful for JSON keys
    --                         score_offset = -1,
    --                         opts = {
    --                             search_paths = { NEOVIM_CONFIG_PATH .. "/lua/cmp/snippets/" },
    --                         },
    --                     },
    --                     path = {
    --                         opts = { get_cwd = vim.uv.cwd },
    --                     },
    --                     buffer = {
    --                         max_items = 4,
    --                         min_keyword_length = 4,
    --                         score_offset = -3,
    --                     },
    --                     Tabnine = {
    --                         name = 'cmp_tabnine',
    --                         module = 'blink.compat.source',
    --                         score_offset = -4,
    --
    --                         opts = {
    --                             max_lines = 1000,
    --                             max_num_results = 20,
    --                             sort = true,
    --                             run_on_every_keystroke = true,
    --                             snippet_placeholder = "..",
    --                             ignored_file_types = {
    --                             },
    --                             show_prediction_strength = true,
    --                             min_percent = 0,
    --
    --                         },
    --                     },
    --
    --                     lazydev = {
    --                         name = "LazyDev",
    --                         module = "lazydev.integrations.blink",
    --                         score_offset = 100, -- show at a higher priority than lsp
    --                     },
    --
    --                     ripgrep = {
    --                         module = "blink-cmp-rg",
    --                         name = "Ripgrep",
    --                         -- options below are optional, these are the default values
    --                         ---@type blink-cmp-rg.Options
    --                         opts = {
    --                             -- `min_keyword_length` only determines whether to show completion items in the menu,
    --                             -- not whether to trigger a search. And we only has one chance to search.
    --                             prefix_min_len = 3,
    --                             get_command = function(context, prefix)
    --                                 return {
    --                                     "rg",
    --                                     "--no-config",
    --                                     "--json",
    --                                     "--word-regexp",
    --                                     "--ignore-case",
    --                                     "--",
    --                                     prefix .. "[\\w_-]+",
    --                                     vim.fs.root(0, ".git") or vim.fn.getcwd(),
    --                                 }
    --                             end,
    --                             get_prefix = function(context)
    --                                 return context.line:sub(1, context.cursor[2]):match("[%w_-]+$") or ""
    --                             end,
    --                         },
    --                     },
    --
    --                     nvim_lua = {
    --                         name = 'nvim_lua',
    --                         module = 'blink.compat.source',
    --                         score_offset = -7,
    --                     },
    --
    --                     treesitter = {
    --                         name = 'treesitter',
    --                         module = 'blink.compat.source',
    --                         score_offset = -8,
    --                     },
    --
    --
    --                 },
    --             },
    --
    --             completion = {
    --                 accept = {
    --                     -- experimental auto-brackets support
    --                     auto_brackets = {
    --                         enabled = true,
    --                     },
    --                 },
    --
    --                 trigger = {
    --                     show_on_keyword = true,
    --                     show_on_trigger_character = true,
    --                     show_on_insert_on_trigger_character = true,
    --                     show_on_accept_on_trigger_character = true,
    --                 },
    --                 menu = {
    --                     border = 'single',
    --                     draw = {
    --                         treesitter = { 'lsp' },
    --                         columns = { { "kind_icon" }, { "label", gap = 1 } },
    --                         components = {
    --                             label = {
    --                                 text = require("colorful-menu").blink_components_text,
    --                                 highlight = require("colorful-menu").blink_components_highlight,
    --                             },
    --                             kind_icon = {
    --                                 ellipsis = false,
    --                                 text = function(ctx)
    --                                     if vim.bo.filetype == "go" then
    --                                         -- go 中非struct的type都是class，直接把这两都弄成一个icon
    --                                         if ctx.kind == "Struct" or ctx.kind == "Class" then
    --                                             ctx.kind_icon = icon.kind["Type"] or ""
    --                                         elseif ctx.source_name == "nvim_lsp_signature_help" and ctx.kind == "Text" then -- 参数提醒
    --                                             ctx.kind_icon = icon.kind["TypeParameter"] or ""
    --                                         elseif ctx.source_name == "treesitter" and ctx.kind == "Property" then          -- treesitter提醒
    --                                             ctx.kind_icon = icon.kind["Treesitter"] or ""
    --                                         elseif ctx.source_name == "cmp_tabnine" then
    --                                             ctx.kind_icon = icon.kind["TabNine"] or ""
    --                                         end
    --                                     end
    --
    --                                     return ctx.kind_icon .. ctx.icon_gap
    --                                 end,
    --                                 highlight = function(ctx)
    --                                     -- log.error(ctx.source_name, ctx.kind)
    --
    --                                     -- cmp icon highlight
    --                                     vim.cmd('highlight CmpItemKindFunction guifg=#CB6460')
    --                                     vim.cmd('highlight CmpItemKindInterface guifg=#659462')
    --                                     vim.cmd('highlight CmpItemKindConstant guifg=#BD805C')
    --                                     vim.cmd('highlight CmpItemKindVariable guifg=#BD805C')
    --                                     vim.cmd('highlight CmpItemKindStruct guifg=#6089EF')
    --                                     vim.cmd('highlight CmpItemKindClass guifg=#6089EF')
    --                                     vim.cmd('highlight CmpItemKindMethod guifg=#A25553')
    --                                     vim.cmd('highlight CmpItemKindField guifg=#BD805C')
    --
    --                                     if ctx.kind == "Function" then
    --                                         return "CmpItemKindFunction"
    --                                     elseif ctx.kind == "Interface" then
    --                                         return "CmpItemKindInterface"
    --                                     elseif ctx.kind == "Constant" then
    --                                         return "CmpItemKindConstant"
    --                                     elseif ctx.kind == "Variable" then
    --                                         return "CmpItemKindVariable"
    --                                     elseif ctx.kind == "Struct" then
    --                                         return "CmpItemKindStruct"
    --                                     elseif ctx.kind == "Class" then
    --                                         return "CmpItemKindClass"
    --                                     elseif ctx.kind == "Method" then
    --                                         return "CmpItemKindMethod"
    --                                     elseif ctx.kind == "Field" then
    --                                         return "CmpItemKindField"
    --                                     end
    --
    --                                     return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or
    --                                         'BlinkCmpKind' .. ctx.kind
    --                                 end,
    --                             },
    --                         },
    --                     },
    --                     auto_show = function(ctx)
    --                         return ctx.mode ~= "cmdline" and not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
    --                     end,
    --                 },
    --                 documentation = {
    --                     window = {
    --                         border = 'single'
    --                     },
    --                     auto_show = false,
    --                     auto_show_delay_ms = 200
    --                 },
    --             },
    --             signature = { enabled = false, window = { border = 'single' } },
    --         })
    --     end
    -- },

}

return M
