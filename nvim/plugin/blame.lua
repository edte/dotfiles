local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local M = {}

local function get_blame_info()
	local line = fn.line(".")
	local blame_info = fn.systemlist("git blame -L " .. line .. "," .. line .. " %")
	local commit_info = fn.systemlist('git show -s --format="%h %an %ar %s" ' .. blame_info[1]:sub(1, 8))
	return commit_info[1]
end

function M.blame_line()
	local blame_info = get_blame_info()
	api.nvim_echo({ { blame_info, "Comment" } }, true, {})
end

return M
