local M = {}

M.config = function()
    --  隐藏文件和目录中的文件和文本搜索
    local telescope = Require("telescope")
    local telescopeConfig = Require("telescope.config")

    if telescope == nil then
        return
    end

    if telescopeConfig == nil then
        return
    end

    -- Clone the default Telescope configuration
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

    -- I want to search in hidden/dot files.
    vimgrep_arguments[#vimgrep_arguments + 1] = "--hidden"
    -- I don't want to search in the `.git` directory.
    vimgrep_arguments[#vimgrep_arguments + 1] = "--glob"
    vimgrep_arguments[#vimgrep_arguments + 1] = "!**/.git/*"

    telescope.setup({
        theme = "center",
        defaults = {
            -- `hidden = true` is not supported in text grep commands.
            vimgrep_arguments = vimgrep_arguments,
            preview = {
                filesize_limit = 0.1, -- MB
            },
            file_ignore_patterns = {
                "node_modules",
                ".git",
            },
        },
        pickers = {
            find_files = {
                -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            },
            buffers = {
                initial_mode = "insert",
            },
        },
    })
end

return M
