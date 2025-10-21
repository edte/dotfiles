local function format_timestamp(timestamp)
	local formatted_time
	-- 判断时间戳是秒还是毫秒
	if string.len(timestamp) == 10 then
		formatted_time = os.date("%Y-%m-%d %H:%M:%S", timestamp) -- 10位时间戳，直接格式化
	elseif string.len(timestamp) == 13 then
		local seconds = math.floor(timestamp / 1000) -- 获取秒部分
		local milliseconds = timestamp % 1000 -- 获取毫秒部分
		formatted_time = os.date("%Y-%m-%d %H:%M:%S", seconds) .. string.format(".%03d", milliseconds) -- 格式化并附加毫秒
	else
		return nil -- 如果不是10位或13位，返回nil
	end
	return formatted_time
end

local function trim(s)
	return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

local function get_token()
	local c_row, c_col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_buf_get_lines(0, c_row - 1, c_row, false)[1]

	local result = ""
	local trim_line = trim(line)

	-- 新增判断：如果当前光标下的字符不是数字，直接返回
	local current_char = string.sub(trim_line, c_col + 1, c_col + 1)
	-- log.error(current_char)
	if tonumber(current_char) == nil then
		return current_char
	end

	-- 从光标位置向左查找数字
	for i = c_col, 1, -1 do
		local char = string.sub(trim_line, i, i)
		-- log.error(char)
		if tonumber(char) ~= nil then
			-- log.error("*")
			result = char .. result
		elseif result ~= "" then
			-- log.error("#")
			break
		else
			-- log.error("?")
			break
		end
	end

	-- 从光标位置向右查找数字
	for i = c_col + 1, #trim_line do
		local char = string.sub(trim_line, i, i)
		-- log.error(char)
		if tonumber(char) ~= nil then
			result = result .. char
		elseif result ~= "" then
			break
		else
			break
		end
	end

	return result
end

local function show_timestamp()
	local token = get_token()
	-- log.error(token)
	if token and token ~= "" then
		local timestamp = tonumber(token) -- 确保时间戳是数字
		-- 新增判断：如果 token 位数不是 10 或 13，直接返回
		if (string.len(token) == 10 or string.len(token) == 13) and timestamp then
			local formatted_time = format_timestamp(timestamp)
			vim.api.nvim_out_write(token .. " -> " .. formatted_time .. "\n")
			return
		end
	end

	vim.api.nvim_out_write("No valid timestamp, token:" .. token .. "\n")
end

-- 绑定快捷键
nmap("gt", show_timestamp)
