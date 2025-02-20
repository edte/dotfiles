local M = {}

local expand = true

function M.setup()
    local cmp, compare = require("cmp"), require("cmp.config.compare")
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
            -- kind：图标样式
            fields = { "kind", "abbr" },
            expandable_indicator = false,
            format = function(entry, kind)
                -- cmp icon highlight
                vim.cmd('highlight CmpItemKindFunction guifg=#CB6460')
                vim.cmd('highlight CmpItemKindInterface guifg=#659462')
                vim.cmd('highlight CmpItemKindConstant guifg=#BD805C')
                vim.cmd('highlight CmpItemKindVariable guifg=#BD805C')
                vim.cmd('highlight CmpItemKindStruct guifg=#6089EF')
                vim.cmd('highlight CmpItemKindClass guifg=#6089EF')
                vim.cmd('highlight CmpItemKindMethod guifg=#A25553')
                vim.cmd('highlight CmpItemKindField guifg=#BD805C')

                local highlights_info = require("colorful-menu").cmp_highlights(entry)

                if highlights_info ~= nil then
                    kind.abbr_hl_group = highlights_info.highlights
                    kind.abbr = highlights_info.text
                end

                kind.kind = icon.kind[kind.kind] or ""

                if vim.bo.filetype == "go" then
                    -- go 中非struct的type都是class，直接把这两都弄成一个icon
                    if kind.kind == "Struct" or kind.kind == "Class" then
                        kind.kind = icon.kind["Type"] or ""
                    elseif entry.source.name == "nvim_lsp_signature_help" and kind.kind == "Text" then -- 参数提醒
                        kind.kind = icon.kind["TypeParameter"] or ""
                    elseif entry.source.name == "treesitter" and kind.kind == "Property" then          -- treesitter提醒
                        kind.kind = icon.kind["Treesitter"] or ""
                    end
                end

                return kind
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
            async_budget = 1,
            max_view_entries = 80,
            filtering_context_budget = 1000,
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
                max_item_count = 1,
            },
            {
                name = "cmp_tabnine",
                priority = 9,
                max_item_count = 4,
            },
            {
                name = "nvim_lsp",
                priority = 8,
                option = {
                    markdown_oxide = {
                        keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
                    }
                }
            },
            {
                name = "luasnip",
                priority = 7,
                max_item_count = 4,
            },
            {
                name = "buffer",
                priority = 7,
                max_item_count = 4,
            },
            {
                name = "dictionary",
                priority = 6,
                keyword_length = 2,
                max_item_count = 4,
                -- keyword_pattern = [[\w\+]],
            },

            {
                name = "treesitter",
                priority = 6,
                max_item_count = 4,
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

            -- {
            --     name = "cmp_yanky",
            --     priority = 4,
            --     option = {
            --         onlyCurrentFiletype = true
            --     }
            -- },

            {
                name = "rg",
                max_item_count = 6,
                option = {
                    additional_arguments = { "--smart-case", "--max-depth", "4" },
                },
                priority = 7,
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
                compare.locality,
                compare.score,            -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
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
