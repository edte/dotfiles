local M = {
    buffer_requesting = {},
    methods = {
        "textDocument/implementation",
        "textDocument/definition",
        "textDocument/references",
    },
}

local lsp = vim.lsp
local api = vim.api
local SymbolKind = vim.lsp.protocol.SymbolKind

local defaults = {
    enable = true,
    include_declaration = false, -- Reference include declaration
    hide_zero_counts = true,     -- Hide lsp sections which have no content
    sections = {
        definition = function(count)
            return ""
        end,
        references = function(count)
            if count == 1 then
                return count .. " usage"
            end
            return count .. " usages"
        end,
        implements = function(count)
            return ""
        end,
        git_authors = function(latest_author, count)
            return latest_author .. (count - 1 == 0 and "" or (" + " .. count - 1))
        end,
    },
    separator = " | ",
    decorator = function(line)
        return line
    end,
    ignore_filetype = {
        "prisma",
    },
    -- Target Symbol Kinds to show lens information
    target_symbol_kinds = {
        SymbolKind.Function,
        SymbolKind.Method,
        SymbolKind.Interface,
        SymbolKind.Class,
        SymbolKind.Struct, -- This is what you need
        SymbolKind.Variable,
        SymbolKind.Constant,
        SymbolKind.Constructor,
        SymbolKind.Namespace,
        SymbolKind.File,
        SymbolKind.Enum,
    },
    -- Symbol Kinds that may have target symbol kinds as children
    wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
    -- Defines indentation logic. false means based on the line.
    indent_by_lsp = true,
}

M.config = vim.deepcopy(defaults)

---Shallow merge two table
---@param tbl1 table
---@param tbl2 table
---@return table merged_table
function M:merge_table(tbl1, tbl2)
    local ret = {}
    for _, item in pairs(tbl1 or {}) do
        table.insert(ret, item)
    end
    for _, item in pairs(tbl2 or {}) do
        table.insert(ret, item)
    end
    return ret
end

---Return index if given bufnr is doing request, -1 otherwise
---@param bufnr integer
---@return integer is_buf_requesting
function M:is_buf_requesting(bufnr)
    for idx, num in ipairs(M.buffer_requesting) do
        if num == bufnr then
            return idx
        end
    end
    return -1
end

---Set given bugnr is requesting, method 0 for begin request and method 1 for request end.
---@param bufnr integer
---@param method integer
function M:set_buf_requesting(bufnr, method)
    if method == 0 then
        table.insert(M.buffer_requesting, bufnr)
    else
        table.remove(M.buffer_requesting, M:is_buf_requesting(bufnr))
    end
end

---Write table to txt for debugging
---@param tbl table
function M:write_table(tbl)
    local file = io.open("./log.txt", "w")
    if file then
        file:write(vim.inspect(tbl))
        file:close()
    end
end

local function default_hl()
    return {
        LspLens = { link = "LspCodeLens", default = true },
    }
end


local lsplens = {}

function M.result_count(results)
    local ret = 0
    for _, res in pairs(results or {}) do
        for _, _ in pairs(res.result or {}) do
            ret = ret + 1
        end
    end
    return ret
end

function M.requests_done(finished)
    for _, p in pairs(finished) do
        if not (p[1] == true and p[2] == true and p[3] == true) then
            return false
        end
    end
    return true
end

function M.get_functions(result)
    local ret = {}
    for _, v in pairs(result or {}) do
        if vim.tbl_contains(M.config.target_symbol_kinds, v.kind) then
            if v.range and v.range.start then
                table.insert(ret, {
                    name = v.name,
                    rangeStart = v.range.start,
                    rangeEnd = v.range["end"],
                    selectionRangeStart = v.selectionRange.start,
                    selectionRangeEnd = v.selectionRange["end"],
                })
            end
        end

        if vim.tbl_contains(M.config.wrapper_symbol_kinds, v.kind) then
            ret = M:merge_table(ret, M.get_functions(v.children)) -- Recursively find methods
        end
    end
    return ret
end

function M.get_cur_document_functions(results)
    local ret = {}
    for _, res in pairs(results or {}) do
        ret = M:merge_table(ret, M.get_functions(res.result))
    end
    return ret
end

function M.lsp_support_method(buf, method)
    for _, client in pairs(lsp.get_clients({ bufnr = buf })) do
        if client.supports_method(method) then
            return true
        end
    end
    return false
end

function M.create_string(counting)
    local cfg = M.config
    local text = ""
    local opts = {}

    -- Print(counting.git_authors)

    -- TODO: refactor
    local function append_with(count, fn)
        if fn == nil or (cfg.hide_zero_counts and count == 0) then
            return
        end

        local formatted = fn(count)
        if formatted == nil or formatted == "" then
            return
        end

        text = text == "" and formatted or text .. cfg.separator .. formatted
    end

    local has = false

    if counting.reference then
        append_with(counting.reference, cfg.sections.references)

        if text ~= "" then
            table.insert(opts, { '', 'SymbolUsageRounding' })
            table.insert(opts, { '󰌹 ', 'SymbolUsageRef' })
            table.insert(opts, { cfg.decorator(text), "SymbolUsageContent" })
            table.insert(opts, { '', 'SymbolUsageRounding' })
            has = true
        end
    end

    if counting.definition then
        append_with(counting.definition, cfg.sections.definition)
    end

    if counting.implementation then
        append_with(counting.implementation, cfg.sections.implements)
    end

    local formatted

    if counting.git_authors then
        if not (cfg.sections.git_authors == nil or (cfg.hide_zero_counts and counting.git_authors.count == 0)) then
            formatted = cfg.sections.git_authors(counting.git_authors.latest_author, counting.git_authors.count)
            text = text == "" and formatted or text .. cfg.separator .. formatted
            -- print(formatted)
        end

        if has then
            table.insert(opts, { ' ', 'SymbolUsageRounding' })
        end

        -- print(has, formatted)

        if formatted ~= nil then
            table.insert(opts, { '', 'SymbolUsageRounding' })
            table.insert(opts, { ' ', 'SymbolUsageImpl' })
            table.insert(opts, { cfg.decorator(formatted), "SymbolUsageContent" })
            table.insert(opts, { '', 'SymbolUsageRounding' })
        end
    end


    return text == "" and "" or cfg.decorator(text), opts
end

function M.delete_existing_lines(bufnr, ns_id)
    local existing_marks = vim.api.nvim_buf_get_extmarks(bufnr, ns_id, 0, -1, {})
    for _, v in pairs(existing_marks) do
        vim.api.nvim_buf_del_extmark(bufnr, ns_id, v[1])
    end
end

function M.normalize_rangeStart_character(bufnr, query)
    local cfg = M.config
    local lines = vim.api.nvim_buf_get_lines(bufnr, query.line, query.line + 1, true)
    if #lines == 0 then
        return
    end
    local line = lines[1]

    if not cfg.indent_by_lsp then
        local tabstop = vim.api.nvim_buf_get_option(bufnr, "tabstop")
        local normalized_text = string.gsub(line, "\t", string.rep(" ", tabstop))
        local _, space_count = string.find(normalized_text, "^%s*")
        query.character = space_count
        return
    end

    local clients = lsp.get_clients({ bufnr = bufnr, name = "lua_ls" })

    if vim.tbl_isempty(clients) then
        return
    end

    local str = "local "
    local indent = line:match("^%s+")
    indent = indent and indent:len() or 0
    local trimmed = vim.trim(line)

    if trimmed:sub(1, str:len()) == str then
        query.character = indent + query.character - str:len()
    end
end

function M.display_lines(bufnr, query_results)
    if vim.fn.bufexists(bufnr) == 0 then
        return
    end
    local ns_id = vim.api.nvim_create_namespace("lsp-lens")
    M.delete_existing_lines(bufnr, ns_id)
    for _, query in pairs(query_results or {}) do
        local virt_lines = {}
        -- Print(query.counting)
        -- print("\n")
        local display_str, opts = M.create_string(query.counting)

        if not (display_str == "") then
            M.normalize_rangeStart_character(bufnr, query.rangeStart)

            local vline = { { string.rep(" ", query.rangeStart.character) .. display_str, "LspLens" } }
            table.insert(virt_lines, vline)

            local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end
            vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

            -- 定义一个高亮组，设置背景颜色为主题背景色，字体颜色为灰色
            vim.cmd('highlight MyHighlightGroup guifg=grey guibg=NONE')

            -- print(vim.inspect(opts))
            -- print("\n")
            -- Print(opts)

            -- print(bufnr, ns_id, query.rangeStart.line)

            if query.rangeStart.line < vim.api.nvim_buf_line_count(bufnr) then
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, query.rangeStart.line, 0, {
                    -- virt_lines = virt_lines,
                    virt_text = opts,

                    -- virt_lines_above = true,
                    virt_text_pos = "eol",
                })
            end
        end
    end
end

function M.get_recent_editor(start_row, end_row, callback)
    local file_path = vim.fn.expand("%:p")

    local stdout = vim.loop.new_pipe()
    if stdout == nil then
        return
    end

    local authors = {}
    local most_recent_editor = nil
    vim.loop.spawn("git", {
        args = { "blame", "-L", start_row .. "," .. end_row, "--incremental", file_path },
        stdio = { nil, stdout, nil },
    }, function(_, _)
        local authors_arr = {}
        for author_name, _ in pairs(authors) do
            table.insert(authors_arr, author_name)
        end
        callback(most_recent_editor, authors_arr)
    end)
    vim.loop.read_start(stdout, function(err, data)
        if data == nil then
            return
        end

        for line in string.gmatch(data, "[^\r\n]+") do
            local space_pos = string.find(line, " ")
            if space_pos ~= nil then
                local key = string.sub(line, 1, space_pos - 1)
                local val = string.sub(line, space_pos + 1)
                if key == "author" then
                    -- if key == "author" or key == "committer" then
                    authors[val] = true
                    if most_recent_editor == nil then
                        most_recent_editor = val
                    end
                end
            end
        end
    end)
end

function M.do_request(symbols)
    if not (M:is_buf_requesting(symbols.bufnr) == -1) then
        return
    else
        M:set_buf_requesting(symbols.bufnr, 0)
    end

    local functions = symbols.document_functions_with_params
    local finished = {}

    for idx, function_info in pairs(functions or {}) do
        table.insert(finished, { false, false, false, false })

        local params = function_info.query_params
        local counting = {}

        if M.config.sections.implements and M.lsp_support_method(symbols.bufnr, M.methods[1]) then
            lsp.buf_request_all(symbols.bufnr, M.methods[1], params, function(implements)
                counting["implementation"] = M.result_count(implements)
                finished[idx][1] = true
            end)
        else
            finished[idx][1] = true
        end

        if M.config.sections.definition and M.lsp_support_method(symbols.bufnr, M.methods[2]) then
            lsp.buf_request_all(symbols.bufnr, M.methods[2], params, function(definition)
                counting["definition"] = M.result_count(definition)
                finished[idx][2] = true
            end)
        else
            finished[idx][2] = true
        end

        if M.config.sections.references and M.lsp_support_method(symbols.bufnr, M.methods[3]) then
            params.context = { includeDeclaration = M.config.include_declaration }
            lsp.buf_request_all(symbols.bufnr, M.methods[3], params, function(reference)
                counting["reference"] = M.result_count(reference)
                finished[idx][3] = true
            end)
        else
            finished[idx][3] = true
        end

        if M.config.sections.git_authors then
            M.get_recent_editor(
                function_info.rangeStart.line + 1,
                function_info.rangeEnd.line + 1,
                function(latest_author, authors)
                    counting["git_authors"] = { latest_author = latest_author, count = #authors }
                    finished[idx][4] = true
                end
            )
        else
            finished[idx][4] = true
        end

        function_info["counting"] = counting
    end

    local timer = vim.loop.new_timer()
    timer:start(
        0,
        500,
        vim.schedule_wrap(function()
            if M.requests_done(finished) then
                if timer ~= nil and timer:is_closing() == false then
                    timer:close()
                end
                M.display_lines(symbols.bufnr, functions)
                M:set_buf_requesting(symbols.bufnr, 1)
            end
        end)
    )
end

function M.make_params(results)
    for _, query in pairs(results or {}) do
        local params = {
            position = {
                character = query.selectionRangeEnd.character,
                line = query.selectionRangeEnd.line,
            },
            textDocument = lsp.util.make_text_document_params(),
        }
        query.query_params = params
    end
    return results
end

function M.lsp_lens_on()
    M.config.enable = true
    M.procedure()
end

function M.lsp_lens_off()
    M.config.enable = false
    M.delete_existing_lines(0, vim.api.nvim_create_namespace("lsp-lens"))
end

function M.lsp_lens_toggle()
    if M.config.enable then
        M.lsp_lens_off()
    else
        M.lsp_lens_on()
    end
end

function M.procedure()
    if M.config.enable == false then
        M.lsp_lens_off()
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()

    for _, val in pairs(M.config.ignore_filetype) do
        if (val == vim.api.nvim_buf_get_option(bufnr, "filetype")) then
            return
        end
    end

    local method = "textDocument/documentSymbol"
    if M.lsp_support_method(bufnr, method) then
        local params = { textDocument = lsp.util.make_text_document_params() }
        lsp.buf_request_all(bufnr, method, params, function(document_symbols)
            -- vim.pretty_print(lsp.buf_request_sync(0, "textDocument/codeLens", document_symbols, 1000))
            local symbols = {}
            symbols["bufnr"] = bufnr
            symbols["document_symbols"] = document_symbols
            symbols["document_functions"] = M.get_cur_document_functions(symbols.document_symbols)
            symbols["document_functions_with_params"] = M.make_params(symbols.document_functions)
            M.do_request(symbols)
        end)
    end
end

function M.setup(opts)
    opts = opts or {}
    for k, v in pairs(opts.sections and opts.sections or {}) do
        if type(v) == "boolean" and v then
            opts.sections[k] = nil
        end
    end
    M.config = vim.tbl_deep_extend("force", defaults, opts)

    for group, hl in pairs(default_hl()) do
        api.nvim_set_hl(0, group, hl)
    end

    vim.api.nvim_create_user_command("LspLensOn", M.lsp_lens_on, {})
    vim.api.nvim_create_user_command("LspLensOff", M.lsp_lens_off, {})
    vim.api.nvim_create_user_command("LspLensToggle", M.lsp_lens_toggle, {})

    vim.api.nvim_create_autocmd({ "LspAttach", "TextChanged", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("lsp_lens", { clear = true }),
        callback = M.procedure,
    })
end

return M
