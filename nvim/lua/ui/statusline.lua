local statusline_augroup = GroupId("native_statusline", { clear = true })
local icons = require("icons")

local function getProjectName()
    if vim.env.TMUX ~= nil then
        return vim.fn.system({ "tmux", "display-message", "-p", "#W" }):gsub("%c", "")
    end

    if vim.fn.system([[git rev-parse --show-toplevel 2> /dev/null]]) == "" then
        -- print("pwd")
        return vim.fn.system("basename $(pwd)"):gsub("%c", "")
    end

    local res = vim.fn.system([[git config --local remote.origin.url|sed -n 's#.*/\([^.]*\)\.git#\1#p']]):gsub("%c", "")
    if res ~= "" then
        -- print("git remote")
        return res
    end

    -- print("git local")
    return vim.fn.system([[ TOP=$(git rev-parse --show-toplevel); echo ${TOP##*/} ]]):gsub("%c", "")
end

-- LSP clients attached to buffer

local function get_lsp()
    local current_buf = vim.api.nvim_get_current_buf()

    local clients = vim.lsp.get_clients({ bufnr = current_buf })
    if next(clients) == nil then
        return ""
    end

    local c = {}
    for _, client in pairs(clients) do
        table.insert(c, client.name)
    end
    return "[" .. table.concat(c, ",") .. "]"
end

local function get_file()
    local fname = vim.fn.expand("%:t")
    if fname == "" then
        return vim.bo.filetype
    end
    return fname .. " "
end

local function get_branch()
    local res = vim.fn.system("git branch --show-current"):gsub("%c", "")
    if res == "致命错误：不是 git 仓库（或者任何父目录）：.git" then
        return ""
    end
    return "  " .. res
end

local function get_time()
    return os.date("%H:%M", os.time())
end

Autocmd({ "WinEnter", "BufEnter", "FileType" }, {
    group = statusline_augroup,
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "minifiles" or vim.bo.filetype == "alpha" then
            vim.o.laststatus = 0
            return
        end
        vim.o.laststatus = 3

        StatusLine.project_name = "%#StatusLineProject#" .. getProjectName()
        StatusLine.file = "%#StatusLineFilename#" .. get_file()
        StatusLine.branch = "%#StatusLineGitBranch#" .. get_branch()
        StatusLine.time = "%#StatusLineTime#" .. get_time()
    end,
})

-- cmdheight =0 之后，进入insert模式,statusline会消失,所以需要手动重绘
vim.cmd([[
autocmd ModeChanged * lua vim.schedule(function() vim.cmd('redraw') end)
]])

Autocmd("LspProgress", {
    group = statusline_augroup,
    desc = "Update LSP progress in statusline",
    pattern = { "begin", "report", "end" },
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end

        lsp_progress = {
            client = vim.lsp.get_client_by_id(args.data.client_id),
            kind = args.data.params.value.kind,
            message = args.data.params.value.message,
            percentage = args.data.params.value.percentage,
            title = args.data.params.value.title,
        }

        if lsp_progress.kind == "end" then
            lsp_progress.title = nil
            vim.defer_fn(function()
                vim.cmd.redrawstatus()
            end, 500)
        else
            vim.cmd.redrawstatus()
        end

        StatusLine.lsp_clients = "%#StatusLineLSP#" .. get_lsp()
    end,
})

StatusLine = {
    project_name,
    file,
    branch,
    diagnostics,
    get_lsp,
    time,
}

-- 定义高亮组
vim.api.nvim_set_hl(0, "StatusLineProject", { fg = "#D3869B", bg = "#1E1E2E", bold = true })
vim.api.nvim_set_hl(0, "StatusLineFilename", { fg = "#83A598", bg = "#1E1E2E", bold = true })
vim.api.nvim_set_hl(0, "StatusLineGitBranch", { fg = "#8EC07C", bg = "#1E1E2E", bold = true })
vim.api.nvim_set_hl(0, "StatusLineLSP", { fg = "#7AA2F7", bg = "#1E1E2E", bold = true })
vim.api.nvim_set_hl(0, "StatusLineTime", { fg = "#D5C4A1", bg = "#1E1E2E", bold = true })

StatusLine.active = function()
    local statusline = {
        StatusLine.project_name or "",
        icons.ui.DividerRight,
        StatusLine.file,
        icons.ui.DividerRight,
        StatusLine.branch or "",
        "%=",
        StatusLine.lsp_clients or "",
        icons.ui.DividerLeft,
        StatusLine.time or "",
    }

    return table.concat(statusline)
end

vim.opt.statusline = "%!v:lua.StatusLine.active()"
