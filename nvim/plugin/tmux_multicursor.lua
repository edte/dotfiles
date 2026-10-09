-- Neovim 0.13 的 Kitty 多光标指令需要显式穿过 tmux。
if not vim.env.TMUX or not vim.env.TMUX_PANE or vim.g.tmux_multicursor_loaded then
	return
end
vim.g.tmux_multicursor_loaded = true

local mc = require('vim._core.mcursor')
local send = vim.api.nvim_ui_send
local pane = vim.env.TMUX_PANE
local previous
local supported = false
local format = '#{pane_left}|#{pane_top}|#{pane_width}|#{pane_height}|#{pane_active}|#{window_active}'
	.. '|#{session_attached}|#{pane_in_mode}|#{status-position}|#{status}'

local function passthrough(sequence)
	send('\027Ptmux;' .. sequence:gsub('\027', '\027\027') .. '\027\\')
end

local function geometry()
	local result = vim.system({ 'tmux', 'display-message', '-p', '-t', pane, format }, { text = true }):wait(200)
	if result.code ~= 0 then
		return
	end
	local fields = vim.split(vim.trim(result.stdout), '|', { plain = true })
	-- 后台窗口、多个客户端和复制模式不绘制终端光标。
	if fields[5] ~= '1' or fields[6] ~= '1' or fields[7] ~= '1' or fields[8] ~= '0' then
		return
	end
	local left, top, width, height = tonumber(fields[1]), tonumber(fields[2]), tonumber(fields[3]), tonumber(fields[4])
	if not left or not top or not width or not height then
		return
	end
	if fields[9] == 'top' then
		top = top + (tonumber(fields[10]) or (fields[10] == 'on' and 1 or 0))
	end
	return { left = left, top = top, width = width, height = height }
end

local function clear(area)
	return ('\027[>0;4:%d:%d:%d:%d q'):format(area.top + 1, area.left + 1, area.top + area.height, area.left + area.width)
end

local function detect()
	if supported or not geometry() then
		return
	end
	vim.tty.request('\027Ptmux;\027\027[> q\027\\', {}, function(response)
		local shapes = response:match('^\027%[>([%d;]*) q$')
		if not shapes then
			return
		end
		if not vim.list_contains(vim.split(shapes, ';', { plain = true }), '29') then
			return true
		end
		supported = true
		vim.api.nvim_ui_send = function(sequence)
			if not sequence:match('^\027%[>[%d;:]* q') then
				return send(sequence)
			end
			local area = geometry()
			if not area then
				return
			end
			local prefix = previous and clear(previous) or ''
			previous = area
			sequence = sequence:gsub('\027%[>(%d+)([%d;:]*) q', function(shape, coordinates)
				if shape == '0' then
					return clear(area)
				elseif shape == '29' then
					coordinates = coordinates:gsub('2:(%d+):(%d+)', function(row, col)
						return ('2:%d:%d'):format(tonumber(row) + area.top, tonumber(col) + area.left)
					end)
				end
				return '\027[>' .. shape .. coordinates .. ' q'
			end)
			passthrough(prefix .. sequence)
		end
		mc.tty_cursors(true)
		return true
	end)
end

local group = vim.api.nvim_create_augroup('tmux_multicursor', { clear = true })
vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'VimResume', 'VimResized' }, {
	group = group,
	callback = function()
		vim.schedule(function()
			if supported then
				mc.tty_cursors(false)
				mc.tty_cursors(true)
			else
				detect()
			end
		end)
	end,
})
vim.api.nvim_create_autocmd({ 'VimLeavePre', 'VimSuspend' }, {
	group = group,
	callback = function()
		if previous and geometry() then
			passthrough(clear(previous))
		end
	end,
})
vim.schedule(detect)
