-- ============================ 路径配置变量 ============================
_G.NEOVIM_CONFIG_PATH = vim.fn.stdpath('config') -- Neovim 配置目录
_G.NEOVIM_SESSION_DATA = vim.fn.stdpath('data') .. '/session' -- 会话数据目录
_G.NEOVIM_BOOKMARKS_DATA = vim.fn.stdpath('data') .. '/bookmarks' -- 书签数据目录
_G.NEOVIM_MESSAGE_DATA = vim.fn.stdpath('state') .. '/message.log' -- 消息日志文件
_G.NEOVIM_LAZY_DATA = vim.fn.stdpath('data') .. '/lazy' -- Lazy.nvim 插件目录
_G.NEOVIM_UNDO_DATA = vim.fn.stdpath('state') .. '/undo' -- 撤销文件目录
_G.NEOVIM_SWAP_DATA = vim.fn.stdpath('state') .. '/swap' -- 交换文件目录
_G.NEOVIM_BACKUP_DATA = vim.fn.stdpath('state') .. '/backup' -- 备份文件目录

-- ============================ API 别名 ============================
_G.log = require('utils.log') -- 日志工具
_G.api = vim.api -- Neovim API
_G.Command = vim.api.nvim_create_user_command -- 创建用户命令
_G.cmd = vim.cmd -- 执行 Vim 命令
_G.Autocmd = vim.api.nvim_create_autocmd -- 创建自动命令
_G.GroupId = vim.api.nvim_create_augroup -- 创建自动命令组
_G.icon = require('utils.icons') -- 图标工具
_G.icons = require('utils.icons') -- 图标工具别名

_G.nmap = require('utils.keymap').nmap
_G.imap = require('utils.keymap').imap
_G.vmap = require('utils.keymap').vmap
_G.xmap = require('utils.keymap').xmap
_G.cmap = require('utils.keymap').cmap

_G.Require = require('utils.utils').require
_G.Setup = require('utils.utils').setup
_G.Print = require('utils.utils').print

_G.zz = require('utils.utils').zz

_G.link_highlight = require('utils.utils').link_highlight
_G.highlight = require('utils.utils').highlight
