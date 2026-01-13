if vim.g.jce_loaded then
	return
end
vim.g.jce_loaded = true

vim.pack.add({
	{ src = "https://github.com/edte/jce-highlight.git" },
})
