local M = {}

local expand = true
local maxItemWidth = 90

local function parseFunctionSignature(signature)
    -- 匹配参数和返回值的模式
    local paramPattern = "^%((.-)%)"
    local returnPattern = "%)(%s*%b())$"
    local mixedPattern = "^%((.-)%)%s*(.*)$"

    local params, returns

    -- 尝试匹配参数和返回值都在括号内的情况
    local paramMatch = signature:match(paramPattern)
    local returnMatch = signature:match(returnPattern)

    if paramMatch then
        params = "(" .. paramMatch .. ")"
    end

    if returnMatch then
        returns = returnMatch
    end

    -- 如果没有匹配到返回值，尝试匹配参数在括号内，返回值在括号外的情况
    if not returns then
        local mixedParam, mixedReturn = signature:match(mixedPattern)
        if mixedParam then
            params = "(" .. mixedParam .. ")"
        end
        if mixedReturn then
            returns = mixedReturn
        end
    end

    if params == nil then
        params = "()"
    end

    if returns == nil then
        returns = ""
    end

    return params, returns
end

local put_down_snippet = function(entry1, entry2)
    local types = require("cmp.types")
    local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
    local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
    kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
    kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
    if kind1 ~= kind2 then
        if kind1 == types.lsp.CompletionItemKind.Snippet then
            return false
        end
        if kind2 == types.lsp.CompletionItemKind.Snippet then
            return true
        end
    end
    return nil
end

local function trim_detail(detail)
    if detail then
        detail = vim.trim(detail)
        if vim.startswith(detail, "(use") then
            detail = string.sub(detail, 6, #detail)
            detail = "(" .. detail
        end
    end
    return detail
end

-- 在一个字符串（haystack）中查找另一个字符串（needle）最后一次出现的位置
-- Lua 的字符串索引从 1 开始
-- 如果你调用 findLast("hello, world", "o")，函数会返回 8，因为 "o" 在 "hello, world" 中最后一次出现的位置是 8
local function findLast(haystack, needle)
    local i = haystack:match(".*" .. needle .. "()")
    if i == nil then
        return nil
    else
        return i - 1
    end
end

local function match_fn(description)
    return string.match(description, "^pub fn")
        or string.match(description, "^fn")
        or string.match(description, "^unsafe fn")
        or string.match(description, "^pub unsafe fn")
        or string.match(description, "^pub const unsafe fn")
        or string.match(description, "^const fn")
        or string.match(description, "^pub const fn")
end

local function rust_fmt(entry, vim_item)
    local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
    })(entry, vim_item)
    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local completion_item = entry:get_completion_item()
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number

    local label_detail = completion_item.labelDetails
    if item_kind == 3 or item_kind == 2 then -- Function/Method
        --[[ labelDetails.
        function#function#if detail: {
          description = "pub fn shl(self, rhs: Rhs) -> Self::Output",
          detail = " (use std::ops::Shl)"
        } ]]
        if label_detail then
            local detail = label_detail.detail
            detail = trim_detail(detail)
            local description = label_detail.description
            if description then
                if string.sub(description, #description, #description) == "," then
                    description = description:sub(1, #description - 1)
                end
            end
            if
                (detail and vim.startswith(detail, "macro")) or (description and vim.startswith(description, "macro"))
            then
                kind.concat = kind.abbr
                goto OUT
            end
            if detail and description then
                if match_fn(description) then
                    local start_index, _ = string.find(description, "(", nil, true)
                    if start_index then
                        description = description:sub(start_index, #description)
                    end
                end
                local index = string.find(kind.abbr, "(", nil, true)
                -- description: "macro simd_swizzle"
                -- detail: " (use std::simd::simd_swizzle)"
                if index then
                    local prefix = string.sub(kind.abbr, 1, index - 1)
                    kind.abbr = prefix .. description .. " " .. detail
                    kind.concat = "fn " .. prefix .. description .. "{}//" .. detail
                    kind.offset = 3
                else
                    kind.concat = kind.abbr .. "  //" .. detail
                    kind.abbr = kind.abbr .. " " .. detail
                end
            elseif detail then
                kind.concat = "fn " .. kind.abbr .. "{}//" .. detail
                kind.abbr = kind.abbr .. " " .. detail
            elseif description then
                if match_fn(description) then
                    local start_index, _ = string.find(description, "%(")
                    if start_index then
                        description = description:sub(start_index, #description)
                    end
                end
                local index = string.find(kind.abbr, "(", nil, true)
                if index then
                    local prefix = string.sub(kind.abbr, 1, index - 1)
                    kind.abbr = prefix .. description .. " "
                    kind.concat = "fn " .. prefix .. description .. "{}//"
                    kind.offset = 3
                else
                    kind.concat = kind.abbr .. "  //" .. description
                    kind.abbr = kind.abbr .. " " .. description
                end
            else
                kind.concat = kind.abbr
            end
        end
    elseif item_kind == 15 then
    elseif item_kind == 5 then -- Field
        local detail = completion_item.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = "struct S {" .. kind.abbr .. ": " .. detail .. "}"
            kind.abbr = kind.abbr .. ": " .. detail
        else
            kind.concat = "struct S {" .. kind.abbr .. ": String" .. "}"
        end
        kind.offset = 10
    elseif item_kind == 6 or item_kind == 21 then -- variable constant
        if label_detail then
            local detail = label_detail.description
            if detail then
                kind.concat = "let " .. kind.abbr .. ": " .. detail
                kind.abbr = kind.abbr .. ": " .. detail
                kind.offset = 4
            else
                kind.concat = kind.abbr
            end
        end
    elseif item_kind == 9 then -- Module
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = kind.abbr .. "  //" .. detail
            kind.abbr = kind.abbr .. " " .. detail
            kind.offset = 0
        else
            kind.concat = kind.abbr
        end
    elseif item_kind == 8 then -- Trait
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = "trait " .. kind.abbr .. "{}//" .. detail
            kind.abbr = kind.abbr .. " " .. detail
        else
            kind.concat = "trait " .. kind.abbr .. "{}"
            kind.abbr = kind.abbr
        end
        kind.offset = 6
    elseif item_kind == 22 then -- Struct
        local detail = label_detail.detail
        detail = trim_detail(detail)
        if detail then
            kind.concat = kind.abbr .. "  //" .. detail
            kind.abbr = kind.abbr .. " " .. detail
        else
            kind.concat = kind.abbr
        end
    elseif item_kind == 1 then -- "Text"
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    elseif item_kind == 14 then
        if kind.abbr == "mut" then
            kind.concat = "let mut"
            kind.offset = 4
        else
            kind.concat = kind.abbr
        end
    else
        -- if label_detail then
        --     local detail = label_detail.detail
        --     local description = label_detail.description
        --     if detail then
        --         kind.abbr = kind.abbr .. " " .. detail
        --     end
        --     if description then
        --         kind.abbr = kind.abbr .. " " .. description
        --     end
        -- end
        -- if completion_item.detail then
        --     kind.abbr = kind.abbr .. " " .. completion_item.detail
        -- end
        kind.concat = kind.abbr
    end
    if item_kind == 15 then
        kind.concat = ""
    end
    ::OUT::
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 60 then
        kind.abbr = kind.abbr:sub(1, 60)
    end
    return kind
end

local function lua_fmt(entry, kind)
    -- 要比主题插件后加载，不然会被覆盖
    Cmd('highlight CmpItemKindFunction guifg=#CB6460')
    Cmd('highlight CmpItemKindInterface guifg=#659462')
    Cmd('highlight CmpItemKindConstant guifg=#BD805C')
    Cmd('highlight CmpItemKindVariable guifg=#BD805C')
    Cmd('highlight CmpItemKindStruct guifg=#6089EF')
    Cmd('highlight CmpItemKindClass guifg=#6089EF')
    Cmd('highlight CmpItemKindMethod guifg=#A25553')
    Cmd('highlight CmpItemKindField guifg=#BD805C')

    -- go 中非struct的type都是class，直接把这两都弄成一个icon
    if kind.kind == "Struct" or kind.kind == "Class" then
        kind.kind = icon.go["Type"] or ""
    elseif entry.source.name == "nvim_lsp_signature_help" and kind.kind == "Text" then -- 参数提醒
        kind.kind = icon.go["TypeParameter"] or ""
    elseif entry.source.name == "treesitter" and kind.kind == "Property" then          -- treesitter提醒
        kind.kind = icon.go["Treesitter"] or ""
    else
        kind.kind = icon.go[kind.kind] or ""
    end


    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    if item_kind == 5 then             -- Field
        kind.concat = "v." .. kind.abbr
        kind.offset = 2
    elseif item_kind == 1 then -- Text
        kind.concat = '"' .. kind.abbr .. '"'
        kind.offset = 1
    else
        kind.concat = kind.abbr
    end
    kind.abbr = kind.abbr
    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = nil
    if string.len(kind.abbr) > 50 then
        kind.abbr = kind.abbr:sub(1, 50)
    end
    return kind
end

local function go_fmt(entry, kind)
    -- 要比主题插件后加载，不然会被覆盖
    Cmd('highlight CmpItemKindFunction guifg=#CB6460')
    Cmd('highlight CmpItemKindInterface guifg=#659462')
    Cmd('highlight CmpItemKindConstant guifg=#BD805C')
    Cmd('highlight CmpItemKindVariable guifg=#BD805C')
    Cmd('highlight CmpItemKindStruct guifg=#6089EF')
    Cmd('highlight CmpItemKindClass guifg=#6089EF')
    Cmd('highlight CmpItemKindMethod guifg=#A25553')
    Cmd('highlight CmpItemKindField guifg=#BD805C')

    -- go 中非struct的type都是class，直接把这两都弄成一个icon
    if kind.kind == "Struct" or kind.kind == "Class" then
        kind.kind = icon.go["Type"] or ""
    elseif entry.source.name == "nvim_lsp_signature_help" and kind.kind == "Text" then -- 参数提醒
        kind.kind = icon.go["TypeParameter"] or ""
    elseif entry.source.name == "treesitter" and kind.kind == "Property" then          -- treesitter提醒
        kind.kind = icon.go["Treesitter"] or ""
    else
        kind.kind = icon.go[kind.kind] or ""
    end

    -- if string.ends(kind.abbr, "~") then
    --     kind.abbr = string.sub(kind.abbr, 1, -2)
    -- end


    local strings = vim.split(kind.kind, "%s", { trimempty = true })
    local item_kind = entry:get_kind() --- @type lsp.CompletionItemKind | number
    local completion_item = entry:get_completion_item()

    -- concat 和 offset 都是nvim cmp魔改之后用于高亮的，原理还不太懂

    local detail = completion_item.detail
    if item_kind == 5 then -- Field
        if detail then
            local last = findLast(kind.abbr, "%.")
            if last then
                kind.abbr = kind.abbr .. " " .. detail
            else
                local size = utf8len(kind.abbr) + utf8len(detail)
                local bank = maxItemWidth - size

                kind.abbr = string.format("%s%" .. bank .. "s", kind.abbr, "") .. detail
            end
        else
            log.error("3", kind.abbr, detail)
            kind.abbr = kind.abbr .. " " .. detail
        end
    elseif item_kind == 1 then                    -- Text
    elseif item_kind == 6 or item_kind == 21 then -- Variable or Constant
        -- log.error(kind, entry)

        if detail then
            local size = utf8len(kind.abbr) + utf8len(detail)
            local bank = maxItemWidth - size
            kind.abbr = string.format("%s%" .. bank .. "s", kind.abbr, "") .. detail
        end
    elseif item_kind == 22 then -- Struct
        detail = " struct{}"

        local size = utf8len(kind.abbr) + utf8len(detail)
        local bank = maxItemWidth - size
        kind.abbr = string.format("%s%" .. bank .. "s", kind.abbr, "") .. detail
    elseif item_kind == 3 or item_kind == 2 then -- Function/Method
        -- 有deatil信息，这里应该都是导包的名字，或者函数的返回值
        if detail then
            detail = detail:sub(5, #detail)
            -- 去除~符号
            kind.abbr = string.sub(kind.abbr, 1, -2)

            local size = utf8len(kind.abbr) + utf8len(detail)
            local bank = maxItemWidth - size
            if bank < 0 then
                bank = 0
            end

            if detail == "()" then
                kind.abbr = string.format("%s%" .. bank .. "s", kind.abbr .. detail, "")
            else
                local b, e = string.find(detail, "from")
                if b == 3 and e == 6 then
                    kind.abbr = string.format("%s%" .. bank .. "s", kind.abbr, "") .. detail
                    -- log.error("%s%" .. bank .. "s", kind, detail)
                else
                    local params, returns = parseFunctionSignature(detail)
                    kind.abbr = string.format("%s%" .. bank .. "s", kind.abbr .. params, "") .. returns
                end
            end
        else
            log.error("4", kind.abbr, detail)
            kind.abbr = kind.abbr
        end

        -- log.error(kind.word)
    elseif item_kind == 9 then -- Module
        if detail then
            kind.abbr = string.sub(kind.abbr, 1, -2)


            local size = utf8len(kind.abbr) + utf8len(detail)
            local bank = maxItemWidth - size

            -- kind.abbr = kind.abbr .. " " .. detail
            kind.abbr = string.format("%s%" .. bank .. "s", kind.abbr, "") .. detail
        end
    elseif item_kind == 8 then -- Interface
        detail = "interface{}"

        local size = utf8len(kind.abbr) + utf8len(detail)
        local bank = maxItemWidth - size
        kind.abbr = string.format("%s%" .. bank .. "s", kind.abbr, "") .. detail
    else
        if string.ends(kind.abbr, "~") then
            kind.abbr = string.sub(kind.abbr, 1, -2)
        end

        -- log.error(entry.source.name, kind, detail)
    end

    kind.kind = " " .. (strings[1] or "") .. " "
    kind.menu = ""



    local highlights_info = require("colorful-menu").cmp_highlights(entry)

    -- if highlight_info==nil, which means missing ts parser, let's fallback to use default `vim_item.abbr`.
    -- What this plugin offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
    if highlights_info ~= nil then
        kind.abbr_hl_group = highlights_info.highlights
        kind.abbr = highlights_info.text
    end

    return kind
end


function M.setup(opts)
    local cmp, compare = Require("cmp"), Require("cmp.config.compare")
    if cmp == nil then
        return
    end
    if compare == nil then
        return
    end

    cmp.setup.filetype({ "markdown" }, {
        completion = {
            autocomplete = false,
        },
    })

    cmp.setup.filetype({ "query" }, {
        sources = {
            { name = "treesitter" },
        },
    })

    -- cmp 源
    cmp.setup({
        formatting = {
            -- fields = { "abbr", "kind", "menu" },

            -- 每一项的样式：
            -- kind：图标样式
            --
            fields = { "kind", "abbr" },

            format = function(entry, cmp_item)
                -- log.error(cmp_item)

                local function commom_format(e, item)
                    local kind = require("lspkind").cmp_format({
                        mode = "symbol_text",
                        -- show_labelDetails = true, -- show labelDetails in menu. Disabled by default
                    })(e, item)
                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    kind.kind = " " .. (strings[1] or "") .. " "
                    -- kind.menu = ""
                    kind.concat = kind.abbr
                    return kind
                end

                if vim.bo.filetype == "rust" then
                    return rust_fmt(entry, cmp_item)
                elseif vim.bo.filetype == "lua" then
                    return lua_fmt(entry, cmp_item)
                elseif vim.bo.filetype == "go" then
                    return go_fmt(entry, cmp_item)
                else
                    return commom_format(entry, cmp_item)
                end
            end,

        },

        preselect = cmp.PreselectMode.Item,
        completion = { completeopt = "menu,menuone,noinsert" },
        window = {
            documentation = cmp.config.window.bordered(),
            -- completion = cmp.config.window.bordered(),
            completion = cmp.config.window.bordered({
                -- winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None'
                winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
            }),
        },
        view = {
            docs = {
                auto_open = false,
            },
        },

        performance = {
            debounce = 0,
            throttle = 0,
            fetching_timeout = 5,
            confirm_resolve_timeout = 80,
            -- async_budget = 1,
            max_view_entries = 20,
        },

        snippet = {
            expand = function(args)
                if not expand then
                    local function remove_bracket_contents(input)
                        local pattern = "^(.*)%b().*$"
                        local result = string.gsub(input, pattern, "%1")
                        return result
                    end
                    args.body = remove_bracket_contents(args.body)
                    expand = true
                end
                require("luasnip").lsp_expand(args.body)
            end,
        },

        mapping = cmp.mapping.preset.insert({
            ["<space>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.close()
                    fallback()
                else
                    fallback()
                end
            end),
            ["<CR>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.confirm({ select = true })
                    -- cmp.complete()
                else
                    fallback()
                end
                _G.has_moved_up = false
            end),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            -- ["<down>"] = function(fallback)
            -- if cmp.visible() then
            --     if cmp.core.view.custom_entries_view:is_direction_top_down() then
            --         -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            --         cmp.select_next_item()
            --     else
            --         cmp.select_prev_item()
            --     end
            -- else
            --     fallback()
            -- end
            -- end,
            -- ["<up>"] = function(fallback)
            --     if cmp.visible() then
            --         if cmp.core.view.custom_entries_view:is_direction_top_down() then
            --             cmp.select_prev_item()
            --         else
            --             cmp.select_next_item()
            --         end
            --     else
            --         fallback()
            --     end
            -- end,

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
                name = "nvim_lsp_signature_help",
                priority = 10,
            },
            {
                name = "cmp_tabnine",
                priority = 9,
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
                keyword_length = 2,
                max_item_count = 5,
                -- keyword_pattern = [[\w\+]],
            },

            {
                name = "treesitter",
                priority = 6,
            },

            {
                name = "go_pkgs",
                priority = 7,
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
                -- Require "cmp-under-comparator".under,
                -- cmp.config.compare.kind,  -- “kind”序数值较小的整体将排名较高
                -- cmp.config.compare.sort_text, -- 条目将按照 sortText 的字典顺序进行排名
                -- cmp.config.compare.length,  --条目，与较短的标签的长度将位居高
                -- cmp.config.compare.order, -- 项与小id将排名更高的
                -- compare.recently_used, --最近使用的条目将排名更高
                -- cmp.locality       --地点:项目与更高的地方(即，言语更接近于光标)将排名较高
                -- compare.scopes  -- 在更近的作用域中定义的条目排名会更高（例如，优先选择局部变量，而不是全局变量

                -- -- Require("cmp.config.compare").sort_text, -- 这个放第一个, 其他的随意
                -- compare.exact,         -- 精准匹配
                -- compare.recently_used, -- 最近用过的靠前
                -- compare.kind,
                -- Require("clangd_extensions.cmp_scores"),
                -- compare.score, -- 得分高靠前
                -- compare.order,
                -- compare.offset,
                -- compare.length, -- 短的靠前
                -- compare.sort_test,

                cmp.config.compare.exact, -- 具有精确== true的条目将排名更高
                put_down_snippet,
                compare.locality,
                compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
                compare.recently_used,
                Require("cmp_tabnine.compare"),
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
end

return M
