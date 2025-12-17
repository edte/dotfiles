local M = {}

M.list = {


    -- lua MiniDiff.toggle_overlay()
    {
        "echasnovski/mini.diff",
        version = false,
        config = function()
            require("mini.diff").setup()
            Cmd("command! Diff lua MiniDiff.toggle_overlay()")
        end,
    },
}

return M
