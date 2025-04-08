-- 根目录下保存文件为 .clang-format
-- BasedOnStyle: LLVM
-- IndentWidth: 4
-- ColumnLimit: 120
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/clangd.lua
return {
	name = "clangd",
	root_markers = { ".git", "Makefile" },
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
	filetypes = { "h", "c", "cpp", "objc", "objcpp", "cuda" },
	single_file_support = true,
	init_options = {
		clangdFileStatus = true,
		-- compilationDatabasePath = "./build",
		fallback_flags = { "-std=c++17" },
	},
	on_attach = function(client, buf)
		vim.lsp.inlay_hint.enable(true, { bufnr = buf })
	end,
}
