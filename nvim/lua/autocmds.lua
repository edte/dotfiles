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
cmd([[
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
vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Open file at the last position it was edited earlier',
    group = GroupId('open-file-at-last-position', { clear = true }),
    pattern = '*',
    command = 'silent! normal! g`"zv'
})
