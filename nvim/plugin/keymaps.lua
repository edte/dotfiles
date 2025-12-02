nmap("}", "}w")
nmap("}", "}j")
vim.cmd("nnoremap <expr><silent> { (col('.')==1 && len(getline(line('.')-1))==0? '2{j' : '{j')")

nmap("<C-u>", "<C-u>zz")
nmap("<C-d>", "<C-d>zz")

nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- 保存文件
nmap("<C-s>", "<cmd>w<cr>")

-- 设置 jj、jk 为 ESC,避免频繁按 esc
imap("jk", "<Esc><right>")

-- 按 esc 消除上一次的高亮
nmap("<esc>", "<cmd>noh<cr>")

nmap("<esc>", function()
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

	cmd(":nohlsearch")
	if isModuleAvailable("clever-f") then
		cmd(":call clever_f#reset()")
		return
	end
end)

nmap("<C-i>", "<C-i>zz")
nmap("<C-o>", "<C-o>zz")

nmap("yp", 'vi"p')
nmap("vp", 'vi"p')

----------------------------------------------------------------
-- 取消撤销
nmap("U", "<c-r>")

nmap("gI", "<cmd>Glance implementations<cr>")

nmap("<C-]>", "<C-]>zz")
nmap("gd", "<C-]>zz")

nmap("grr", "<cmd>Glance references<cr>")

nmap("<c-n>", function()
	vim.diagnostic.goto_next()
	-- vim.diagnostic.jump({ count = 1, float = true })
	zz()
end)

nmap("<c-p>", function()
	vim.diagnostic.goto_prev()
	-- vim.diagnostic.jump({ count = -1, float = true })
	zz()
end)

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
-- nmap("s", "") -- 取消 s 默认功能
-- map("n", "S", "", opt)                          -- 取消 s 默认功能

nmap("sv", "<cmd>vsp<CR>") -- 水平分屏
nmap("sh", "<cmd>sp<CR>") -- 垂直分屏

nmap("sc", "<C-w>c") -- 关闭当前屏幕
nmap("so", "<C-w>o") -- 关闭其它屏幕

nmap("s,", "<cmd>vertical resize +20<CR>") -- 向右移动屏幕
nmap("s.", "<cmd>vertical resize -20<CR>") -- 向左移动屏幕

nmap("sm", "<C-w>|") -- 全屏
nmap("sn", "<C-w>=") -- 恢复全屏

nmap("<a-,>", "<C-w>h") -- 移动到左分屏
nmap("<a-.>", "<C-w>l") -- 移动到右分屏

-- 窗口切换
nmap("<left>", "<c-w>h")
nmap("<right>", "<c-w>l")
nmap("<up>", "<c-w>k")
nmap("<down>", "<c-w>j")

-- 交换 : ;

cmd("noremap ; :")
cmd("noremap : ;")

cmd("nnoremap ; :")
cmd("nnoremap : ;")

cmd("inoremap ; :")
cmd("inoremap : ;")

cmd("nnoremap <Enter> o<ESC>") -- Insert New Line quickly

cmd("xnoremap p P")

cmd("silent!")

nmap("gw", "<cmd>lua Snacks.picker.grep_word()<CR>")

nmap("C", '"_C')
nmap("D", '"_D')
nmap("yc", "yy<cmd>normal gcc<CR>p")
nmap("<C-c>", "ciw")
nmap("cr", "ciw")

vmap("J", ":m '>+1<CR>gv=gv")
vmap("K", ":m '<-2<CR>gv=gv")

cmd("command! Pwd !ls %:p")
cmd("command! Cwd lua print(vim.uv.cwd())")

vim.api.nvim_create_user_command("LiteralSearch", function(opts)
	cmd("normal! /\\V" .. vim.fn.escape(opts.args, "\\"))
end, { nargs = 1 })

nmap("<space>/", "gcc", { noremap = false, silent = true, desc = "comment" })
vmap("<space>/", "gc", { noremap = false, silent = true, desc = "comment" })

nmap("go", ":lua vim.lsp.buf.document_symbol()<cr>")

-- FIX: 过滤函数和结构体，但是没成功
-- nmap("go", function()
-- 	vim.lsp.buf.document_symbol({
-- 		on_list = function(options)
-- 			local res = {}
--
-- 			for _, symbol in ipairs(options.items) do
-- 				if symbol.kind == "Function" or symbol.kind == "Struct" then
-- 					table.insert(res, symbol)
-- 				end
-- 			end
--
-- 			options.items = res
--
-- 			vim.fn.setqflist({}, " ", options)
-- 		end,
-- 	})
-- end)

vim.keymap.set("x", "/", "<Esc>/\\%V") --search within visual selection - this is magic

vim.keymap.set("n", "md", function()
	require("marks"):delete_line_marks()
	require("bookmarks").delete_bookmark()
end, { desc = "bookmarks delete", silent = true })

Command("JsonCompress", function()
	vim.api.nvim_command(":%!jq -c")
end, { nargs = "*" })

-- cmdline 模式下的emacs键位
vim.cmd("cnoremap <C-A>		<Home>")
vim.cmd("cnoremap <C-D>		<Del>")
vim.cmd("cnoremap <C-E>		<End>")
vim.cmd("cnoremap <C-F>		<Right>")
vim.cmd("cnoremap <C-N>		<Down>")
vim.cmd("cnoremap <C-P>		<Up>")
vim.cmd("cnoremap <Esc><C-B>	<S-Left>")
vim.cmd("cnoremap <Esc><C-F>	<S-Right>")

-- insert 模式下的emacs键位
vim.cmd("inoremap <C-A>		<Home>")
vim.cmd("inoremap <C-D>		<Del>")
vim.cmd("inoremap <C-E>		<End>")
vim.cmd("inoremap <C-F>		<Right>")
vim.cmd("inoremap <C-N>		<Down>")
vim.cmd("inoremap <C-P>		<Up>")
vim.cmd("inoremap <Esc><C-B>	<S-Left>")
vim.cmd("inoremap <Esc><C-F>	<S-Right>")

-- 按f快速跳转
local EASYMOTION_NS = vim.api.nvim_create_namespace('EASYMOTION_NS')
local EM_CHARS = vim.split('fjdkslgha;rueiwotyqpvbcnxmzFJDKSLGHARUEIWOTYQPVBCNXMZ', '')

local function easy_motion()
    local char1 = vim.fn.nr2char( vim.fn.getchar() --[[@as number]] )
    local char2 = vim.fn.nr2char( vim.fn.getchar() --[[@as number]] )
    local line_idx_start, line_idx_end = vim.fn.line('w0'), vim.fn.line('w$')
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, EASYMOTION_NS, 0, -1)

    local char_idx = 1
    ---@type table<string, {line: integer, col: integer, id: integer}>
    local extmarks = {}
    local lines = vim.api.nvim_buf_get_lines(bufnr, line_idx_start - 1, line_idx_end, false)
    local needle = char1 .. char2

    local is_case_sensitive = needle ~= string.lower(needle)

    for lines_i, line_text in ipairs(lines) do
        if not is_case_sensitive then
            line_text = string.lower(line_text)
        end
        local line_idx = lines_i + line_idx_start - 1
        -- skip folded lines
        if vim.fn.foldclosed(line_idx) == -1 then
            for i = 1, #line_text do
                if line_text:sub(i, i + 1) == needle and char_idx <= #EM_CHARS then
                    local overlay_char = EM_CHARS[char_idx]
                    local linenr = line_idx_start + lines_i - 2
                    local col = i - 1
                    local id = vim.api.nvim_buf_set_extmark(bufnr, EASYMOTION_NS, linenr, col + 2, {
                        virt_text = { { overlay_char, 'CurSearch' } },
                        virt_text_pos = 'overlay',
                        hl_mode = 'replace',
                    })
                    extmarks[overlay_char] = { line = linenr, col = col, id = id }
                    char_idx = char_idx + 1
                    if char_idx > #EM_CHARS then
                        goto break_outer
                    end
                end
            end
        end
    end
    ::break_outer::

    -- if only one match, jump directly
    local extmarks_count = 0
    local single_pos = nil
    for _, pos in pairs(extmarks) do
        extmarks_count = extmarks_count + 1
        single_pos = pos
    end

    if extmarks_count == 1 and single_pos then
        vim.schedule(function()
            -- to make <C-o> work
            vim.cmd("normal! m'")
            vim.api.nvim_win_set_cursor(0, { single_pos.line + 1, single_pos.col })
            -- clear extmarks
            vim.api.nvim_buf_clear_namespace(0, EASYMOTION_NS, 0, -1)
        end)
        return
    end

    -- otherwise setting extmarks and waiting for next char is on the same frame
    vim.schedule(function()
        local next_char = vim.fn.nr2char(vim.fn.getchar() --[[@as number]])
        if extmarks[next_char] then
            local pos = extmarks[next_char]
            -- to make <C-o> work
            vim.cmd("normal! m'")
            vim.api.nvim_win_set_cursor(0, { pos.line + 1, pos.col })
        end
        -- clear extmarks
        vim.api.nvim_buf_clear_namespace(0, EASYMOTION_NS, 0, -1)
    end)
end

vim.keymap.set({ 'n', 'x' }, 'f', easy_motion, { desc = 'Jump to 2 characters' })

