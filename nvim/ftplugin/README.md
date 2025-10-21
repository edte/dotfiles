# 📄 文件类型特定配置

这个目录包含针对特定文件类型的配置，当打开对应类型的文件时自动加载。

## 📁 目录结构

```
ftplugin/
├── csv.lua             # CSV 文件配置
├── http.lua            # HTTP 文件配置
├── markdown.lua        # Markdown 文件配置
├── tsv.lua             # TSV 文件配置
└── README.md           # 本文档
```

## 🔄 自动加载机制

当 Neovim 检测到文件类型时，会自动加载对应的 `ftplugin/{filetype}.lua` 文件。这是 Vim/Neovim 的标准机制。

### 触发条件
- **文件扩展名**: 根据文件扩展名自动检测
- **文件内容**: 根据文件内容特征检测
- **手动设置**: 使用 `:set filetype=type` 手动设置

## 📄 文件类型配置

### 📊 CSV 文件 (csv.lua)
CSV (逗号分隔值) 文件的专用配置：

```lua
-- 显示设置
vim.opt_local.wrap = false          -- 不换行显示
vim.opt_local.scrollbind = true     -- 同步滚动
vim.opt_local.number = true         -- 显示行号

-- 编辑设置
vim.opt_local.expandtab = true      -- 使用空格
vim.opt_local.tabstop = 2           -- Tab 宽度
vim.opt_local.shiftwidth = 2        -- 缩进宽度

-- CSV 特定功能
-- 列对齐显示
-- 数据验证
-- 快速导航
```

**适用文件**:
- `.csv` - 标准 CSV 文件
- `.CSV` - 大写扩展名

**常用操作**:
- 列对齐查看
- 数据排序
- 字段验证
- 导出转换

### 🌐 HTTP 文件 (http.lua)
HTTP 请求文件的配置：

```lua
-- 语法高亮
vim.opt_local.syntax = "http"

-- 编辑设置
vim.opt_local.wrap = false          -- 不换行
vim.opt_local.number = true         -- 显示行号
vim.opt_local.cursorline = true     -- 高亮当前行

-- HTTP 特定功能
-- 请求发送
-- 响应查看
-- 环境变量支持
```

**适用文件**:
- `.http` - HTTP 请求文件
- `.rest` - REST API 测试文件

**功能特性**:
- 语法高亮
- 请求执行
- 响应预览
- 环境管理

### 📝 Markdown 文件 (markdown.lua)
Markdown 文档的专用配置：

```lua
-- 显示设置
vim.opt_local.wrap = true           -- 自动换行
vim.opt_local.linebreak = true      -- 智能换行
vim.opt_local.conceallevel = 2      -- 隐藏标记符号
vim.opt_local.spell = true          -- 拼写检查

-- 编辑设置
vim.opt_local.textwidth = 80        -- 文本宽度
vim.opt_local.formatoptions:append("t")  -- 自动格式化

-- Markdown 特定功能
-- 实时预览
-- 目录生成
-- 链接跳转
-- 表格编辑
```

**适用文件**:
- `.md` - Markdown 文件
- `.markdown` - 完整扩展名
- `.mdown` - 简化扩展名

**增强功能**:
- 实时预览
- 语法高亮
- 目录导航
- 表格对齐
- 链接检查

### 📋 TSV 文件 (tsv.lua)
TSV (制表符分隔值) 文件配置：

```lua
-- 显示设置
vim.opt_local.wrap = false          -- 不换行
vim.opt_local.list = true           -- 显示不可见字符
vim.opt_local.listchars = "tab:│ "  -- Tab 字符显示

-- 编辑设置
vim.opt_local.expandtab = false     -- 保持 Tab 字符
vim.opt_local.tabstop = 8           -- Tab 显示宽度
vim.opt_local.softtabstop = 8       -- 软 Tab 宽度

-- TSV 特定功能
-- 列对齐
-- Tab 可视化
-- 数据验证
```

**适用文件**:
- `.tsv` - 标准 TSV 文件
- `.TSV` - 大写扩展名

**特殊处理**:
- Tab 字符保护
- 列对齐显示
- 数据完整性检查

## 🔧 自定义文件类型配置

### 创建新的文件类型配置

1. **创建配置文件**:
```bash
# 为 Python 文件创建配置
touch ftplugin/python.lua
```

2. **编写配置内容**:
```lua
-- ftplugin/python.lua
-- Python 文件特定配置

-- 缩进设置
vim.opt_local.expandtab = true      -- 使用空格
vim.opt_local.tabstop = 4           -- Tab 宽度
vim.opt_local.shiftwidth = 4        -- 缩进宽度
vim.opt_local.softtabstop = 4       -- 软 Tab

-- Python 特定设置
vim.opt_local.textwidth = 88        -- PEP 8 推荐宽度
vim.opt_local.colorcolumn = "88"    -- 显示边界线

-- 键位映射
local map = vim.keymap.set
map("n", "<F5>", ":!python %<CR>", { buffer = true })

-- 自动命令
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    -- 保存前自动格式化
    vim.lsp.buf.format()
  end,
})
```

### 修改现有配置

直接编辑对应的文件类型配置文件，例如修改 Markdown 配置：

```lua
-- ftplugin/markdown.lua
-- 添加自定义键位映射
local map = vim.keymap.set

-- 表格格式化
map("n", "<leader>tf", ":TableFormat<CR>", { buffer = true })

-- 预览切换
map("n", "<leader>mp", ":MarkdownPreview<CR>", { buffer = true })
```

## 🎯 常见文件类型配置

### 编程语言
```lua
-- JavaScript/TypeScript
-- ftplugin/javascript.lua, ftplugin/typescript.lua
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

-- Go
-- ftplugin/go.lua
vim.opt_local.expandtab = false     -- Go 使用 Tab
vim.opt_local.tabstop = 4

-- Rust
-- ftplugin/rust.lua
vim.opt_local.textwidth = 100      -- Rust 推荐宽度
```

### 配置文件
```lua
-- YAML
-- ftplugin/yaml.lua
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.foldmethod = "indent"

-- JSON
-- ftplugin/json.lua
vim.opt_local.conceallevel = 0      -- 显示所有字符
vim.opt_local.foldmethod = "syntax"
```

### 文档类型
```lua
-- LaTeX
-- ftplugin/tex.lua
vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.textwidth = 80

-- reStructuredText
-- ftplugin/rst.lua
vim.opt_local.wrap = true
vim.opt_local.textwidth = 79
```

## 🔍 文件类型检测

### 自动检测
Neovim 通过以下方式检测文件类型：

1. **文件扩展名**: 最常用的方式
2. **文件名模式**: 如 `Makefile`, `Dockerfile`
3. **文件内容**: 检查文件头部的特征
4. **Shebang**: Unix 脚本的 `#!/bin/bash` 等

### 手动设置
```lua
-- 临时设置文件类型
:set filetype=python

-- 永久设置 (在配置中)
vim.filetype.add({
  extension = {
    foo = "fooscript",
  },
  filename = {
    ["Foofile"] = "fooscript",
  },
  pattern = {
    [".*%.foo%..*"] = "fooscript",
  },
})
```

## 🐛 故障排除

### 配置不生效
```lua
-- 检查文件类型
:set filetype?

-- 查看文件类型检测
:filetype

-- 重新检测文件类型
:filetype detect
```

### 冲突解决
```lua
-- 查看所有文件类型插件
:scriptnames

-- 检查特定设置来源
:verbose set tabstop?
```

### 调试文件类型
```lua
-- 开启文件类型调试
:set verbose=1
:filetype detect

-- 查看加载的文件类型插件
:autocmd FileType
```

## 📚 相关文档

- [Neovim 文件类型文档](https://neovim.io/doc/user/filetype.html)
- [Vim 文件类型插件](https://vimdoc.sourceforge.net/htmldoc/usr_43.html)
- [文件类型检测](https://neovim.io/doc/user/filetype.html#filetype-detect)
- [主配置文档](../README.md)

## 💡 最佳实践

### 1. 使用局部选项
在 ftplugin 中使用 `vim.opt_local` 而不是 `vim.opt`，避免影响其他文件类型。

### 2. 缓冲区特定映射
使用 `{ buffer = true }` 选项创建缓冲区特定的键位映射。

### 3. 条件配置
根据项目或环境条件应用不同的配置：

```lua
-- 根据项目类型调整配置
if vim.fn.filereadable("package.json") == 1 then
  -- Node.js 项目特定配置
  vim.opt_local.tabstop = 2
end
```

### 4. 性能考虑
避免在 ftplugin 中执行耗时操作，使用懒加载或异步执行。

### 5. 插件集成
与相关插件协调配置，避免冲突：

```lua
-- 检查插件是否存在
if vim.fn.exists(":MarkdownPreview") == 2 then
  -- 插件存在时的配置
end
```

---

📄 **提示**: ftplugin 配置只对特定文件类型生效，是实现文件类型特定功能的最佳方式。