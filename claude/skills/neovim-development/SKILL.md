---
name: neovim-development
description: This skill should be used for any Neovim/Vim-related development tasks, including plugin development, configuration, troubleshooting, error diagnosis, and best practices. Covers Lua plugins, user commands, keymaps, lazy loading, health checks, configuration optimization, and debugging Neovim/Vim issues.
---

# Neovim Development

## User's Neovim Config Locations

The user's Neovim configuration is stored in the dotfiles repository:

- **Main path**: `~/dotfiles/nvim/`
- **Symlink**: `~/.config/nvim/` → `~/dotfiles/nvim/`

## Plugin Installation Directories

| Directory                                 | Purpose                                 |
| ----------------------------------------- | --------------------------------------- |
| `~/.local/share/nvim/lazy`                | Lazy.nvim plugin installation directory |
| `~/.local/share/nvim/site/pack/core/opt/` | Vim.pack plugin installation directory  |

# Develop Neovim plugins in Lua following official best practices

## Core Pattern

**Keep `plugin/*.lua` minimal.** Defer `require()` into callbacks.

```lua
-- ✅ GOOD: Lazy-loads
vim.api.nvim_create_user_command('Cmd', function()
    require('plugin').action()
end, {})
```

## Key Practices

| Practice              | Why                    | How                           |
| --------------------- | ---------------------- | ----------------------------- |
| Defer require()       | Minimize startup       | Call `require()` in callbacks |
| Use `<Plug>` mappings | User controls keys     | Create `<Plug>(Action)`       |
| Add health checks     | Prevent support issues | `lua/plugin/health.lua`       |
| Use ftplugin/         | Proper lazy loading    | `ftplugin/{filetype}.lua`     |

## `<Plug>` Pattern

```lua
-- Plugin: deferred
vim.keymap.set('n', '<Plug>(Action)', function()
    require('plugin').action()
end)
-- User: binds to their keys
vim.keymap.set('n', '<leader>a', '<Plug>(Action)')
```

## Common Mistakes

- Loading at top of `plugin/*.lua` → Move `require()` into callbacks
- Direct leader mappings → Use `<Plug>(Action)`
- No health checks → Add `lua/plugin/health.lua`
- lazy.nvim `ft` specs → Use `ftplugin/{filetype}.lua`

## Official Docs

<https://neovim.io/doc/user/lua-plugin.html>

## Supporting Files

All supporting files are in the `references/` directory:

| File                             | When to Use                                                  |
| -------------------------------- | ------------------------------------------------------------ |
| `references/api-reference.md`    | Need API details (commands, keymaps, autocommands)           |
| `references/examples.md`         | Need complete code patterns and advanced examples            |
| `references/health-checks.md`    | Implementing `:checkhealth` support                          |
| `references/help-conventions.md` | Writing `:help` documentation (vimdoc files)                 |
| `references/lsp.md`              | Adding LSP integration to your plugin                        |
| `references/treesitter.md`       | Using Treesitter queries/parsing in your plugin              |
| `references/plenary.md`          | Using plenary.nvim library (async, job, path, testing, etc.) |
