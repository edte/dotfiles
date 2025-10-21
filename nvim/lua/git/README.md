# 🌿 Git 集成模块

完整的 Git 工作流集成，提供版本控制的可视化和操作功能。

## 📦 包含的插件

### 🔍 Git 状态显示
- **gitsigns.nvim** - Git 变更标记
  - 行级变更显示
  - 实时状态更新
  - 变更预览和操作

### 📊 Git 界面
- **lazygit.nvim** - LazyGit 集成
  - 全功能 Git TUI
  - 可视化分支管理
  - 交互式提交

### 🔄 差异查看
- **diffview.nvim** - 差异查看器
  - 文件差异对比
  - 提交历史查看
  - 合并冲突解决

### 🌳 Git 浏览
- **neogit** - Neovim 原生 Git 界面
  - Magit 风格操作
  - 状态缓冲区
  - 交互式 rebase

### 📝 提交增强
- **vim-fugitive** - Git 命令集成
  - 完整的 Git 命令支持
  - 状态窗口
  - 历史浏览

## ⌨️ 键位映射

### Git 状态和操作
- `<leader>gg` - 打开 LazyGit
- `<leader>gd` - 查看文件差异
- `<leader>gb` - Git blame
- `<leader>gl` - Git 日志

### Gitsigns 操作
- `]c` - 下一个变更
- `[c` - 上一个变更
- `<leader>hs` - 暂存变更块
- `<leader>hr` - 重置变更块
- `<leader>hu` - 撤销暂存
- `<leader>hp` - 预览变更

### 文本对象
- `ih` - 选择变更块内容
- `ah` - 选择整个变更块

## 🎨 视觉指示

### 行标记
- **添加行**: 绿色 `+` 标记
- **修改行**: 蓝色 `~` 标记  
- **删除行**: 红色 `-` 标记

### 状态栏集成
- 显示当前分支
- 显示变更统计
- 显示仓库状态

## 🔧 Gitsigns 配置

### 基本设置
```lua
{
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  current_line_blame = true,    -- 显示当前行 blame
  current_line_blame_delay = 1000,
}
```

### 高级功能
- **实时 blame**: 显示每行的最后修改信息
- **变更预览**: 悬浮窗口显示变更详情
- **智能导航**: 在变更间快速跳转
- **批量操作**: 选择多行进行批量暂存/重置

## 🚀 LazyGit 集成

### 功能特性
- **可视化分支**: 图形化显示分支结构
- **交互式提交**: 选择性暂存文件和变更块
- **冲突解决**: 内置合并冲突解决工具
- **远程操作**: push、pull、fetch 等操作

### 使用技巧
1. 使用 `<leader>gg` 打开 LazyGit
2. 在 LazyGit 中使用 `?` 查看帮助
3. 使用 `q` 退出回到 Neovim
4. 支持鼠标操作和键盘快捷键

## 📊 Diffview 功能

### 差异查看
- **文件差异**: 并排显示文件变更
- **提交对比**: 比较不同提交间的差异
- **分支对比**: 查看分支间的差异

### 常用命令
```vim
:DiffviewOpen              " 打开差异视图
:DiffviewClose             " 关闭差异视图
:DiffviewFileHistory       " 查看文件历史
:DiffviewFileHistory %     " 查看当前文件历史
```

## 🌳 Neogit 工作流

### 状态缓冲区
- 查看工作区状态
- 暂存/取消暂存文件
- 查看变更详情
- 提交变更

### 交互式操作
- **Tab** - 展开/折叠部分
- **s** - 暂存文件/变更块
- **u** - 取消暂存
- **c** - 提交
- **P** - 推送
- **F** - 拉取

## 🔄 工作流示例

### 日常开发流程
1. **查看状态**: `<leader>gg` 打开 LazyGit
2. **查看变更**: 使用 `]c` 和 `[c` 导航变更
3. **预览变更**: `<leader>hp` 预览变更详情
4. **暂存变更**: `<leader>hs` 暂存当前变更块
5. **提交变更**: 在 LazyGit 中提交
6. **推送变更**: 在 LazyGit 中推送

### 冲突解决流程
1. **发现冲突**: Git 操作后出现冲突标记
2. **打开差异**: `:DiffviewOpen` 查看冲突
3. **解决冲突**: 编辑文件解决冲突
4. **标记解决**: 暂存解决后的文件
5. **完成合并**: 提交合并结果

## 🎯 自定义配置

### 修改 Gitsigns 样式
```lua
-- 在 plugins.lua 中修改
{
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "▎" },      -- 自定义添加标记
      change = { text = "▎" },   -- 自定义修改标记
    },
    current_line_blame_opts = {
      delay = 500,               -- 调整 blame 延迟
    },
  },
}
```

### 自定义键位映射
```lua
-- 添加更多 Git 操作键位
nmap("<leader>gp", ":Git push<CR>")
nmap("<leader>gP", ":Git pull<CR>")
nmap("<leader>gs", ":Git status<CR>")
```

### 集成状态栏
```lua
-- 在状态栏显示 Git 信息
local function git_branch()
  local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
  if branch ~= "" then
    return " " .. branch
  else
    return ""
  end
end
```

## 🐛 故障排除

### Gitsigns 不显示
```lua
:Gitsigns toggle_signs     -- 切换标记显示
:checkhealth gitsigns      -- 检查健康状态
:Gitsigns refresh          -- 刷新状态
```

### LazyGit 无法打开
```bash
# 确保 LazyGit 已安装
brew install lazygit       # macOS
# 或其他包管理器安装
```

### 差异视图问题
```lua
:DiffviewRefresh           -- 刷新差异视图
:checkhealth diffview      -- 检查状态
```

### 性能问题
```lua
-- 减少 Gitsigns 更新频率
{
  "lewis6991/gitsigns.nvim",
  opts = {
    update_debounce = 200,   -- 增加防抖时间
    max_file_length = 10000, -- 限制大文件
  },
}
```

## 📚 相关文档

- [LazyGit 官方文档](https://github.com/jesseduffield/lazygit)
- [Gitsigns 配置指南](https://github.com/lewis6991/gitsigns.nvim)
- [Diffview 使用说明](https://github.com/sindrets/diffview.nvim)
- [主配置文档](../README.md)

## 💡 使用技巧

### 1. 快速暂存
使用可视模式选择多行，然后按 `<leader>hs` 批量暂存。

### 2. 变更导航
使用 `]c` 和 `[c` 在文件的变更间快速跳转，比滚动查找更高效。

### 3. 实时 blame
开启 `current_line_blame` 后，光标所在行会显示最后修改的作者和时间。

### 4. 交互式提交
在 LazyGit 中可以选择性暂存文件的部分内容，实现精确的提交控制。

### 5. 历史查看
使用 `:DiffviewFileHistory %` 查看当前文件的完整修改历史。

---

🌟 **提示**: Git 集成功能会自动检测 Git 仓库，只在 Git 项目中启用相关功能。