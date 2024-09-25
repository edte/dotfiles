local M = {}

M.config = function()
	local icons = require("icons")
	require("lualine").setup({
		options = {
			icons_enabled = icons.use_icons,
			theme = "auto",
			component_separators = { left = icons.ui.DividerRight, right = icons.ui.DividerLeft },
			section_separators = { left = icons.ui.BoldDividerRight, right = icons.ui.BoldDividerLeft },
			disabled_filetypes = { "alpha" },
			ignore_focus = {},
			always_divide_middle = true,
			globalstatus = true,
			refresh = { statusline = 10000, tabline = 10000, winbar = 10000 },
		},
		sections = {
			lualine_a = {
				-- mode
				{
					function()
						return " " .. icons.ui.Target .. " "
					end,
					padding = { left = 0, right = 0 },
				},
			},
			lualine_b = { "project-name", "fileline" },
			lualine_c = { "branch", "diff" },
			lualine_x = {
				-- diagnostics
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					symbols = {
						error = icons.diagnostics.BoldError .. " ",
						warn = icons.diagnostics.BoldWarning .. " ",
						info = icons.diagnostics.BoldInformation .. " ",
						hint = icons.diagnostics.BoldHint .. " ",
					},
				},
				{
					"lsp-status",
					color = { gui = "bold" },
				},
				-- filetype
				{
					"filetype",
					padding = { left = 1, right = 1 },
				},
			},
			lualine_y = {},
			lualine_z = { "time" },
		},
	})
end

return M
