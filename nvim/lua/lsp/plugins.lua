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

    -- {
    --     'Wansmer/symbol-usage.nvim',
    --     event = 'LspAttach', -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    --     config = function()
    --         -- require('symbol-usage').setup({
    --         --     vt_position = 'end_of_line',
    --         -- })
    --         local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end
    --
    --         -- hl-groups can have any name
    --         vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
    --         vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
    --         vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
    --         vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
    --         vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })
    --
    --         local function text_format(symbol)
    --             local res = {}
    --
    --             local round_start = { '', 'SymbolUsageRounding' }
    --             local round_end = { '', 'SymbolUsageRounding' }
    --
    --             -- Indicator that shows if there are any other symbols in the same line
    --             local stacked_functions_content = symbol.stacked_count > 0
    --                 and ("+%s"):format(symbol.stacked_count)
    --                 or ''
    --
    --             if symbol.references then
    --                 local usage = symbol.references <= 1 and 'usage' or 'usages'
    --                 local num = symbol.references == 0 and 'no' or symbol.references
    --                 table.insert(res, round_start)
    --                 table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
    --                 table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
    --                 table.insert(res, round_end)
    --             end
    --
    --             if symbol.definition then
    --                 if #res > 0 then
    --                     table.insert(res, { ' ', 'NonText' })
    --                 end
    --                 table.insert(res, round_start)
    --                 table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
    --                 table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
    --                 table.insert(res, round_end)
    --             end
    --
    --             if symbol.implementation then
    --                 if #res > 0 then
    --                     table.insert(res, { ' ', 'NonText' })
    --                 end
    --                 table.insert(res, round_start)
    --                 table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
    --                 table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
    --                 table.insert(res, round_end)
    --             end
    --
    --             if stacked_functions_content ~= '' then
    --                 if #res > 0 then
    --                     table.insert(res, { ' ', 'NonText' })
    --                 end
    --                 table.insert(res, round_start)
    --                 table.insert(res, { ' ', 'SymbolUsageImpl' })
    --                 table.insert(res, { stacked_functions_content, 'SymbolUsageContent' })
    --                 table.insert(res, round_end)
    --             end
    --
    --             return res
    --         end
    --
    --         require('symbol-usage').setup({
    --             text_format = text_format,
    --             vt_position = 'end_of_line',
    --         })
    --     end
    -- },

    -- Neovim 插件，用于显示 JB 的 IDEA 等函数的引用和定义信息。
    {
        "edte/lsp_lens.nvim",
        ft = { "lua", "go", "cpp" },
        config = function()
            local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end

            vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

            -- local usage = symbol.references <= 1 and 'usage' or 'usages'
            -- table.insert(res, round_start)
            -- table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
            -- table.insert(res, { ('%s %s'):format(count, usage), 'SymbolUsageContent' })
            -- table.insert(res, round_end)


            local SymbolKind = vim.lsp.protocol.SymbolKind
            Setup("lsp-lens", {
                target_symbol_kinds = {
                    SymbolKind.Function,
                    SymbolKind.Method,
                    SymbolKind.Interface,
                    SymbolKind.Class,
                    SymbolKind.Struct, -- This is what you need
                    SymbolKind.Variable,
                    SymbolKind.Constant,
                    SymbolKind.Constructor,
                    SymbolKind.Namespace,
                    SymbolKind.File,
                    SymbolKind.Enum,
                },
                indent_by_lsp = false,
                sections = {
                    definition = function(count)
                        -- return "Definitions: " .. count
                        return ""
                    end,
                    references = function(count)
                        if count == 1 then
                            return '󰌹 ' .. count .. " usage"
                        end
                        return '󰌹 ' .. count .. " usages"
                    end,
                    implements = function(count)
                        if count == 1 then
                            return '󰡱 ' .. count .. " impl"
                        end
                        return '󰡱 ' .. count .. " impls"
                    end,
                    git_authors = function(latest_author, count)
                        return " " .. latest_author .. (count - 1 == 0 and "" or (" + " .. count - 1))
                    end,
                },
            })
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
    {
        'stevearc/quicker.nvim',
        event = "FileType qf",
        opts = {},
        config = function()
            require("quicker").setup()
        end
    },

}

return M
