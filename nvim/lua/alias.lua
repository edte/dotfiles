-- =============================================================================
-- Neovim 工具函数库 - 全局别名和实用工具
-- =============================================================================

-- ============================ 路径配置变量 ============================
_G.NEOVIM_CONFIG_PATH = vim.fn.stdpath("config") -- Neovim 配置目录
_G.NEOVIM_SESSION_DATA = vim.fn.stdpath("data") .. "/session" -- 会话数据目录
_G.NEOVIM_BOOKMARKS_DATA = vim.fn.stdpath("data") .. "/bookmarks" -- 书签数据目录
_G.NEOVIM_MESSAGE_DATA = vim.fn.stdpath("state") .. "/message.log" -- 消息日志文件
_G.NEOVIM_LAZY_DATA = vim.fn.stdpath("data") .. "/lazy" -- Lazy.nvim 插件目录
_G.NEOVIM_UNDO_DATA = vim.fn.stdpath("state") .. "/undo" -- 撤销文件目录
_G.NEOVIM_SWAP_DATA = vim.fn.stdpath("state") .. "/swap" -- 交换文件目录
_G.NEOVIM_BACKUP_DATA = vim.fn.stdpath("state") .. "/backup" -- 备份文件目录

-- ============================ API 别名 ============================
_G.log = require("utils.log") -- 日志工具
_G.Api = vim.api -- Neovim API
_G.Command = vim.api.nvim_create_user_command -- 创建用户命令
_G.cmd = vim.cmd -- 执行 Vim 命令
_G.Autocmd = vim.api.nvim_create_autocmd -- 创建自动命令
_G.GroupId = vim.api.nvim_create_augroup -- 创建自动命令组
_G.Del_cmd = vim.api.nvim_del_user_command -- 删除用户命令
_G.icon = require("utils.icons") -- 图标工具
_G.icons = require("utils.icons") -- 图标工具别名

-- ============================ 显示相关函数 ============================

--- 屏幕居中当前行
_G.zz = function()
	Api.nvim_feedkeys("zz", "n", false)
end

--- 链接高亮组
--- @param name string 目标高亮组名
--- @param link string 源高亮组名
_G.link_highlight = function(name, link)
	Api.nvim_set_hl(0, name, {
		link = link,
		default = true,
	})
end

--- 设置高亮组
--- @param name string 高亮组名，如 "ErrorMsg"
--- @param fg string|table 前景色或完整高亮配置表
--- @param bg string 背景色
_G.highlight = function(name, fg, bg)
	if type(fg) == "table" then
		Api.nvim_set_hl(0, name, fg)
		return
	end

	local t = {}

	if fg then
		t["fg"] = fg
	end

	if bg then
		t["bg"] = bg
	end

	Api.nvim_set_hl(0, name, t)
end

-- ============================ 文件操作函数 ============================

--- 智能文件选择器：Git 项目中使用 git_files，否则使用普通文件选择
_G.project_files = function()
	local ret = vim.fn.system("git rev-parse --show-toplevel 2> /dev/null")
	if ret == "" then
		Snacks.picker.files()
	else
		Snacks.picker.git_files()
	end
end

--- 与剪贴板内容进行差异比较
_G.compare_to_clipboard = function()
	local ftype = Api.nvim_eval("&filetype")
	cmd(string.format(
		[[
  execute "normal! \"xy"
  vsplit
  enew
  normal! P
  setlocal buftype=nowrite
  set filetype=%s
  diffthis
  execute "normal! \<C-w>\<C-w>"
  enew
  set filetype=%s
  normal! "xP
  diffthis
  ]],
		ftype,
		ftype
	))
end

-- ============================ 模块加载工具 ============================

--- 安全地加载模块，避免 require 失败导致崩溃
--- @param package_name string 模块名
--- @return table|nil 加载的模块或 nil
function Require(package_name)
	local status, plugin = pcall(require, package_name)
	if not status then
		print("Error loading package " .. package_name .. ": " .. package_name)
		log.error("Error loading package " .. package_name .. ": " .. package_name)
		return nil
	else
		return plugin
	end
end

--- 安全地调用插件的 setup 函数
--- @param package_name string 插件名
--- @param options table|nil 配置选项
function Setup(package_name, options)
	local success, package = pcall(require, package_name)

	if not success then
		log.error("Error loading package " .. package_name .. ": " .. package)
		print("Error loading package " .. package_name .. ": " .. package)
		return
	end

	if type(package.setup) ~= "function" then
		log.error("Error: package " .. package_name .. " does not have a 'setup' function")
		print("Error: package " .. package_name .. " does not have a 'setup' function")
		return
	end

	if options == nil then
		options = {}
	else
		if type(options) ~= "table" then
			log.error("invalid table type: ", package_name, options)
			print("invalid table type: ", package_name, options)
			return
		end
	end

	package.setup(options)
end

-- ============================ 键映射工具 ============================

_G.nmap = function(lhs, rhs, opts)
	Keymap("n", lhs, rhs, opts)
end -- Normal 模式映射
_G.cmap = function(lhs, rhs, opts)
	Keymap("c", lhs, rhs, opts)
end -- Command 模式映射
_G.vmap = function(lhs, rhs, opts)
	Keymap("v", lhs, rhs, opts)
end -- Visual 模式映射
_G.imap = function(lhs, rhs, opts)
	Keymap("i", lhs, rhs, opts)
end -- Insert 模式映射
_G.xmap = function(lhs, rhs, opts)
	Keymap("x", lhs, rhs, opts)
end -- Visual Line 模式映射

--- 统一键映射设置函数
--- @param mode string 模式（n, i, v, c, x）
--- @param lhs string 左边键位
--- @param rhs string|function 右边命令或函数
--- @param opts table|nil 选项
_G.Keymap = function(mode, lhs, rhs, opts)
	if opts == nil then
		opts = { noremap = true, silent = true }
	end

	if type(rhs) == "string" then
		Api.nvim_set_keymap(mode, lhs, rhs, opts)
		return
	end

	if type(rhs) == "function" then
		vim.keymap.set(mode, lhs, rhs, opts)
		return
	end

	log.error("rhs type error", type(rhs))
end

-- ============================ 调试工具 ============================

--- 递归打印 table 内容
--- @param tbl table 要打印的 table
--- @param level number 递归层级
--- @param filteDefault boolean 是否过滤构造函数关键字
function Print(tbl, level, filteDefault)
	if type(tbl) ~= "table" then
		print(tbl)
		return
	end

	if tbl == nil then
		return
	end

	local msg = ""
	filteDefault = filteDefault or true
	level = level or 1
	local indent_str = ""
	for i = 1, level do
		indent_str = indent_str .. "  "
	end

	print(indent_str .. "{")
	for k, v in pairs(tbl) do
		if filteDefault then
			if k ~= "_class_type" and k ~= "DeleteMe" then
				local item_str = string.format("%s%s = %s", indent_str .. " ", tostring(k), tostring(v))
				print(item_str)
				if type(v) == "table" then
					Print(v, level + 1)
				end
			end
		else
			local item_str = string.format("%s%s = %s", indent_str .. " ", tostring(k), tostring(v))
			print(item_str)
			if type(v) == "table" then
				Print(v, level + 1)
			end
		end
	end
	print(indent_str .. "}")
end

-- ============================ 字符串工具 ============================

--- 字符串分割方法
--- @param sep string 分隔符
--- @return table 分割后的字符串数组
function string:split_b(sep)
	local cuts = {}
	for v in string.gmatch(self, "[^'" .. sep .. "']+") do
		cuts[#cuts + 1] = v
	end
	return cuts
end

--- 计算 UTF-8 字符串的字符长度（非字节长度）
--- @param input string 输入字符串
--- @return number 字符长度
_G.utf8len = function(input)
	local len = string.len(input)
	local left = len
	local cnt = 0
	local arr = { 0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc }
	while left ~= 0 do
		local tmp = string.byte(input, -left)
		local i = #arr
		while arr[i] do
			if tmp >= arr[i] then
				left = left - i
				break
			end
			i = i - 1
		end
		cnt = cnt + 1
	end
	return cnt
end

--- 检查字符串是否以指定前缀开头
--- @param String string 源字符串
--- @param Start string 前缀
--- @return boolean
function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

--- 检查字符串是否以指定后缀结尾
--- @param String string 源字符串
--- @param End string 后缀
--- @return boolean
function string.ends(String, End)
	return End == "" or string.sub(String, -string.len(End)) == End
end

-- ============================ 插件管理工具 ============================

--- 检查插件是否已加载
--- @param name string 插件名
--- @return boolean
function is_loaded(name)
	local Config = require("lazy.core.config")
	return Config.plugins[name] and Config.plugins[name]._.loaded
end

--- 获取插件配置选项
--- @param name string 插件名
--- @return table
function get_opts(name)
	local plugin = get_plugin(name)
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

--- 获取插件对象
--- @param name string 插件名
--- @return table|nil
function get_plugin(name)
	return require("lazy.core.config").spec.plugins[name]
end

--- 检查插件是否存在
--- @param plugin string 插件名
--- @return boolean
function has_plugin(plugin)
	return get_plugin(plugin) ~= nil
end

--- 插件加载完成后执行回调
--- @param name string 插件名
--- @param fn function 回调函数
function on_load(name, fn)
	if is_loaded(name) then
		fn(name)
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyLoad",
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	end
end
