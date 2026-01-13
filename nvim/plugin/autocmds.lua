-- 这段自动命令可以防止你在一个注释行中换行后，新行会继续注释的情况
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
	end,
	group = vim.api.nvim_create_augroup("comment_", { clear = true }),
})

-- 在打开文件时跳转到上次编辑的位置
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("edit_cache", { clear = true }),
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
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

-- Close on "q"
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"help",
		"startuptime",
		"qf",
		"lspinfo",
		"man",
		"checkhealth",
		"neotest-output-panel",
		"neotest-summary",
		"lazy",
	},
	command = [[
          nnoremap <buffer><silent> q :close<CR>
          nnoremap <buffer><silent> <ESC> :close<CR>
          set nobuflisted
      ]],
})

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

vim.api.nvim_create_autocmd({ "LspDetach" }, {
	group = vim.api.nvim_create_augroup("LspStopWithLastClient", {}),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client or not client.attached_buffers then
			return
		end
		for buf_id in pairs(client.attached_buffers) do
			if buf_id ~= args.buf then
				return
			end
		end
		client:stop()
	end,
	desc = "Stop lsp client when no buffer is attached",
})

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

-- 自定义文件类型检测
vim.filetype.add({
	extension = {
		jce = "jce",
	},
})
