-- 根据语言启动 lsp

local M = {
    lua_ls = { "lua" },
    gopls = { "go" },
    clangd = { "cpp", "c" },
    jsonls = { "json" },
    vimls = { "vim" },
    -- bashls = { "zsh", "sh", "bash" }, -- -- bashls不能这样，不知道为啥
}

for k, v in pairs(M) do
    Autocmd("FileType", {
        pattern = v,
        callback = function()
            vim.lsp.enable({ k })
        end,
        group = GroupId("lsp_enable_" .. k, { clear = true }),
    })
end

vim.lsp.enable({ "bashls" })
