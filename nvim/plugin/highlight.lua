if vim.env.Test then
    return
end

vim.api.nvim_set_hl(0, "LineNr", { fg = "#808080" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#808080" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#808080" })
