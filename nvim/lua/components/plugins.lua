local M = {}

M.list = {
    -- 展示颜色
    -- TODO: cmp 集成

    --TODO:
    --FIX:
    --NOTE:
    --WARN:
    -- {
    --     "echasnovski/mini.hipatterns",
    --     version = false,
    --     config = function()
    --         require("components.todo").config()
    --     end,
    -- },



    -- 自动保存会话
    -- 保存目录是：（不知道哪里配置的）
    -- /Users/edte/.local/state/nvim/view
    -- {
    --     name = "sessions",
    --     dir = "components.sessions",
    --     virtual = true,
    --     config = function()
    --         Require("components.session").setup()
    --
    --         Api.nvim_create_autocmd("VimEnter", {
    --             callback = function()
    --                 if vim.fn.argc(-1) == 0 then
    --                     -- local b = MiniSessions.config.directory .. a
    --                     --
    --                     -- if file_exists(b) then
    --                     --     return
    --                     -- end
    --
    --                     MiniSessions.read(GetPath())
    --                 end
    --             end,
    --             nested = true,
    --         })
    --         Api.nvim_create_autocmd("VimLeavePre", {
    --             callback = function()
    --                 MiniSessions.write(GetPath())
    --             end,
    --         })
    --     end
    -- },


    { --${conf, snacks.nvim}
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        init = function()
            highlight("SnacksPickerMatch", { italic = true, bold = true, bg = "#ffc777", fg = "#222436" })
        end,
        keys = {
            {
                "<space>.",
                function()
                    Snacks.scratch()
                end,
                desc = "scratch",
            },
            -- do 删除范围上下两行
            {
                "o",
                mode = "o",
                desc = "delete scope",
                function()
                    local operator = vim.v.operator
                    if operator == "d" then
                        local res
                        require("snacks").scope.get(function(scope)
                            res = scope
                        end)
                        local top = res.from
                        local bottom = res.to
                        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                        _ = col
                        local move = ""
                        if row == bottom then
                            move = "k"
                        elseif row == top then
                            move = "j"
                        end
                        local ns = vim.api.nvim_create_namespace("border")
                        vim.hl.range(0, ns, "Substitute", { top - 1, 0 }, { top - 1, -1 })
                        vim.hl.range(0, ns, "Substitute", { bottom - 1, 0 }, { bottom - 1, -1 })
                        vim.defer_fn(function()
                            vim.api.nvim_buf_set_text(0, top - 1, 0, top - 1, -1, {})
                            vim.api.nvim_buf_set_text(0, bottom - 1, 0, bottom - 1, -1, {})
                            vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
                        end, 150)
                        return "<esc>" .. move
                    else
                        return "o"
                    end
                end,
            },

            {
                "<M-n>",
                mode = { "n", "i" },
                function()
                    Snacks.terminal.toggle("zsh")
                end,
                desc = "Toggle floating terminal",
            },
            {
                "<m-n>",
                mode = { "t" },
                function()
                    Snacks.terminal.toggle("zsh")
                end,
                ft = "snacks_terminal",
                desc = "Toggle terminal",
            },
        },
        opts = {
            animate = { enabled = true },
            bigfile = { enabled = false },
            buffdelete = { enabled = true },
            dashboard = { enabled = false },
            debug = { enabled = false },
            dim = { enabled = false },
            explorer = { enabled = false },
            git = { enabled = false },
            gitbrowser = { enabled = false },
            image = {
                enabled = true,
                force = true, -- try displaying the image, even if the terminal does not support it
                doc = {
                    max_width = 150,
                    max_height = 100,
                },
            },
            indent = { enabled = true },
            input = { enabled = true },
            layout = { enable = true },
            lazygit = { enabled = false },
            notifier = { enabled = true },
            -- Snacks.notifier.show_history() 查询snacks notify history历史
            notify = { enabled = true },
            picker = {
                enabled = true,
                formatters = {
                    file = {
                        truncate = 60, -- truncate the file path to (roughly) this length
                    },
                },
                win = {
                    input = {
                        keys = {
                            ["<Esc>"] = { "close", mode = { "n", "i" } },
                        },
                    },
                    list = {
                        keys = {
                            ["<Esc>"] = { "close", mode = { "n", "i" } },
                        },
                    },
                    preview = {
                        keys = {
                            ["<Esc>"] = { "close", mode = { "n", "i" } },
                        },
                    },
                },
            },
            profiler = { enabled = true },
            quickfile = { enabled = true },
            rename = { enabled = true },
            scope = { enabled = true },
            scratch = { enabled = true },
            scroll = { enabled = false },
            statuscolumn = {
                enabled = true,
                left = { "mark" },  -- priority of signs on the left (high to low)
                right = { "fold" }, -- priority of signs on the right (high to low)
                folds = {
                    open = true,    -- show open fold icons
                    git_hl = false, -- use Git Signs hl for fold icons
                },
                git = {
                    -- patterns to match Git signs
                    patterns = { "MiniDiffSign" },
                },
                refresh = 50, -- refresh at most every 50ms
            },
            styles = {
                input = {
                    relative = "cursor",
                },
            },
            terminal = {
                enabled = true,
            },
            toggle = { enabled = false },
            health = { enabled = true },
            words = { enabled = true },
        },
        config = function(_, opts)
            require("snacks").setup(opts)

            _G.dd = function(...)
                Snacks.debug.inspect(...)
            end
            _G.bt = function()
                Snacks.debug.backtrace()
            end
            vim.print = _G.dd

            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesActionRename",
                callback = function(event)
                    Snacks.rename.on_rename_file(event.data.from, event.data.to)
                end,
            })
        end,
    },

    -- {
    --     "fei6409/log-highlight.nvim",
    --     ft = "log",
    --     config = function()
    --         require("log-highlight").setup({
    --             keyword = {
    --                 error = 'ERROR_MSG',
    --                 warning = { 'WARN_X', 'WARN_Y' },
    --                 info = { 'DEBUG' },
    --                 debug = {},
    --                 pass = {},
    --             },
    --
    --         })
    --     end,
    -- },



}
return M
