local requires = {
    -- "base.mini",

    "alias",
    "options",
    "autocmds",
    "commands",
    "keymaps",
    "lazys",
}

for _, r in ipairs(requires) do
    require(r)
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


-- 搜索高亮颜色（根据需要修改颜色值）
  vim.api.nvim_set_hl(0, "Search", { fg = "#C8D3F5", bg = "#3E68D7" })
  vim.api.nvim_set_hl(0, "IncSearch", { fg = "#1B1D2B", bg = "#FF966C" })
  vim.api.nvim_set_hl(0, "CurSearch", { fg = "#1B1D2B", bg = "#FF966C" })


-- 文件类型自动识别
vim.filetype.add({
	extension = {
		log = "log",
	},
	pattern = {
		[".*/logs?/.*"] = "log", -- 匹配任何 logs 或 log 目录下的文件
	},
})

