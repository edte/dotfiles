---
name: neovim-lua-plugin
description: Use when developing Lua plugins for Neovim, including user commands, keymaps, lazy loading, health checks, or help documentation. Apply best practices for <Plug> mappings, deferred require, proper structure, even when user requests shortcuts or quick solutions.
---

# Neovim Lua Plugin

Develop Neovim plugins in Lua following official best practices.

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

| File                  | When to Use                                                  |
| --------------------- | ------------------------------------------------------------ |
| `api-reference.md`    | Need API details (commands, keymaps, autocommands)           |
| `examples.md`         | Need complete code patterns and advanced examples            |
| `health-checks.md`    | Implementing `:checkhealth` support                          |
| `help-conventions.md` | Writing `:help` documentation (vimdoc files)                 |
| `lsp.md`              | Adding LSP integration to your plugin                        |
| `treesitter.md`       | Using Treesitter queries/parsing in your plugin              |
| `plenary.md`          | Using plenary.nvim library (async, job, path, testing, etc.) |
