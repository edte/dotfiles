-- 用snack.profiler分析启动性能
-- `PROF=1 nvim` 启动
if vim.env.PROF then
	local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
	vim.opt.rtp:append(snacks)
	require("snacks.profiler").startup({
		startup = {
			event = "VimEnter",
		},
	})
end

local requires = {
	"alias", -- 函数别名
	"lazys", -- 插件
}

for _, r in ipairs(requires) do
	require(r)
end

-- 设置主题
vim.cmd([[colorscheme tokyonight]])

-- 行号颜色，必须在colorscheme之后
vim.api.nvim_set_hl(0, "LineNr", { fg = "#808080" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#808080" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#808080" })
