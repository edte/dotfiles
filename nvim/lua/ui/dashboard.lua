local M = {}

-- TODO: 这里图标有点小，看能不能放大一点
M.config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    math.randomseed(os.time())

    dashboard.section.header.opts.hl = "Type"
    dashboard.section.header.opts.position = "center"
    dashboard.section.header.type = "text"
    dashboard.section.header.val = {
        [[          ▀████▀▄▄              ▄█ ]],
        [[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
        [[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
        [[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
        [[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
        [[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
        [[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
        [[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
        [[   █   █  █      ▄▄           ▄▀   ]],
    }

    dashboard.section.buttons.opts.spacing = 1
    dashboard.section.buttons.opts.hl_shortcut = "Include"
    dashboard.section.buttons.type = "group"
    dashboard.section.buttons.position = "center"
    dashboard.section.buttons.val = {
        dashboard.button("f", "     Find File ", "<cmd>lua project_files()<cr>"),
        dashboard.button("n", "     New File ", "<cmd>ene!<CR>"),
        dashboard.button("e", "     File Trees", "<cmd>lua ToggleMiniFiles()<CR>"),
        dashboard.button("r", "     Recently Files", "<cmd>FzfLua oldfiles<CR>"),
        dashboard.button("t", "     Find Texts", "<cmd>FzfLua live_grep_native<CR>"),
        dashboard.button("p", "     Plugins Status", "<cmd>Lazy<CR>"),
        -- TODO: 这里现在是nwtree的进入，改成直接进入
        dashboard.button("c", "     Configuration", "<cmd>edit " .. NEOVIM_CONFIG_PATH .. "/init.lua" .. "<CR>"),
        dashboard.button("q", "     Quit", "<CMD>quit<CR>" .. NEOVIM_CONFIG_PATH .. "<CR>"),
    }

    alpha.setup(dashboard.opts)

    Cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
end

return M
