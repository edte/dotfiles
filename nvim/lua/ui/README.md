# 🎨 UI 模块

用户界面相关的插件和配置，负责 Neovim 的视觉体验和交互界面。

## 📦 包含的插件

### 🌙 主题
- **tokyonight.nvim** - 现代化的深色主题
  - 风格：moon
  - 支持多种变体
  - 优秀的语法高亮

### 📑 缓冲区管理
- **bufferline.nvim** - 美观的标签页管理
  - LSP 诊断集成
  - 文件类型图标
  - 智能排序和分组

### 📊 状态栏
- **自定义状态栏** (`statusline.lua`)
  - 显示文件信息
  - Git 状态
  - LSP 状态
  - 编码和文件类型

### 🎯 滚动条
- **satellite.nvim** - 右侧滚动条
  - 显示文件位置
  - 搜索结果标记
  - Git 变更标记

### 💬 命令行增强
- **wilder.nvim** - 命令行补全增强
  - 模糊匹配
  - 历史记录
  - 智能建议

### 🌈 语法高亮增强
- **rainbow-delimiters.nvim** - 彩虹括号
  - Tree-sitter 支持
  - 多种颜色配置
  - 智能匹配

### 📝 注释生成
- **neogen** - 智能注释生成
  - 多语言支持
  - 函数文档生成
  - 自定义模板

### ⌨️ 键位提示
- **which-key.nvim** - 键位提示和管理
  - 实时键位提示
  - 分组管理
  - 自定义描述

### 🔍 视觉匹配
- **visimatch.nvim** - 视觉模式匹配高亮
  - 自动高亮相同文本
  - 可配置最小字符数
  - 性能优化

### 📋 日志高亮
- **log-highlight.nvim** - 日志文件语法高亮
  - 错误/警告/信息级别
  - 时间戳识别
  - 自定义模式

### 🧩 UI 组件
- **nui.nvim** - UI 组件库
  - 弹窗组件
  - 输入框
  - 菜单组件

## ⌨️ 键位映射

### 缓冲区操作
- `gp` - 切换到上一个缓冲区
- `gn` - 切换到下一个缓冲区

### 注释生成
- `gcn` - 生成函数/类注释

## 🎨 主题配置

### 颜色方案
```lua
-- 主题设置
vim.cmd.colorscheme("tokyonight")

-- 行号颜色统一设置
for _, hl_group in ipairs({ "LineNr", "LineNrAbove", "LineNrBelow" }) do
  vim.api.nvim_set_hl(0, hl_group, { fg = "#808080" })
end
```

### 彩虹括号颜色
- 🔴 红色 (`#E06C75`)
- 🟡 黄色 (`#E5C07B`)
- 🔵 蓝色 (`#61AFEF`)
- 🟠 橙色 (`#D19A66`)
- 🟢 绿色 (`#98C379`)
- 🟣 紫色 (`#C678DD`)
- 🔷 青色 (`#56B6C2`)

## 📊 状态栏信息

自定义状态栏显示以下信息：
- 📁 文件路径和名称
- 📝 文件修改状态
- 🔢 光标位置（行:列）
- 📊 文件进度百分比
- 🌿 Git 分支和状态
- 🔧 LSP 状态和诊断
- 📄 文件编码
- 📋 文件类型

## 🔧 自定义配置

### 修改主题
```lua
-- 在 plugins.lua 中修改
{
  "folke/tokyonight.nvim",
  opts = { 
    style = "storm",  -- 可选: storm, moon, night, day
  },
}
```

### 自定义状态栏
编辑 `lua/ui/statusline.lua` 文件来自定义状态栏内容和样式。

### 添加新的 UI 插件
在 `plugins.lua` 的 `M.list` 表中添加新插件：

```lua
{
  "author/plugin-name",
  event = "VeryLazy",
  config = function()
    -- 插件配置
  end,
}
```

## 🎯 性能优化

### 懒加载策略
- 大部分 UI 插件使用 `event = "VeryLazy"`
- 命令行插件使用 `event = "CmdlineEnter"`
- 文件类型特定插件使用 `ft = { "filetype" }`

### 内存优化
- 禁用不需要的功能（如 marks, gitsigns 在 satellite 中）
- 使用合适的更新频率
- 避免重复的高亮计算

## 🐛 故障排除

### 主题不生效
```lua
:colorscheme tokyonight
:hi Normal  -- 检查颜色设置
```

### 状态栏显示异常
```lua
:set laststatus=3  -- 确保状态栏显示
:lua print(require('ui.statusline'))  -- 检查模块加载
```

### 缓冲区标签页问题
```lua
:BufferLineCyclePrev  -- 测试缓冲区切换
:Lazy reload bufferline.nvim  -- 重新加载插件
```

### 彩虹括号不显示
```lua
:TSUpdate  -- 更新 Tree-sitter
:checkhealth nvim-treesitter  -- 检查 Tree-sitter 状态
```

## 📚 相关文档

- [状态栏配置](./statusline.lua)
- [Which-key 配置](./whichkey.lua)
- [Wilder 配置](./wilder.lua)
- [主配置文档](../README.md)

## 🎨 截图和演示

> 💡 **提示**: 启动 Neovim 后，所有 UI 组件会自动加载并应用配置。如果遇到问题，可以使用 `:Lazy` 命令查看插件状态。

---

🌟 **个性化建议**: 可以根据个人喜好调整主题风格、状态栏内容和颜色方案。