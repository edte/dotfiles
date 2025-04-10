--------------------------------------------------------------which key ------------------------------------------------------------------------
local wk = require("which-key")

wk.add({
	mode = { "v" },
	{ "<leader>l", group = "LSP", desc = "lsp" },
	{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "code Action" },
	{ "<leader>t", ":'<,'>Translate ZH<cr>", desc = "translate" },
	{ "<leader>d", ":lua compare_to_clipboard()<cr>", desc = "diff copy" },
	{ "<leader>g", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", desc = "git history" },
	{ "<enter>", ":'<,'>SnipRun<CR>", desc = "run code" },

	{ "<leader>r", group = "Refactor", desc = "Refactor" },
	{ "<leader>re", ":Refactor extract<cr>", desc = "extract" },
	{ "<leader>rf", ":Refactor extract_to_file<cr>", desc = "extract_to_file" },
	{ "<leader>rv", ":Refactor extract_var<cr>", desc = "extract_var" },
	{ "<leader>rI", ":Refactor inline_func<cr>", desc = "inline_func" },
	{ "<leader>rb", ":Refactor extract_block<cr>", desc = "extract_block" },
	{ "<leader>rbf", ":Refactor extract_block_to_file<cr>", desc = "extract_block_to_file" },
})

wk.add({
	{ "<leader>C", "<cmd>%bd|e#|bd#<CR>", desc = "Close Other Buffer" },
	{ "<leader>c", "<cmd>bd<CR>", desc = "close Buffer" },
	{ "<leader>e", "<cmd>lua ToggleMiniFiles()<CR>", desc = "Explorer" },
	{ "<leader>f", "<cmd>lua project_files()<CR>", desc = "files" },

	{ "<leader>g", group = "git", desc = "git" },
	{ "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "branch" },
	{ "<leader>gp", "<cmd>DiffviewFileHistory<cr>", desc = "project history" },
	{ "<leader>gf", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "file history" },
	{ "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "status" },
	{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "diff head" },
	-- { "<leader>gd", "<cmd>DiffviewOpen<cr><cmd>DiffviewToggleFiles<cr>",        desc = "diff origin" },
	{ "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "blame line" },
	{ "<leader>gL", "<cmd>BlameToggle<cr>", desc = "blame file" },

	{ "<leader>l", group = "lsp", desc = "lsp" },
	{ "<leader>lI", "<cmd>Mason<cr>", desc = "Mason Info" },
	{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
	{ "<leader>ld", "<cmd>FzfLua diagnostics_document<cr>", desc = "Buffer Diagnostics" },
	{ "<leader>le", "<cmd>FzfLua quickfix<cr>", desc = "FzfLua Quickfix" },
	{ "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format" },
	{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
	{ "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
	{ "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
	{ "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
	{ "<leader>lw", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
	{ "<leader>p", "<cmd>Lazy<cr>", desc = "plugins" },
	{ "<leader>q", "<cmd>confirm q<CR>", desc = "quit" },
	{ "<leader>r", "<cmd>FzfLua oldfiles<CR>", desc = "recents" },
	-- { "<leader>r",  "<cmd>SnipRun<CR>",                                         desc = "run code", },

	{ "<leader>s", group = "search", desc = "search" },
	{ "<leader>sh", "<cmd>FzfLua highlights<cr>", desc = "highlight" },
	{ "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "autocmds" },
	{ "<leader>sf", "<cmd>FzfLua files<cr>", desc = "file" },
	{ "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "keymaps" },
	{ "<leader>st", "<cmd>FzfLua live_grep<cr>", desc = "text" },
	{ "<leader>sp", '<cmd>lua require("fzf-lua-lazy").search()<cr>', desc = "plugins" },
	{ "<leader>sc", "<cmd>edit" .. NEOVIM_CONFIG_PATH .. "/init.lua" .. "<CR>", desc = "config" },
	{ "<leader>su", "<cmd>UndotreeToggle<CR>", desc = "undo" },

	{ "<leader>t", "<cmd>FzfLua live_grep_native<CR>", desc = "text" },
	{ "<leader>m", "<cmd>M<CR>", desc = "message" },
})
