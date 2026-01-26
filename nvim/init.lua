-- 核心模块加载
local modules = { "alias", "lazys" }
for _, module in ipairs(modules) do
	require(module)
end

local colors = {
	line_number = "#808080",
	theme = "tokyonight",
}

vim.cmd.colorscheme(colors.theme)

-- 统一设置行号颜色
for _, hl_group in ipairs({ "LineNr", "LineNrAbove", "LineNrBelow" }) do
	vim.api.nvim_set_hl(0, hl_group, { fg = colors.line_number })
end

-- 分屏分隔线颜色（更醒目）
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#565f89", bg = "NONE" })

vim.cmd.source(vim.fn.stdpath("config") .. "/lua/vim/match.vim")

-- 启动nvim mcp，搞一个panel启动实例给模型用就行，正常注释
-- vim.fn.serverstart("/tmp/nvim.sock")
