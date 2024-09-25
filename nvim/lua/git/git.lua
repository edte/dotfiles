-- Lua

local M = {}

M.diffConfig = function()
    local diff = try_require("diffview")
    if diff == nil then
        return
    end
    local actions = try_require("diffview.actions")
    if actions == nil then
        return
    end
    diff.setup({
        view = {
            -- Configure the layout and behavior of different types of views.
            -- Available layouts:
            --  'diff1_plain'
            --    |'diff2_horizontal'
            --    |'diff2_vertical'
            --    |'diff3_horizontal'
            --    |'diff3_vertical'
            --    |'diff3_mixed'
            --    |'diff4_mixed'
            -- For more info, see |diffview-config-view.x.layout|.
            default = {
                -- Config for changed files, and staged files in diff views.
                layout = "diff2_horizontal",
                disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
                winbar_info = false, -- See |diffview-config-view.x.winbar_info|
            },
            merge_tool = {
                -- Config for conflicted files in diff views during a merge or rebase.
                --  ('diff1_plain'|'diff3_horizontal'|'diff3_vertical'|'diff3_mixed'|'diff4_mixed'|-
                layout = "diff3_horizontal",
                disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
                winbar_info = true, -- See |diffview-config-view.x.winbar_info|
            },
            file_history = {
                -- Config for changed files in file history views.
                layout = "diff2_horizontal",
                disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
                winbar_info = false, -- See |diffview-config-view.x.winbar_info|
            },
        },
    })
end

return M
