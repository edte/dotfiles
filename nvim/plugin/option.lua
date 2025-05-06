if vim.env.Test then
	return
end

local default_options = {
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 0, -- more space in the neovim command line for displaying messages
	completeopt = { "menuone", "noselect" },
	conceallevel = 0, -- so that `` is visible in markdown files
	fileencoding = "utf-8", -- the encoding written to a file
	hidden = true, -- required to keep multiple buffers and open multiple buffers
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	mouse = "a", -- allow the mouse to be used in neovim
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	smartcase = true, -- smart case
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	termguicolors = true, -- set term gui colors (most terminals support this)
	title = true, -- set the title of window to the value of the titlestring
	titlestring = "%<%F%=%l/%L - nvim", -- what the title of the window will be set to
	updatetime = 100, -- faster completion
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 4, -- the number of spaces inserted for each indentation
	tabstop = 4, -- insert 2 spaces for a tab
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	numberwidth = 4, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = false, -- display lines as one long line
	scrolloff = 0, -- minimal number of screen lines to keep above and below the cursor.
	sidescrolloff = 0, -- minimal number of screen lines to keep left and right of the cursor.
	showcmd = false,
	ruler = false,
	laststatus = 3,

	-- 这表示 Vim 将等待 500 毫秒来完成一个键映射。如果在这个时间内没有完成，映射将会被取消。
	timeoutlen = 500, -- 设置 Vim 等待键映射（包括普通模式和插入模式下的映射）完成的时间

	-- 这表示 Vim 将等待 100 毫秒来完成一个终端键代码。如果在这个时间内没有完成，Vim 将会认为没有更多的键代码输入。
	ttimeoutlen = 0, -- 设置 Vim 等待终端键代码完成的时间

	-- n-v-c-sm:block：在普通模式（n）、可视模式（v）、选择模式（sm）下，光标样式为块状（block）。
	-- i-ci-ve:ver25：在命令行模式（c）、插入模式（i）、命令行插入模式（ci）和可视模式（ve）下，光标样式为垂直线，线宽为 25% 的字符宽度。
	-- r-cr-o:hor20：在替换模式（r）、命令行替换模式（cr）和操作待决模式（o）下，光标样式为水平线，线宽为 20% 的字符高度。
	guicursor = "n-v-sm:block,c-i-ci-ve:ver25,r-cr-o:hor20",

	-- backup
	undodir = vim.fn.stdpath("state") .. "/undo", -- set an undo directory
	undofile = true, -- enable persistent undo
	backup = true, -- creates a backup file
	backupdir = vim.fn.stdpath("state") .. "/backup", -- neovim backup directory
	swapfile = false, -- creates a swapfile
	directory = vim.fn.stdpath("state") .. "/swap", -- neovim swap dir
	wildmode = "list:longest,list:full", -- for : stuff

	-- 折叠相关
	foldcolumn = "1",
	fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
	foldmethod = "expr",
	foldlevelstart = 99,
	foldenable = true,
	foldlevel = 99,
	-- 默认treessiter折叠，如果lsp支持换成lsp
	foldexpr = "v:lua.vim.treesitter.foldexpr()",
	foldtext = "",
}

for k, v in pairs(default_options) do
	vim.opt[k] = v
end

vim.cmd([[set foldopen-=search]])

vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = false,
	virtual_lines = false,
	jump = {
		float = true,
	},
})

vim.g.have_nerd_font = true
vim.g.maplocalleader = "\\"
vim.g.netrw_banner = 0
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.filetype.add({
	extension = {
		tex = "tex",
		zir = "zir",
		cr = "crystal",
	},
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc",
	},
})

vim.opt.wildmode = "list:longest,list:full" -- for : stuff
vim.opt.wildignore:append({ ".javac", "node_modules", "*.pyc" })
vim.opt.wildignore:append({ ".aux", ".out", ".toc" }) -- LaTeX
vim.opt.wildignore:append({
	".o",
	".obj",
	".dll",
	".exe",
	".so",
	".a",
	".lib",
	".pyc",
	".pyo",
	".pyd",
	".swp",
	".swo",
	".class",
	".DS_Store",
	".git",
	".hg",
	".orig",
})

vim.opt.include = [[\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+]]
vim.opt.includeexpr = "substitute(v:fname,'\\.','/','g')"

for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
	vim.cmd("set path+=" .. path .. "/lua")
end

vim.opt.suffixesadd:append({ ".lua", ".java", ".rs", ".go" }) -- search for suffexes using gf
vim.opt.spelllang:append("cjk") -- disable spellchecking for asian characters (VIM algorithm does not support it)
vim.opt.shortmess:append("c") -- don't show redundant messages from ins-completion-menu
vim.opt.shortmess:append("I") -- don't show the default intro message
vim.opt.whichwrap:append("<,>,[,],h,l")

-- FIX: 这里folds恢复会失败（lsp/treessiter的，如果是manul手动折叠的正常，不知道为啥）
vim.cmd([[
    set sessionoptions=blank,buffers,curdir,help,tabpages,winsize,terminal
]])

vim.o.diffopt = "internal,filler,vertical,closeoff"
-- vim.o.winborder = "rounded"

-- 如果lsp支持，则换成lsp折叠
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(args)
-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
-- 		if client:supports_method("textDocument/foldingRange") then
-- 			local win = vim.api.nvim_get_current_win()
-- 			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
-- 		end
-- 	end,
-- })

-- https://www.reddit.com/r/neovim/comments/1k24zgk/weak_git_diff_in_neovim/
if vim.fn.has("patch-9.1.1243") == 1 then
	vim.opt.diffopt:append("inline:word")
end

-- https://github.com/neovim/neovim/pull/27855
-- require("vim._extui").enable({})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
	pattern = "?*",
	group = vim.api.nvim_create_augroup("remember_folds", { clear = true }),
	callback = function()
		vim.cmd([[mkview]])
	end,
})
vim.api.nvim_create_autocmd({ "BufRead" }, {
	pattern = "?*",
	group = vim.api.nvim_create_augroup("remember_folds", { clear = true }),
	callback = function()
		vim.cmd([[loadview]])
	end,
})
