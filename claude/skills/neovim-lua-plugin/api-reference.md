# Neovim Lua Plugin API Reference

Complete API reference for Neovim Lua plugin development. For the core best practices, see [SKILL.md](SKILL.md).

## Table of Contents

- [User Commands](#user-commands)
- [Keymaps](#keymaps)
- [Autocommands](#autocommands)
- [Health Checks](#health-checks)
- [Lua Module System](#lua-module-system)
- [Options and Variables](#options-and-variables)

## User Commands

### Creating Commands

Use `vim.api.nvim_create_user_command()`:

```lua
vim.api.nvim_create_user_command('MyCommand', function(opts)
    -- opts.name: command name
    -- opts.fargs: arguments as table
    -- opts.bang: true if command had !
    -- opts.line1, opts.line2: range
    -- opts.range: 0, 1, or 2
    -- opts.count: count supplied
    -- opts.smods: command modifiers
    print('Args: ' .. vim.inspect(opts.fargs))
end, {
    nargs = '*',  -- 0, 1, ?, *, or +
    desc = 'My command description',
    complete = function(ArgLead, CmdLine, CursorPos)
        -- Return completion candidates
        return { 'option1', 'option2' }
    end,
    range = true,  -- Accept range
    bang = true,   -- Accept ! modifier
})
```

### Buffer-Local Commands

```lua
vim.api.nvim_buf_create_user_command(0, 'BufCommand', function(opts)
    print('Buffer-local command')
end, { nargs = 0 })
```

### Deleting Commands

```lua
vim.api.nvim_del_user_command('MyCommand')
vim.api.nvim_buf_del_user_command(0, 'BufCommand')
```

## Keymaps

### Creating Keymaps

Use `vim.keymap.set()`:

```lua
vim.keymap.set(mode, lhs, rhs, opts)
```

**Parameters:**

- `mode`: `'n'` (normal), `'i'` (insert), `'v'` (visual), `'x'` (visual-block), `'s'` (select), `'t'` (terminal), `'c'` (command), `'o'` (operator-pending), `''` (normal+visual+operator-pending), or table of modes
- `lhs`: Left-hand side (key sequence)
- `rhs`: Right-hand side (command or Lua function)
- `opts`: Optional table

**Common options:**

- `buffer`: Buffer number or `true` for current buffer
- `silent`: Suppress output
- `expr`: Use return value as input (expression mapping)
- `remap`: Allow recursive mappings (default: non-recursive)
- `desc`: Description (shown in `:map` output)

**Examples:**

```lua
-- Normal mode mapping
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')

-- Lua function (deferred loading)
vim.keymap.set('n', '<leader>ga', function()
    require('myplugin').action()
end)

-- Expression mapping
vim.keymap.set('c', '<down>', function()
    if vim.fn.pumvisible() == 1 then
        return '<c-n>'
    end
    return '<down>'
end, { expr = true })

-- Buffer-local with description
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
    buffer = 0,
    desc = 'LSP hover'
})
```

### Deleting Keymaps

```lua
vim.keymap.del('n', '<leader>ff')
vim.keymap.del({'n', 'v'}, '<leader>q', { buffer = true })
```

## Autocommands

### Creating Autocommands

Use `vim.api.nvim_create_autocmd()`:

```lua
vim.api.nvim_create_autocmd(event, opts)
```

**Parameters:**

- `event`: Event name or table of events
- `opts`: Options table

**Common events:**

- `BufRead`, `BufNewFile`, `BufWritePre`, `BufWritePost`
- `FileType`, `BufEnter`, `BufWinEnter`
- `TextYankPost`, `VimEnter`, `VimLeave`
- `User` (custom events)

**Options:**

- `pattern`: File pattern(s)
- `callback`: Lua function (receives args table)
- `command`: Vim command string
- `group`: Augroup name or ID
- `desc`: Description
- `buffer`: Buffer number for buffer-local

**Callback arguments:**

- `args.match`: Matched pattern
- `args.buf`: Buffer number
- `args.file`: File name
- `args.data`: Event-specific data

**Examples:**

```lua
-- Simple callback
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function(args)
        print('Lua file opened: ' .. args.file)
    end,
    desc = 'Log Lua file opens'
})

-- With augroup
local mygroup = vim.api.nvim_create_augroup('MyGroup', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.lua',
    group = mygroup,
    callback = function()
        -- Format before save
    end,
})

-- Buffer-local
vim.api.nvim_create_autocmd('CursorHold', {
    buffer = 0,
    callback = function()
        print('Cursor hold')
    end,
})
```

### Augroups

```lua
-- Create/clear augroup
local group = vim.api.nvim_create_augroup('MyGroup', { clear = true })

-- Reference by name
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'MyGroup',
    callback = function() end,
})
```

### Clearing Autocommands

```lua
vim.api.nvim_clear_autocmds({ event = 'BufEnter' })
vim.api.nvim_clear_autocmds({ pattern = '*.py' })
vim.api.nvim_clear_autocmds({ group = 'MyGroup' })
vim.api.nvim_clear_autocmds({ event = 'ColorScheme', buffer = 0 })
```

## Health Checks

### Creating Health Checks

Create `lua/plugin/health.lua` (or `lua/plugin/health/init.lua`):

```lua
local M = {}

M.check = function()
    vim.health.start('myplugin report')

    -- Check configuration
    if check_config_valid() then
        vim.health.ok('Configuration is valid')
    else
        vim.health.error('Configuration is invalid', { 'Check your setup()' })
    end

    -- Check external dependencies
    if vim.fn.executable('rg') == 1 then
        vim.health.ok('ripgrep found')
    else
        vim.health.warn('ripgrep not found', {
            'Install ripgrep for better performance',
            'https://github.com/BurntSushi/ripgrep'
        })
    end

    -- Check Lua dependencies
    local ok, _ = pcall(require, 'dependency')
    if ok then
        vim.health.ok('dependency module found')
    else
        vim.health.error('dependency module not found')
    end
end

return M
```

### Health API

- `vim.health.start(name)` - Start a new report section
- `vim.health.ok(msg)` - Report success
- `vim.health.warn(msg, advice?)` - Report warning with optional advice
- `vim.health.error(msg, advice?)` - Report error with optional advice
- `vim.health.info(msg)` - Report info

### Running Health Checks

```vim
:checkhealth myplugin
```

## Lua Module System

### Requiring Modules

```lua
-- Require a module
local mymodule = require('mymodule')

-- Require with subdirectory
local submodule = require('myproject.submodule')
-- Equivalent to: require('myproject/submodule')

-- Require index file
local myproject = require('myproject')
-- Loads: lua/myproject/init.lua
```

### Module Caching

```lua
-- First require loads and caches the module
local m = require('mymodule')

-- Subsequent requires return cached value
local m2 = require('mymodule')  -- Same as m

-- Clear cache to reload
package.loaded['mymodule'] = nil
local m3 = require('mymodule')  -- Reloads from disk
```

### Module Locations

Modules are searched in all `lua/` directories in `'runtimepath'`:

```
~/.config/nvim/
├── lua/
│   ├── myplugin.lua        -- require('myplugin')
│   └── myplugin/
│       ├── init.lua        -- require('myplugin')
│       └── utils.lua       -- require('myplugin.utils')
```

## Options and Variables

### Setting Options

```lua
-- vim.opt (table-like interface)
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- vim.opt_global
vim.opt_global.statusline = 'Hello'

-- vim.opt_local
vim.opt_local.textwidth = 80

-- vim.o (direct access)
vim.o.smarttab = false
vim.o.listchars = 'space:_,tab:>~'
print(vim.o.smarttab)  -- false
```

### Buffer/Window Options

```lua
-- Buffer options (by number)
vim.bo[4].expandtab = true

-- Window options
vim.wo.number = true
vim.wo[0].relativenumber = true
```

### Variables

```lua
-- Global variables (g:)
vim.g.my_var = { key = 'value' }
print(vim.g.my_var.key)

-- Buffer variables (b:)
vim.b[10].my_buf_var = true

-- Window variables (w:)
vim.w[100].my_win_var = 'test'

-- Tab variables (t:)
vim.t.my_tab_var = 42

-- Environment variables
vim.env.PATH = vim.env.PATH .. ':/custom/path'

-- Predefined variables (v:)
local cwd = vim.v.cwd
local version = v.version
```

### Variable Naming with Special Characters

```lua
-- Use bracket notation for names with special chars
vim.g['my#variable'] = 1
vim.fn['my#autoload#function']()
```

## Additional Resources

- `:h lua-plugin` - Plugin development guide
- `:h lua-guide` - Lua usage guide
- `:h api` - Nvim API reference
- `:h lua` - Lua standard library
