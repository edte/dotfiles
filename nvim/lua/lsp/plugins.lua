local M = {}

M.list = {
    {
        "neovim/nvim-lspconfig",
        commit = "a89de2e",
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
        name = "codeLens",
        dir = "lsp.codelens",
        virtual = true,
        ft = { "lua", "go", "cpp" },
        config = function()
            require("lsp.codelens").setup()
        end,
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
        keys = {},
    },

    -- 一个漂亮的窗口，用于在一个地方预览、导航和编辑 LSP 位置，其灵感来自于 vscode 的 peek 预览。
    {
        "dnlhc/glance.nvim",
        config = function()
            require("glance").setup()
        end,
        cmd = "Glance",
    },



    -- go 插件
    {
        "ray-x/go.nvim",
        ft = "go",
        config = function()
            local go = try_require("go")
            if go == nil then
                return
            end
            go.setup()

            Command("GoAddTagEmpty", function()
                vim.api.nvim_command(":GoAddTag json -add-options json=")
            end, { nargs = "*" })

            require("lsp.go-return").setup({})

            require("lsp.go-impl").setup({
                -- Whether to display the package name along with the type name (i.e., builtins.error vs error)
                display_package = false,
                -- The namespace to use for the extmarks (no real reason to change this except for testing)
                namespace_name = "goplements",
                -- The highlight group to use (if you want to change the default colors)
                -- The default links to DiagnosticHint
                highlight = "Goplements",
            })
        end,
    },

    -- 使用 ] r/[r 跳转到光标下项目的下一个 / 上一个 LSP 参考
    {
        "mawkler/refjump.nvim",
        keys = { "]r", "[r" }, -- Uncomment to lazy load
        opts = {},
    },

    -- 显示更漂亮的诊断消息的 Neovim 插件。在光标所在位置显示诊断消息，并带有图标和颜色。
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        -- event = "LspAttach", -- Or `LspAttach`
        priority = 3000, -- needs to be loaded in first
        branch = "main",
        init = function()
            vim.diagnostic.config({
                virtual_text = false,
                update_in_insert = true,
                virtual_lines = {
                    -- only_current_line = true,
                    highlight_whole_line = false,
                },
            })
        end,
        config = function()
            -- Default configuration
            require("tiny-inline-diagnostic").setup({
                preset = "ghost", -- Can be: "modern", "classic", "minimal", "ghost", "simple", "nonerdfont", "amongus"

                options = {
                    -- Throttle the update of the diagnostic when moving cursor, in milliseconds.
                    -- You can increase it if you have performance issues.
                    -- Or set it to 0 to have better visuals.
                    throttle = 0,

                    -- The minimum length of the message, otherwise it will be on a new line.
                    softwrap = 30,

                    -- If multiple diagnostics are under the cursor, display all of them.
                    multiple_diag_under_cursor = true,

                    -- Enable diagnostic message on all lines.
                    multilines = true,

                    -- Show all diagnostics on the cursor line.
                    show_all_diags_on_cursorline = true,

                    -- Enable diagnostics on Insert mode. You should also se the `throttle` option to 0, as some artefacts may appear.
                    enable_on_insert = true,

                },
            })
        end
    },

    -- https://freshman.tech/vim-quickfix-and-location-list/
    -- {
    --     'stevearc/quicker.nvim',
    --     event = "FileType qf",
    --     opts = {},
    --     config = function()
    --         require("quicker").setup()
    --     end
    -- },

}

return M
