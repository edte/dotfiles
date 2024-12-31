-- https://vi.stackexchange.com/questions/4493/what-is-the-order-of-winenter-bufenter-bufread-syntax-filetype-events

-- autocmd({ "VimLeave" }, {
-- 	pattern = "*",
-- 	callback = function()
-- 		require("plenary.profile").stop()
-- 	end,
-- })

-- 这段自动命令可以防止你在一个注释行中换行后，新行会继续注释的情况
Autocmd({ "BufEnter" }, {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
    end,
    group = GroupId("comment_", { clear = true }),
})

-- 打开二进制文件
Cmd([[
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
Autocmd('BufReadPost', {
    desc = 'Open file at the last position it was edited earlier',
    group = GroupId('open-file-at-last-position', { clear = true }),
    pattern = '*',
    command = 'silent! normal! g`"zv'
})


-- Append backup files with timestamp
Autocmd("BufWritePre", {
    desc = 'Automatically backup files with timestamp and categorize by directory',
    group = GroupId('timestamp_backupext', { clear = true }),
    pattern = '*',
    callback = function()
        local dir = vim.fn.expand('%:p:h')
        local filename = vim.fn.expand('%:t')
        local timestamp = vim.fn.strftime("%Y-%m-%d-%H%M%S")
        local backup_dir = NEOVIM_BACKUP_DATA .. dir
        vim.fn.mkdir(backup_dir, 'p')
        vim.o.backupext = '-' .. timestamp
        vim.o.backupdir = backup_dir

        -- Limit the number of backups to 5
        -- Configurable limit for the number of backups
        local max_backups = vim.g.max_backups or 5

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
