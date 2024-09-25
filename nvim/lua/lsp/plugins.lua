local M = {}

M.list = {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local m = try_require("lsp.lsp")
            if m ~= nil then
                m.lspConfig()
            end
        end,
    },

    -- 适用于 Neovim 的轻量级但功能强大的格式化程序插件
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            default_format_opts = {
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                go = { "goimports-reviser" },
                -- cargo install sleek
                sql = { "sleek" },
                json = { "jq" },
                cpp = { lsp_format = "never" },
                zsh = { "shfmt", lsp_format = "never" },
                bash = { "shfmt", lsp_format = "never" },
                toml = { "taplo", lsp_format = "never" },
            },
            format_on_save = {
                timeout_ms = 200,
            },
        },
    },

    -- lsp_lines 是一个简单的 neovim 插件，它使用真实代码行之上的虚拟行来呈现诊断。
    --https://git.sr.ht/~whynothugo/lsp_lines.nvim
    {
        -- url 备份
        -- url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        url = "https://github.com/edte/lsp_lines.nvim",
        config = function()
            vim.diagnostic.config({
                virtual_text = false,
                update_in_insert = true,
                virtual_lines = {
                    -- only_current_line = true,
                    highlight_whole_line = false,
                },
            })
            require("lsp_lines").setup()
            vim.keymap.set("n", "g?", vim.diagnostic.open_float, { silent = true })
        end,
    },

    -- Clanalphagd 针对 neovim 的 LSP 客户端的不合规范的功能。使用 https://sr.ht/~p00f/clangd_extensions.nvim 代替
    {
        "p00f/clangd_extensions.nvim",
        ft = { "cpp", "h" },
        config = function()
            local clangd = try_require("clangd_extensions")
            if clangd == nil then
                return
            end
            clangd.setup()
        end,
    },

    -- jce 高亮
    {
        "edte/jce-highlight",
        ft = { "jce" },
    },

    -- Neovim 插件添加了对使用内置 LSP 的文件操作的支持
    {
        "antosha417/nvim-lsp-file-operations",
        ft = { "vue" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-tree.lua",
        },
        config = function()
            require("lsp-file-operations").setup()

            local lspconfig = require("lspconfig")
            lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
                capabilities = vim.tbl_deep_extend(
                    "force",
                    vim.lsp.protocol.make_client_capabilities(),
                    --     -- returns configured operations if setup() was already called
                    --     -- or default operations if not
                    require("lsp-file-operations").default_capabilities()
                ),
            })
        end,
    },

    -- 基于 Neovim 的命令预览功能的增量 LSP 重命名。
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        config = function()
            require("inc_rename").setup({})
        end,
    },

    -- Neovim 插件，用于显示 JB 的 IDEA 等函数的引用和定义信息。
    {
        "edte/lsp_lens.nvim",
        ft = { "lua", "go", "cpp" },
        config = function()
            local SymbolKind = vim.lsp.protocol.SymbolKind
            Setup("lsp-lens", {
                target_symbol_kinds = {
                    SymbolKind.Function,
                    SymbolKind.Method,
                    SymbolKind.Interface,
                    SymbolKind.Class,
                    SymbolKind.Struct, -- This is what you need
                },
                indent_by_lsp = false,
                sections = {
                    definition = function(count)
                        return "Definitions: " .. count
                    end,
                    references = function(count)
                        return "References: " .. count
                    end,
                    implements = function(count)
                        return "Implements: " .. count
                    end,
                    git_authors = function(latest_author, count)
                        return " " .. latest_author .. (count - 1 == 0 and "" or (" + " .. count - 1))
                    end,
                },
            })
        end,
    },

    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },

    -- 在分割窗口或弹出窗口中运行测试并提供实时反馈
    -- 这个插件太慢了，暂时不用
    {
        "quolpr/quicktest.nvim",
        -- ft = "go",
        lazy = true,
        config = function()
            local qt = require("quicktest")
            qt.setup({
                -- Choose your adapter, here all supported adapters are listed
                adapters = {
                    require("quicktest.adapters.golang")({
                        additional_args = function(bufnr)
                            return { "-race", "-count=1" }
                        end,
                    }),
                    require("quicktest.adapters.vitest")({}),
                    require("quicktest.adapters.elixir"),
                    require("quicktest.adapters.criterion"),
                    require("quicktest.adapters.dart"),
                },
                default_win_mode = "split",
                use_baleia = false,
            })
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            -- {
            --   "tl",
            --   function()
            --     require("quicktest").run_line()
            --   end,
            --   desc = "[T]est Run [L]line",
            -- },
            -- {
            --   "tt",
            --   function()
            --     require("quicktest").toggle_win("split")
            --   end,
            --   desc = "[T]est [T]oggle Window",
            -- },
            -- {
            --   "tc",
            --   function()
            --     require("quicktest").cancel_current_run()
            --   end,
            --   desc = "[T]est [C]ancel Current Run",
            -- },
        },
    },

    -- 一个漂亮的窗口，用于在一个地方预览、导航和编辑 LSP 位置，其灵感来自于 vscode 的 peek 预览。
    {
        "dnlhc/glance.nvim",
        config = function()
            require("glance").setup()
        end,
        cmd = "Glance",
    },

    -- 类似coplit，但是有点冲突，都是预览，tab接受，先注释掉不用
    -- Supermaven 的官方 Neovim 插件
    -- {
    -- 	"supermaven-inc/supermaven-nvim",
    -- 	config = function()
    -- 		require("supermaven-nvim").setup({})
    -- 	end,
    -- },

    -- 像使用 Cursor AI IDE 一样使用 Neovim！
    -- 但是没key，所以先注释掉不用
    -- {
    --   "yetone/avante.nvim",
    --   event = "VeryLazy",
    --   build = "make",
    --   opts = {
    --     -- add any opts here
    --   },
    --   dependencies = {
    --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    --     "stevearc/dressing.nvim",
    --     "nvim-lua/plenary.nvim",
    --     "MunifTanjim/nui.nvim",
    --     --- The below is optional, make sure to setup it properly if you have lazy=true
    --     {
    --       "MeanderingProgrammer/render-markdown.nvim",
    --       opts = {
    --         file_types = { "markdown", "Avante" },
    --       },
    --       ft = { "markdown", "Avante" },
    --     },
    --   },
    -- },

    ---------------------------------------------------golang 相关插件--------------------------------

    -- 显示接口实现了哪些
    {
        "maxandron/goplements.nvim",
        ft = "go",
        opts = {
            -- The prefixes prepended to the type names
            prefix = {
                interface = "implemented by: ",
                struct = "implements: ",
            },
            -- Whether to display the package name along with the type name (i.e., builtins.error vs error)
            display_package = false,
            -- The namespace to use for the extmarks (no real reason to change this except for testing)
            namespace_name = "goplements",
            -- The highlight group to use (if you want to change the default colors)
            -- The default links to DiagnosticHint
            highlight = "Goplements",
        },
    },

    -- go 插件
    {
        "ray-x/go.nvim",
        config = function()
            local r = try_require("lsp.go")
            if r ~= nil then
                r.goConfig()
            end
        end,
        event = { "CmdlineEnter" },
    },

    -- Neovim 插件可在您键入时自动添加或删除 Go 函数返回括号
    {
        "Jay-Madden/auto-fix-return.nvim",
        ft = "go",
        config = function()
            require("auto-fix-return").setup({})
        end,
    },

    -- 使用 ] r/[r 跳转到光标下项目的下一个 / 上一个 LSP 参考
    {
        "mawkler/refjump.nvim",
        keys = { "]r", "[r" }, -- Uncomment to lazy load
        opts = {},
    },

    -- -- 适用于 Visual Studio Code、Neovim 和其他 LSP 客户端的源代码拼写检查器
    -- {
    -- 	"tekumara/typos-lsp",
    -- },

    -- Neovim 中的 AI 聊天机器人无需 API 密钥
    {
        "RayenMnif/tgpt.nvim",
        cmd = { "Chat", "RateMyCode" },
        config = function()
            require("tgpt").setup()
        end,
    },
}

return M
