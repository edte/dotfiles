# Plenary.nvim Reference

> **plenary**: full; complete; entire; absolute; unqualified.

Lua library for Neovim providing utility functions for plugin development. Includes modules for async operations, path manipulation, job execution, testing, and more.

## Table of Contents

- [Installation](#installation)
- [Module Overview](#module-overview)
- [plenary.async](#plenaryasync)
- [plenary.job](#plenaryjob)
- [plenary.path](#plenarypath)
- [plenary.scandir](#plenaryscandir)
- [plenary.test_harness](#plenarytest_harness)
- [plenary.filetype](#plenaryfiletype)
- [plenary.strings](#plenarystrings)
- [Other Modules](#other-modules)
- [Troubleshooting](#troubleshooting)

---

## Installation

### Using vim-plug

```vim
Plug 'nvim-lua/plenary.nvim'
```

### Using packer.nvim

```lua
use "nvim-lua/plenary.nvim"
```

### Using lazy.nvim

```lua
require("lazy").setup({
  "nvim-lua/plenary.nvim",
})
```

---

## Module Overview

| Module                    | Purpose                           |
| ------------------------- | --------------------------------- |
| `plenary.async`           | Async programming with coroutines |
| `plenary.job`             | System process interaction        |
| `plenary.path`            | Path manipulation (pathlib-style) |
| `plenary.scandir`         | Fast recursive directory scanning |
| `plenary.test_harness`    | Busted-style testing framework    |
| `plenary.filetype`        | Filetype detection                |
| `plenary.strings`         | String utilities                  |
| `plenary.context_manager` | Python-style context manager      |
| `plenary.popup`           | Floating windows and UI           |
| `plenary.profile`         | LuaJIT profiling                  |

---

## plenary.async

Async programming using native Lua coroutines and libuv. Avoids callback hell and enables cooperative concurrency.

### Getting Started

```lua
local async = require("plenary.async")
```

All submodules are accessible by indexing `async`. Loading is lazy for performance.

### Example: File Reading

**libuv version (callback hell):**

```lua
local uv = vim.loop
local read_file = function(path, callback)
  uv.fs_open(path, "r", 438, function(err, fd)
    assert(not err, err)
    uv.fs_fstat(fd, function(err, stat)
      assert(not err, err)
      uv.fs_read(fd, stat.size, 0, function(err, data)
        assert(not err, err)
        uv.fs_close(fd, function(err)
          assert(not err, err)
          callback(data)
        end)
      end)
    end)
  end)
end
```

**plenary.async version (clean):**

```lua
local a = require("plenary.async")

local read_file = function(path)
  local err, fd = a.uv.fs_open(path, "r", 438)
  assert(not err, err)
  local err, stat = a.uv.fs_fstat(fd)
  assert(not err, err)
  local err, data = a.uv.fs_read(fd, stat.size, 0)
  assert(not err, err)
  local err = a.uv.fs_close(fd)
  assert(not err, err)
  return data
end
```

### Channels

#### Oneshot Channel

```lua
local a = require("plenary.async")
local tx, rx = a.control.channel.oneshot()

a.run(function()
  local ret = long_running_fn()
  tx(ret)
end)

local ret = rx()
```

#### MPSC Channel (Multi-Producer Single-Consumer)

```lua
local a = require("plenary.async")
local sender, receiver = a.control.channel.mpsc()

a.run(function()
  sender.send(10)
  sender.send(20)
end)

a.run(function()
  sender.send(30)
  sender.send(40)
end)

for _ = 1, 4 do
  local value = receiver.recv()
  print("received:", value)
end
```

### Plugins using plenary.async

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [vgit.nvim](https://github.com/tanvirtin/vgit.nvim)
- [neogit](https://github.com/TimUntersberger/neogit)
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)

---

## plenary.job

Module for interacting with system processes.

### Basic Example

```lua
local Job = require("plenary.job")

Job:new({
  command = "rg",
  args = { "--files" },
  cwd = "/usr/bin",
  env = { ["a"] = "b" },
  on_exit = function(j, return_val)
    print(return_val)
    print(j:result())
  end,
}):sync()  -- or :start()
```

### Callbacks

```lua
Job:new({
  command = "git",
  args = { "status" },
  on_stdout = function(err, data)
    if data then
      print("STDOUT:", data)
    end
  end,
  on_stderr = function(err, data)
    if data then
      print("STDERR:", data)
    end
  end,
  on_exit = function(j, return_val)
    print("Exit code:", return_val)
  end,
}):start()
```

### Note

Each job has an empty environment by default. Specify `env` if needed.

---

## plenary.path

Path manipulation module, inspired by Python's `pathlib`.

### Examples

```lua
local Path = require("plenary.path")

-- Create path
local p = Path:new("lua", "myplugin", "init.lua")

-- Information
print(p:absolute())   -- Absolute path
print(p:exists())     -- If exists
print(p:is_file())    -- If is file
print(p:is_dir())     -- If is directory

-- Manipulation
local parent = p:parent()
local filename = p:_split()

-- Reading
local content = p:read()

-- Writing
p:write("content", "w")
```

---

## plenary.scandir

Fast recursive directory scanning, similar to Unix `find` or `fd`.

### Basic Example

```lua
local scan = require("plenary.scandir")

local results = scan.scan_dir(".", {
  hidden = true,    -- Include hidden files
  depth = 2,        -- Max depth
  add_dirs = true,  -- Include directories
})
```

### Options

```lua
scan.scan_dir(path, {
  hidden = false,      -- Show hidden files
  depth = math.huge,   -- Max depth
  add_dirs = false,    -- Add directories to results
  silent = false,      -- Suppress errors
  respect_gitignore = true,  -- Respect .gitignore
})
```

### Callbacks

```lua
scan.scan_dir_async(path, {
  on_insert = function(file, typ)
    print("Found:", file, typ)
  end,
  on_exit = function(files)
    print("Complete:", #files)
  end,
})
```

---

## plenary.test_harness

Busted-style testing framework integrated into Neovim.

### Commands

| Command                                 | Description                  |
| --------------------------------------- | ---------------------------- |
| `:PlenaryBustedFile {path}`             | Run single `*_spec.lua` file |
| `:PlenaryBustedDirectory {path} {opts}` | Run all tests in directory   |

### Keymap

```vim
nmap <leader>t <cmd>PlenaryTestFile<cr>
```

### Test Example

```lua
describe("some basics", function()
  local bello = function(boo)
    return "bello " .. boo
  end

  local bounter

  before_each(function()
    bounter = 0
  end)

  it("some test", function()
    bounter = 100
    assert.equals("bello Brian", bello("Brian"))
  end)

  it("some other test", function()
    assert.equals(0, bounter)
  end)
end)
```

### Supported Busted Items

- `describe` - Group tests
- `it` - Define a test
- `pending` - Test to implement
- `before_each` - Run before each test
- `after_each` - Run after each test
- `clear` - Clear context
- `assert.*` - Assertions from luassert (bundled)

### CLI Execution

```bash
# Run all tests in headless mode
nvim --headless -c "PlenaryBustedDirectory tests/"

# With options
nvim --headless -c "PlenaryBustedDirectory tests/ { sequential = true, timeout = 5000 }"
```

### Directory Options

```lua
{
  nvim_cmd = vim.v.progpath,  -- Command to launch Neovim
  init = "path/to/init.vim",   -- Custom init file
  minimal_init = "path/to/init.vim",  -- Init with --noplugin
  sequential = false,          -- Run sequentially
  keep_going = true,           -- Continue on failure (if sequential)
  timeout = 50000,             -- Timeout in ms (default 50000)
}
```

### Exit Code

- `0` - Success
- `1` - Failure

Usable in Makefile for CI/CD.

---

## plenary.filetype

Detects filetype based on extension, filename, shebang, or modeline.

### Functions

```lua
local filetype = require("plenary.filetype")

-- Auto-detect (all methods)
local ft = filetype.detect(filepath)

-- Specific methods
local ft = filetype.detect_from_extension(filepath)
local ft = filetype.detect_from_name(filepath)
local ft = filetype.detect_from_modeline(filepath)
local ft = filetype.detect_from_shebang(filepath)
```

### Adding Custom Filetypes

Create `~/.config/nvim/data/plenary/filetypes/mylang.lua`:

```lua
return {
  extension = {
    -- extension = filetype
    ["myext"] = "mylang",
  },
  file_name = {
    -- special filename = filetype
    [".myrc"] = "mylang",
  },
  shebang = {
    -- shebang = filetype
    ["/usr/bin/mylang"] = "mylang",
  },
}
```

Register the file:

```vim
:lua require('plenary.filetype').add_file('mylang')
```

---

## plenary.strings

String utilities, VimL function reimplementation for use in Lua loops.

### Available Functions

```lua
local strings = require("plenary.strings")

-- From VimL
strings.strdisplaywidth(str)
strings.strcharpart(str, start, length)

-- Common utilities
strings.truncate(str, len, ...)
strings.align_str(str, width, ...)
strings.dedent(str)
```

### Truncate Example

```lua
local strings = require("plenary.strings")

local truncated = strings.truncate("Very long text", 10)
-- "Very long..."
```

---

## Other Modules

### plenary.context_manager

Python-style context manager.

```lua
local with = require("plenary.context_manager").with
local open = require("plenary.context_manager").open

local result = with(open("README.md"), function(reader)
  return reader:read()
end)
```

### plenary.profile

Wrapper for LuaJIT profiler.

```lua
local profile = require("plenary.profile")

profile.start("profile.log")
-- code to profile
profile.stop()

-- Flamegraph
profile.start("profile.log", { flame = true })
-- code to profile
profile.stop()
```

Generate flamegraph with:

```bash
inferno-flamegraph profile.log > flame.svg
```

### plenary.popup

Floating windows and UI. See `POPUP.md` in plenary documentation.

### plenary.window

Helper functions for windows, especially floating.

### plenary.collections

Pure Lua implementations of standard collections.

```lua
local List = require("plenary.collections.py_list")

local myList = List({ 9, 14, 32, 5 })
for i, v in myList:iter() do
  print(i, v)
end
```

---

## Mocking with Luassert

Plenary includes [luassert](https://github.com/Olivine-Labs/luassert) with stubs, mocks, and spies.

### Full Mock (Unit Test)

```lua
local mock = require("luassert.mock")

describe("example", function()
  it("Should mock api calls", function()
    -- Full mock of vim.api
    local api = mock(vim.api, true)

    -- Set expectation
    api.nvim_create_buf.returns(5)

    -- Execute test code
    mymodule.realistic_func()

    -- Verify calls
    assert.stub(api.nvim_create_buf).was_called_with(false, true)
    assert.stub(api.nvim_command).was_called_with("sbuffer 5")

    -- Revert
    mock.revert(api)
  end)
end)
```

### Single Stub (Integration Test)

```lua
local stub = require("luassert.stub")

describe("example", function()
  it("Should stub single function", function()
    local buf_count = #vim.api.nvim_list_bufs()

    -- Stub only nvim_command
    stub(vim.api, "nvim_command")

    mymodule.realistic_func()

    local after_buf_count = #vim.api.nvim_list_bufs()
    assert.equals(buf_count + 1, after_buf_count)
  end)
end)
```

---

## Async Testing

Tests run in a coroutine, can be yielded and resumed.

```lua
it("async test", function()
  local co = coroutine.running()

  vim.defer_fn(function()
    coroutine.resume(co)
  end, 1000)

  -- Reached immediately
  coroutine.yield()

  -- Reached after 1 second
  assert.equals(true, true)
end)
```

---

## Troubleshooting

### Debug Mode

Enable debug for Plenary:

```bash
export DEBUG_PLENARY=true
```

### FAQ: "Too many open files"

\*nix systems have a limit on open file handles.

**Linux:**

```bash
ulimit -n 4096
```

**macOS:**

```bash
sudo launchctl limit maxfiles 4096 4096
```

---

## Recommended Test Structure

```
lua/
├── myplugin/
│   └── init.lua
└── spec/
    └── myplugin/
        └── init_spec.lua
```

---

## References

- Repository: https://github.com/nvim-lua/plenary.nvim
- Telescope (usage example): https://github.com/nvim-telescope/telescope.nvim
- Luassert: https://github.com/Olivine-Labs/luassert
