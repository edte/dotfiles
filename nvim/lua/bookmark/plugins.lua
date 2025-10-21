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
}

return M
