# 📝 文本处理模块

文本编辑、语法高亮和内容处理相关的插件配置。

## 📦 包含的插件

### 🌳 语法解析
- **nvim-treesitter** - 现代语法高亮引擎
  - 精确的语法高亮
  - 智能代码折叠
  - 文本对象支持
  - 增量选择

### 🔍 搜索增强
- **telescope.nvim** - 模糊查找器
  - 文件搜索
  - 内容搜索
  - 符号搜索
  - 历史记录

### ✏️ 编辑增强
- **nvim-surround** - 包围字符操作
- **vim-repeat** - 重复操作支持
- **Comment.nvim** - 智能注释
- **nvim-autopairs** - 自动配对

### 📋 文本对象
- **nvim-treesitter-textobjects** - Tree-sitter 文本对象
- **targets.vim** - 扩展文本对象
- **vim-textobj-user** - 自定义文本对象

### 🎯 导航增强
- **hop.nvim** - 快速跳转
- **vim-matchup** - 匹配增强
- **nvim-spider** - 智能单词移动

## 📁 文件结构

```
text/
├── plugins.lua         # 文本处理插件配置
├── treesitter.lua     # Tree-sitter 详细配置
└── README.md          # 本文档
```

## 🌳 Tree-sitter 配置

### 支持的语言
```lua
ensure_installed = {
  -- 系统语言
  "c", "lua", "vim", "vimdoc", "query",
  
  -- Web 开发
  "html", "css", "javascript", "typescript",
  "json", "yaml", "toml",
  
  -- 后端语言
  "go", "rust", "python", "java",
  
  -- 配置和标记
  "markdown", "markdown_inline",
  "bash", "fish", "dockerfile",
  
  -- 其他
  "sql", "regex", "gitignore",
}
```

### 功能模块
- **高亮**: 精确的语法高亮
- **缩进**: 智能自动缩进
- **折叠**: 基于语法的代码折叠
- **选择**: 增量语法选择
- **文本对象**: 函数、类、参数等对象

## 🔍 Telescope 搜索

### 核心功能
- **文件搜索**: 快速查找项目文件
- **内容搜索**: 全文搜索和替换
- **符号搜索**: LSP 符号查找
- **历史记录**: 命令和搜索历史

### 键位映射
```lua
-- 基础搜索
"<leader>ff" - 查找文件
"<leader>fg" - 全文搜索
"<leader>fb" - 查找缓冲区
"<leader>fh" - 搜索帮助

-- 高级搜索
"<leader>fs" - 搜索符号
"<leader>fc" - 搜索命令
"<leader>fk" - 搜索键位映射
"<leader>fo" - 搜索选项
```

## ✏️ 编辑增强功能

### Surround 操作
```lua
-- 添加包围
ys{motion}{char}    -- 添加包围字符
ysiw"               -- 给单词添加双引号
yss)                -- 给整行添加括号

-- 修改包围
cs{old}{new}        -- 修改包围字符
cs"'                -- 双引号改单引号
cs([                -- 圆括号改方括号

-- 删除包围
ds{char}            -- 删除包围字符
ds"                 -- 删除双引号
ds)                 -- 删除括号
```

### 注释操作
```lua
-- 行注释
gcc                 -- 切换当前行注释
gc{motion}          -- 注释指定范围
gcap                -- 注释段落

-- 块注释
gbc                 -- 切换块注释
gb{motion}          -- 块注释指定范围
```

### 自动配对
- **括号**: `()`, `[]`, `{}`
- **引号**: `"`, `'`, `` ` ``
- **标签**: HTML/XML 标签自动配对
- **智能删除**: 删除左括号时自动删除右括号

## 🎯 导航和跳转

### Hop 快速跳转
```lua
-- 字符跳转
f{char}             -- 跳转到字符
F{char}             -- 反向跳转到字符
t{char}             -- 跳转到字符前
T{char}             -- 反向跳转到字符前

-- 单词跳转
<leader>w           -- 跳转到单词
<leader>b           -- 反向跳转到单词
<leader>l           -- 跳转到行
```

### 智能单词移动
- **w/b**: 智能单词边界识别
- **e**: 单词结尾跳转
- **ge**: 反向单词结尾跳转

## 📋 文本对象

### Tree-sitter 文本对象
```lua
-- 函数相关
af/if               -- 函数 (around/inner)
ac/ic               -- 类 (around/inner)
aa/ia               -- 参数 (around/inner)

-- 控制结构
al/il               -- 循环 (around/inner)
ai/ii               -- 条件 (around/inner)
ab/ib               -- 块 (around/inner)
```

### 扩展文本对象
```lua
-- 引号内容
a'/i'               -- 单引号内容
a"/i"               -- 双引号内容
a`/i`               -- 反引号内容

-- 括号内容
a)/i)               -- 圆括号内容
a]/i]               -- 方括号内容
a}/i}               -- 花括号内容

-- 特殊对象
a,/i,               -- 参数 (逗号分隔)
a./i.               -- 句子
ap/ip               -- 段落
```

## 🔧 自定义配置

### 添加新语言支持
```lua
-- 在 treesitter.lua 中添加
ensure_installed = {
  "your_language",
  -- ...
}
```

### 自定义文本对象
```lua
-- 添加自定义文本对象
textobjects = {
  select = {
    keymaps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["your_key"] = "@your_object",
    },
  },
}
```

### 修改 Telescope 配置
```lua
-- 自定义 Telescope 设置
defaults = {
  file_ignore_patterns = {
    "node_modules",
    ".git/",
    "your_pattern",
  },
}
```

## 🚀 性能优化

### Tree-sitter 优化
- **按需安装**: 只安装需要的语言解析器
- **懒加载**: 文件类型触发时才加载
- **缓存**: 解析结果缓存提升性能

### Telescope 优化
- **文件忽略**: 排除不需要搜索的文件
- **索引缓存**: 文件索引缓存
- **搜索限制**: 限制搜索结果数量

## 🐛 故障排除

### Tree-sitter 问题
```lua
:TSUpdate                  -- 更新解析器
:TSInstall language        -- 安装特定语言
:checkhealth treesitter    -- 检查健康状态
:TSPlayground              -- 调试语法树
```

### Telescope 问题
```lua
:Telescope                 -- 查看可用搜索器
:checkhealth telescope     -- 检查健康状态
:Telescope builtin         -- 查看内置搜索器
```

### 高亮问题
```lua
:TSBufToggle highlight     -- 切换高亮
:syntax sync fromstart     -- 重新同步语法
:set syntax=language       -- 手动设置语法
```

### 性能问题
```lua
-- 禁用大文件的 Tree-sitter
vim.g.loaded_treesitter = 1  -- 临时禁用

-- 或者设置文件大小限制
disable = function(lang, buf)
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end
```

## 📚 相关文档

- [Tree-sitter 配置](./treesitter.lua)
- [Telescope 官方文档](https://github.com/nvim-telescope/telescope.nvim)
- [Surround 使用指南](https://github.com/kylechui/nvim-surround)
- [主配置文档](../README.md)

## 💡 使用技巧

### 1. 增量选择
使用 Tree-sitter 的增量选择功能，按 `<CR>` 逐步扩大选择范围。

### 2. 智能搜索
在 Telescope 中使用空格分隔多个搜索词，支持模糊匹配。

### 3. 快速注释
使用 `gc` 配合文本对象，如 `gcap` 注释整个段落。

### 4. 包围操作
结合可视模式和 surround，如选中文本后按 `S"` 添加双引号。

### 5. 文本对象组合
结合操作符和文本对象，如 `daf` 删除整个函数，`cic` 修改类内容。

---

🎯 **提示**: 文本处理功能会根据文件类型自动启用相应的语言支持和优化。