-- 这段自动命令可以防止你在一个注释行中换行后，新行会继续注释的情况
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
	end,
	group = vim.api.nvim_create_augroup("comment_", { clear = true }),
})

-- 在打开文件时跳转到上次编辑的位置
-- mini.sessions 恢复会话时跳过 zz 居中，保留 session 保存的原始视图位置
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("edit_cache", { clear = true }),
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			-- vim.g.SessionLoad 在 :source session.vim 过程中为 1
			if vim.g.SessionLoad == 1 then
				vim.cmd('normal! g`"')
			else
				vim.cmd('normal! g`"zz')
			end
		end
	end,
})

-- Append backup files with timestamp
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Automatically backup files with timestamp and categorize by directory",
	group = vim.api.nvim_create_augroup("timestamp_backupext", { clear = true }),
	pattern = "*",
	callback = function()
		local dir = vim.fn.expand("%:p:h")
		local filename = vim.fn.expand("%:t")
		local timestamp = vim.fn.strftime("%Y-%m-%d-%H%M%S")
		local backup_dir = NEOVIM_BACKUP_DATA .. dir
		vim.fn.mkdir(backup_dir, "p")
		vim.o.backupext = "-" .. timestamp
		vim.o.backupdir = backup_dir

		-- Reduced from 2 to 1 to minimize backup storage and cleanup time
		-- Cleanup is now done asynchronously to avoid blocking
		local max_backups = vim.g.max_backups or 1

		-- Perform cleanup asynchronously to avoid blocking editor
		vim.schedule(function()
			local backups = vim.fn.globpath(backup_dir, filename .. "-*")
			if backups == "" then
				return
			end
			local backup_list = vim.split(backups, "\n")
			if #backup_list > max_backups then
				table.sort(backup_list, function(a, b)
					return a > b
				end) -- Sort descending to keep newest
				for i = max_backups + 1, #backup_list do
					vim.fn.delete(backup_list[i])
				end
			end
		end)
	end,
})

-- 有点问题，区分不了需要使用的分屏，比如diff的时候
-- Dim inactive windows
-- vim.cmd("highlight default DimInactiveWindows guifg=#666666")
-- vim.api.nvim_create_autocmd({ "WinLeave" }, {
-- 	group = vim.api.nvim_create_augroup("EnableDimInactiveWindows", { clear = true }),
-- 	callback = function()
-- 		if vim.bo.filetype == "minifiles" or vim.bo.filetype == "DiffviewFiles" then
-- 			return
-- 		end
--
-- 		local highlights = {}
-- 		for hl, _ in pairs(vim.api.nvim_get_hl(0, {})) do
-- 			table.insert(highlights, hl .. ":DimInactiveWindows")
-- 		end
-- 		vim.wo.winhighlight = table.concat(highlights, ",")
-- 	end,
-- })
-- vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
-- 	group = vim.api.nvim_create_augroup("DisableDimInactiveWindows", { clear = true }),
-- 	callback = function()
-- 		if vim.bo.filetype == "minifiles" or vim.bo.filetype == "DiffviewFiles" then
-- 			return
-- 		end
-- 		vim.wo.winhighlight = ""
-- 	end,
-- })

-- Show cursorline only on active windows
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	callback = function()
		if vim.w.auto_cursorline then
			vim.wo.cursorline = true
			vim.w.auto_cursorline = false
		end
	end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	callback = function()
		if vim.wo.cursorline then
			vim.w.auto_cursorline = true
			vim.wo.cursorline = false
		end
	end,
})

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {

	pattern = "term://*",
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			local set = vim.opt_local
			set.number = false -- Don't show numbers
			set.relativenumber = false -- Don't show relativenumbers
			set.scrolloff = 0 -- Don't scroll when at the top or bottom of the terminal buffer

			vim.opt.filetype = "terminal"

			vim.cmd.startinsert() -- Start in insert mode
		end
	end,
})

-- Remove hl search when enter Insert
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
	desc = "Remove hl search when enter Insert",
	callback = vim.schedule_wrap(function()
		vim.cmd.nohlsearch()
	end),
})

-- Updates scrolloff on startup and when window is resized
-- https://github.com/tonymajestro/smart-scrolloff.nvim/
vim.api.nvim_create_autocmd({ "WinResized" }, {
	group = vim.api.nvim_create_augroup("smart-scrolloff", { clear = true }),
	callback = function()
		local scrolloffPercentage = 0.2
		vim.opt.scrolloff = math.floor(vim.o.lines * scrolloffPercentage)
	end,
})

vim.cmd([[
augroup diffcolors
    autocmd!
    autocmd Colorscheme * call s:SetDiffHighlights()
augroup END

function! s:SetDiffHighlights()
    if &background == "dark"
        highlight DiffAdd gui=bold guifg=none guibg=#2e4b2e
        highlight DiffDelete gui=bold guifg=none guibg=#4c1e15
        highlight DiffChange gui=bold guifg=none guibg=#45565c
        highlight DiffText gui=bold guifg=none guibg=#996d74
    else
        highlight DiffAdd gui=bold guifg=none guibg=palegreen
        highlight DiffDelete gui=bold guifg=none guibg=tomato
        highlight DiffChange gui=bold guifg=none guibg=lightblue
        highlight DiffText gui=bold guifg=none guibg=lightpink
    endif
endfunction
]])

-- Delete empty [No Name] buffer when closing a tab
vim.api.nvim_create_autocmd("TabClosed", {
	group = vim.api.nvim_create_augroup("TabCleanUp", { clear = true }),
	callback = function()
		local buffers = vim.api.nvim_list_bufs()

		for _, bufnr in ipairs(buffers) do
			if
				api.nvim_buf_is_loaded(bufnr)
				and api.nvim_buf_get_name(bufnr) == ""
				-- Important: check for empty buffer type to avoid issues with
				-- plugins like snacks or telescope which use scratch buffers for
				-- preview, for example. They usually set buftype to something like
				-- 'nofile' or 'prompt'.
				and api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
			then
				local is_modified = api.nvim_get_option_value("modified", { buf = bufnr })
				if not is_modified then
					local is_empty = vim.api.nvim_buf_line_count(bufnr) == 1
						and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == ""

					-- Check that the empty buffer is not shown in any window and therefore can be deleted
					local windows = vim.fn.win_findbuf(bufnr)
					if is_empty and #windows == 0 then
						pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
					end
				end
			end
		end
	end,
})

-- :FdDiagnostic  诊断 fd 泄漏
-- 正常 nvim: channels < 50, fds < 100
-- 异常: fds 上千通常意味着插件 socket 泄漏 (如 CodeCompanion ACP 未回收)
vim.api.nvim_create_user_command('FdDiagnostic', function()
	local chans = vim.api.nvim_list_chans()
	local pid = vim.fn.getpid()

	-- 用 systemlist 拿每一行，自己在 lua 里过滤，避免 shell 引号转义坑
	local lines = vim.fn.systemlist('lsof -p ' .. pid .. ' 2>/dev/null')
	local fd_count, unix_count = 0, 0
	for i, line in ipairs(lines) do
		if i > 1 and line ~= '' then -- 跳过 header
			fd_count = fd_count + 1
			-- lsof 输出第 5 列是 TYPE，列间用若干空格分隔
			local _, _, _, _, typ = line:match('^(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
			if typ == 'unix' then
				unix_count = unix_count + 1
			end
		end
	end

	local msg = string.format(
		'nvim pid=%d\nchannels=%d\nfds=%d  (unix sockets: %d)',
		pid, #chans, fd_count, unix_count
	)
	vim.notify(msg, vim.log.levels.INFO, { title = 'FD diagnostic' })
end, { desc = 'Show nvim channel / fd count for leak diagnosis' })

-- :FdSnap  拍快照，记录当前 fd 列表
-- :FdDiff  对比当前与上次快照的差异，输出新增的 fd（带类型和 peer 信息）
-- 用法: :FdSnap -> 切一次 buffer -> :FdDiff  就能看到新增 socket 来自哪里
local fd_snapshot = nil

local function list_fds()
	local pid = vim.fn.getpid()
	local lines = vim.fn.systemlist('lsof -p ' .. pid .. ' 2>/dev/null')
	local set = {}
	for i, line in ipairs(lines) do
		if i > 1 and line ~= '' then
			-- 用 FD 列（第 4 列）作为 key，整行作为 value
			local _, _, _, fd = line:match('^(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
			if fd then
				set[fd] = line
			end
		end
	end
	return set
end

vim.api.nvim_create_user_command('FdSnap', function()
	fd_snapshot = list_fds()
	local n = 0
	for _ in pairs(fd_snapshot) do n = n + 1 end
	vim.notify('Snapshot taken: ' .. n .. ' fds', vim.log.levels.INFO, { title = 'FD snap' })
end, { desc = 'Take a snapshot of current fds' })

vim.api.nvim_create_user_command('FdDiff', function()
	if not fd_snapshot then
		vim.notify('Run :FdSnap first', vim.log.levels.WARN)
		return
	end
	local now = list_fds()
	local added = {}
	for fd, line in pairs(now) do
		if not fd_snapshot[fd] then
			table.insert(added, line)
		end
	end
	if #added == 0 then
		vim.notify('No new fds since last snapshot', vim.log.levels.INFO)
		return
	end
	-- 按类型分组统计 + 列出前 20 条详情
	local by_type = {}
	for _, line in ipairs(added) do
		local _, _, _, _, typ = line:match('^(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
		typ = typ or '?'
		by_type[typ] = (by_type[typ] or 0) + 1
	end
	local summary = { '=== Added fds: ' .. #added .. ' ===' }
	for typ, cnt in pairs(by_type) do
		table.insert(summary, string.format('  %s: %d', typ, cnt))
	end
	table.insert(summary, '--- sample (first 20) ---')
	for i = 1, math.min(20, #added) do
		table.insert(summary, added[i])
	end
	-- 写到新 buffer 方便查看
	vim.cmd('new')
	vim.api.nvim_buf_set_lines(0, 0, -1, false, summary)
	vim.bo.buftype = 'nofile'
end, { desc = 'Diff fds against last snapshot' })

-- :SpawnTraceOn  / :SpawnTraceOff  / :SpawnTraceShow
-- 拦截 vim.fn.jobstart / vim.system / vim.uv.spawn，把每次调用的命令+调用栈记录下来
-- 诊断步骤:
--   :SpawnTraceOn   -> 切一次 buffer -> :SpawnTraceShow
local spawn_trace = {
	enabled = false,
	events = {},
	orig = {},
}

local function record(label, arg)
	if not spawn_trace.enabled then return end
	-- 取简短调用栈（跳过我们自己的 wrapper 层）
	local stack = debug.traceback('', 3)
	table.insert(spawn_trace.events, {
		label = label,
		arg = arg,
		stack = stack,
		time = os.time(),
	})
end

local function stringify_cmd(cmd)
	if type(cmd) == 'string' then return cmd end
	if type(cmd) == 'table' then return table.concat(cmd, ' ') end
	return tostring(cmd)
end

vim.api.nvim_create_user_command('SpawnTraceOn', function()
	if spawn_trace.enabled then
		vim.notify('Already on', vim.log.levels.WARN)
		return
	end
	spawn_trace.events = {}
	spawn_trace.orig.jobstart = vim.fn.jobstart
	spawn_trace.orig.system = vim.system
	spawn_trace.orig.uv_spawn = vim.uv.spawn

	vim.fn.jobstart = function(cmd, opts)
		record('jobstart', stringify_cmd(cmd))
		return spawn_trace.orig.jobstart(cmd, opts)
	end
	vim.system = function(cmd, opts, on_exit)
		record('vim.system', stringify_cmd(cmd))
		return spawn_trace.orig.system(cmd, opts, on_exit)
	end
	vim.uv.spawn = function(path, opts, on_exit)
		record('uv.spawn', path .. ' ' .. (opts and opts.args and table.concat(opts.args, ' ') or ''))
		return spawn_trace.orig.uv_spawn(path, opts, on_exit)
	end

	spawn_trace.enabled = true
	vim.notify('Spawn trace ON', vim.log.levels.INFO)
end, { desc = 'Start tracing process spawns' })

vim.api.nvim_create_user_command('SpawnTraceOff', function()
	if not spawn_trace.enabled then return end
	vim.fn.jobstart = spawn_trace.orig.jobstart
	vim.system = spawn_trace.orig.system
	vim.uv.spawn = spawn_trace.orig.uv_spawn
	spawn_trace.enabled = false
	vim.notify('Spawn trace OFF (events captured: ' .. #spawn_trace.events .. ')', vim.log.levels.INFO)
end, { desc = 'Stop tracing' })

vim.api.nvim_create_user_command('SpawnTraceShow', function()
	if #spawn_trace.events == 0 then
		vim.notify('No events. Run :SpawnTraceOn first', vim.log.levels.WARN)
		return
	end
	-- 统计每个命令出现次数
	local counts = {}
	for _, e in ipairs(spawn_trace.events) do
		local key = e.label .. '  ' .. (e.arg or '')
		counts[key] = (counts[key] or 0) + 1
	end
	local lines = { '=== Spawn Trace (' .. #spawn_trace.events .. ' events) ===', '' }
	table.insert(lines, '--- Command frequency ---')
	local sorted = {}
	for k, v in pairs(counts) do table.insert(sorted, { cmd = k, n = v }) end
	table.sort(sorted, function(a, b) return a.n > b.n end)
	for _, item in ipairs(sorted) do
		table.insert(lines, string.format('  %4d x  %s', item.n, item.cmd))
	end
	table.insert(lines, '')
	table.insert(lines, '--- Sample stacks (first 5 events) ---')
	for i = 1, math.min(5, #spawn_trace.events) do
		local e = spawn_trace.events[i]
		table.insert(lines, string.format('[%d] %s: %s', i, e.label, e.arg or ''))
		for stackline in (e.stack or ''):gmatch('[^\n]+') do
			table.insert(lines, '    ' .. stackline)
		end
		table.insert(lines, '')
	end
	vim.cmd('new')
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	vim.bo.buftype = 'nofile'
end, { desc = 'Show spawn trace results' })
