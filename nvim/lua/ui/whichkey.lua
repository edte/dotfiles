--------------------------------------------------------------which key ------------------------------------------------------------------------
local wk = require("which-key")

wk.add({
	mode = { "v" },
	-- lsp
	{ "<leader>l", group = "LSP", desc = "lsp" },
	{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "code Action" },
	{ "<leader>t", ":'<,'>Translate ZH<cr>", desc = "translate" },
	{ "<leader>d", ":lua compare_to_clipboard()<cr>", desc = "diff copy" },
	{ "<leader>g", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", desc = "git history" },
	{ "<enter>", ":'<,'>SnipRun<CR>", desc = "run code" },
})

wk.add({
	-- normal
	{ "<leader>C", "<cmd>%bd|e#|bd#<CR>", desc = "Close Other Buffer" },
	{ "<leader>c", "<cmd>bd<CR>", desc = "close Buffer" },
	{ "<leader>f", "<cmd>lua project_files()<CR>", desc = "files" },
	{ "<leader>p", "<cmd>Lazy<cr>", desc = "plugins" },
	{ "<leader>q", "<cmd>confirm q<CR>", desc = "quit" },
	-- { "<leader>r", "<cmd>lua Snacks.picker.recent()<CR>", desc = "recents" },
	{ "<leader>t", "<cmd>lua Snacks.picker.grep()<CR>", desc = "text" },
	{ "<leader>m", "<cmd>M<CR>", desc = "log" },
	{ "<space>n", "<cmd>message<cr>", desc = "message" },

	-- git
	{ "<leader>g", group = "git", desc = "git" },
	{ "<leader>gb", "<cmd>lua Snacks.picker.git_branches()<cr>", desc = "branch" },
	{ "<leader>gp", "<cmd>DiffviewFileHistory<cr>", desc = "project history" },
	{ "<leader>gf", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "file history" },
	{ "<leader>gs", "<cmd>lua Snacks.picker.git_status()<cr>", desc = "status" },
	-- { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "diff head" },
	-- { "<leader>gd", "<cmd>DiffviewOpen<cr><cmd>DiffviewToggleFiles<cr>",        desc = "diff origin" },
	{ "<leader>gl", "<cmd>lua require('git-blame.view').show()<cr>", desc = "blame line" },
	-- { "<leader>gL", "<cmd>BlameToggle<cr>", desc = "blame file" },

	-- lsp
	{ "<leader>l", group = "lsp", desc = "lsp" },
	{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
	{ "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format" },
	{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
	{ "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
	{ "<leader>ls", "<cmd>lua Snacks.picker.lsp_symbols()<cr>", desc = "Document Symbols" },

	-- search
	{ "<leader>s", group = "search", desc = "search" },
	{ "<leader>sh", "<cmd>lua Snacks.picker.highlights()<cr>", desc = "highlight" },
	{ "<leader>sa", "<cmd>lua Snacks.picker.autocmds() <cr>", desc = "autocmds" },
	{ "<leader>sf", "<cmd>lua Snacks.picker.git_files()<cr>", desc = "file" },
	{ "<leader>sk", "<cmd>lua Snacks.picker.keymaps() <cr>", desc = "keymaps" },
	{ "<leader>st", "<cmd>lua Snacks.picker.grep()<cr>", desc = "text" },
})
