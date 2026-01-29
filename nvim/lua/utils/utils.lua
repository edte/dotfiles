local M = {}

--- 安全地加载模块，避免 require 失败导致崩溃
--- @param package_name string 模块名
--- @return table|nil 加载的模块或 nil
M.require = function(package_name)
	local status, plugin = pcall(require, package_name)
	if not status then
		print('Error loading package ' .. package_name .. ': ' .. package_name)
		log.error('Error loading package ' .. package_name .. ': ' .. package_name)
		return nil
	else
		return plugin
	end
end

--- 安全地调用插件的 setup 函数
--- @param package_name string 插件名
--- @param options table|nil 配置选项
M.setup = function(package_name, options)
	local success, package = pcall(require, package_name)

	if not success then
		log.error('Error loading package ' .. package_name .. ': ' .. package)
		print('Error loading package ' .. package_name .. ': ' .. package)
		return
	end

	if type(package.setup) ~= 'function' then
		log.error('Error: package ' .. package_name .. " does not have a 'setup' function")
		print('Error: package ' .. package_name .. " does not have a 'setup' function")
		return
	end

	if options == nil then
		options = {}
	else
		if type(options) ~= 'table' then
			log.error('invalid table type: ', package_name, options)
			print('invalid table type: ', package_name, options)
			return
		end
	end

	package.setup(options)
end

--- 递归打印 table 内容
--- @param tbl table 要打印的 table
--- @param level number 递归层级
--- @param filteDefault boolean 是否过滤构造函数关键字
M.print = function(tbl, level, filteDefault)
	if type(tbl) ~= 'table' then
		print(tbl)
		return
	end

	if tbl == nil then
		return
	end

	local msg = ''
	filteDefault = filteDefault or true
	level = level or 1
	local indent_str = ''
	for i = 1, level do
		indent_str = indent_str .. '  '
	end

	print(indent_str .. '{')
	for k, v in pairs(tbl) do
		if filteDefault then
			if k ~= '_class_type' and k ~= 'DeleteMe' then
				local item_str = string.format('%s%s = %s', indent_str .. ' ', tostring(k), tostring(v))
				print(item_str)
				if type(v) == 'table' then
					Print(v, level + 1)
				end
			end
		else
			local item_str = string.format('%s%s = %s', indent_str .. ' ', tostring(k), tostring(v))
			print(item_str)
			if type(v) == 'table' then
				Print(v, level + 1)
			end
		end
	end
	print(indent_str .. '}')
end

--- 屏幕居中当前行
M.zz = function()
	vim.api.nvim_feedkeys('zz', 'n', false)
end

--- 链接高亮组
--- @param name string 目标高亮组名
--- @param link string 源高亮组名
M.link_highlight = function(name, link)
	vim.api.nvim_set_hl(0, name, {
		link = link,
		default = true,
	})
end

--- 设置高亮组
--- @param name string 高亮组名，如 "ErrorMsg"
--- @param fg string|table 前景色或完整高亮配置表
--- @param bg string 背景色
M.highlight = function(name, fg, bg)
	if type(fg) == 'table' then
		vim.api.nvim_set_hl(0, name, fg)
		return
	end

	local t = {}

	if fg then
		t['fg'] = fg
	end

	if bg then
		t['bg'] = bg
	end

	vim.api.nvim_set_hl(0, name, t)
end

return M
