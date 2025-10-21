# ⚙️ Plugin 配置目录

这个目录包含 Neovim 启动时自动加载的配置文件，用于设置核心功能和全局配置。

## 📁 目录结构

```
plugin/
├── autocmds.lua        # 自动命令配置
├── binary.lua          # 二进制文件处理
├── blame.lua           # Git blame 功能
├── cursorline.lua      # 光标行高亮
├── cwd.lua             # 工作目录管理
├── ft.lua              # 文件类型设置
├── highlight.lua       # 高亮配置
├── keymaps.lua         # 全局键位映射
├── lsp.lua             # LSP 基础配置
├── option.lua          # Vim 选项设置
├── timestamp.lua       # 时间戳功能
├── tmux.lua            # Tmux 集成
└── README.md           # 本文档
```

## 🚀 自动加载机制

这个目录下的所有 `.lua` 文件会在 Neovim 启动时自动加载，无需手动 `require`。这是 Neovim 的标准插件目录结构。

### 加载顺序
文件按字母顺序加载，但建议不要依赖加载顺序，而是确保每个文件都是独立的。

## 📄 文件说明

### 🔄 autocmds.lua
自动命令配置，包含：
- **文件保存时的自动操作**
- **文件类型检测和设置**
- **窗口和缓冲区事件处理**
- **编辑行为自动化**

```lua
-- 示例自动命令
Autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- 保存前自动操作
  end,
})
```

### 💾 binary.lua
二进制文件处理配置：
- **二进制文件检测**
- **十六进制模式切换**
- **二进制编辑工具集成**
- **文件类型自动识别**

### 📝 blame.lua
Git blame 功能：
- **行级 blame 信息**
- **作者和时间显示**
- **快速 blame 切换**
- **blame 信息格式化**

### 🎯 cursorline.lua
光标行高亮管理：
- **智能光标行高亮**
- **窗口焦点检测**
- **插入模式行为**
- **性能优化设置**

### 📁 cwd.lua
工作目录管理：
- **项目根目录检测**
- **自动目录切换**
- **目录历史记录**
- **项目特定设置**

### 📋 ft.lua
文件类型设置：
- **自定义文件类型**
- **文件扩展名映射**
- **语法高亮关联**
- **特殊文件处理**

### 🎨 highlight.lua
高亮配置：
- **自定义高亮组**
- **颜色方案调整**
- **语法高亮增强**
- **主题适配**

### ⌨️ keymaps.lua
全局键位映射：
- **基础编辑键位**
- **窗口管理快捷键**
- **文件操作映射**
- **自定义功能键位**

重要键位包括：
```lua
-- 基础操作
"<C-s>" - 保存文件
"jk" - 退出插入模式
"<Esc>" - 清除搜索高亮

-- 窗口管理
"sv" - 垂直分屏
"sc" - 关闭窗口
"<Left/Right/Up/Down>" - 窗口切换

-- 编辑增强
";" / ":" - 交换命令模式键位
"<Enter>" - 快速插入新行
```

### 🔧 lsp.lua
LSP 基础配置：
- **LSP 客户端设置**
- **诊断配置**
- **LSP 事件处理**
- **服务器通用配置**

### ⚙️ option.lua
Vim 选项设置，包含：
- **编辑器行为配置**
- **显示选项设置**
- **性能优化选项**
- **文件处理选项**

重要设置：
```lua
-- 显示设置
number = true           -- 显示行号
cursorline = true       -- 高亮当前行
termguicolors = true    -- 真彩色支持

-- 编辑设置
expandtab = true        -- 使用空格替代 Tab
shiftwidth = 4          -- 缩进宽度
tabstop = 4             -- Tab 宽度

-- 性能设置
updatetime = 100        -- 更新时间 (毫秒)
timeoutlen = 500        -- 键位等待时间
```

### ⏰ timestamp.lua
时间戳功能：
- **文件修改时间记录**
- **自动时间戳插入**
- **时间格式自定义**
- **时间戳更新机制**

### 🖥️ tmux.lua
Tmux 集成：
- **Tmux 会话检测**
- **窗格导航集成**
- **剪贴板同步**
- **状态栏集成**

## 🔧 自定义配置

### 添加新的配置文件
在 `plugin/` 目录下创建新的 `.lua` 文件：

```lua
-- plugin/your-config.lua
-- 你的自定义配置
vim.opt.your_option = "value"

-- 自动命令
vim.api.nvim_create_autocmd("Event", {
  callback = function()
    -- 你的逻辑
  end,
})
```

### 修改现有配置
直接编辑对应的文件，例如：
- 修改键位映射 → 编辑 `keymaps.lua`
- 调整编辑器选项 → 编辑 `option.lua`
- 添加自动命令 → 编辑 `autocmds.lua`

### 禁用特定配置
如果需要临时禁用某个配置文件：

```lua
-- 在文件开头添加
if vim.env.DISABLE_FEATURE then
  return
end
```

或者重命名文件（添加 `.disabled` 后缀）：
```bash
mv plugin/feature.lua plugin/feature.lua.disabled
```

## 🐛 故障排除

### 配置不生效
1. **检查文件路径**: 确保文件在 `plugin/` 目录下
2. **检查语法错误**: 使用 `:messages` 查看错误信息
3. **重启 Neovim**: 某些配置需要重启才能生效

### 键位冲突
```lua
-- 检查键位映射
:map <key>
:verbose map <key>  -- 查看映射来源
```

### 选项设置问题
```lua
-- 检查选项值
:set option?
:verbose set option?  -- 查看设置来源
```

### 自动命令问题
```lua
-- 查看自动命令
:autocmd
:autocmd Event  -- 查看特定事件的自动命令
```

## 📚 相关文档

- [Neovim 配置指南](https://neovim.io/doc/user/lua-guide.html)
- [Vim 选项文档](https://neovim.io/doc/user/options.html)
- [自动命令文档](https://neovim.io/doc/user/autocmd.html)
- [主配置文档](../README.md)

## 💡 最佳实践

### 1. 模块化配置
将相关功能组织在同一个文件中，保持配置的逻辑性。

### 2. 条件加载
使用条件判断避免在不需要的环境中加载配置：

```lua
-- 只在 GUI 环境中设置
if vim.fn.has("gui_running") == 1 then
  -- GUI 特定配置
end
```

### 3. 性能考虑
避免在启动时执行耗时操作，使用懒加载或异步执行。

### 4. 错误处理
使用 `pcall` 包装可能失败的操作：

```lua
local ok, result = pcall(function()
  -- 可能失败的操作
end)
if not ok then
  vim.notify("操作失败: " .. result, vim.log.levels.ERROR)
end
```

### 5. 文档注释
为复杂的配置添加注释，说明用途和原理。

---

⚙️ **提示**: plugin 目录的配置会在每次启动时加载，确保这里的配置是稳定和必需的。