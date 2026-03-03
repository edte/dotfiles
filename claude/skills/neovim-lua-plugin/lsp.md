# LSP Integration for Neovim Plugins

Complete guide to LSP (Language Server Protocol) integration for Neovim plugins. For core plugin best practices, see [SKILL.md](SKILL.md).

## Table of Contents

- [Quickstart](#quickstart)
- [Configuration](#configuration)
- [LSP Attach](#lsp-attach)
- [Events](#events)
- [API Reference](#api-reference)
- [Common Patterns](#common-patterns)

## Quickstart

Basic LSP setup:

```lua
-- Define LSP config
vim.lsp.config['lua_ls'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      }
    }
  }
}

-- Enable the config
vim.lsp.enable('lua_ls')
```

## Configuration

### Defining LSP Configs

**As code:**

```lua
vim.lsp.config('my_server', {
  cmd = { 'my-language-server' },
  filetypes = { 'myfiletype' },
  root_markers = { '.git', 'project.json' },
})
```

**As file:**

Create `lsp/my_server.lua` on 'runtimepath':

```lua
return {
  cmd = { 'my-language-server' },
  filetypes = { 'myfiletype' },
  root_markers = { '.git', 'project.json' },
}
```

### Config Merging

Configs are merged in order of increasing priority:

1. `'*'` global config
2. `lsp/<config>.lua` files in 'runtimepath'
3. `after/lsp/<config>.lua` files
4. `vim.lsp.config()` calls

Example:

```lua
-- Global defaults
vim.lsp.config('*', {
  root_markers = { '.git' },
})

-- Server-specific
vim.lsp.config['clangd', {
  root_markers = { '.clangd', 'compile_commands.json' },
  filetypes = { 'c', 'cpp' },
})
```

### Root Markers

Root markers define project workspace:

```lua
-- Simple: first match wins
root_markers = { 'stylua.toml', '.git' }

-- Equal priority: both markers must be in same directory
root_markers = { { 'stylua.toml', '.luarc.json' }, '.git' }
```

## LSP Attach

Use `LspAttach` event for buffer-local setup:

```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Check server capabilities before setting up
    if client:supports_method('textDocument/implementation') then
      -- Create keymap for implementation
    end

    -- Enable completion
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    end

    -- Auto-format on save
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
  end,
})
```

## Events

### LspAttach

After LSP client attaches to buffer:

```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- Setup buffer-local mappings, options, etc.
  end,
})
```

### LspDetach

Before LSP client detaches:

```lua
vim.api.nvim_create_autocmd('LspDetach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Cleanup, e.g., remove autocmds
  end,
})
```

### LspProgress

On progress notification from server:

```lua
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local value = ev.data.params.value
    -- Handle progress updates
  end,
})
```

### LspTokenUpdate

When semantic token is updated:

```lua
vim.api.nvim_create_autocmd('LspTokenUpdate', {
  callback = function(args)
    local token = args.data.token
    -- Custom token highlighting
  end,
})
```

## API Reference

### vim.lsp.config(name, cfg)

Sets LSP client configuration.

```lua
vim.lsp.config('mylang', {
  cmd = { 'mylang-server' },
  filetypes = { 'mylang' },
  root_markers = { '.git' },
})
```

### vim.lsp.enable(name)

Auto-activates LSP for buffers.

```lua
vim.lsp.enable('mylang')
vim.lsp.enable({ 'lua_ls', 'pyright' })
```

### vim.lsp.start(config)

Creates LSP client and starts server.

```lua
vim.lsp.start({
  name = 'my-server',
  cmd = {'my-language-server'},
  root_dir = vim.fs.root(0, {'pyproject.toml', 'setup.py'}),
})
```

### vim.lsp.buf functions

| Function                    | Purpose            |
| --------------------------- | ------------------ |
| `vim.lsp.buf.hover()`       | Show hover info    |
| `vim.lsp.buf.definition()`  | Jump to definition |
| `vim.lsp.buf.references()`  | Find references    |
| `vim.lsp.buf.rename()`      | Rename symbol      |
| `vim.lsp.buf.code_action()` | Show code actions  |
| `vim.lsp.buf.format()`      | Format buffer      |

## Common Patterns

### Dynamic Root Directory

```lua
vim.lsp.config('conditional', {
  root_dir = function(bufnr, on_dir)
    if not vim.fn.bufname(bufnr):match('%.txt$') then
      on_dir(vim.fn.getcwd())
    end
  end,
})
```

### Custom Filetype Matching

```lua
vim.filetype.add({
  pattern = {
    ['.*/etc/my_file_pattern/.*'] = 'my_filetype',
  },
})
vim.lsp.config('mylang', {
  filetypes = { 'my_filetype' },
})
```

### Conditional Auto-Format

```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          -- Only format if server doesn't support willSaveWaitUntil
          if not client:supports_method('textDocument/willSaveWaitUntil') then
            vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
          end
        end,
      })
    end
  end,
})
```

## Official Documentation

- `:help lsp` - Complete LSP documentation
- https://neovim.io/doc/user/lsp.html - Online documentation
- https://microsoft.github.io/language-server-protocol/ - LSP specification
