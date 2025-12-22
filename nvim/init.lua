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

require("vim.match").setup()
