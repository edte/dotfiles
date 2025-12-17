Cmd("command! Pwd !ls %:p")
Cmd("command! Cwd lua print(vim.uv.cwd())")

Api.nvim_create_user_command('LiteralSearch', function(opts)
    Cmd('normal! /\\V' .. vim.fn.escape(opts.args, '\\'))
end, { nargs = 1 })
