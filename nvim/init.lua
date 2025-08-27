-- Neovim 初始化配置
-- 性能分析: PROF=1 nvim

local M = {}

-- 安全加载模块
local function safe_require(module)
	local ok, result = pcall(require, module)
	if not ok then
		vim.notify("加载模块失败: " .. module .. " - " .. result, vim.log.levels.ERROR)
		return nil
	end
	return result
end

-- 性能分析配置
local function setup_profiler()
	if not vim.env.PROF then
		return
	end

	local snacks_path = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
	if vim.fn.isdirectory(snacks_path) == 0 then
		vim.notify("Snacks.nvim 未找到，跳过性能分析", vim.log.levels.WARN)
		return
	end

	vim.opt.rtp:append(snacks_path)
	safe_require("snacks.profiler").startup({
		startup = { event = "VimEnter" },
	})
end

-- 主题配置
local function setup_theme()
	local colors = {
		line_number = "#808080",
		theme = "tokyonight",
	}

	vim.cmd.colorscheme(colors.theme)

	-- 统一设置行号颜色
	for _, hl_group in ipairs({ "LineNr", "LineNrAbove", "LineNrBelow" }) do
		vim.api.nvim_set_hl(0, hl_group, { fg = colors.line_number })
	end
end

-- 主初始化流程
function M.init()
	setup_profiler()

	-- 核心模块加载
	local modules = { "alias", "lazys" }
	for _, module in ipairs(modules) do
		safe_require(module)
	end

	setup_theme()
end

-- 启动
M.init()
