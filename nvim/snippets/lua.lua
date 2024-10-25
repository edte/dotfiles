-- https://vi.stackexchange.com/questions/4493/what-is-the-order-of-winenter-bufenter-bufread-syntax-filetype-events

-- 这段自动命令可以防止你在一个注释行中换行后，新行会继续注释的情况
Autocmd({ "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
  end,
})

-- autocmd({ "VimLeave" }, {
-- 	pattern = "*",
-- 	callback = function()
-- 		require("plenary.profile").stop()
-- 	end,
-- })

cmd([[
	" vim -b : edit binary using xxd-format!
	augroup Binary
	  autocmd!
	  autocmd BufReadPre  *.bin set binary
	  autocmd BufReadPost *.bin
	    \ if &binary
	    \ |   execute "silent %!xxd -c 32"
	    \ |   set filetype=xxd
	    \ |   redraw
	    \ | endif
	  autocmd BufWritePre *.bin
	    \ if &binary
	    \ |   let s:view = winsaveview()
	    \ |   execute "silent %!xxd -r -c 32"
	    \ | endif
	  autocmd BufWritePost *.bin
	    \ if &binary
	    \ |   execute "silent %!xxd -c 32"
	    \ |   set nomodified
	    \ |   call winrestview(s:view)
	    \ |   redraw
	    \ | endif
	augroup END
]])

-- 如果你安装了诸如 neotree 或 nvim-tree 这种大纲性质的插件并且它们被打开时，那么你可能希望在当前缓冲区删除的时候不会影响到现有的窗口布局。上面的自动命令 BUfferDelete 很好的完成了这件事。所以，再见 bufdelete.nvim 插件，该命令灵感来源于 NvChad 的早期版本。
Command("BufferDelete", function()
  ---@diagnostic disable-next-line: missing-parameter
  local file_exists = vim.fn.filereadable(vim.fn.expand("%p"))
  local modified = vim.api.nvim_buf_get_option(0, "modified")
  if file_exists == 0 and modified then
    local user_choice = vim.fn.input("The file is not saved, whether to force delete? Press enter or input [y/n]:")
    if user_choice == "y" or string.len(user_choice) == 0 then
      vim.cmd("bd!")
    end
    return
  end
  local force = not vim.bo.buflisted or vim.bo.buftype == "nofile"
  vim.cmd(force and "bd!" or string.format("bp | bd! %s", vim.api.nvim_get_current_buf()))
end, { desc = "Delete the current Buffer while maintaining the window layout" })
					ls.t("local function"),
				}),
				ls.i(2),
				ls.i(3),
				ls.i(0),
			}
		)
	), --}}}

	s( -- Require Module {{{
		{ trig = "req", name = "Require", dscr = "Choices are on the variable name" },
		fmt([[local {} = require("{}")]], {
			d(2, last_lua_module_section, { 1 }),
			ls.i(1),
		})
	), --}}}

	-- Start Refactoring --
	s("CMD", { -- [CMD] multiline vim.cmd{{{
		t({ "vim.cmd[[", "  " }),
		i(1, ""),
		t({ "", "]]" }),
	}), --}}}
	s("cmd", fmt("vim.cmd[[{}]]", { i(1, "") })), -- single line vim.cmd
	s({ -- github import for packer{{{
		trig = "https://github%.com/([%w-%._]+)/([%w-%._]+)!",
		regTrig = true,
		hidden = true,
	}, {
		t([[use "]]),
		f(function(_, snip)
			return snip.captures[1]
		end),
		t("/"),
		f(function(_, snip)
			return snip.captures[2]
		end),
		t({ [["]], "" }),
		i(1, ""),
	}), --}}}
	s( -- {regexSnippet} LuaSnippet{{{
		"regexSnippet",
		fmt(
			[=[
cs( -- {}
{{ trig = "{}", regTrig = true, hidden = true }}, fmt([[
{}
]], {{
  {}
}}))
      ]=],
			{
				i(1, "Description"),
				i(2, ""),
				i(3, ""),
				i(4, ""),
			}
		)
	), --}}}
	s( -- [luaSnippet] LuaSnippet{{{
		"luaSnippet",
		fmt(
			[=[
cs("{}", fmt( -- {}
[[
{}
]], {{
  {}
  }}){})
    ]=],
			{
				i(1, ""),
				i(2, "Description"),
				i(3, ""),
				i(4, ""),
				c(5, {
					t(""),
					fmt([[, "{}"]], { i(1, "keymap") }),
					fmt([[, {{ pattern = "{}", {} }}]], { i(1, "*/snippets/*.lua"), i(2, "keymap") }),
				}),
			}
		)
	), --}}}

	s( -- choice_node_snippet luaSnip choice node{{{
		"choice_node_snippet",
		fmt(
			[[
c({}, {{ {} }}),
]],
			{
				i(1, ""),
				i(2, ""),
			}
		)
	), --}}}
	s( -- [function] Lua function snippet{{{
		"function",
		fmt(
			[[
function {}({})
  {}
end
]],
			{
				i(1, ""),
				i(2, ""),
				i(3, ""),
			}
		)
	), --}}}
	s( -- [local_function] Lua function snippet{{{
		"local_function",
		fmt(
			[[
local function {}({})
  {}
end
]],
			{
				i(1, ""),
				i(2, ""),
				i(3, ""),
			}
		),
		"jlf"
	), --}}}
	s( -- [local] Lua local variable snippet{{{
		"local",
		fmt(
			[[
local {} = {}
  ]],
			{ i(1, ""), i(2, "") }
		),
		"jj"
	), --}}}
})
-- End Refactoring --
