-- https://vi.stackexchange.com/questions/4493/what-is-the-order-of-winenter-bufenter-bufread-syntax-filetype-events

-- autocmd({ "VimLeave" }, {
-- 	pattern = "*",
-- 	callback = function()
-- 		require("plenary.profile").stop()
-- 	end,
-- })

-- 这段自动命令可以防止你在一个注释行中换行后，新行会继续注释的情况
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
    end,
    group = vim.api.nvim_create_augroup("comment_", { clear = true }),
})

-- 打开二进制文件
vim.cmd([[
	" vim -b : edit binary using xxd-format!
	augroup Binary
	  autocmd!
	  autocmd BufReadPre  *.bin set binary
	  autocmd BufReadPost *.bin
	    \ if &binary
	    \ |   execute "silent %!xxd -c 32"
	    \ |   set filetype=xxd
	    \ |   redraw
	    \ | endif
	  autocmd BufWritePre *.bin
	    \ if &binary
	    \ |   let s:view = winsaveview()
	    \ |   execute "silent %!xxd -r -c 32"
	    \ | endif
	  autocmd BufWritePost *.bin
	    \ if &binary
	    \ |   execute "silent %!xxd -c 32"
	    \ |   set nomodified
	    \ |   call winrestview(s:view)
	    \ |   redraw
	    \ | endif
	augroup END
]])


-- 在打开文件时跳转到上次编辑的位置
vim.api.nvim_create_autocmd("BufReadPost", {
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
    desc = 'Automatically backup files with timestamp and categorize by directory',
    group = vim.api.nvim_create_augroup('timestamp_backupext', { clear = true }),
    pattern = '*',
    callback = function()
        local dir = vim.fn.expand('%:p:h')
        local filename = vim.fn.expand('%:t')
        local timestamp = vim.fn.strftime("%Y-%m-%d-%H%M%S")
        local backup_dir = NEOVIM_BACKUP_DATA .. dir
        vim.fn.mkdir(backup_dir, 'p')
        vim.o.backupext = '-' .. timestamp
        vim.o.backupdir = backup_dir

        -- Limit the number of backups to 2
        -- Configurable limit for the number of backups
        local max_backups = vim.g.max_backups or 2

        local backups = vim.fn.globpath(backup_dir, filename .. '-*')
        local backup_list = vim.split(backups, '\n')
        if #backup_list > max_backups then
            table.sort(backup_list)
            for i = 1, #backup_list - max_backups do
                vim.fn.delete(backup_list[i])
            end
        end
    end,
})


-- 有点问题，区分不了需要使用的分屏，比如diff的时候
-- Dim inactive windows
-- vim.cmd("highlight default DimInactiveWindows guifg=#666666")
-- vim.api.nvim_create_autocmd({ "WinLeave" }, {
--     group = vim.api.nvim_create_augroup("EnableDimInactiveWindows", { clear = true }),
--     callback = function()
--         if vim.bo.filetype == "minifiles" or vim.bo.filetype == "DiffviewFiles" then
--             return
--         end
--
--         local highlights = {}
--         for hl, _ in pairs(vim.api.nvim_get_hl(0, {})) do
--             table.insert(highlights, hl .. ":DimInactiveWindows")
--         end
--         vim.wo.winhighlight = table.concat(highlights, ",")
--     end,
-- })
-- vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
--     group = vim.api.nvim_create_augroup("DisableDimInactiveWindows", { clear = true }),
--     callback = function()
--         if vim.bo.filetype == "minifiles" or vim.bo.filetype == "DiffviewFiles" then
--             return
--         end
--         vim.wo.winhighlight = ""
--     end,
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
            set.number = false         -- Don't show numbers
            set.relativenumber = false -- Don't show relativenumbers
            set.scrolloff = 0          -- Don't scroll when at the top or bottom of the terminal buffer
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

-- 退出的时候也会写message到日志文件
-- 调试用
-- Redir message
-- vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "CmdlineEnter" }, {
--     group = vim.api.nvim_create_augroup("redir-message-begin", { clear = true }),
--     callback = function()
--         Cmd("redir >> " .. NEOVIM_MESSAGE_DATA)
--     end,
-- })
--
-- vim.api.nvim_create_autocmd("VimLeave", {
--     group = vim.api.nvim_create_augroup("redir-message-end", { clear = true }),
--     callback = function()
--         Cmd("redir END")
--     end,
-- })
