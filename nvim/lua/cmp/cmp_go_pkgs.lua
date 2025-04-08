local source = {}

local items = {}

local list_pkgs_command = "gopls.list_known_packages"

source.new = function()
	local self = setmetatable({}, { __index = source })

	return self
end

local init_items = function(a)
	local client = vim.lsp.get_client_by_id(a.data.client_id)
	local bufnr = vim.api.nvim_get_current_buf()
	local uri = vim.uri_from_bufnr(bufnr)
	local arguments = { { uri = uri } }

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

source._check_if_inside_imports = function()
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

source.complete = function(self, _, callback)
	local ok = self._check_if_inside_imports()
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

source.is_available = function()
	return vim.bo.filetype == "go"
end

return source
