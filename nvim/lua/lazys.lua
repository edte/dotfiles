-- Neovim 的现代插件管理器
-- https://github.com/folke/lazy.nvim
-- https://lazy.folke.io/spec

-- lazy.nvim 插件管理器安装
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		Api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- 组装插件列表

local modules = {
	"ui.plugins",
	"bookmark.plugins",
	"vim.plugins",
	"text.plugins",
	"cmp.plugins",
	"lsp.plugins",
	"git.plugins",
	"components.plugins",
}

local plugins_list = {}

-- 遍历每个模块
for _, module_name in ipairs(modules) do
	local module = require(module_name)
	if module == nil then
		return
	end
	-- 遍历模块中的每个插件
	for _, plugin in ipairs(module.list) do
		plugins_list[#plugins_list + 1] = plugin
	end
end

require("lazy").setup({
	root = NEOVIM_LAZY_DATA, -- directory where plugins will be installed
	defaults = {
		-- Set this to `true` to have all your plugins lazy-loaded by default.
		-- Only do this if you know what you are doing, as it can lead to unexpected behavior.
		lazy = false, -- should plugins be lazy-loaded?
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = nil, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
		-- default `cond` you can use to globally disable a lot of plugins
		-- when running inside vscode for example
		cond = nil, ---@type boolean|fun(self:LazyPlugin):boolean|nil
	},
	-- leave nil when passing the spec as the first argument to setup()
	--     -- 导入你的插件
	spec = plugins_list,

	local_spec = true, -- load project specific .lazy.lua spec files. They will be added at the end of the spec.
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated after running update.
	---@type number? limit the maximum amount of concurrent tasks
	concurrency = jit.os:find("Windows") and (vim.uv.available_parallelism() * 2) or nil,
	git = {
		-- defaults for the `Lazy log` command
		-- log = { "--since=3 days ago" }, -- show commits from the last 3 days
		log = { "-8" }, -- show the last 8 commits
		timeout = 120, -- kill processes that take more than 2 minutes
		url_format = "https://github.com/%s.git",
		-- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
		-- then set the below to false. This should work, but is NOT supported and will
		-- increase downloads a lot.
		filter = true,
		-- rate of network related git operations (clone, fetch, checkout)
		throttle = {
			enabled = false, -- not enabled by default
			-- max 2 ops every 5 seconds
			rate = 2,
			duration = 5 * 1000, -- in ms
		},
		-- Time in seconds to wait before running fetch again for a plugin.
		-- Repeated update/check operations will not run again until this
		-- cooldown period has passed.
		cooldown = 0,
	},
	pkg = {
		enabled = true,
		cache = vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua",
		-- the first package source that is found for a plugin will be used.
		sources = {
			"lazy",
			"rockspec", -- will only be used when rocks.enabled is true
			"packspec",
		},
	},
	rocks = {
		enabled = true,
		root = vim.fn.stdpath("data") .. "/lazy-rocks",
		server = "https://nvim-neorocks.github.io/rocks-binaries/",
		-- use hererocks to install luarocks?
		-- set to `nil` to use hererocks when luarocks is not found
		-- set to `true` to always use hererocks
		-- set to `false` to always use luarocks
		hererocks = nil,
	},
	dev = {
		-- Directory where you store your local plugin projects. If a function is used,
		-- the plugin directory (e.g. `~/projects/plugin-name`) must be returned.
		---@type string | fun(plugin: LazyPlugin): string
		path = NEOVIM_CONFIG_PATH .. "/lua",
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		patterns = {}, -- For example {"folke"}
		fallback = false, -- Fallback to git when local plugin doesn't exist
	},

	install = {
		-- install missing plugins on startup. This doesn't increase startup time.
		missing = true,
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "tokyonight" },
	},
	ui = {
		-- a number <1 is a percentage., >1 is a fixed size
		size = { width = 0.8, height = 0.8 },
		wrap = true, -- wrap the lines in the ui
		-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
		border = "none",
		-- The backdrop opacity. 0 is fully opaque, 100 is fully transparent.
		backdrop = 60,
		title = nil, ---@type string only works when border is not "none"
		title_pos = "center", ---@type "center" | "left" | "right"
		-- Show pills on top of the Lazy window
		pills = true, ---@type boolean
		icons = {
			cmd = " ",
			config = "",
			event = " ",
			favorite = " ",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = "󰒲 ",
			loaded = "●",
			not_loaded = "○",
			plugin = " ",
			runtime = " ",
			require = "󰢱 ",
			source = " ",
			start = " ",
			task = "✔ ",
			list = {
				"●",
				"➜",
				"★",
				"‒",
			},
		},
		-- leave nil, to automatically select a browser depending on your OS.
		-- If you want to use a specific browser, you can define it here
		browser = nil, ---@type string?
		throttle = 1000 / 30, -- how frequently should the ui process render events
	},
	-- Output options for headless mode
	headless = {
		-- show the output from process commands like git
		process = true,
		-- show log messages
		log = true,
		-- show task start/end
		task = true,
		-- use ansi colors
		colors = true,
	},
	diff = {
		-- diff command <d> can be one of:
		-- * browser: opens the github compare view. Note that this is always mapped to <K> as well,
		--   so you can have a different command for diff <d>
		-- * git: will run git diff and open a buffer with filetype git
		-- * terminal_git: will open a pseudo terminal with git diff
		-- * diffview.nvim: will open Diffview to show the diff
		cmd = "git",
	},
	checker = {
		-- automatically check for plugin updates
		enabled = false,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		notify = true, -- get a notification when new updates are found
		frequency = 3600, -- check for updates every hour
		check_pinned = false, -- check for pinned packages that can't be updated
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = true, -- get a notification when changes are found
	},
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true, -- reset the package path to improve startup time
		rtp = {
			reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
			---@type string[]
			paths = {}, -- add any custom paths here that you want to includes in the rtp
			---@type string[] list any plugins you want to disable here
			disabled_plugins = {
				--     "gzip",
				--     "matchit",
				--     "matchparen",
				"netrwPlugin",
				--     "tarPlugin",
				--     "tohtml",
				--     "tutor",
				--     "zipPlugin",
			},
		},
	},
	-- lazy can generate helptags from the headings in markdown readme files,
	-- so :help works even for plugins that don't have vim docs.
	-- when the readme opens with :help it will be correctly displayed as markdown
	readme = {
		enabled = true,
		root = vim.fn.stdpath("state") .. "/lazy/readme",
		files = { "README.md", "lua/**/README.md" },
		-- only generate markdown helptags for plugins that don't have docs
		skip_if_doc_exists = true,
	},
	state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
	-- Enable profiling of lazy.nvim. This will add some overhead,
	-- so only enable this when you are debugging lazy.nvim
	profiling = {
		-- Enables extra stats on the debug tab related to the loader cache.
		-- Additionally gathers stats about all package.loaders
		loader = false,
		-- Track each new require in the Lazy profiling tab
		require = false,
	},
})
