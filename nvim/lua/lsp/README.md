# 🔍 LSP 模块

语言服务器协议 (Language Server Protocol) 配置模块，提供强大的代码智能功能。

## 📦 包含的插件

### 🔧 核心 LSP
- **go.nvim** - Go 语言专用增强
  - 自动导入管理
  - 结构体标签添加
  - Go 特定命令集成

### 💊 诊断显示
- **tiny-inline-diagnostic.nvim** - 内联诊断显示
  - 实时错误提示
  - 多种显示风格
  - 性能优化

### 🎨 代码格式化
- **conform.nvim** - 统一格式化工具
  - 多语言支持
  - 保存时自动格式化
  - 自定义格式化器

### 🔨 C/C++ 增强
- **clangd_extensions.nvim** - Clangd 扩展功能
  - 内联提示
  - AST 查看
  - 头文件切换

### 🎯 语法高亮
- **jce-highlight** - JCE 文件语法高亮
- **codelens.nvim** - 代码引用显示
- **lsp-hover.nvim** - 悬停信息增强

### 👁️ 代码预览
- **glance.nvim** - LSP 位置预览
  - 定义预览
  - 引用查看
  - 实现预览

### 🔄 重构工具
- **refactoring.nvim** - 代码重构
  - 提取函数
  - 内联变量
  - 重命名重构

### 🔍 代码检查
- **nvim-lint** - 异步代码检查
  - 多种 linter 支持
  - 实时错误检查
  - 自定义规则

### 🤖 AI 辅助
- **claudecode.nvim** - Claude AI 集成
- **import.nvim** - 智能导入管理
- **wtf.nvim** - AI 错误诊断和修复

## 🌍 支持的语言

### 完整支持
- **Go** - 完整的 LSP + 专用工具
- **Lua** - Neovim 配置开发
- **C/C++** - Clangd 集成
- **Rust** - 基础 LSP 支持

### 格式化支持
- **Go** - goimports-reviser
- **Lua** - stylua
- **SQL** - sleek
- **JSON** - jq
- **Shell** - shfmt
- **TOML** - taplo
- **HTTP** - kulala
- **Markdown** - prettier + markdownlint

### Linting 支持
- **Fish** - fish
- **SQL** - sqlfluff
- **Markdown** - markdownlint-cli2
- **CMake** - cmakelint
- **Shell** - shellcheck
- **JSON** - jsonlint

## ⌨️ 键位映射

### LSP 导航
- `gd` - 跳转到定义
- `gI` - 查看实现
- `grr` - 查看引用
- `K` - 显示悬停文档

### 诊断导航
- `<C-n>` - 下一个诊断
- `<C-p>` - 上一个诊断

### 代码操作
- `<Space>i` - 智能导入

### AI 辅助
- `<Space>wd` - AI 诊断错误
- `<Space>wf` - AI 修复错误
- `<Space>wg` - Google 搜索错误
- `<Space>wh` - 查看 AI 历史

## 🔧 Go 语言特殊功能

### 自动命令
- **保存时自动导入** - 保存 Go 文件时自动运行 `GoImports`

### 自定义命令
- `:GoAddTagEmpty` - 添加空的 JSON 标签

### 配置示例
```lua
-- Go 文件保存时自动导入
Autocmd("BufWritePost", {
  group = GroupId("go_auto_import", { clear = true }),
  pattern = "*.go",
  callback = function()
    cmd("GoImports")
  end,
})
```

## 🎨 诊断配置

### 显示设置
```lua
vim.diagnostic.config({
  virtual_text = false,        -- 禁用虚拟文本
  update_in_insert = true,     -- 插入模式更新
  virtual_lines = {
    highlight_whole_line = false,
  },
})
```

### Tiny Inline Diagnostic 配置
- **预设风格**: ghost
- **节流时间**: 0ms (实时更新)
- **软换行**: 30 字符
- **多诊断**: 支持
- **多行显示**: 支持

## 📝 格式化配置

### 保存时格式化
```lua
format_on_save = {
  timeout_ms = 200,  -- 格式化超时时间
}
```

### 语言特定配置
- **Go**: 使用 goimports-reviser 而非 LSP
- **C++**: 禁用 LSP 格式化
- **Shell**: 使用 shfmt，禁用 LSP
- **TOML**: 使用 taplo，禁用 LSP

## 🔍 代码检查配置

### 事件触发
- `BufWritePost` - 保存后检查
- `BufReadPost` - 读取后检查
- `InsertLeave` - 离开插入模式后检查

### 防抖设置
- **延迟**: 100ms
- **避免频繁检查**，提升性能

## 🤖 AI 功能配置

### WTF.nvim 设置
- **提供商**: DeepSeek
- **模型**: deepseek-v3
- **语言**: 中文
- **搜索引擎**: Google

### Claude Code 集成
- **终端命令**: codebuddy
- **Snacks 集成**: 支持

## 🔧 自定义配置

### 添加新的格式化器
```lua
-- 在 conform.nvim 配置中添加
formatters_by_ft = {
  your_language = { "your_formatter" },
}
```

### 添加新的 Linter
```lua
-- 在 nvim-lint 配置中添加
linters_by_ft = {
  your_language = { "your_linter" },
}
```

### 自定义诊断显示
```lua
-- 修改 tiny-inline-diagnostic 配置
require("tiny-inline-diagnostic").setup({
  preset = "modern",  -- 或其他预设
  options = {
    throttle = 50,    -- 调整更新频率
  },
})
```

## 🐛 故障排除

### LSP 服务器未启动
```lua
:LspInfo                    -- 查看 LSP 状态
:checkhealth lsp           -- 检查 LSP 健康状态
:Mason                     -- 管理 LSP 服务器
```

### 格式化不工作
```lua
:ConformInfo               -- 查看格式化器状态
:checkhealth conform       -- 检查 conform 健康状态
```

### 诊断不显示
```lua
:lua vim.diagnostic.show() -- 强制显示诊断
:checkhealth nvim-lint     -- 检查 lint 状态
```

### Go 特定问题
```lua
:GoInstallBinaries         -- 安装 Go 工具
:checkhealth go            -- 检查 Go 环境
```

## 📚 相关文档

- [主配置文档](../README.md)
- [插件配置](./plugins.lua)
- [全局 LSP 配置](../../plugin/lsp.lua)

## 💡 使用技巧

### 1. 快速诊断
使用 `<C-n>` 和 `<C-p>` 快速在错误间跳转，每次跳转后会自动居中显示。

### 2. AI 辅助调试
遇到不理解的错误时，使用 `<Space>wd` 让 AI 解释错误原因。

### 3. 智能导入
在 Go/TypeScript 等语言中，使用 `<Space>i` 快速导入需要的包。

### 4. 代码预览
使用 `grr` 查看引用时，可以在预览窗口中直接编辑代码。

---

🚀 **性能提示**: LSP 功能会根据文件类型自动加载，确保最佳的启动性能。