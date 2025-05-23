local ns = vim.api.nvim_create_namespace("qflist")

local M = {}

local function get_lines(ttt)
	local lines = {}
	for _, tt in ipairs(ttt) do
		local line = ""
		for _, t in ipairs(tt) do
			line = line .. t[1]
		end
		table.insert(lines, line)
	end
	return lines
end

local function apply_highlights(bufnr, ttt)
	for i, tt in ipairs(ttt) do
		local col = 0
		for _, t in ipairs(tt) do
			vim.hl.range(bufnr, ns, t[2], { i - 1, col }, { i - 1, col + #t[1] })
			col = col + #t[1]
		end
	end
end

local typeHilights = {
	E = "DiagnosticSignError",
	W = "DiagnosticSignWarn",
	I = "DiagnosticSignInfo",
	N = "DiagnosticSignHint",
	H = "DiagnosticSignHint",
}

function M.quickfix_text(info)
	local list
	if info.quickfix == 1 then
		list = vim.fn.getqflist({ id = info.id, items = 1, qfbufnr = 1 })
	else
		list = vim.fn.getloclist(info.winid, { id = info.id, items = 1, qfbufnr = 1 })
	end

	local ttt = {}
	for _, item in ipairs(list.items) do
		local tt = { { "  ", "qfText" } }
		if item.bufnr == 0 then
			table.insert(tt, { item.text, "qfText" })
		else
			table.insert(tt, { "" .. item.lnum .. ": ", "qfLineNr" })
			local text = item.text:match("^%s*(.-)%s*$") -- trim item.text
			local hl = typeHilights[item.type] or "qfText"
			table.insert(tt, { text, hl })
		end
		table.insert(ttt, tt)
	end

	vim.schedule(function()
		apply_highlights(list.qfbufnr, ttt)
	end)
	Print(ttt)
	return get_lines(ttt)
end

vim.o.quickfixtextfunc = "v:lua.require('vim.quickfix').quickfix_text"

---------------------------------------------------------------------------------------------

local function add_virt_lines()
	if vim.bo[0].buftype ~= "quickfix" or vim.bo[0].buftype ~= "qf" then
		return
	end
	local list = vim.fn.getqflist({ id = 0, winid = 1, qfbufnr = 1, items = 1 })
	vim.api.nvim_buf_clear_namespace(list.qfbufnr, ns, 0, -1)
	local lastfname = ""
	for i, item in ipairs(list.items) do
		local fname = vim.fn.bufname(item.bufnr)
		fname = vim.fn.fnamemodify(fname, ":p:.")
		if fname ~= "" and fname ~= lastfname then
			lastfname = fname
			vim.api.nvim_buf_set_extmark(list.qfbufnr, ns, i - 1, 0, {
				virt_lines = { { { fname .. ":", "qfFilename" } } },
				virt_lines_above = true,
				strict = false,
			})
		end
	end
end

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "filename as virt_lines",
	callback = add_virt_lines,
})
