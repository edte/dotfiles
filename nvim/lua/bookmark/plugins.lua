local M = {}

M.list = {

	-- 文件mark，按git隔离
	-- 保存目录 /Users/edte/.cache/lvim/arrow
	{
		"otavioschwanck/arrow.nvim",
		branch = "master",
		keys = { "`" },
		opts = {
			show_icons = true,
			leader_key = "`", -- Recommended to be a single key
			-- buffer_leader_key = "m", -- Per Buffer Mappings
			index_keys = "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
			save_key = "git_root", -- what will be used as root to save the bookmarks. Can be also `git_root`.
			hide_handbook = true,
			always_show_path = true,
		},
	},

	-- mark 插件，在singn栏展示，同时直接用大写字母来快速跳转,md 删除本行
	{
		"edte/marks.nvim",
		opts = {},
	},

	-- 命名书签
	-- echo stdpath("data")
	-- /Users/edte/.local/share/lvim
	-- ~/.local/share/nvim/bookmarks/
	{
		"edte/bookmarks.nvim",
		dependencies = {
			"folke/snacks.nvim",
		},
		opts = {},
	},

	-- Neovim 的小型自动化会话管理器
	-- 当不带参数启动 nvim 时，AutoSession 将尝试恢复当前 cwd 的现有会话（如果存在）。
	-- 当启动 nvim 时。 （或另一个目录），AutoSession 将尝试恢复该目录的会话。
	-- 当启动 nvim some_file.txt （或多个文件）时，默认情况下，AutoSession 不会执行任何操作。有关更多详细信息，请参阅参数处理。
	-- 即使使用文件参数启动 nvim 后，仍然可以通过运行 :SessionRestore 手动恢复会话。
	-- 任何会话保存和恢复都会考虑当前工作目录 cwd。
	-- 当通过管道传输到 nvim 时，例如： cat myfile | nvim、AutoSession 不会做任何事情。
	-- ⚠️请注意，如果您的配置中有错误，恢复会话可能会失败，如果发生这种情况，自动会话将禁用当前会话的自动保存。仍然可以通过调用 :SessionSave 来手动保存会话。
	-- {
	--     "rmagatti/auto-session",
	--     -- cmd = { "SessionSave", "SessionRestore", "SessionDelete", "SessionToggleAutoSave", "SessionSearch" },
	--     config = function()
	--         require("auto-session").setup({
	--             log_level = "error",
	--             auto_session_suppress_dirs = { "~/", "~/Documents", "~/Projects", "~/Downloads", "/" },
	--             -- auto_session_use_git_branch = true,
	--             auto_save_enabled = true,
	--             bypass_save_filetypes = { "alpha", "dashboard" }, -- or whatever dashboard you use
	--         })
	--     end,
	-- },
}

return M
