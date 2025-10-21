# 💬 代码补全模块

基于 nvim-cmp 的智能代码补全系统，提供多源补全和代码片段功能。

## 📦 包含的插件

### 🧠 核心补全引擎
- **nvim-cmp** - 主补全引擎
- **cmp-nvim-lsp** - LSP 补全源
- **cmp-buffer** - 缓冲区补全源
- **cmp-path** - 路径补全源
- **cmp-cmdline** - 命令行补全源

### 📝 代码片段
- **LuaSnip** - 代码片段引擎
- **cmp_luasnip** - LuaSnip 补全集成
- **friendly-snippets** - 预定义代码片段库

### 🎨 UI 增强
- **lspkind.nvim** - 补全项图标
- **cmp-nvim-lsp-signature-help** - 函数签名帮助

## 📁 文件结构

```
cmp/
├── plugins.lua         # 补全插件配置
├── cmp.lua            # 核心补全配置
├── luasnippets/       # 自定义代码片段
│   ├── all.lua        # 通用片段
│   ├── go.lua         # Go 语言片段
│   ├── markdown.lua   # Markdown 片段
│   └── gitignore.lua  # Gitignore 片段
└── dict/              # 字典文件目录
```

## 🎯 补全源优先级

1. **LSP** - 语言服务器补全 (最高优先级)
2. **LuaSnip** - 代码片段
3. **Buffer** - 当前缓冲区内容
4. **Path** - 文件路径

## ⌨️ 键位映射

### 补全导航
- `<Tab>` - 选择下一个补全项 / 展开片段
- `<S-Tab>` - 选择上一个补全项 / 跳转到上一个片段位置
- `<CR>` - 确认选择
- `<C-Space>` - 手动触发补全
- `<Esc>` - 关闭补全菜单

### 片段跳转
- `<Tab>` - 跳转到下一个片段位置
- `<S-Tab>` - 跳转到上一个片段位置

### 文档滚动
- `<C-d>` - 向下滚动文档
- `<C-u>` - 向上滚动文档

## 📝 代码片段

### 通用片段 (`all.lua`)
- `todo` - TODO 注释
- `fixme` - FIXME 注释
- `note` - NOTE 注释
- `hack` - HACK 注释
- `warn` - WARN 注释
- `perf` - PERF 注释
- `test` - TEST 注释
- `date` - 当前日期
- `time` - 当前时间
- `datetime` - 日期时间
- `uuid` - UUID 生成

### Go 语言片段 (`go.lua`)
- `pkg` - package 声明
- `imp` - import 语句
- `func` - 函数定义
- `meth` - 方法定义
- `if` - if 语句
- `for` - for 循环
- `range` - range 循环
- `switch` - switch 语句
- `struct` - 结构体定义
- `interface` - 接口定义
- `err` - 错误处理
- `test` - 测试函数
- `bench` - 基准测试
- `example` - 示例函数

### Markdown 片段 (`markdown.lua`)
- `link` - 链接格式
- `img` - 图片格式
- `code` - 代码块
- `table` - 表格模板
- `todo` - 任务列表

### Gitignore 片段 (`gitignore.lua`)
- 常见文件类型忽略规则
- 语言特定忽略模板
- IDE 配置忽略

## 🎨 UI 配置

### 补全菜单样式
- **边框**: 圆角边框
- **最大高度**: 15 项
- **滚动条**: 自动显示
- **图标**: lspkind 提供的 VSCode 风格图标

### 补全项格式
```
[图标] 补全文本 [来源]
```

### 颜色主题
- 与 Tokyo Night 主题集成
- 支持语法高亮
- 清晰的选中状态

## 🔧 自定义配置

### 添加新的补全源
```lua
-- 在 cmp.lua 中添加
sources = cmp.config.sources({
  { name = "nvim_lsp" },
  { name = "luasnip" },
  { name = "your_source" },  -- 添加新源
})
```

### 修改键位映射
```lua
-- 在 cmp.lua 的 mapping 部分修改
mapping = cmp.mapping.preset.insert({
  ["<Your-Key>"] = cmp.mapping.your_action(),
})
```

### 自定义代码片段
在 `luasnippets/` 目录下创建新文件：

```lua
-- luasnippets/your_language.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("your_trigger", {
    t("your template "),
    i(1, "placeholder"),
    t(" more text"),
  }),
}
```

## 🚀 性能优化

### 懒加载策略
- 补全插件在插入模式时加载
- 代码片段按需加载
- 字典文件延迟加载

### 补全触发优化
- 最小触发字符数: 1
- 智能触发条件
- 防抖机制

### 内存管理
- 自动清理未使用的补全缓存
- 限制补全项数量
- 优化大文件性能

## 🐛 故障排除

### 补全不显示
```lua
:CmpStatus                 -- 查看补全状态
:checkhealth cmp           -- 检查健康状态
:lua print(vim.inspect(require('cmp').get_config()))
```

### LSP 补全缺失
```lua
:LspInfo                   -- 检查 LSP 状态
:lua print(vim.lsp.get_active_clients())
```

### 代码片段不工作
```lua
:LuaSnipEdit               -- 编辑片段
:checkhealth luasnip       -- 检查片段引擎
```

### 性能问题
```lua
-- 减少补全源
sources = cmp.config.sources({
  { name = "nvim_lsp" },
  -- 注释掉不需要的源
})

-- 增加触发字符数
completion = {
  keyword_length = 2,      -- 默认是 1
}
```

## 📚 代码片段语法

### 基本语法
```lua
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node

s("trigger", {
  t("static text"),
  i(1, "placeholder"),
  f(function() return os.date() end),
  c(2, { t("choice1"), t("choice2") }),
})
```

### 高级功能
- **动态节点**: 根据输入动态生成内容
- **选择节点**: 提供多个选项
- **函数节点**: 执行 Lua 函数
- **变换节点**: 转换其他节点的内容

## 💡 使用技巧

### 1. 快速补全
输入几个字符后按 `<Tab>` 快速选择第一个补全项。

### 2. 片段展开
输入片段触发词后按 `<Tab>` 展开，然后用 `<Tab>` 和 `<S-Tab>` 在占位符间跳转。

### 3. 路径补全
在字符串中输入 `/` 或 `./` 触发路径补全。

### 4. 命令行补全
在命令模式下享受智能补全，支持命令、选项和文件路径。

### 5. 函数签名
输入函数名后，会自动显示函数签名和参数信息。

## 📊 补全统计

### 支持的语言
- **40+** 编程语言的 LSP 补全
- **20+** 语言的代码片段
- **通用** 文件路径和缓冲区补全

### 片段数量
- **通用**: 20+ 片段
- **Go**: 50+ 片段
- **Markdown**: 10+ 片段
- **Gitignore**: 30+ 模板

---

🎯 **提示**: 补全系统会根据上下文智能排序，最相关的补全项会优先显示。