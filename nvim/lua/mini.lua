-- 最小配置

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "echasnovski/mini.sessions",
        config = function()
            require("mini.sessions").setup({
                autoread = false,
                autowrite = false,
            })

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
})
