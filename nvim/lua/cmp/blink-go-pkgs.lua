--- @module 'blink.cmp'

--- @class (exact) blink-go-pkgs.DocumentationOptions
--- @field enable boolean|fun(item: blink.cmp.CompletionItem): boolean
--- @field get_command? string[]|fun(item: blink.cmp.CompletionItem): string[]

--- @class (exact) blink-go-pkgs.Options
--- @field get_prefix? string|fun(context: blink.cmp.Context): string
--- @field prefix_min_len? number|fun(context: blink.cmp.Context, prefix: string): number
--- @field get_command? string[]|fun(context: blink.cmp.Context, prefix: string): string[]
--- @field output_separator? string|fun(context: blink.cmp.Context, prefix: string): string
--- @field documentation? blink-go-pkgs.DocumentationOptions

--- @class blink-go-pkgs.DictionarySource : blink.cmp.Source
--- @field get_completions? fun(self: blink.cmp.Source, context: blink.cmp.Context, callback: fun(response: blink.cmp.CompletionResponse | nil)):  nil

-- blink.cmp provider
-- https://github.com/Saghen/blink.cmp/blob/main/lua/blink/cmp/sources/lib/provider/init.lua

local M = {}

local items = {}

local list_pkgs_command = "gopls.list_known_packages"

M.new = function()
	local self = setmetatable({}, { __index = M })
	return self
end

function M:enabled()
	return vim.bo.filetype == "go"
end

function M:get_completions(context, callback)
	local function check_if_inside_imports()
		local cur_node = require("nvim-treesitter.ts_utils").get_node_at_cursor()

		local func = cur_node
		local flag = false

		while func do
			if func:type() == "import_declaration" then
				flag = true
				break
			end

			func = func:parent()
		end

		return flag
	end

	local ok = check_if_inside_imports()
	if ok == false then
		-- log.error("not inside imports")
		callback()
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()

	if next(items) == nil or items[bufnr] == nil then
		callback()
		return
	end

	callback({ items = items[bufnr], isIncomplete = false })
end

local init_items = function(a)
	local client = vim.lsp.get_client_by_id(a.data.client_id)
	local bufnr = vim.api.nvim_get_current_buf()
	local uri = vim.uri_from_bufnr(bufnr)
	local arguments = { { URI = uri } }

	if client == nil then
		log.error("client is nil")
		return
	end

	local method = "workspace/executeCommand"

	local params = {
		command = list_pkgs_command,
		arguments = arguments,
	}

	local handler = function(result, context, _)
		if context == nil and result ~= nil then
			log.error("LSP error", result)
			return
		end

		if result == nil and context == nil then
			log.error("both arg1 and arg2 are nil")
			return
		end

		local tmp = {}

		-- log.error(result, context)

		for _, v in ipairs(context.Packages) do
			table.insert(tmp, {
				label = string.format('"%s"', v),
				kind = 9,
				insertText = string.format('"%s"', v),
			})
		end

		items[bufnr] = tmp

		-- log.error(items)
	end

	local ok, id = client:request(method, params, handler, bufnr)

	-- log.error(ok, id, a, items)
end

vim.api.nvim_create_autocmd({ "LspAttach" }, {
	group = vim.api.nvim_create_augroup("go_pkg_cmp", { clear = true }),

	pattern = { "*.go" },
	callback = init_items,
})

return M
