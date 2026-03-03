# Neovim Health Checks

Complete guide to implementing health checks for Neovim plugins. For core best practices, see [SKILL.md](SKILL.md).

## Table of Contents

- [Running Health Checks](#running-health-checks)
- [Configuration](#configuration)
- [Creating Health Checks](#creating-health-checks)
- [Health API Reference](#health-api-reference)
- [Best Practices](#best-practices)

## Running Health Checks

```vim
:checkhealth            " Run all healthchecks
:checkhealth myplugin   " Run healthcheck for specific plugin
:checkhealth foo bar    " Run healthchecks for multiple plugins
:checkhealth vim.lsp    " Run healthcheck for submodule
:checkhealth vim*        " Run healthchecks for all vim.* submodules
```

## Configuration

### Display Style

Display health in a floating window:

```lua
vim.g.health = { style = 'float' }
```

### Customization with FileType

You can customize the health buffer by handling the FileType event:

```lua
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'checkhealth',
    callback = function()
        -- Example: Remove emojis
        vim.opt_local.modifiable = true
        vim.cmd([[silent! %s/\v( ?[^\x00-\x7F])//g]])
    end,
})
```

## Creating Health Checks

`:checkhealth` automatically finds health modules on 'runtimepath'. Create a `health.lua` module that returns a table with a `check()` function.

### File Locations

**For a main plugin:**

```
lua/
└── myplugin/
    ├── health.lua       " require('myplugin.health').check()
    └── health/
        └── init.lua       " Also works
```

**For a submodule:**

```
lua/
└── myplugin/
    └── submodule/
        ├── health.lua   " require('myplugin.submodule.health').check()
        └── health/
            └── init.lua   " Also works
```

### Basic Example

```lua
-- lua/myplugin/health.lua
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

### Multiple Sections

You can create multiple sections by calling `start()` multiple times:

```lua
M.check = function()
    -- Configuration section
    vim.health.start('myplugin config')
    vim.health.ok('Config is valid')

    -- Dependencies section
    vim.health.start('myplugin dependencies')
    vim.health.ok('All dependencies found')
end
```

## Health API Reference

### vim.health.start(name)

Starts a new report section. Most plugins should call this only once, but you can call it multiple times for different sections.

**Parameters:**

- `name` (string) - Name of the report section

```lua
vim.health.start('myplugin report')
```

### vim.health.ok(msg)

Reports a success message.

**Parameters:**

- `msg` (string) - The success message

```lua
vim.health.ok('Configuration is valid')
```

### vim.health.warn(msg, ...)

Reports a warning with optional advice.

**Parameters:**

- `msg` (string) - The warning message
- `...` (string|string[], optional) - Advice or additional information

```lua
-- Single advice string
vim.health.warn('ripgrep not found', 'Install ripgrep for better performance')

-- Multiple advice items
vim.health.warn('ripgrep not found', {
    'Install ripgrep for better performance',
    'https://github.com/BurntSushi/ripgrep'
})
```

### vim.health.error(msg, ...)

Reports an error with optional advice.

**Parameters:**

- `msg` (string) - The error message
- `...` (string|string[], optional) - Advice or additional information

```lua
vim.health.error('Configuration is invalid', { 'Check your setup()' })
```

### vim.health.info(msg)

Reports an informational message.

**Parameters:**

- `msg` (string) - The info message

```lua
vim.health.info('Plugin version: ' .. version)
```

## Best Practices

### What to Check

1. **User configuration** - Validate setup() parameters
2. **External dependencies** - Check for required executables (rg, fzf, etc.)
3. **Lua dependencies** - Check for required plugins/modules
4. **Proper initialization** - Verify plugin initialized correctly

### Reporting Levels

- **ok** - Everything is working correctly
- **info** - Informational (version, configuration state)
- **warn** - Something is wrong but plugin will work (missing optional dependency)
- **error** - Something is broken and needs attention

### Advice Messages

Always provide actionable advice when reporting errors/warnings:

```lua
-- ❌ BAD: No advice
vim.health.error('Configuration invalid')

-- ✅ GOOD: With advice
vim.health.error('Configuration invalid', {
    'Check that setup() is called with valid options',
    'See :h myplugin-config for reference'
})
```

### Testing Your Health Check

```vim
:checkhealth myplugin
```

For development, you can also reload the module:

```lua
package.loaded['myplugin.health'] = nil
:checkhealth myplugin
```

## Official Documentation

- `:help health-dev` - Complete health check developer guide
- `:help health` - Health check overview
- https://neovim.io/doc/user/health.html - Online documentation
