vim.api.nvim_buf_set_keymap(
	0,
	"i",
	"<c-v>",
	"<cmd>PasteImage<cr>",
	{ noremap = true, silent = true, desc = "Paste image from system clipboard" }
)
