# 🧩 通用组件模块

通用工具和组件集合，提供各种实用功能和第三方服务集成。

## 📦 包含的插件

### 🎨 颜色工具

- **nvim-colorizer.lua** - 颜色代码可视化
  - CSS 颜色显示
  - 十六进制颜色预览
  - RGB/HSL 支持
  - 实时颜色更新

### 🔧 开发工具

- **cronex.nvim** - Cron 表达式解析
- **todo-comments.nvim** - TODO 注释高亮
- **trouble.nvim** - 诊断信息管理
- **toggleterm.nvim** - 终端管理

### 📊 信息显示

- **nvim-notify** - 通知系统
- **dressing.nvim** - UI 增强
- **noice.nvim** - 命令行 UI 美化
- **alpha-nvim** - 启动屏幕

### 🔍 搜索增强

- **flash.nvim** - 快速跳转
- **nvim-hlslens** - 搜索结果增强
- **searchbox.nvim** - 搜索框 UI

### 📁 文件管理

- **neo-tree.nvim** - 文件树
- **oil.nvim** - 文件编辑器
- **ranger.nvim** - Ranger 集成

## 📁 文件结构

```
components/
├── plugins.lua         # 组件插件配置
├── REAMDE.md          # 本文档 (注意拼写错误)
└── configs/           # 各组件详细配置
    ├── colorizer.lua
    ├── notify.lua
    └── ...
```

## 🎨 颜色工具

### Colorizer 功能

- **CSS 颜色**: `#ff0000`, `rgb(255,0,0)`, `red`
- **十六进制**: `#RGB`, `#RRGGBB`, `#RRGGBBAA`
- **函数形式**: `rgb()`, `rgba()`, `hsl()`, `hsla()`
- **命名颜色**: CSS 标准颜色名称

### 支持的文件类型

```lua
filetypes = {
  "*",                    -- 所有文件类型
  css = { rgb_fn = true }, -- CSS 特殊支持
  html = { names = false }, -- HTML 禁用颜色名称
  javascript = { RGB = true }, -- JS 支持大写 RGB
}
```

### 配置选项

```lua
{
  RGB = true,           -- #RGB 十六进制颜色
  RRGGBB = true,        -- #RRGGBB 十六进制颜色
  names = true,         -- "Name" 颜色名称如 Blue
  RRGGBBAA = true,      -- #RRGGBBAA 带透明度
  rgb_fn = true,        -- CSS rgb() 和 rgba() 函数
  hsl_fn = true,        -- CSS hsl() 和 hsla() 函数
  css = true,           -- 启用所有 CSS 功能
  css_fn = true,        -- 启用所有 CSS 函数
}
```

## 🔧 开发工具

### TODO 注释高亮

支持的关键词：

- `TODO:` - 待办事项
- `FIXME:` - 需要修复
- `NOTE:` - 重要说明
- `WARN:` - 警告信息
- `PERF:` - 性能相关
- `HACK:` - 临时解决方案
- `TEST:` - 测试相关

### Cron 表达式解析

```lua
-- 示例 cron 表达式
"0 0 * * *"           -- 每天午夜
"*/5 * * * *"         -- 每5分钟
"0 9-17 * * 1-5"      -- 工作日 9-17 点
```

### 终端管理

```lua
-- 终端操作
<C-\>               -- 切换终端
<leader>tf          -- 浮动终端
<leader>th          -- 水平终端
<leader>tv          -- 垂直终端
```

## 📊 信息显示

### 通知系统

- **级别**: ERROR, WARN, INFO, DEBUG
- **持续时间**: 可配置显示时间
- **动画**: 淡入淡出效果
- **位置**: 可配置显示位置

### UI 增强

- **输入框**: 美化的输入对话框
- **选择器**: 增强的选择界面
- **确认框**: 美化的确认对话框

### 启动屏幕

- **Logo**: 自定义 ASCII 艺术
- **快捷操作**: 常用操作快捷键
- **最近文件**: 显示最近打开的文件
- **项目**: 快速打开项目

## 🔍 搜索增强

### Flash 跳转

```lua
-- 快速跳转
s                   -- 双字符跳转
S                   -- 行跳转
r                   -- 远程操作
R                   -- Treesitter 搜索
```

### 搜索结果增强

- **计数显示**: 显示匹配数量和位置
- **虚拟文本**: 在行尾显示匹配信息
- **高亮增强**: 更明显的搜索高亮
- **导航优化**: 更好的搜索结果导航

## 📁 文件管理

### Neo-tree 文件树

```lua
-- 文件树操作
<leader>e           -- 切换文件树
<leader>E           -- 聚焦文件树

-- 在文件树中
<CR>                -- 打开文件/文件夹
<Tab>               -- 预览文件
a                   -- 添加文件/文件夹
d                   -- 删除
r                   -- 重命名
c                   -- 复制
x                   -- 剪切
p                   -- 粘贴
```

### Oil 文件编辑

- **直接编辑**: 像编辑文本一样编辑目录
- **批量操作**: 批量重命名、移动文件
- **预览**: 实时预览操作结果
- **撤销**: 支持操作撤销

## 🎯 诊断管理

### Trouble 诊断面板

```lua
-- 诊断操作
<leader>xx          -- 切换诊断面板
<leader>xw          -- 工作区诊断
<leader>xd          -- 文档诊断
<leader>xq          -- 快速修复列表
<leader>xl          -- 位置列表
```

### 诊断类型

- **错误**: 语法错误、类型错误
- **警告**: 潜在问题、废弃用法
- **信息**: 一般信息、建议
- **提示**: 代码改进建议

## 🔧 自定义配置

### 颜色工具配置

```lua
{
  "NvChad/nvim-colorizer.lua",
  opts = {
    filetypes = {
      "*",
      css = { rgb_fn = true },
      html = { names = false },
    },
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      names = true,
      RRGGBBAA = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
    },
  },
}
```

### 通知系统配置

```lua
{
  "rcarriga/nvim-notify",
  opts = {
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
  },
}
```

### 文件树配置

```lua
{
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = true,
        hide_gitignored = true,
      },
    },
  },
}
```

## 🚀 性能优化

### 懒加载策略

- **事件触发**: 根据特定事件加载
- **命令触发**: 使用时才加载
- **文件类型**: 特定文件类型才加载

### 内存管理

- **缓存清理**: 定期清理不用的缓存
- **资源限制**: 限制资源使用
- **优化配置**: 禁用不需要的功能

## 🐛 故障排除

### 颜色不显示

```lua
:ColorizerToggle           -- 切换颜色显示
:ColorizerReloadAllBuffers -- 重新加载所有缓冲区
:checkhealth colorizer     -- 检查健康状态
```

### 通知不显示

```lua
:lua vim.notify("Test")    -- 测试通知
:Notifications             -- 查看通知历史
:checkhealth notify        -- 检查状态
```

### 文件树问题

```lua
:Neotree toggle           -- 切换文件树
:Neotree refresh          -- 刷新文件树
:checkhealth neo-tree     -- 检查状态
```

### 性能问题

```lua
-- 禁用颜色显示在大文件中
vim.g.colorizer_auto_color = 0

-- 减少通知显示时间
require("notify").setup({
  timeout = 1000,
})
```

## 📚 相关文档

- [Colorizer 文档](https://github.com/NvChad/nvim-colorizer.lua)
- [Neo-tree 文档](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [Notify 文档](https://github.com/rcarriga/nvim-notify)
- [主配置文档](../README.md)

## 💡 使用技巧

### 1. 颜色开发

在编写 CSS 或主题时，颜色预览功能可以实时查看颜色效果。

### 2. 项目管理

使用文件树快速浏览项目结构，配合书签功能标记重要文件。

### 3. 诊断查看

使用 Trouble 面板集中查看所有诊断信息，提高问题解决效率。

### 4. 终端集成

使用浮动终端快速执行命令，不离开编辑环境。

### 5. 通知管理

合理配置通知显示时间和位置，避免干扰编辑工作。

---

🧩 **提示**: 组件模块提供的都是辅助功能，可以根据个人需求选择性启用。

## 🔧 修复拼写错误

注意到 `REAMDE.md` 文件名有拼写错误，应该是 `README.md`。
