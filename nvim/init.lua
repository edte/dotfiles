local requires = {
    "alias", -- 这个必须调，各个地方用的很多

    -- 最小配置，用于测试
    -- "mini",

    -- 常用配置
    "lazys",
}

for _, r in ipairs(requires) do
    require(r)
end


-- vim.keymap.set({ 'n', 'v' }, '<C-k>', '<cmd>Treewalker Up<cr>', { silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<C-j>', '<cmd>Treewalker Down<cr>', { silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<C-h>', '<cmd>Treewalker Left<cr>', { silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<C-l>', '<cmd>Treewalker Right<cr>', { silent = true })
