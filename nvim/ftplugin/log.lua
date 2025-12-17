if vim.bo.filetype ~= "log" then
	return
end

-- 定义高亮颜色组
-- vim.api.nvim_set_hl(0, "LogTimestamp", { fg = "#7aa2f7", bold = false })
vim.api.nvim_set_hl(0, "LogLevelDebug", { fg = "#9ece6a", bold = true })
vim.api.nvim_set_hl(0, "LogLevelError", { fg = "#f7768e", bold = true })
vim.api.nvim_set_hl(0, "LogLevelWarn", { fg = "#e0af68", bold = true })
vim.api.nvim_set_hl(0, "LogLevelInfo", { fg = "#7aa2f7", bold = true })
-- vim.api.nvim_set_hl(0, "LogFileLocation", { fg = "#bb9af7", bold = false })
-- vim.api.nvim_set_hl(0, "LogFunction", { fg = "#7dcfff", bold = false })
-- vim.api.nvim_set_hl(0, "LogNumber", { fg = "#ff9e64", bold = false })
-- vim.api.nvim_set_hl(0, "LogString", { fg = "#9ece6a", bold = false })
-- vim.api.nvim_set_hl(0, "LogBoolean", { fg = "#f7768e", bold = false })
-- vim.api.nvim_set_hl(0, "LogURL", { fg = "#7dcfff", underline = true })
-- vim.api.nvim_set_hl(0, "LogSuccess", { fg = "#9ece6a", bold = true })
vim.api.nvim_set_hl(0, "LogFailure", { fg = "#f7768e", bold = true })


-- 创建匹配规则
-- vim.fn.matchadd("LogTimestamp", "\\[\\d\\{4\\}-\\d\\{2\\}-\\d\\{2\\} \\d\\{2\\}:\\d\\{2\\}:\\d\\{2\\}\\.\\d\\+\\]")
vim.fn.matchadd("LogLevelDebug", "\\[DEBUG\\]")
vim.fn.matchadd("LogLevelError", "\\[ERROR\\]")
vim.fn.matchadd("LogLevelWarn", "\\[WARN\\]")
vim.fn.matchadd("LogLevelInfo", "\\[INFO\\]")
vim.fn.matchadd("LogFileLocation", "\\[\\w\\+\\.\\w\\+:\\d\\+\\]")
-- vim.fn.matchadd("LogFunction", "\\[\\zs[a-zA-Z0-9_.]\\+\\ze\\]")
-- vim.fn.matchadd("LogNumber", "\\d\\{10,\\}")
-- vim.fn.matchadd("LogString", "\"[^\"]*\"")
-- vim.fn.matchadd("LogBoolean", "true\\|false")
-- vim.fn.matchadd("LogURL", "https\\?://\\S\\+")
-- vim.fn.matchadd("LogSuccess", "succ\\|success\\|SUCCESS")
vim.fn.matchadd("LogFailure", "ERROR")



-- 设置基本选项
vim.opt_local.wrap = true
vim.opt_local.number = true
vim.opt_local.relativenumber = false
vim.opt_local.cursorline = true

