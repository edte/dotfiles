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
            require("components.todo").setup()
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

        branch = "dev",

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
            require("components.session").setup()

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
                    if vim.fn.argc(-1) > 0 then
                        Cmd("argdelete *")
                    end

                    MiniSessions.write(GetPath())
                end,
            })
        end
    },

    -- 用于 CSV 文件编辑的 Neovim 插件。
    -- {
    --     'hat0uma/csvview.nvim',
    --     ft = {"csv", "tsv"},
    --     config = function()
    --         require('csvview').setup({
    --             view = {
    --                 display_mode = "border",
    --             },
    --             delimiter = {
    --                 default = ",",
    --                 ft = {
    --                     tsv = "\t",
    --                 },
    --             },
    --         })
    --
    --         Autocmd({ "FileType" }, {
    --             pattern = "csv",
    --             callback = function()
    --                 Cmd("CsvViewEnable")
    --             end,
    --         })
    --         Autocmd({ "FileType" }, {
    --             pattern = "tsv",
    --             callback = function()
    --                 -- Cmd("vim.opt_local.expandtab = true")
    --                 Cmd(":%s/	/,/g")
    --                 Cmd("set ft=csv")
    --                 Cmd("CsvViewEnable")
    --             end,
    --         })
    --     end
    -- },



    -- {
    --     "chrisbra/csv.vim",
    -- },
    --

    -- cp 选择颜色
    {
        "edte/colortils.nvim",
        keys = { "cp" },
        config = function()
            nmap("cp", "<cmd>Colortils<CR>")
            require("colortils").setup()
            highlight("ColortilsCurrentLine", "#A10000")
        end,
    },

    -- 📸 功能丰富的快照插件，可以为 Neovim 制作漂亮的代码快照
    {
        "mistricky/codesnap.nvim",
        build = "make",
        keys = {
            { "<leader>c", "<cmd>CodeSnap<cr>", mode = "x", desc = "snapshot" },
        },
    },

    -- Screencast your keys in Neovim
    {
        "NStefan002/screenkey.nvim",
        cmd = "Screenkey",
        lazy = false,
        version = "*", -- or branch = "dev", to use the latest commit
    },

    -- neovim 交互式数据库客户端
    {
        "kndndrj/nvim-dbee",
        dependencies = {
            {
                "MunifTanjim/nui.nvim",
                config = function()
                    local NuiTable = require("nui.table")

                    function render_tsv_as_table()
                        local lines = {}
                        local headers = {}
                        local data = {}

                        -- Get the current buffer number
                        local bufnr = vim.api.nvim_get_current_buf()

                        -- Get the filetype of the current buffer
                        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

                        -- Check if the filetype is tsv
                        if filetype ~= "tsv" then
                            log.error("Error: Current buffer is not a TSV file.")
                            return
                        end

                        -- Get the lines from the current buffer
                        lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

                        -- log.error(vim.api.nvim_buf_get_option("0", {"filetype"}), lines, #lines)

                        if #lines == 1 then
                            return
                        end

                        if #lines > 0 then
                            headers = vim.split(lines[1], "\t")
                            for i = 2, #lines do
                                local row = {}
                                local values = vim.split(lines[i], "\t")
                                for j, header in ipairs(headers) do
                                    row[header] = values[j]
                                end
                                table.insert(data, row)
                            end
                        else
                            log.error("Error: Current buffer is empty.")
                            return
                        end

                        -- Clear the current buffer
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

                        local tbl = NuiTable({
                            bufnr = bufnr,
                            columns = vim.tbl_map(function(header)
                                return {
                                    align = "center",
                                    accessor_key = header,
                                    header = header,
                                }
                            end, headers),
                            data = data,
                        })

                        tbl:render()
                    end
                end
            },
        },
        build = function()
            -- Install tries to automatically detect the install method.
            -- if it fails, try calling it with one of these parameters:
            --    "curl", "wget", "bitsadmin", "go"
            require("dbee").install()
        end,
        config = function()
            require("dbee").setup( --[[optional config]])
        end,
    },


    -- http 请求
    {
        'mistweaverco/kulala.nvim',
        opts = {
            display_mode = "float",
            default_winbar_panes = { "body", "headers", "headers_body" },
            contenttypes = {
                ["application/csv"] = {
                    ft = "csv",
                },
                ["text/csv"] = {
                    ft = "csv",
                },
                ["text/tsv"] = {
                    ft = "tsv",
                    formatter = function(body)
                        -- return body:gsub("\t", ",")
                        return body
                    end,
                    pathresolver = function(body, path)
                        -- print(body)
                        return body
                    end,
                },
            },
        },
    },

    -- 轻松将图像嵌入到任何标记语言中，例如 LaTeX、Markdown 或 Typst
    {
        "HakonHarnes/img-clip.nvim",
        cmd = "PasteImage",
        opts = {
        },
    },

    -- 局部run代码
    {
        "michaelb/sniprun",
        branch = "master",
        cmd = "SnipRun",

        build = "sh install.sh",
        -- do 'sh install.sh 1' if you want to force compile locally
        -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

        config = function()
            require("sniprun").setup({
                display = {
                    "VirtualText", --# display results as virtual text
                    "Terminal",    --# display ok results as virtual text (multiline is shortened)
                },
            })
        end,
    },

}

return M
