local M = {}

local cmp_style = "default"

local field_arrangement = {
	atom = { "kind", "abbr", "menu" },
	atom_colored = { "kind", "abbr", "menu" },
}

local lspkind = {
	Namespace = "󰌗",
	Text = "󰉿",
	Method = "󰆧",
	Function = "󰆧",
	Constructor = "",
	Field = "󰜢",
	Variable = "󰀫",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "󰑭",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈚",
	Reference = "󰈇",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "󰙅",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "󰊄",
	Table = "",
	Object = "󰅩",
	Tag = "",
	Array = "[]",
	Boolean = "",
	Number = "",
	Null = "󰟢",
	Supermaven = "",
	String = "󰉿",
	Calendar = "",
	Watch = "󰥔",
	Package = "",
	Copilot = "",
	Codeium = "",
	TabNine = "",
}

local formatting_style = {
	-- default fields order i.e completion word + item.kind + item.kind icons
	fields = field_arrangement[cmp_style] or { "abbr", "kind", "menu" },

	format = function(_, item)
		local icon = (true and lspkind[item.kind]) or ""

		if cmp_style == "atom" or cmp_style == "atom_colored" then
			icon = " " .. icon .. " "
			item.menu = true and "   (" .. item.kind .. ")" or ""
			item.kind = icon
		else
			icon = true and (" " .. icon .. " ") or icon
			item.kind = string.format("%s %s", icon, true and item.kind or "")
		end

		return item
	end,
}

local function border(hl_name)
	return {
		{ "╭", hl_name },
		{ "─", hl_name },
		{ "╮", hl_name },
		{ "│", hl_name },
		{ "╯", hl_name },
		{ "─", hl_name },
		{ "╰", hl_name },
		{ "│", hl_name },
	}
end

function M.cmpConfig()
	local cmp, compare = try_require("cmp"), try_require("cmp.config.compare")
	if cmp == nil then
		return
	end
	if compare == nil then
		return
	end

	-- cmp 源
	cmp.setup({
		window = {
			completion = {
				side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
				-- winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
				winhighlight = "Normal:CmpPmenu,FloatBorder:Pmenu,Search:None",
				scrollbar = true,
				-- col_offset = -3,
				-- side_padding = 0,
			},
			documentation = {
				border = border("CmpDocBorder"),
				winhighlight = "Normal:CmpDoc",
			},
		},
		formatting = formatting_style,
		preselect = cmp.PreselectMode.Item,
		completion = { completeopt = "menu,menuone,select" },

		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},

		mapping = cmp.mapping.preset.insert({
			["<Space>"] = cmp.mapping(function(fallback)
				local entry = cmp.get_selected_entry()
				if entry == nil then
					entry = cmp.core.view:get_first_entry()
				end
				if entry and entry.source.name == "nvim_lsp" and entry.source.source.client.name == "rime_ls" then
					cmp.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					})
				else
					fallback()
				end
			end, { "i", "s" }),
			["<CR>"] = cmp.mapping(function(fallback)
				local entry = cmp.get_selected_entry()
				if entry == nil then
					entry = cmp.core.view:get_first_entry()
				end
				if entry and entry.source.name == "nvim_lsp" and entry.source.source.client.name == "rime_ls" then
					cmp.abort()
				else
					if entry ~= nil then
						cmp.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						})
					else
						fallback()
					end
				end
			end, { "i", "s" }),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.close(),
		}),

		matching = {
			disallow_symbol_nonprefix_matching = false,
			disallow_fuzzy_matching = true,
			disallow_fullfuzzy_matching = true,
			disallow_partial_fuzzy_matching = true,
			disallow_partial_matching = true,
			disallow_prefix_unmatching = false,
		},

		sources = {
			{
				name = "cmp_tabnine",
				priority = 8,
			},

			{
				name = "nvim_lsp_signature_help",
				priority = 8,
			},
			{
				name = "nvim_lsp",
				priority = 8,
			},
			{
				name = "luasnip",
				priority = 7,
			},
			{
				name = "buffer",
				priority = 7,
			},
			{
				name = "dictionary",
				priority = 6,
				keyword_length = 6,
				keyword_pattern = [[\w\+]],
			},

			{
				priority = 6,
				name = "treesitter",
			},

			{
				priority = 6,
				name = "go_pkgs",
			},

			{
				name = "lazydev",
				group_index = 0,
				entry_filter = function()
					if vim.bo.filetype ~= "lua" then
						return false
					end
					return true
				end,
				priority = 6,
			},

			{
				name = "nvim_lua",
				priority = 5,
			},
			{
				name = "async_path",
				priority = 4,
			},
			{
				name = "emoji",
				priority = 4,
			},
			{
				name = "calc",
				priority = 4,
			},

			{
				name = "rg",
				keyword_length = 5,
				max_item_count = 5,
				option = {
					additional_arguments = "--smart-case --hidden",
				},
				priority = 4,
				group_index = 3,
			},
		},

		-- cmp 补全的顺序
		-- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
		sorting = {
			priority_weight = 1.0,
			comparators = {
				-- cmp.config.compare.offset, -- 偏移量较小的条目将排名较高
				-- cmp.config.compare.exact,  -- 具有精确== true的条目将排名更高
				-- cmp.config.compare.score,  -- 得分越高的作品排名越高
				-- try_require "cmp-under-comparator".under,
				-- cmp.config.compare.kind,  -- “kind”序数值较小的整体将排名较高
				-- cmp.config.compare.sort_text, -- 条目将按照 sortText 的字典顺序进行排名
				-- cmp.config.compare.length,  --条目，与较短的标签的长度将位居高
				-- cmp.config.compare.order, -- 项与小id将排名更高的
				-- compare.recently_used, --最近使用的条目将排名更高
				-- cmp.locality       --地点:项目与更高的地方(即，言语更接近于光标)将排名较高
				-- compare.scopes  -- 在更近的作用域中定义的条目排名会更高（例如，优先选择局部变量，而不是全局变量

				-- -- try_require("cmp.config.compare").sort_text, -- 这个放第一个, 其他的随意
				-- compare.exact,         -- 精准匹配
				-- compare.recently_used, -- 最近用过的靠前
				-- compare.kind,
				-- try_require("clangd_extensions.cmp_scores"),
				-- compare.score, -- 得分高靠前
				-- compare.order,
				-- compare.offset,
				-- compare.length, -- 短的靠前
				-- compare.sort_test,

				-- compare.score_offset, -- not good at all
				-- try_require('cmp_ai.compare'),
				compare.locality,
				compare.recently_used,
				compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
				-- try_require("copilot_cmp.comparators").prioritize,
				try_require("cmp_tabnine.compare"),
				compare.offset,
				compare.order,
				-- compare.scopes, -- what?
				-- compare.sort_text,
				-- compare.exact,
				-- compare.kind,
				-- compare.length, -- useless
				-- require("cmp-under-comparator").under,
			},
		},
	})

	-- tabnine 设置，一个ai补全的
	local tabnine = try_require("cmp_tabnine.config")
	if tabnine == nil then
		return
	end

	tabnine:setup({
		max_lines = 1000,
		max_num_results = 20,
		sort = true,
		run_on_every_keystroke = true,
		snippet_placeholder = "..",
		ignored_file_types = {
			-- default is not to ignore
			-- uncomment to ignore in lua:
			-- lua = true
		},
		show_prediction_strength = false,
		min_percent = 0,
	})

	-- git clone https://github.com/skywind3000/vim-dict lvim/
	local dict = {
		["*"] = { "/usr/share/dict/words" },
		go = { user_config_path .. "dict/go.dict" },
		sh = { user_config_path .. "dict/sh.dict" },
		lua = { user_config_path .. "dict/lua.dict" },
		html = { user_config_path .. "dict/html.dict" },
		css = { user_config_path .. "dict/css.dict" },
		cpp = { user_config_path .. "dict/cpp.dict" },
		cmake = { user_config_path .. "dict/cmake.dict" },
		c = { user_config_path .. "dict/c.dict" },
	}

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "*",
		callback = function(ev)
			dict = try_require("cmp_dictionary")
			if dict == nil then
				return
			end
			dict.setup({
				paths = dict[ev.match] or dict["*"],
				exact_length = 4,
				first_case_insensitive = true,
			})
		end,
	})
end

return M
