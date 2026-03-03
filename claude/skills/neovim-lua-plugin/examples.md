# Neovim Lua Plugin Examples

Advanced code examples and patterns for Neovim Lua plugin development. For core best practices, see [SKILL.md](SKILL.md).

## Table of Contents

- [Complete Plugin Structure](#complete-plugin-structure)
- [Lazy Loading Patterns](#lazy-loading-patterns)
- [Filetype Plugins](#filetype-plugins)
- [Setup Function](#setup-function)
- [Advanced Keymap Patterns](#advanced-keymap-patterns)
- [Autocommand Patterns](#autocommand-patterns)

## Complete Plugin Structure

```
myplugin/
├── lua/
│   └── myplugin/
│       ├── init.lua          -- Main module (exported API)
│       ├── config.lua        -- Configuration management
│       ├── core.lua          -- Core functionality
│       ├── health/
│       │   └── init.lua      -- Health checks
│       └── utils.lua         -- Utilities
├── plugin/
│   └── myplugin.lua          -- Entry point (minimal!)
├── ftplugin/
│   └── mylang.lua            -- Filetype-specific
├── doc/
│   └── myplugin.txt          -- Help documentation
└── README.md
```

### Entry Point (`plugin/myplugin.lua`)

```lua
-- Minimal entry point - defer all loading
vim.api.nvim_create_user_command('MyPlugin', function(opts)
    require('myplugin').command(opts.fargs)
end, {
    nargs = '*',
    desc = 'MyPlugin main command',
    complete = function(ArgLead, CmdLine, CursorPos)
        return require('myplugin').complete(ArgLead, CmdLine, CursorPos)
    end,
})

-- <Plug> mapping for main action
vim.keymap.set('n', '<Plug>(MyPluginAction)', function()
    require('myplugin').action()
end)

-- <Plug> mapping for alternate action
vim.keymap.set('v', '<Plug>(MyPluginVisual)', function()
    require('myplugin').visual_action()
end)
```

### Main Module (`lua/myplugin/init.lua`)

```lua
local M = {}

-- Lazy-loaded dependencies cache
local core = nil

local function ensure_core()
    if not core then
        core = require('myplugin.core')
    end
    return core
end

-- User command handler
function M.command(args)
    ensure_core().handle_command(args)
end

-- Completion function
function M.complete(ArgLead, CmdLine, CursorPos)
    return require('myplugin').completion(ArgLead, CmdLine, CursorPos)
end

-- Action functions
function M.action()
    ensure_core().do_action()
end

function M.visual_action()
    ensure_core().do_visual_action()
end

-- Setup function (configuration only, no initialization)
function M.setup(opts)
    require('myplugin.config').setup(opts)
end

return M
```

## Lazy Loading Patterns

### Command-Based Lazy Loading

```lua
-- plugin/myplugin.lua
vim.api.nvim_create_user_command('MyPluginToggle', function()
    require('myplugin').toggle()
end, {})
```

### Keymap-Based Lazy Loading

```lua
-- plugin/myplugin.lua
vim.keymap.set('n', '<leader>mt', function()
    require('myplugin').toggle()
end, { desc = 'Toggle MyPlugin' })
```

### Autocommand-Based Lazy Loading

```lua
-- plugin/myplugin.lua
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function(args)
        -- Lazy-load Python-specific features
        require('myplugin.python').setup(args.buf)
    end,
})
```

### Event-Based Lazy Loading

```lua
-- plugin/myplugin.lua
vim.api.nvim_create_autocmd('User', {
    pattern = 'MyPluginReallyNeeded',
    callback = function()
        -- Initialize expensive features
        require('myplugin.heavy').initialize()
    end,
})

-- Trigger manually elsewhere
vim.api.nvim_exec_autocmds('User', { pattern = 'MyPluginReallyNeeded' })
```

## Filetype Plugins

### Basic Filetype Plugin

```lua
-- ftplugin/mylang.lua
if vim.g.loaded_myplugin_mylang then
    return
end
vim.g.loaded_myplugin_mylang = true

local bufnr = vim.api.nvim_get_current_buf()

-- Buffer-local <Plug> mapping
vim.keymap.set('n', '<Plug>(MyPluginLangAction)', function()
    require('myplugin.mylang').action(bufnr)
end, { buffer = bufnr })
```

### Advanced Filetype Plugin

```lua
-- ftplugin/python.lua
local M = {}

local bufnr = vim.api.nvim_get_current_buf()

-- Check if already initialized
local ns = vim.api.nvim_create_namespace('myplugin_python')
if vim.api.nvim_buf_get_var(bufnr, 'myplugin_initialized', false) then
    return
end

-- Setup buffer
function M.setup()
    -- Buffer-local keymaps
    vim.keymap.set('n', '<localleader>r', function()
        require('myplugin.python').run_file(bufnr)
    end, { buffer = bufnr, desc = 'Run Python file' })

    -- Buffer-local autocommands
    local augroup = vim.api.nvim_create_augroup('MyPluginPython' .. bufnr, {})
    vim.api.nvim_create_autocmd('BufWritePost', {
        buffer = bufnr,
        group = augroup,
        callback = function()
            require('myplugin.python').on_save(bufnr)
        end,
    })

    -- Mark as initialized
    vim.api.nvim_buf_set_var(bufnr, 'myplugin_initialized', true)
end

M.setup()
```

### Setting FileType as Late as Possible

```lua
-- For custom UI buffers
local M = {}

function M.show_ui()
    local bufnr = vim.api.nvim_create_buf(false, true)

    -- Set buffer content
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
        'My Plugin UI',
        '',
        'Press q to close',
    })

    -- Set options
    vim.bo[bufnr].buftype = 'nofile'
    vim.bo[bufnr].bufhidden = 'wipe'
    vim.bo[bufnr].modifiable = false

    -- Open in window
    vim.api.nvim_open_win(bufnr, true, {
        split = 'right',
        win = 0,
    })

    -- Set filetype AS LATE AS POSSIBLE
    -- This allows users to override with FileType autocommand
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.bo[bufnr].filetype = 'mypluginui'
end

return M
```

## Setup Function

### Configuration-Only Setup

```lua
-- lua/myplugin/config.lua
local M = {}

local defaults = {
    option1 = 'default',
    option2 = true,
    option3 = 10,
}

M.config = vim.deepcopy(defaults)

function M.setup(opts)
    M.config = vim.tbl_deep_extend('force', defaults, opts or {})

    -- Validate configuration
    validate_config(M.config)
end

function M.validate_config(config)
    if type(config.option1) ~= 'string' then
        error('option1 must be a string')
    end
    -- More validation...
end

return M
```

### Setup with Lazy Loading

```lua
-- lua/myplugin/init.lua
local M.local

-- Exported API functions (always available)
M.toggle = function()
    require('myplugin.core').toggle()
end

-- Setup is configuration-only, no side effects
M.setup = function(opts)
    require('myplugin.config').setup(opts)
end

-- Heavy features not loaded until needed
M.heavy_feature = function()
    require('myplugin.heavy').do_something()
end

return M
```

## Advanced Keymap Patterns

### Expression Mappings

```lua
-- Smart completion mapping
vim.keymap.set('c', '<down>', function()
    if vim.fn.pumvisible() == 1 then
        return '<c-n>'
    else
        -- Check if we want history or down
        local line = vim.fn.getline('.')
        if #line > 0 then
            return '<down>'
        else
            return '<c-n>'
        end
    end
end, { expr = true })
```

### Mode-Specific Mappings

```lua
-- Different behavior per mode
vim.keymap.set('n', '<Plug>(MyPluginAction)', function()
    require('myplugin').normal_action()
end)

vim.keymap.set('v', '<Plug>(MyPluginAction)', function()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    require('myplugin').visual_action(start_pos, end_pos)
end)

vim.keymap.set('i', '<Plug>(MyPluginAction)', function()
    require('myplugin').insert_action()
end)
```

### Buffer-Local Mappings

```lua
-- In a buffer-specific setup
local function setup_buffer_mappings(bufnr)
    local opts = { buffer = bufnr, silent = true }

    vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover()
    end, opts)

    vim.keymap.set('n', 'gd', function()
        vim.lsp.buf.definition()
    end, opts)

    -- Clear on detach
    vim.api.nvim_buf_attach(bufnr, false, {
        on_detach = function()
            -- Mappings automatically cleared when buffer is deleted
        end,
    })
end
```

## Autocommand Patterns

### Pattern Matching

```lua
-- Multiple patterns
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.lua', '*.vim', '*.py' },
    callback = function(args)
        require('myplugin').format_before_save(args.file)
    end,
})

-- User-defined event
vim.api.nvim_create_autocmd('User', {
    pattern = 'MyPluginCustomEvent',
    callback = function(args)
        print('Custom event triggered: ' .. vim.inspect(args.data))
    end,
})

-- Trigger user event
vim.api.nvim_exec_autocmds('User', {
    pattern = 'MyPluginCustomEvent',
    data = { custom = 'data' },
})
```

### One-Shot Autocommands

```lua
-- Run once and self-destruct
local function run_once(event, callback)
    local group = vim.api.nvim_create_augroup('OneShot' .. event, {})
    vim.api.nvim_create_autocmd(event, {
        group = group,
        once = true,
        callback = function(...)
            vim.api.nvim_del_augroup_by_id(group)
            return callback(...)
        end,
    })
end

-- Usage
run_once('VimEnter', function()
    print('First time entering Neovim!')
end)
```

### Debounced Autocommands

```lua
-- Debounce FileType events
local debounce_timer = nil
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(args)
        if debounce_timer then
            vim.loop.timer_stop(debounce_timer)
        end
        debounce_timer = vim.loop.new_timer()
        debounce_timer:start(100, 0, function()
            require('myplugin').on_filetype_change(args.buf)
            debounce_timer = nil
        end)
    end,
})
```

## Additional Examples

### LSP Integration

```lua
-- Create in-process LSP server for custom UI
local M = {}

function M.setup_lsp()
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'mypluginui',
        callback = function(args)
            -- Attach LSP for code actions in UI buffer
            vim.lsp.start({
                name = 'myplugin',
                cmd = function()
                    return vim.lsp.rpc.connect('127.0.0.1', 12345)
                end,
            }, {
                bufnr = args.buf,
            })
        end,
    })
end

return M
```

### Async Operations

```lua
-- Using vim.loop for async operations
local M = {}

function M.async_operation(callback)
    vim.loop.new_timer():start(0, 0, function()
        -- Do expensive work
        local result = heavy_computation()

        -- Schedule callback on main thread
        vim.schedule(function()
            callback(result)
        end)
    end)
end

return M
```

## Testing Patterns

```lua
-- Minimal test setup
local M = {}

function M.setup_tests()
    -- Create test command
    vim.api.nvim_create_user_command('MyPluginTest', function()
        local ok, result = pcall(function()
            return require('myplugin.tests').run_all()
        end)
        if ok then
            print('All tests passed!')
        else
            print('Test failed: ' .. tostring(result))
        end
    end, {})
end

return M
```
