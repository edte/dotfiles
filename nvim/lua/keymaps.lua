-- --==========================================luvar_vim keybinding settings===============================================================
-- 取消lunar的一些默认快捷键

if vim.fn.has("nvim-0.11") == 1 then
    vim.keymap.del("", "grr", {})
    vim.keymap.del("", "gra", {})
    vim.keymap.del("", "grn", {})
    vim.keymap.del("", "gcc", {})
end

-- cmd("nmap <tab> %")

Keymap("n", "}", "}w")
Keymap("n", "}", "}j")
Cmd("nnoremap <expr><silent> { (col('.')==1 && len(getline(line('.')-1))==0? '2{j' : '{j')")

-- 上下滚动浏览
Keymap("", "<C-j>", "5j")
Keymap("", "<C-k>", "5k")

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll up and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll down and center" })

vim.keymap.set("n", "n", "nzzzv", { desc = "keep cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "keep cursor centered" })

-- 保存文件
Keymap("", "<C-s>", "<cmd>w<cr>")

-- 删除整行
-- keymap("", "D", "Vd")

Keymap("n", "c", '"_c')

-- -- 设置 jj、jk 为 ESC,避免频繁按 esc
Keymap('i', 'jk', '<Esc><right>')


-- 按 esc 消除上一次的高亮
Keymap("n", "<esc>", "<cmd>noh<cr>")


vim.keymap.set("n", "<esc>", function()
    local function isModuleAvailable(name)
        if package.loaded[name] then
            return true
        else
            for _, searcher in ipairs(package.searchers or package.loaders) do
                local loader = searcher(name)
                if type(loader) == "function" then
                    package.preload[name] = loader
                    return true
                end
            end
            return false
        end
    end

    Cmd(":nohlsearch")
    if isModuleAvailable("clever-f") then
        Cmd(":call clever_f#reset()")
        return
    end
end, { desc = "esc", noremap = true, buffer = true })

Api.nvim_set_keymap('n', '<C-i>', '<C-i>zz', { noremap = true, silent = true })
Api.nvim_set_keymap('n', '<C-o>', '<C-o>zz', { noremap = true, silent = true })

-- 大小写转换
-- map("n", "<esc>", "~", opt)

-- what?
-- map("n", "<cmd>lua vim.lsp.buf.hover()<cr>", opt)

Keymap("n", "yp", 'vi"p')
Keymap("n", "vp", 'vi"p')

----------------------------------------------------------------
-- 取消撤销
Keymap("n", "U", "<c-r>")

-- error 管理
Keymap("n", "<c-p>", "<cmd>lua vim.diagnostic.goto_prev()<cr>") -- pre error
Keymap("n", "<c-n>", "<cmd>lua vim.diagnostic.goto_next()<cr>") -- next error

-- 重命名
-- keymap("n", "R", "<cmd>lua vim.lsp.buf.rename()<CR>")

vim.keymap.set("n", "R", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

Keymap("n", "<bs>", "<C-^>")
Keymap("", "gI", "<cmd>Glance implementations<cr>")
-- keymap("", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")

vim.keymap.set('n', 'gd', function()
    vim.lsp.buf.definition()
    Api.nvim_feedkeys("zz", "n", false)
end, { noremap = true, silent = true })

Keymap("", "gD", "<cmd>FzfLua lsp_declarations<cr>")
Keymap("", "gr", "<cmd>Glance references<cr>")
Keymap("n", "gh", "<CMD>ClangdSwitchSourceHeader<CR>")


vim.keymap.set('n', '<c-p>', function()
    vim.diagnostic.goto_prev()
    Api.nvim_feedkeys("zz", "n", false)
end, { noremap = true, silent = true })


vim.keymap.set('n', '<c-n>', function()
    vim.diagnostic.goto_next()
    Api.nvim_feedkeys("zz", "n", false)
end, { noremap = true, silent = true })

-- keymap("n", "<c-p>", "<cmd>lua vim.diagnostic.goto_prev()<cr>") -- pre error
-- keymap("n", "<c-n>", "<cmd>lua vim.diagnostic.goto_next()<cr>") -- next error

-- gqn/gqj 自带的格式化
-- gm 跳屏幕中央
-- ga 显示字符编码
-- gs 等待重新映射
-- gv 最后的视觉选择
-- gi 上一个插入点
-- g* 类似于“*”，但不使用“\<”和“\>”

--------------------------------------------------------------screen ------------------------------------------------
------------------------------------------------------------------
--                          分屏
------------------------------------------------------------------
Keymap("n", "s", "") -- 取消 s 默认功能
-- map("n", "S", "", opt)                          -- 取消 s 默认功能

-- 分屏状态下，一起滚动，用于简单的diff
-- set scrollbind
-- 恢复
-- set noscrollbind

Keymap("n", "sv", "<cmd>vsp<CR>") -- 水平分屏
-- keymap("n", "sh", "<cmd>sp<CR>")                  -- 垂直分屏

Keymap("n", "sc", "<C-w>c")                       -- 关闭当前屏幕
Keymap("n", "so", "<C-w>o")                       -- 关闭其它屏幕

Keymap("n", "s,", "<cmd>vertical resize +20<CR>") -- 向右移动屏幕
Keymap("n", "s.", "<cmd>vertical resize -20<CR>") -- 向左移动屏幕

Keymap("n", "sm", "<C-w>|")                       -- 全屏
Keymap("n", "sn", "<C-w>=")                       -- 恢复全屏

Keymap("n", "<a-,>", "<C-w>h")                    -- 移动到左分屏
Keymap("n", "<a-.>", "<C-w>l")                    -- 移动到右分屏

-- 窗口切换
Keymap("n", "<left>", "<c-w>h")
Keymap("n", "<right>", "<c-w>l")
Keymap("n", "<up>", "<c-w>k")
Keymap("n", "<down>", "<c-w>j")
Keymap("", "<c-h>", "<c-w>h")
Keymap("", "<c-l>", "<c-w>l")

-- kitty 终端区分 c-i 和 tab
if vim.env.TERM == "xterm-kitty" then
    Cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
    Cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
    Cmd("nnoremap <c-i> <c-i>")
    Cmd("nnoremap <ESC>[105;5u <C-I>")
    Cmd("nnoremap <Tab>        %")
    Cmd("noremap  <ESC>[88;5u  :!echo B<CR>")
    Cmd("noremap  <ESC>[49;5u  :!echo C<CR>")
    Cmd("noremap  <ESC>[1;5P   :!echo D<CR>")
end

-- 交换 : ;

Cmd("noremap ; :")
Cmd("noremap : ;")

Cmd("nnoremap ; :")
Cmd("nnoremap : ;")

Cmd("inoremap ; :")
Cmd("inoremap : ;")

Cmd("nnoremap <Enter> o<ESC>") -- Insert New Line quickly
-- cmd("nnoremap <Enter> %")

Cmd("xnoremap p P")

Cmd("silent!")

-- cmd("nnoremap # *")
-- cmd("nnoremap * #")

Keymap("n", "gw", "<cmd>FzfLua grep_cword<CR>")
Keymap("n", "gW", "<cmd>FzfLua grep_cWORD<CR>")
Keymap("n", "<c-r>", "<cmd>FzfLua resume<CR>")


vim.keymap.set('n', 'C', '"_C', { noremap = true })
vim.keymap.set('n', 'D', '"_D', { noremap = true })

vim.keymap.set('n', 'yc', 'yy<cmd>normal gcc<CR>p')

vim.keymap.set("n", "<C-c>", "ciw")
vim.keymap.set("n", "cr", "ciw")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
