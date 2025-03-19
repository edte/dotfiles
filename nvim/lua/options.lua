-- =================================================vim option settings=======================================================
vim.g.have_nerd_font = true
vim.g.maplocalleader = "\\"
vim.g.netrw_banner = 0

-- 日志等级
-- vim.lsp.set_log_level("trace")

-- 不可见字符的显示，这里只把空格显示为一个点
-- vim.o.list = false
-- vim.o.listchars = "space:·"

-- vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- -- 恢复上次会话
-- vim.opt.sessionoptions = 'buffers,curdir,tabpages,winsize'

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

local default_options = {
    clipboard = "unnamedplus",          -- allows neovim to access the system clipboard
    cmdheight = 0,                      -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" },
    conceallevel = 0,                   -- so that `` is visible in markdown files
    fileencoding = "utf-8",             -- the encoding written to a file
    foldmethod = "manual",              -- folding, set to "expr" for treesitter based folding
    foldexpr = "",                      -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
    hidden = true,                      -- required to keep multiple buffers and open multiple buffers
    hlsearch = true,                    -- highlight all matches on previous search pattern
    ignorecase = true,                  -- ignore case in search patterns
    mouse = "a",                        -- allow the mouse to be used in neovim
    pumheight = 10,                     -- pop up menu height
    showmode = false,                   -- we don't need to see things like -- INSERT -- anymore
    smartcase = true,                   -- smart case
    splitbelow = true,                  -- force all horizontal splits to go below current window
    splitright = true,                  -- force all vertical splits to go to the right of current window
    termguicolors = true,               -- set term gui colors (most terminals support this)
    title = true,                       -- set the title of window to the value of the titlestring
    titlestring = "%<%F%=%l/%L - nvim", -- what the title of the window will be set to
    updatetime = 100,                   -- faster completion
    writebackup = false,                -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true,                   -- convert tabs to spaces
    shiftwidth = 4,                     -- the number of spaces inserted for each indentation
    tabstop = 4,                        -- insert 2 spaces for a tab
    cursorline = true,                  -- highlight the current line
    number = true,                      -- set numbered lines
    numberwidth = 4,                    -- set number column width to 2 {default 4}
    signcolumn = "yes",                 -- always show the sign column, otherwise it would shift the text each time
    wrap = false,                       -- display lines as one long line
    scrolloff = 0,                      -- minimal number of screen lines to keep above and below the cursor.
    sidescrolloff = 0,                  -- minimal number of screen lines to keep left and right of the cursor.
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
    undodir = NEOVIM_UNDO_DATA,     -- set an undo directory
    undofile = true,                -- enable persistent undo
    backup = true,                  -- creates a backup file
    backupdir = NEOVIM_BACKUP_DATA, -- neovim backup directory
    swapfile = true,                -- creates a swapfile
    directory = NEOVIM_SWAP_DATA,   -- neovim swap dir
}

for k, v in pairs(default_options) do
    vim.opt[k] = v
end

vim.opt.wildmode = "list:longest,list:full"           -- for : stuff
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
    Cmd("set path+=" .. path .. '/lua')
end


vim.opt.suffixesadd:append({ ".lua", ".java", ".rs", ".go" }) -- search for suffexes using gf
vim.opt.spelllang:append("cjk")                               -- disable spellchecking for asian characters (VIM algorithm does not support it)
vim.opt.shortmess:append("c")                                 -- don't show redundant messages from ins-completion-menu
vim.opt.shortmess:append("I")                                 -- don't show the default intro message
vim.opt.whichwrap:append("<,>,[,],h,l")

vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    virtual_lines = false,
    jump = {
        float = true
    },
})



vim.o.sessionoptions = vim.o.sessionoptions:gsub('args', '')

vim.o.diffopt = 'internal,filler,vertical,closeoff'
-- vim.o.winborder = "rounded"
