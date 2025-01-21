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
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "mistweaverco/kulala-ls",
        },
        config = function()
            local nvim_lsp = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            local servers = {
                "kulala_ls",
                "gopls",
            }
            for _, lsp in ipairs(servers) do
                if nvim_lsp[lsp] ~= nil then
                    if nvim_lsp[lsp].setup ~= nil then
                        nvim_lsp[lsp].setup({
                            capabilities = capabilities,
                        })
                    else
                        vim.notify("LSP server " .. lsp .. " does not have a setup function", vim.log.levels.ERROR)
                    end
                end
            end
        end,
    }
})
