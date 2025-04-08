-- bash没诊断，需要看咋弄

local M = {
	name = "bashls",
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "zsh", "bash", "tmux" },
	root_markers = { ".git", "Makefile" },
	single_file_support = true,
	settings = {
		{
			bashIde = {
				globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
			},
		},
	},
}

return M
