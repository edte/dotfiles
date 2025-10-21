# 📦 Lua 配置模块

这个目录包含了 Neovim 配置的核心 Lua 模块，采用模块化设计，按功能分类组织。

## 📁 目录结构

```
lua/
├── alias.lua           # 全局工具函数和别名定义
├── lazys.lua          # lazy.nvim 插件管理器配置
├── ui/                # 用户界面相关插件和配置
├── cmp/               # 代码补全系统配置
├── lsp/               # 语言服务器协议配置
├── git/               # Git 集成功能
├── text/              # 文本处理和语法高亮
├── vim/               # Vim 核心功能增强
├── bookmark/          # 书签和标记功能
├── components/        # 通用组件和工具
└── utils/             # 工具函数库
```

## 🔧 核心文件

### alias.lua
全局工具函数和别名定义，提供：
- 路径配置变量
- API 简化别名
- 键映射工具函数
- 文件操作工具
- 调试和字符串处理工具

```lua
-- 使用示例
nmap("<leader>f", ":Files<CR>")  -- 键映射
Print(some_table)                -- 调试打印
project_files()                  -- 智能文件选择
```

### lazys.lua
插件管理器配置，负责：
- 插件列表组装
- lazy.nvim 配置
- 插件加载策略
- 性能优化设置

## 📋 模块说明

### 🎨 UI 模块 (`ui/`)
用户界面相关的插件和配置：
- 主题配置
- 状态栏设置
- 缓冲区管理
- 窗口装饰
- 颜色方案

### 💬 补全模块 (`cmp/`)
代码补全系统：
- nvim-cmp 配置
- 补全源设置
- 代码片段管理
- 补全样式定制

### 🔍 LSP 模块 (`lsp/`)
语言服务器配置：
- LSP 服务器设置
- 诊断配置
- 格式化工具
- 代码操作
- 语言特定配置

### 🌿 Git 模块 (`git/`)
Git 集成功能：
- Git 状态显示
- 差异查看
- 提交管理
- 分支操作
- Git 工作流

### 📝 文本模块 (`text/`)
文本处理和语法高亮：
- Treesitter 配置
- 语法高亮规则
- 文本对象
- 编辑增强

### ⚡ Vim 模块 (`vim/`)
Vim 核心功能增强：
- 编辑器行为定制
- 快捷操作
- 文本操作工具
- 搜索增强

### 🔖 书签模块 (`bookmark/`)
书签和标记功能：
- 文件书签
- 行标记
- 快速跳转
- 书签管理

### 🧩 组件模块 (`components/`)
通用组件和工具：
- 颜色显示
- 通用 UI 组件
- 实用工具
- 第三方集成

### 🛠️ 工具模块 (`utils/`)
工具函数库：
- 图标定义
- 日志系统
- 通用工具函数
- 辅助功能

## 🚀 使用方式

### 加载模块
```lua
-- 在 init.lua 中
require("alias")    -- 加载全局工具函数
require("lazys")    -- 加载插件管理器
```

### 模块间依赖
```
init.lua
    ↓
alias.lua (全局工具函数)
    ↓
lazys.lua (插件管理器)
    ↓
各个功能模块 (ui, cmp, lsp, etc.)
```

## 📝 添加新模块

### 1. 创建模块目录
```bash
mkdir lua/your-module
```

### 2. 创建插件配置文件
```lua
-- lua/your-module/plugins.lua
local M = {}

M.list = {
  {
    "author/plugin-name",
    config = function()
      -- 插件配置
    end,
  },
}

return M
```

### 3. 在 lazys.lua 中注册
```lua
-- 在 modules 表中添加
local modules = {
  "ui.plugins",
  "your-module.plugins",  -- 添加这行
  -- ...
}
```

### 4. 添加模块文档
```markdown
<!-- lua/your-module/README.md -->
# Your Module

模块说明和使用方法
```

## 🔧 配置自定义

### 修改插件配置
1. 找到对应的模块目录
2. 编辑 `plugins.lua` 文件
3. 修改插件配置或添加新插件

### 添加工具函数
1. 在 `alias.lua` 中添加全局函数
2. 或在 `utils/` 目录中创建专用模块

### 自定义键位映射
1. 在插件配置中使用 `keys` 字段
2. 或在 `plugin/keymaps.lua` 中添加全局映射

## 🐛 调试技巧

### 检查模块加载
```lua
:lua print(vim.inspect(package.loaded))
```

### 查看插件状态
```lua
:Lazy
```

### 检查配置错误
```lua
:messages
:checkhealth
```

## 📚 相关文档

- [插件管理指南](../plugin/README.md)
- [键位映射说明](../plugin/README.md)
- [LSP 配置文档](./lsp/README.md)
- [UI 配置文档](./ui/README.md)

---

💡 **提示**: 每个模块都有独立的 README.md 文件，包含详细的配置说明和使用方法。