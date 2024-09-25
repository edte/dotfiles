cmd("command! Pwd !ls %:p")
cmd("command! Cwd lua print(vim.fn.getcwd())")

vim.api.nvim_create_user_command('LiteralSearch', function(opts)
    vim.cmd('normal! /\\V' .. vim.fn.escape(opts.args, '\\'))
end, { nargs = 1 })
