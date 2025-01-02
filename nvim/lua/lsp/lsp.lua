---------------------------------------------------lsp-----------------------------------------------------------------------------------

local M = {}

local lspTable = {
    {
        name = "jsonls",
        filetypes = { "json" },
        capabilities = M.capabilities,
    },

    {
        name = "autotools_ls",
        filetypes = { "config", "automake", "make" },
        capabilities = M.capabilities,
    },

    {

        name = "bashls",
        filetypes = { "sh", "zsh", "tmux" },
        cmd = { "bash-language-server", "start" },
        capabilities = M.capabilities,
    },
    {
        name = "marksman",
        filetypes = { "md" },
        capabilities = M.capabilities,
    },

    {
        name = "lua_ls",
        filetypes = { "lua" },
        on_attach = M.on_attach,
        capabilities = M.capabilities,
        on_init = function(client)
            if client.workspace_folders == nil then
                return
            end

            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                return
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        -- Depending on the usage, you might want to add additional paths here.
                        -- "${3rd}/luv/library"
                        -- "${3rd}/busted/library",
                    },
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                    -- library = api.nvim_get_runtime_file("", true)
                },
            })
        end,

        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim", "lvim" },
                },
                hint = {
                    enable = true, -- necessary
                },
            },
        },
        handlers = {
            ["textDocument/definition"] = function(err, result, ctx, config)
                if type(result) == "table" then
                    result = { result[1] }
                end
                vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
            end,
        },
    },
    {
        name = "gopls",
        filetypes = { "go", "gomod", "gosum", "gotmpl" },
        capabilities = M.capabilities,
        root_dir = function(fname)
            local gopath = os.getenv("GOPATH")
            if gopath == nil then
                gopath = ""
            end
            local lastRootPath = nil
            local fullpath = vim.fn.expand(fname, ":p")
            if string.find(fullpath, gopath .. "/pkg/mod") and lastRootPath ~= nil then
                return lastRootPath
            end
            lastRootPath = require("lspconfig/util").root_pattern("go.mod", ".git")(fname)
            return lastRootPath
        end,
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
                -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
                hints = {
                    -- rangeVariableTypes = true, -- 范围变量类型
                    constantValues = true,         -- 常数值
                    assignVariableTypes = true,    -- 分配变量类型
                    compositeLiteralFields = true, -- 复合文字字段
                    compositeLiteralTypes = true,  -- 复合文字类型
                    parameterNames = true,         -- 参数名称
                    functionTypeParameters = true, -- 函数类型参数
                },
            },
        },
    },

    -- 根目录下保存文件为 .clang-format
    -- BasedOnStyle: LLVM
    -- IndentWidth: 4
    -- ColumnLimit: 120
    {
        name = "clangd",
        capabilities = M.capabilities,
        cmd = {
            "clangd",
            unpack({
                -- 默认格式化风格: 谷歌开源项目代码指南
                "--fallback-style=google",

                -- 建议风格：打包(重载函数只会给出一个建议）
                -- 相反可以设置为detailed
                "--completion-style=bundled",

                "--completion-style=detailed",
                "--header-insertion-decorators",
                "--enable-config",
                "--offset-encoding=utf-8",
                "--ranking-model=heuristics",
                -- 跨文件重命名变量
                -- "--cross-file-rename",
                -- 设置verbose时，会把编译命令和索引构建结果，占用内存等信息都打印出来，需要检查索引构建失败原因时，可以设置为verbose, error
                "--log=error",
                -- 输出的 JSON 文件更美观
                "--pretty",
                -- 输入建议中，已包含头文件的项与还未包含头文件的项会以圆点加以区分
                "--header-insertion-decorators",
                -- "--folding-ranges",
                -- 在后台自动分析文件（基于complie_commands)
                "--background-index",
                -- 标记compelie_commands.json文件的目录位置
                -- "--compile-commands-dir=/Users/edte/go/src/login/test/wesing-backend-service-cpp/compile_commands.json",
                -- 告诉clangd用那个clang进行编译，路径参考which clang++的路径
                "--query-driver=/usr/bin/clang++",
                -- 启用 Clang-Tidy 以提供「静态检查」
                "--clang-tidy",
                -- Clang-Tidy 静态检查的参数，指出按照哪些规则进行静态检查，详情见「与按照官方文档配置好的 VSCode 相比拥有的优势」
                -- 参数后部分的*表示通配符
                -- 在参数前加入-，如-modernize-use-trailing-return-type，将会禁用某一规则
                -- "--clang-tidy-checks=cppcoreguidelines-*,performance-*,bugprone-*,portability-*,modernize-*,google-*",
                -- 默认格式化风格: 谷歌开源项目代码指南
                -- "--fallback-style=file",
                -- 同时开启的任务数量
                "-j=5",
                -- 全局补全（会自动补充头文件）
                "--all-scopes-completion",
                -- 更详细的补全内容
                "--completion-style=detailed",
                -- 补充头文件的形式
                "--header-insertion=iwyu",
                -- pch优化的位置(memory 或 disk，选择memory会增加内存开销，但会提升性能) 推荐在板子上使用disk
                "--pch-storage=memory",

                -- 启用这项时，补全函数时，将会给参数提供占位符，键入后按 Tab 可以切换到下一占位符，乃至函数末
                "--function-arg-placeholders=true",
            }),
        },
        on_attach = M.on_attach,
        filetypes = { "h", "c", "cpp" },
        init_options = {
            clangdFileStatus = true,
            -- compilationDatabasePath = "./build",
            fallback_flags = { "-std=c++17" },
        },
    },
}

M.lspConfig = function()
    -- 自动安装 lsp
    local lspconfig = Require("lspconfig")
    if lspconfig == nil then
        return
    end

    local lspConfigGroup = GroupId("autocmd_lspconfig_group", { clear = true })

    local function configSetup(filetype, name, config)
        Autocmd({ "FileType" }, {
            pattern = filetype,
            callback = function()
                lspconfig[name].setup(config)
            end,
            group = lspConfigGroup,
        })
    end

    for _, lsp in ipairs(lspTable) do
        configSetup(lsp.filetypes, lsp.name, lsp)
    end


    --  -- lsp debug
    -- vim.lsp.set_log_level(vim.log.levels.DEBUG)
    -- vim.lsp.log.set_format_func(vim.inspect)
end

M.on_attach = function(client, buf)
    if vim.fn.has("nvim-0.10") == 1 and client.supports_method("textDocument/inlayHint", { bufnr = buf }) then
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
end

M.capabilities = function()
    return require('blink.cmp').get_lsp_capabilities()
end


return M
