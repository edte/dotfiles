local M = {}

M.config = function()
    local make_pattern_in_comment = function(pattern)
        return function(buf_id)
            local cs = vim.bo[buf_id].commentstring
            if cs == nil or cs == "" then
                cs = "# %s"
            end

            -- Extract left and right part relative to '%s'
            local left, right = cs:match("^(.*)%%s(.-)$")
            left, right = vim.trim(left), vim.trim(right)
            -- General ideas:
            -- - Line is commented if it has structure
            -- "whitespace - comment left - anything - comment right - whitespace"
            -- - Highlight pattern only if it is to the right of left comment part
            --   (possibly after some whitespace)
            -- Example output for '/* %s */' commentstring: '^%s*/%*%s*()TODO().*%*/%s*'
            return string.format("^%%s*%s%%s*()%s().*%s%%s*$", vim.pesc(left), pattern, vim.pesc(right))
        end
    end

    -- 创建高亮组
    vim.api.nvim_set_hl(0, "HG_TODO_LIST_WARN", { bold = true, bg = "#ffc777", fg = "#222436" })
    vim.api.nvim_set_hl(0, "HG_TODO_LIST_FIX", { bold = true, bg = "#c53b53", fg = "#c8d3f5" })
    vim.api.nvim_set_hl(0, "HG_TODO_LIST_NOTE", { bold = true, bg = "#4fd6be", fg = "#222436" })
    vim.api.nvim_set_hl(0, "HG_TODO_LIST_TODO", { bold = true, bg = "#0db9d7", fg = "#222436" })

    Command("TODO", function()
        require("fzf-lua").grep({ search = "TODO:", no_esc = true })
    end, { nargs = "*" })

    Command("WARN", function()
        require("fzf-lua").grep({ search = "TODO:", no_esc = true })
    end, { nargs = "*" })

    Command("FIX", function()
        require("fzf-lua").grep({ search = "FIX:", no_esc = true })
    end, { nargs = "*" })

    Command("NOTE", function()
        require("fzf-lua").grep({ search = "NOTE:", no_esc = true })
    end, { nargs = "*" })

    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
        highlighters = {
            fix = { pattern = make_pattern_in_comment("FIX:"), group = "HG_TODO_LIST_FIX" },
            warn = { pattern = make_pattern_in_comment("WARN:"), group = "HG_TODO_LIST_WARN" },
            todo = { pattern = make_pattern_in_comment("TODO:"), group = "HG_TODO_LIST_TODO" },
            note = { pattern = make_pattern_in_comment("NOTE:"), group = "HG_TODO_LIST_NOTE" },

            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
end

return M
