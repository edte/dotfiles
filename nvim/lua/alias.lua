-- utils alias

------------------------------------------------- var --------------------------------------------------
_G.NEOVIM_CONFIG_PATH = vim.fn.stdpath("config")
_G.NEOVIM_SESSION_DATA = vim.fn.stdpath("data") .. "/session"
_G.NEOVIM_BOOKMARKS_DATA = vim.fn.stdpath("data") .. "/bookmarks"
_G.NEOVIM_MESSAGE_DATA = vim.fn.stdpath("state") .. "/message.log"
_G.NEOVIM_LAZY_DATA = vim.fn.stdpath("data") .. "/lazy"
_G.NEOVIM_UNDO_DATA = vim.fn.stdpath("state") .. "/undo"
_G.NEOVIM_SWAP_DATA = vim.fn.stdpath("state") .. "/swap"
_G.NEOVIM_BACKUP_DATA = vim.fn.stdpath("state") .. "/backup"

_G.log = require("utils.log")
_G.Api = vim.api
_G.Command = vim.api.nvim_create_user_command
_G.cmd = vim.cmd
_G.Autocmd = vim.api.nvim_create_autocmd
_G.GroupId = vim.api.nvim_create_augroup
_G.Del_cmd = vim.api.nvim_del_user_command
_G.icon = require("utils.icons")
_G.icons = require("utils.icons")

_G.zz = function()
	Api.nvim_feedkeys("zz", "n", false)
end

_G.link_highlight = function(name, link)
	Api.nvim_set_hl(0, name, {
		link = link,
		default = true,
	})
end

--- @param name string Highlight group name, e.g. "ErrorMsg"
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

_G.project_files = function()
	local ret = vim.fn.system("git rev-parse --show-toplevel 2> /dev/null")
	if ret == "" then
		require("fzf-lua").files()
	else
		require("fzf-lua").git_files()
	end
end

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

-- 使用 pcall 和 require 尝试加载包
function Require(package_name)
	local status, plugin = pcall(require, package_name)
	if not status then
		-- 如果加载失败，打印错误信息
		print("Error loading package " .. package_name .. ": " .. package_name)
		log.error("Error loading package " .. package_name .. ": " .. package_name)
		return nil
	else
		-- 如果加载成功，返回包
		return plugin
	end
end

function Setup(package_name, options)
	-- 尝试加载包，捕获加载过程中的错误
	local success, package = pcall(require, package_name)

	if not success then
		-- 如果加载失败，打印错误信息
		log.error("Error loading package " .. package_name .. ": " .. package)
		print("Error loading package " .. package_name .. ": " .. package)
		return
	end

	-- 检查包是否具有 'setup' 函数
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

	-- 调用包的 'setup' 函数进行设置
	package.setup(options)
end

_G.nmap = function(lhs, rhs, opts)
	Keymap("n", lhs, rhs, opts)
end

_G.cmap = function(lhs, rhs, opts)
	Keymap("c", lhs, rhs, opts)
end

_G.vmap = function(lhs, rhs, opts)
	Keymap("v", lhs, rhs, opts)
end

_G.imap = function(lhs, rhs, opts)
	Keymap("i", lhs, rhs, opts)
end

_G.xmap = function(lhs, rhs, opts)
	Keymap("x", lhs, rhs, opts)
end

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

---
-- @function: 打印table的内容，递归
-- @param: tbl 要打印的table
-- @param: level 递归的层数，默认不用传值进来
-- @param: filteDefault 是否过滤打印构造函数，默认为是
-- @return: return
function Print(tbl, level, filteDefault)
	if type(tbl) ~= "table" then
		print(tbl)
		return
	end

	if tbl == nil then
		return
	end

	local msg = ""
	filteDefault = filteDefault or true --默认过滤关键字（DeleteMe, _class_type）
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

--  字符串扩展方法 split_b，用于将字符串按照指定的分隔符 sep 进行分割，并返回一个包含切割结果的表
function string:split_b(sep)
	local cuts = {}
	for v in string.gmatch(self, "[^'" .. sep .. "']+") do
		cuts[#cuts + 1] = v
	end

	return cuts
end

_G.utf8len = function(input)
	local len = string.len(input) --这里获取到的长度为字节数，如示例长度为：21，而我们肉眼看到的长度应该是15（包含空格）
	local left = len --将字节长度赋值给将要使用的变量，作为判断退出while循环的字节长度
	local cnt = 0 --将要返回的字符长度
	local arr = { 0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc } --用来判断是否满足字节长度的列表
	while left ~= 0 do --遍历每一个字符
		--获取字节的ASCII值，这里的 “-” 代表反向对应的索引，-left：input反着第left
		--假设字符串字符input长度是：21，left的值是：21，那string.byte(input, -left)就是第一个字节的ASCII值
		local tmp = string.byte(input, -left) --看上面两行
		local i = #arr --获取判断列表的长度，同时作为字节长度
		while arr[i] do --循环判定列表
			if tmp >= arr[i] then --判定当前 “字符” 的 头“字节” ACSII值符合的范围
				left = left - i --字符串字节长度 -i，也就是 减去字节长度
				break --结束判断
			end
			i = i - 1 --每次判断失败都说明不符合当前字节长度
		end
		cnt = cnt + 1 --“字符” 长度+1
	end
	return cnt --返回 “字符” 长度
end

function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

function string.ends(String, End)
	return End == "" or string.sub(String, -string.len(End)) == End
end

function ToggleMiniFiles()
	local mf = require("mini.files")
	if not mf.close() then
		local n = Api.nvim_buf_get_name(0)
		if n ~= "" then
			mf.open(n)
			mf.reveal_cwd()
		else
			mf.open()
			mf.reveal_cwd()
		end
	end
end

function is_loaded(name)
	local Config = require("lazy.core.config")
	return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
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

function get_opts(name)
	local plugin = get_plugin(name)
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

function get_plugin(name)
	return require("lazy.core.config").spec.plugins[name]
end

function has_plugin(plugin)
	return get_plugin(plugin) ~= nil
end

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
