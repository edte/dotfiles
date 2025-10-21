# 🔖 书签模块

文件书签和快速导航功能，提供高效的项目内跳转和标记管理。

## 📦 包含的插件

### 📍 书签管理
- **bookmarks.nvim** - 现代书签系统
  - 持久化书签存储
  - 书签分组管理
  - 快速跳转功能
  - 书签搜索和过滤

### 🏷️ 标记增强
- **marks.nvim** - 标记可视化
  - 标记显示增强
  - 自动标记管理
  - 标记导航优化

### 🔍 导航集成
- **telescope-bookmarks** - Telescope 集成
  - 模糊搜索书签
  - 预览书签内容
  - 批量操作支持

## ⌨️ 键位映射

### 书签操作
```lua
-- 基本操作
mm                  -- 添加/切换书签
md                  -- 删除当前行书签 (与 marks 共用)
ma                  -- 添加书签到列表
ml                  -- 列出所有书签

-- 导航
mn                  -- 下一个书签
mp                  -- 上一个书签
mg                  -- 跳转到指定书签

-- 管理
mc                  -- 清除当前文件书签
mC                  -- 清除所有书签
```

### 标记操作
```lua
-- 设置标记
m{a-z}              -- 设置局部标记
m{A-Z}              -- 设置全局标记

-- 跳转标记
'{mark}             -- 跳转到标记行
`{mark}             -- 跳转到标记位置

-- 特殊标记
''                  -- 上次跳转位置
'.                  -- 上次编辑位置
'^                  -- 上次插入位置
```

## 🔖 书签功能

### 书签类型
1. **文件书签** - 标记重要文件
2. **行书签** - 标记代码中的重要位置
3. **项目书签** - 跨项目的全局书签
4. **临时书签** - 会话内的临时标记

### 书签属性
- **名称** - 自定义书签名称
- **描述** - 书签详细说明
- **标签** - 书签分类标签
- **时间戳** - 创建和修改时间

### 持久化存储
```lua
-- 书签存储位置
~/.local/share/nvim/bookmarks/
├── global.json     -- 全局书签
├── project1.json   -- 项目特定书签
└── project2.json   -- 其他项目书签
```

## 🏷️ 标记增强

### 可视化显示
- **标记符号** - 在行号旁显示标记
- **颜色区分** - 不同类型标记使用不同颜色
- **悬浮信息** - 鼠标悬停显示标记信息

### 自动管理
- **自动清理** - 删除无效标记
- **智能更新** - 文件修改时更新标记位置
- **冲突解决** - 处理标记冲突

### 标记类型
```lua
-- 局部标记 (a-z)
a-z                 -- 当前缓冲区内标记

-- 全局标记 (A-Z)
A-Z                 -- 跨文件标记

-- 数字标记 (0-9)
0-9                 -- 系统自动设置

-- 特殊标记
'                   -- 跳转前位置
"                   -- 退出时位置
[                   -- 上次修改开始
]                   -- 上次修改结束
```

## 🔍 搜索和导航

### Telescope 集成
```lua
:Telescope bookmarks list    -- 搜索书签
:Telescope marks            -- 搜索标记
```

### 搜索功能
- **模糊匹配** - 支持模糊搜索书签名称
- **内容预览** - 预览书签所在位置的代码
- **过滤器** - 按项目、标签、时间过滤
- **排序** - 按使用频率、时间等排序

### 快速导航
```lua
-- 书签导航
<leader>bm          -- 打开书签管理器
<leader>ba          -- 添加书签
<leader>bd          -- 删除书签
<leader>bl          -- 列出书签

-- 标记导航
<leader>mm          -- 标记管理器
<leader>ml          -- 列出标记
<leader>mc          -- 清除标记
```

## 🎯 使用场景

### 1. 代码审查
```lua
-- 标记需要审查的位置
ma                  -- 标记问题点1
mb                  -- 标记问题点2
mc                  -- 标记问题点3

-- 在标记间跳转
'a                  -- 跳转到问题点1
'b                  -- 跳转到问题点2
```

### 2. 重构工作
```lua
-- 标记相关函数
mA                  -- 标记主函数
mB                  -- 标记辅助函数
mC                  -- 标记测试函数

-- 跨文件跳转
'A                  -- 回到主函数
'B                  -- 查看辅助函数
```

### 3. 学习代码
```lua
-- 添加学习书签
:BookmarkAdd "入口函数"
:BookmarkAdd "核心逻辑"
:BookmarkAdd "错误处理"

-- 按学习路径导航
:BookmarkList
```

## 🔧 自定义配置

### 书签配置
```lua
{
  "tomasky/bookmarks.nvim",
  opts = {
    -- 保存位置
    save_file = vim.fn.expand("$HOME/.bookmarks"),
    
    -- 键位映射
    keywords = {
      ["@t"] = "☑️ ", -- 任务
      ["@w"] = "⚠️ ", -- 警告
      ["@f"] = "⭐ ", -- 重要
      ["@n"] = "📝 ", -- 笔记
    },
    
    -- 显示设置
    on_attach = function(bufnr)
      local bm = require("bookmarks")
      local map = vim.keymap.set
      
      map("n", "mm", bm.bookmark_toggle)
      map("n", "mi", bm.bookmark_ann)
      map("n", "mc", bm.bookmark_clean)
      map("n", "mn", bm.bookmark_next)
      map("n", "mp", bm.bookmark_prev)
      map("n", "ml", bm.bookmark_list)
    end,
  },
}
```

### 标记配置
```lua
{
  "chentoast/marks.nvim",
  opts = {
    -- 默认映射
    default_mappings = true,
    
    -- 循环标记
    cyclic = true,
    
    -- 强制写入
    force_write_shada = true,
    
    -- 刷新间隔
    refresh_interval = 250,
    
    -- 标记符号
    sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
    
    -- 排除的标记
    excluded_filetypes = {
      "qf",
      "NvimTree",
      "toggleterm",
      "TelescopePrompt",
      "alpha",
      "netrw",
    },
  },
}
```

## 🎨 视觉配置

### 标记符号
```lua
-- 自定义标记符号
signs = {
  bookmark = "🔖",
  annotate = "📝",
  global = "🌍",
  local = "📍",
}
```

### 高亮组
```lua
-- 自定义高亮颜色
vim.api.nvim_set_hl(0, "BookmarkSign", { fg = "#61AFEF" })
vim.api.nvim_set_hl(0, "BookmarkAnnotationSign", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "MarkSignHL", { fg = "#98C379" })
```

## 🚀 性能优化

### 懒加载
- 按需加载书签数据
- 延迟初始化标记显示
- 缓存频繁访问的书签

### 存储优化
- 压缩书签数据
- 定期清理无效书签
- 限制书签数量

## 🐛 故障排除

### 书签不保存
```lua
-- 检查保存路径权限
:lua print(vim.fn.expand("$HOME/.bookmarks"))

-- 手动保存
:BookmarkSave

-- 检查配置
:checkhealth bookmarks
```

### 标记不显示
```lua
-- 切换标记显示
:MarksToggleSigns

-- 刷新标记
:MarksListAll

-- 检查配置
:checkhealth marks
```

### 性能问题
```lua
-- 减少刷新频率
refresh_interval = 1000

-- 排除大文件
excluded_filetypes = {
  "log",
  "txt",
}
```

## 📚 相关文档

- [Bookmarks.nvim 文档](https://github.com/tomasky/bookmarks.nvim)
- [Marks.nvim 文档](https://github.com/chentoast/marks.nvim)
- [Vim 标记系统](https://vimdoc.sourceforge.net/htmldoc/motion.html#mark-motions)
- [主配置文档](../README.md)

## 💡 使用技巧

### 1. 项目导航
为项目的关键文件设置全局标记 (A-Z)，实现快速跨文件导航。

### 2. 代码审查工作流
使用书签标记需要审查的代码段，添加注释说明问题。

### 3. 学习新代码库
为重要的函数和类添加书签，建立代码地图。

### 4. 调试会话
使用临时标记记录调试过程中的关键位置。

### 5. 重构计划
使用书签标记需要重构的代码，按优先级组织。

---

🔖 **提示**: 合理使用书签和标记可以大大提高代码导航效率，特别是在大型项目中。