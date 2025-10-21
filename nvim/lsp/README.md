# 🔧 LSP 服务器配置目录

这个目录包含各种语言服务器 (Language Server) 的配置文件，用于提供代码智能功能。

## 📁 目录结构

```
lsp/
├── clangd.lua          # C/C++ 语言服务器配置
├── gopls.lua           # Go 语言服务器配置
├── lua_ls.lua          # Lua 语言服务器配置
├── pyright.lua         # Python 语言服务器配置
├── rust_analyzer.lua   # Rust 语言服务器配置
├── tsserver.lua        # TypeScript/JavaScript 服务器配置
├── jsonls.lua          # JSON 语言服务器配置
├── yamlls.lua          # YAML 语言服务器配置
├── bashls.lua          # Bash 语言服务器配置
├── dockerls.lua        # Dockerfile 语言服务器配置
└── README.md           # 本文档
```

## 🌍 支持的语言服务器

### 🔧 系统语言
- **clangd** - C/C++ 语言服务器
  - 代码补全和导航
  - 静态分析
  - 重构支持
  - 编译数据库集成

- **rust-analyzer** - Rust 语言服务器
  - 类型推断
  - 宏展开
  - 错误检查
  - 代码生成

### 🌐 Web 开发
- **tsserver** - TypeScript/JavaScript
  - 类型检查
  - 智能重构
  - 导入管理
  - JSDoc 支持

- **html** - HTML 语言服务器
  - 标签补全
  - 属性验证
  - Emmet 支持

- **cssls** - CSS 语言服务器
  - 属性补全
  - 颜色预览
  - 语法验证

### 🐍 脚本语言
- **pyright** - Python 语言服务器
  - 类型检查
  - 导入解析
  - 代码补全
  - 重构支持

- **lua_ls** - Lua 语言服务器
  - Neovim API 支持
  - 类型推断
  - 诊断信息
  - 文档生成

### 🔧 后端语言
- **gopls** - Go 语言服务器
  - 模块感知
  - 接口实现
  - 测试支持
  - 性能分析

- **jdtls** - Java 语言服务器
  - 项目管理
  - 依赖解析
  - 调试支持
  - Maven/Gradle 集成

### 📄 配置语言
- **jsonls** - JSON 语言服务器
  - Schema 验证
  - 自动补全
  - 格式化
  - 错误检查

- **yamlls** - YAML 语言服务器
  - Schema 支持
  - 多文档处理
  - 语法验证
  - Kubernetes 支持

- **bashls** - Bash 语言服务器
  - 语法检查
  - 命令补全
  - 变量解析
  - ShellCheck 集成

## 🔧 服务器配置示例

### Go 语言服务器 (gopls.lua)
```lua
-- lsp/gopls.lua
return {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      gofumpt = true,
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
```

### TypeScript 服务器 (tsserver.lua)
```lua
-- lsp/tsserver.lua
return {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}
```

### Lua 语言服务器 (lua_ls.lua)
```lua
-- lsp/lua_ls.lua
return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
      },
    },
  },
}
```

## 🚀 LSP 功能

### 核心功能
- **代码补全** - 智能代码补全
- **错误诊断** - 实时错误检查
- **跳转定义** - 快速导航到定义
- **查找引用** - 查找符号引用
- **重命名** - 智能重命名
- **代码操作** - 快速修复和重构

### 高级功能
- **内联提示** - 类型和参数提示
- **代码镜头** - 额外信息显示
- **工作区符号** - 项目级符号搜索
- **调用层次** - 函数调用关系
- **类型层次** - 类型继承关系

## ⌨️ LSP 键位映射

### 导航功能
```lua
-- 定义和声明
gd                  -- 跳转到定义
gD                  -- 跳转到声明
gi                  -- 跳转到实现
gr                  -- 查找引用

-- 类型信息
gy                  -- 跳转到类型定义
K                   -- 显示悬浮文档
<C-k>               -- 显示签名帮助
```

### 编辑功能
```lua
-- 重构操作
<leader>rn          -- 重命名符号
<leader>ca          -- 代码操作
<leader>f           -- 格式化代码

-- 诊断导航
[d                  -- 上一个诊断
]d                  -- 下一个诊断
<leader>e           -- 显示行诊断
<leader>q           -- 诊断列表
```

### 工作区功能
```lua
-- 符号搜索
<leader>ws          -- 工作区符号
<leader>ds          -- 文档符号

-- 工作区管理
<leader>wa          -- 添加工作区文件夹
<leader>wr          -- 移除工作区文件夹
<leader>wl          -- 列出工作区文件夹
```

## 🔧 自定义 LSP 配置

### 添加新的语言服务器

1. **创建配置文件**:
```bash
# 为 Zig 语言创建配置
touch lsp/zls.lua
```

2. **编写配置内容**:
```lua
-- lsp/zls.lua
return {
  cmd = { "zls" },
  filetypes = { "zig" },
  root_dir = function(fname)
    return require("lspconfig.util").find_git_ancestor(fname)
  end,
  settings = {
    zls = {
      enable_snippets = true,
      enable_ast_check_diagnostics = true,
    },
  },
}
```

3. **注册服务器**:
```lua
-- 在 LSP 配置中注册
require("lspconfig").zls.setup(require("lsp.zls"))
```

### 修改现有配置

直接编辑对应的配置文件，例如修改 Go 配置：

```lua
-- lsp/gopls.lua
local config = require("lsp.gopls")

-- 添加自定义设置
config.settings.gopls.buildFlags = { "-tags=integration" }

-- 添加初始化选项
config.init_options = {
  usePlaceholders = true,
}

return config
```

## 🎯 特定语言配置

### Go 语言优化
```lua
-- 启用所有分析器
analyses = {
  fieldalignment = true,
  nilness = true,
  unusedwrite = true,
  useany = true,
}

-- 代码镜头
codelenses = {
  test = true,
  tidy = true,
  upgrade_dependency = true,
}
```

### TypeScript 优化
```lua
-- 严格模式
strict = true,

-- 导入组织
organizeImports = true,

-- 内联提示
inlayHints = {
  includeInlayParameterNameHints = "all",
  includeInlayFunctionParameterTypeHints = true,
}
```

### Python 优化
```lua
-- 类型检查模式
typeCheckingMode = "strict",

-- 导入分析
autoImportCompletions = true,

-- 诊断规则
diagnosticMode = "workspace",
```

## 🐛 故障排除

### 服务器未启动
```lua
-- 检查 LSP 状态
:LspInfo

-- 查看服务器日志
:LspLog

-- 重启 LSP 服务器
:LspRestart
```

### 配置不生效
```lua
-- 检查配置加载
:lua print(vim.inspect(require("lspconfig").gopls.get_config()))

-- 验证服务器设置
:lua print(vim.inspect(vim.lsp.get_active_clients()))
```

### 性能问题
```lua
-- 禁用不需要的功能
settings = {
  gopls = {
    analyses = {
      unusedparams = false,  -- 禁用未使用参数检查
    },
  },
}

-- 限制工作区范围
root_dir = function(fname)
  return vim.fn.getcwd()  -- 使用当前目录作为根
end
```

### 诊断问题
```lua
-- 调整诊断级别
vim.diagnostic.config({
  virtual_text = false,    -- 禁用虚拟文本
  signs = true,           -- 启用标记
  underline = true,       -- 启用下划线
  update_in_insert = false, -- 插入模式不更新
})
```

## 📚 相关文档

- [nvim-lspconfig 文档](https://github.com/neovim/nvim-lspconfig)
- [LSP 规范](https://microsoft.github.io/language-server-protocol/)
- [各语言服务器文档](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
- [主配置文档](../README.md)

## 💡 使用技巧

### 1. 项目特定配置
在项目根目录创建 `.nvim.lua` 文件，设置项目特定的 LSP 配置。

### 2. 条件加载
根据项目类型或环境条件加载不同的 LSP 配置。

### 3. 性能优化
对于大型项目，适当调整 LSP 设置以平衡功能和性能。

### 4. 多服务器支持
某些文件类型可以同时使用多个语言服务器，如 TypeScript 可以同时使用 tsserver 和 eslint。

### 5. 调试配置
使用 `:LspInfo` 和 `:LspLog` 命令调试 LSP 配置问题。

---

🔧 **提示**: LSP 配置是提供代码智能功能的核心，合理配置可以显著提升开发效率。