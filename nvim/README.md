# 🚀 Neovim 个人配置

一个高度定制化、模块化的 Neovim 配置，专注于开发效率和用户体验。

## ✨ 特性

- 🎨 **现代化 UI** - Tokyo Night 主题 + 精美状态栏
- ⚡ **高性能** - 基于 lazy.nvim 的懒加载插件管理
- 🔧 **模块化架构** - 按功能分类的清晰目录结构
- 🌍 **多语言支持** - Go, Lua, C++, Rust, JavaScript 等
- 🔍 **强大的搜索** - 集成 Telescope 和 Snacks
- 📝 **智能补全** - nvim-cmp + 多种补全源
- 🔗 **Git 集成** - 完整的 Git 工作流支持
- 🎯 **LSP 集成** - 完整的语言服务器支持

## 📁 目录结构

```
nvim/
├── init.lua              # 入口配置文件
├── lua/                  # 主要配置目录
│   ├── alias.lua         # 全局工具函数和别名
│   ├── lazys.lua         # 插件管理器配置
│   ├── ui/               # 用户界面相关插件
│   ├── cmp/              # 代码补全配置
│   ├── lsp/              # 语言服务器配置
│   ├── git/              # Git 相关功能
│   ├── text/             # 文本处理和语法高亮
│   ├── vim/              # Vim 功能增强
│   ├── bookmark/         # 书签功能
│   ├── components/       # 通用组件
│   └── utils/            # 工具函数
├── plugin/               # 启动时自动加载的配置
├── ftplugin/             # 文件类型特定配置
└── lsp/                  # LSP 服务器配置
```

## 🚀 快速开始

### 安装要求

- Neovim >= 0.9.0
- Git
- Node.js (用于某些 LSP 服务器)
- ripgrep (用于搜索)
- fd (用于文件查找)

### 安装

```bash
# 备份现有配置
mv ~/.config/nvim ~/.config/nvim.backup

# 克隆配置
git clone <your-repo> ~/.config/nvim

# 启动 Neovim，插件会自动安装
nvim
```

### 首次启动

1. 启动 Neovim，lazy.nvim 会自动安装所有插件
2. 等待插件安装完成
3. 重启 Neovim
4. 运行 `:checkhealth` 检查配置状态

## ⌨️ 核心键位

### 基础操作
- `<Space>` - Leader 键
- `;` / `:` - 交换命令模式键位
- `jk` - 退出插入模式
- `<C-s>` - 保存文件

### 文件操作
- `<Space>ff` - 查找文件
- `<Space>fg` - 全局搜索
- `<Space>fb` - 查找缓冲区
- `<Space>fr` - 最近文件

### 窗口管理
- `sv` - 垂直分屏
- `sc` - 关闭当前窗口
- `so` - 关闭其他窗口
- `<Left/Right/Up/Down>` - 窗口切换

### Git 操作
- `<Space>gg` - Git 状态
- `<Space>gc` - Git 提交
- `<Space>gp` - Git 推送
- `<Space>gl` - Git 日志

### LSP 功能
- `gd` - 跳转到定义
- `gr` - 查找引用
- `K` - 显示文档
- `<Space>rn` - 重命名
- `<Space>ca` - 代码操作

## 🔧 自定义配置

### 添加新插件

在对应的模块目录下的 `plugins.lua` 文件中添加：

```lua
-- 例如在 lua/ui/plugins.lua 中
{
  "plugin-author/plugin-name",
  config = function()
    -- 插件配置
  end,
}
```

### 修改键位映射

在 `plugin/keymaps.lua` 中添加或修改键位：

```lua
nmap("<leader>x", ":YourCommand<CR>")
```

### 添加自动命令

在 `plugin/autocmds.lua` 中添加：

```lua
Autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function()
    -- 你的自动命令
  end,
})
```

## 📦 主要插件

### 核心插件
- [lazy.nvim](https://github.com/folke/lazy.nvim) - 插件管理器
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - 主题
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - 语法高亮

### 编辑增强
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - 代码补全
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP 配置
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - 模糊查找

### UI 增强
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - 标签页
- [which-key.nvim](https://github.com/folke/which-key.nvim) - 键位提示
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - 文件树

## 🛠️ 故障排除

### 常见问题

1. **插件加载失败**
   ```bash
   :Lazy sync
   ```

2. **LSP 不工作**
   ```bash
   :LspInfo
   :checkhealth lsp
   ```

3. **键位冲突**
   ```bash
   :map <key>  # 查看键位映射
   ```

### 性能问题

- 检查启动时间：`nvim --startuptime startup.log`
- 查看插件状态：`:Lazy profile`
- 检查健康状态：`:checkhealth`

## 📚 文档

- [插件配置说明](./lua/README.md)
- [键位映射文档](./plugin/README.md)
- [文件类型配置](./ftplugin/README.md)
- [LSP 配置指南](./lsp/README.md)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License - 详见 [LICENSE.md](./LICENSE.md)

## 🙏 致谢

感谢所有插件作者和 Neovim 社区的贡献！

---

⭐ 如果这个配置对你有帮助，请给个 Star！