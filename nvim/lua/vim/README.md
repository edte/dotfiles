# ⚡ Vim 功能增强模块

Vim 核心功能的增强和扩展，提供更强大的编辑体验。

## 📦 包含的插件

### 🔢 数字操作
- **dial.nvim** - 智能数字/日期递增递减
  - 数字递增递减
  - 日期时间操作
  - 布尔值切换
  - 自定义模式

### 🎯 编辑增强
- **vim-visual-multi** - 多光标编辑
- **vim-exchange** - 文本交换
- **vim-abolish** - 智能替换和缩写
- **vim-speeddating** - 日期时间操作

### 🔍 搜索增强
- **vim-asterisk** - 搜索增强
- **vim-anzu** - 搜索计数显示
- **clever-f.vim** - 智能 f/F 跳转

### 📝 文本操作
- **vim-textobj-entire** - 整个文件文本对象
- **vim-textobj-line** - 行文本对象
- **vim-textobj-indent** - 缩进文本对象

## 📁 文件结构

```
vim/
├── plugins.lua         # Vim 增强插件配置
├── dial.lua           # Dial.nvim 详细配置
└── README.md          # 本文档
```

## 🔢 Dial.nvim 数字操作

### 基本操作
- `<C-a>` - 递增数字/切换值
- `<C-x>` - 递减数字/切换值
- `g<C-a>` - 可视模式递增序列
- `g<C-x>` - 可视模式递减序列

### 支持的类型

#### 数字类型
```lua
-- 十进制数字
1, 2, 3, 4, 5...
-1, -2, -3...

-- 十六进制数字
0x1, 0x2, 0x3...
0X1, 0X2, 0X3...

-- 八进制数字
0o1, 0o2, 0o3...

-- 二进制数字
0b1, 0b10, 0b11...
```

#### 日期时间
```lua
-- 日期格式
2024-01-01
2024/01/01
01-01-2024

-- 时间格式
12:30:45
12:30 PM
12:30:45.123

-- 星期
Monday, Tuesday, Wednesday...
Mon, Tue, Wed...
```

#### 布尔值和常量
```lua
-- 布尔值
true ↔ false
True ↔ False
TRUE ↔ FALSE

-- 常见对偶
yes ↔ no
on ↔ off
enable ↔ disable
show ↔ hide
```

#### 编程语言特定
```lua
-- Go 语言
nil ↔ err
public ↔ private

-- JavaScript
null ↔ undefined
const ↔ let ↔ var

-- CSS
left ↔ right
top ↔ bottom
```

### 自定义配置

#### 添加新的递增模式
```lua
-- 在 dial.lua 中添加
augend.constant.new({
  elements = { "your", "custom", "cycle" },
  word = true,
  cyclic = true,
})
```

#### 模式特定配置
```lua
-- 为不同模式设置不同的递增器
vim.keymap.set("n", "<C-a>", function()
  require("dial.map").manipulate("increment", "normal")
end)

vim.keymap.set("v", "<C-a>", function()
  require("dial.map").manipulate("increment", "visual")
end)
```

## 🎯 多光标编辑

### 基本操作
```lua
-- 选择单词
<C-n>               -- 选择当前单词
<C-n>               -- 继续选择下一个相同单词
<C-x>               -- 跳过当前选择
<C-p>               -- 回到上一个选择

-- 创建光标
<C-Down>            -- 向下创建光标
<C-Up>              -- 向上创建光标
<A-n>               -- 选择所有相同单词

-- 退出多光标
<Esc>               -- 退出多光标模式
```

### 高级操作
```lua
-- 可视模式选择
<S-Arrows>          -- 扩展选择
<S-Left/Right>      -- 按单词扩展

-- 查找模式
//                  -- 开始查找模式
n/N                 -- 查找下一个/上一个

-- 对齐操作
<Tab>               -- 对齐光标
<S-Tab>             -- 反向对齐
```

## 🔍 搜索增强

### Asterisk 搜索
```lua
*                   -- 搜索当前单词 (精确匹配)
g*                  -- 搜索当前单词 (部分匹配)
#                   -- 反向搜索当前单词
g#                  -- 反向部分匹配搜索

-- 可视模式搜索
*                   -- 搜索选中文本
#                   -- 反向搜索选中文本
```

### Anzu 搜索计数
- 显示当前匹配位置
- 显示总匹配数量
- 状态栏集成显示

### Clever-f 智能跳转
```lua
f{char}             -- 跳转到字符 (可重复按 f)
F{char}             -- 反向跳转 (可重复按 F)
t{char}             -- 跳转到字符前
T{char}             -- 反向跳转到字符前

;                   -- 重复上次跳转
,                   -- 反向重复上次跳转
```

## 📝 文本对象增强

### 整个文件
```lua
ae                  -- 整个文件 (包括空行)
ie                  -- 整个文件 (不包括首尾空行)
```

### 行对象
```lua
al                  -- 整行 (包括换行符)
il                  -- 行内容 (不包括换行符)
```

### 缩进对象
```lua
ai                  -- 相同缩进级别 (包括空行)
ii                  -- 相同缩进级别 (不包括空行)
aI                  -- 相同缩进级别 (包括上级)
iI                  -- 相同缩进级别 (不包括上级)
```

## 🔄 文本交换

### Exchange 操作
```lua
cx{motion}          -- 标记要交换的文本
cxx                 -- 标记当前行
X                   -- 可视模式标记
cxc                 -- 清除标记
```

### 使用示例
```lua
-- 交换两个单词
cxiw                -- 标记第一个单词
{移动到第二个单词}
cxiw                -- 交换完成

-- 交换两行
cxx                 -- 标记第一行
{移动到第二行}
cxx                 -- 交换完成
```

## 🔧 自定义配置

### 修改 Dial 配置
```lua
-- 添加自定义递增器
local augend = require("dial.augend")
require("dial.config").augends:register_group({
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.date.alias["%Y-%m-%d"],
    -- 添加自定义配置
    augend.constant.new({
      elements = {"your", "custom", "values"},
    }),
  },
})
```

### 自定义键位映射
```lua
-- 添加更多 Vim 增强键位
nmap("<leader>x", ":YourCommand<CR>")
vmap("<leader>s", ":sort<CR>")
```

### 集成其他插件
```lua
-- 与其他插件的集成配置
-- 例如与 which-key 的集成
require("which-key").register({
  ["<C-a>"] = "递增数字/切换值",
  ["<C-x>"] = "递减数字/切换值",
})
```

## 🚀 性能优化

### 懒加载策略
- 按键触发加载
- 文件类型特定加载
- 命令触发加载

### 内存优化
- 禁用不需要的功能
- 限制历史记录大小
- 优化正则表达式

## 🐛 故障排除

### Dial 不工作
```lua
:lua print(require("dial.config"))  -- 检查配置
:checkhealth dial                   -- 检查健康状态
```

### 多光标问题
```lua
:VMDebug                           -- 开启调试模式
:checkhealth visual-multi          -- 检查状态
```

### 搜索增强问题
```lua
:set hlsearch                      -- 确保搜索高亮开启
:checkhealth asterisk             -- 检查 asterisk 状态
```

### 文本对象不工作
```lua
:verbose map ae                    -- 检查映射
:checkhealth textobj               -- 检查文本对象
```

## 📚 相关文档

- [Dial 配置文件](./dial.lua)
- [Vim 官方文档](https://vimdoc.sourceforge.net/)
- [多光标使用指南](https://github.com/mg979/vim-visual-multi)
- [主配置文档](../README.md)

## 💡 使用技巧

### 1. 批量数字递增
选择多行数字，使用 `g<C-a>` 创建递增序列。

### 2. 日期操作
光标在日期上使用 `<C-a>/<C-x>` 可以按天递增递减。

### 3. 多光标重构
使用多光标功能快速重命名变量或批量修改。

### 4. 智能搜索
使用 `*` 搜索当前单词，配合 `n/N` 快速导航。

### 5. 文本交换
使用 exchange 功能快速交换函数参数或变量位置。

---

⚡ **提示**: Vim 增强功能专注于提升编辑效率，熟练使用这些功能可以显著提高编码速度。