---
name: neovim-development
description: Help with Neovim development, configuration, plugin setup, and runtime inspection. Use this skill when the user asks to inspect or modify Neovim config files, plugin specs, keymaps, autocmds, options, LSP setup, lazy.nvim configuration, runtime files, help docs, or a currently running Neovim instance via RPC/socket. Works both for config-repo editing and live Neovim session debugging, using `$NVIM` inside a Neovim terminal or `$NVIM_SOCKET_PATH` in a normal terminal.
---

# Neovim Development

Use this skill for both sides of Neovim work:

1. **Config and plugin development** — inspect or edit `init.lua`, `lua/**`, plugin
   specs, keymaps, autocmds, LSP setup, lazy.nvim config, help docs, and plugin
   source code.
2. **Live Neovim inspection** — query the currently running Neovim instance over
   msgpack-RPC, inspect buffers/windows/options/LSP/runtime state, or execute
   Lua/Vimscript/Ex commands when a live session is required.

When Claude Code(Codex, Gemini) needs to talk to a running Neovim instance, it can
connect over Neovim's msgpack-RPC socket. Inside a Neovim terminal, `$NVIM`
usually points to the parent Neovim socket automatically. In a normal terminal,
set `$NVIM_SOCKET_PATH` to the socket path yourself.

## Decision workflow

1. If the user asks where Neovim config, plugin specs, keymaps, autocmds, or LSP
   setup live, inspect the config repo directly with normal file tools first.
2. If the user asks about the *current* buffer, window, option, diagnostics, LSP
   clients, or anything that depends on a running session, use RPC against the
   live Neovim socket.
3. If the user says a plugin is broken, not loading, or behaving differently than
   expected, inspect both the config files and the live runtime state.
4. Do not require a live Neovim instance for pure config-file questions.

## Known local paths

For this machine and user setup, prefer these concrete paths before guessing:

- Neovim config repo source / source of truth: `~/dotfiles/nvim`
- Standard Neovim config entry path: `~/.config/nvim`
- When editing repo-managed config, prefer the repo source path above and use the
  standard config entry path only when you specifically need the active on-disk
  location that Neovim reads.
- lazy.nvim plugin install root: `~/.local/share/nvim/lazy/`
- Built-in package-style optional plugins: `~/.local/share/nvim/site/pack/core/opt/`

When the user asks where their config or plugins live, check these paths first.
Use runtime or RPC queries only when you need to confirm the active instance's
view of those paths.

## Prerequisites

First, resolve the server socket you want to use:

```bash
SERVER="${NVIM:-$NVIM_SOCKET_PATH}"
printf '%s\n' "$SERVER"
```

If `SERVER` is empty, you are not connected to a Neovim instance yet. Either:

1. Run the agent inside a Neovim terminal so `$NVIM` is set automatically, or
2. Start Neovim with an explicit socket, for example `nvim --listen /tmp/nvim.sock`,
   then export `NVIM_SOCKET_PATH=/tmp/nvim.sock` in your normal terminal.

All examples below assume `SERVER="${NVIM:-$NVIM_SOCKET_PATH}"` has already been
set.

**Important:** When `NVIM_APPNAME` is set, all `nvim --server` commands emit a
`Warning: Using NVIM_APPNAME=...` message on **stdout** (not stderr). This
corrupts parsed output (especially JSON). To suppress it, capture the output
first, then filter:

```bash
result=$(nvim --server "$SERVER" --remote-expr 'EXPR') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

**Note:** Piping `nvim` directly (for example `nvim --server "$SERVER" ... | grep ...`)
can still leave you with warning-contaminated output. Always capture the command
output first with command substitution (`$(...)`) as shown above.

## Normal terminal usage

If you are outside Neovim, start or identify a listening Neovim instance and
point `NVIM_SOCKET_PATH` at it.

```bash
nvim --listen /tmp/nvim.sock
```

In another terminal:

```bash
export NVIM_SOCKET_PATH=/tmp/nvim.sock
SERVER="${NVIM:-$NVIM_SOCKET_PATH}"
result=$(nvim --server "$SERVER" --remote-expr 'v:version') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

## Evaluating expressions

All examples below use the command substitution pattern from Prerequisites to
filter the `NVIM_APPNAME` warning. The shorthand `nvimx EXPR` means:

```bash
result=$(nvim --server "$SERVER" --remote-expr 'EXPR') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

Use `--remote-expr` to evaluate a Vimscript expression and get the result back:

```bash
result=$(nvim --server "$SERVER" --remote-expr 'v:version') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

For Lua expressions, wrap them in `luaeval()`:

```bash
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.api.nvim_buf_get_name(0)")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

For multi-statement Lua that returns a value, use an IIFE:

```bash
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("(function() local x = vim.api.nvim_get_current_win(); return vim.api.nvim_win_get_number(x) end)()")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

### Returning tables/lists

`luaeval()` returns Lua tables as Vimscript values. For complex data, encode as
JSON:

```bash
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.json.encode(vim.api.nvim_list_bufs())")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

## Sending commands

Use `--remote-send` to send keystrokes (as if the user typed them):

```bash
nvim --server "$SERVER" --remote-send ':echo "hello"<CR>'
```

Note: `--remote-send` does not return output and does not need the warning
filter. Use `--remote-expr` when you need a return value.

## Opening files remotely

Use `--remote` to open files in the running Neovim instance:

```bash
nvim --server "$SERVER" --remote file.txt
```

Use `--remote-tab` to open files in new tabs:

```bash
nvim --server "$SERVER" --remote-tab file1.txt file2.txt
```

## Executing Lua without a return value

To run Lua that performs side effects (no return value needed):

```bash
result=$(nvim --server "$SERVER" --remote-expr 'execute("lua vim.notify(\"Hello from Claude\")")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

The `execute()` Vimscript function runs an Ex command and returns its output as a
string (empty if the command produces no output).

## Common patterns

```bash
# Current buffer path
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.api.nvim_buf_get_name(0)")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='

# List all buffer paths (JSON)
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.json.encode(vim.tbl_map(function(b) return vim.api.nvim_buf_get_name(b) end, vim.api.nvim_list_bufs()))")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='

# Current working directory
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.fn.getcwd()")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='

# Current cursor position [row, col] (1-indexed row)
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.json.encode(vim.api.nvim_win_get_cursor(0))")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='

# Get a Neovim option value
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.o.filetype")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='

# Check if an LSP client is attached
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.json.encode(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({bufnr = 0})))")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

## Reading help documentation

Do **not** use `execute("help ...")` — that opens help inside the editor as a
side effect instead of returning content.

First, get the key paths via RPC (do this once per session):

```bash
# Neovim data directory (plugin install root is <data>/lazy/ for lazy.nvim)
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.fn.stdpath(\"data\")")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='

# Built-in Neovim docs
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.fn.expand(\"$VIMRUNTIME\")")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

Then use standard tools (`fd`, `rg`, `Glob`, `Grep`) to search and `Read` to
view the files. Search `<data>/lazy/*/doc/` for plugin docs and
`<runtime>/doc/` for built-in docs.

**Search help tags** (equivalent to `:h query<Tab>` completion):

```bash
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.json.encode(vim.fn.getcompletion(\"MiniDiff\", \"help\"))")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

## Finding plugin source code

**Search runtime files** (searches all runtime paths including user config,
plugins, and `pack/*/start/*`):

```bash
# Find Lua source files matching a keyword (e.g. "codediff", "neotest")
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.json.encode(vim.api.nvim_get_runtime_file(\"lua/**/neotest*\", true))")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='

# Find any runtime file by pattern (plugin/, autoload/, syntax/, etc.)
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.json.encode(vim.api.nvim_get_runtime_file(\"**/neotest*\", true))")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

**Note:** `nvim_get_runtime_file` only searches **active** runtime paths.
Lazy-loaded plugins that haven't been loaded yet won't appear. See the
lazy.nvim section below for how to find those.

Then use `Read`, `Glob`, or `Grep` to explore the returned paths.

## lazy.nvim

The plugin manager [lazy.nvim](https://github.com/folke/lazy.nvim) uses its own
directory layout, separate from Neovim's built-in `pack/` structure.

### Plugin install directory

On this machine, lazy.nvim plugins are installed under
`~/.local/share/nvim/lazy/<plugin-name>/`. In general this corresponds
to `stdpath("data")/lazy/`. This path is **not** part of the standard Neovim
`packpath`.

### Finding plugins (loaded or not)

The lazy.nvim API knows about all plugins regardless of whether they are loaded:

```bash
# Get a specific plugin's directory
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("require(\"lazy.core.config\").plugins[\"neotest\"].dir")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='

# List all plugins with their paths (JSON)
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.json.encode(vim.tbl_map(function(p) return {name = p.name, dir = p.dir, dev = p.dev or false} end, vim.tbl_values(require(\"lazy.core.config\").plugins)))")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

You can also search the install directory directly with `fd`/`Glob` using
`~/.local/share/nvim/lazy/` on this machine, or `stdpath("data")/lazy/`
more generally. For package-style optional plugins installed through Neovim's
built-in `pack` layout on this machine, also check
`~/.local/share/nvim/site/pack/core/opt/`.

### Dev plugins (`dev = true`)

Plugins with `dev = true` in their spec are loaded from a local development
path instead of the install directory.

```bash
# Get the dev path from lazy.nvim config
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("require(\"lazy.core.config\").options.dev.path")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='

# Check if a specific plugin is using dev mode
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("require(\"lazy.core.config\").plugins[\"codediff.nvim\"].dev")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

A dev plugin's source lives at `<dev.path>/<plugin-name>` (e.g. if dev.path is
`~/code/public`, then `codediff.nvim` with `dev = true` loads from
`~/code/public/codediff.nvim`). The plugin's `.dir` field in the lazy API
already reflects this.

### Plugin specs (lazy config files)

Plugin specifications (the Lua files that configure which plugins to load) live
in the Neovim config directory, not in the install directory. For this user,
start with `~/dotfiles/nvim` as the preferred repo source of truth.
If you need the standard live config entry path that Neovim reads from, also
check `~/.config/nvim`. Search there when you need to find how a
plugin is configured:

```bash
# Find plugin spec files
result=$(nvim --server "$SERVER" --remote-expr 'luaeval("vim.fn.stdpath(\"config\")")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
# Then use Glob/Grep to search the returned config path
```

## Stale LSP diagnostics

When files are edited externally (e.g. by Claude Code tools), Neovim's LSP
diagnostics can become stale — showing warnings for old line numbers or
already-fixed issues. To refresh:

1. **Reload the buffer and save** — this forces the LSP to re-analyze:

```bash
result=$(nvim --server "$SERVER" --remote-expr 'execute("lua vim.api.nvim_buf_call(BUFNR, function() vim.cmd(\"edit! | write\") end)")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

1. **Restart the LSP** — if diagnostics are still stale after reloading:

```bash
result=$(nvim --server "$SERVER" --remote-expr 'execute("LspRestart")') && printf '%s\n' "$result" | grep -v '^Warning: Using NVIM_APPNAME='
```

After restarting, wait ~10 seconds for the LSP server to re-index before
querying diagnostics again.

1. **Verify independently** — if diagnostics seem wrong, run the linter directly
   to confirm the actual state (e.g. `golangci-lint run ./...` for Go).

## Safety

- **Never** send `:q`, `:qa`, `:bdelete`, or other destructive commands without
  explicit user confirmation.
- **Never** modify buffer contents via RPC without asking first — the user may
  have unsaved work or an undo history they care about.
- Prefer `--remote-expr` (read-only queries) over `--remote-send` (simulates
  typing) whenever possible.
- Always use command substitution + `grep -v` to suppress the `NVIM_APPNAME`
  warning (see Prerequisites).

## Example prompts

These prompts should strongly match this skill:

- `帮我看看我的 nvim 配置目录和插件配置文件在哪`
- `帮我修改 lazy.nvim 里这个插件的 spec`
- `查一下我的 nvim keymap 是在哪个文件里定义的`
- `帮我排查这个 Neovim 插件为什么没加载`
- `看看我的 LSP 配置在 nvim 里是怎么组织的`
- `帮我找一下这个插件的源码和 help 文档`
- `通过当前 nvim 实例查一下 stdpath("config")`
- `帮我看看当前 buffer 挂了哪些 LSP client`
- `在当前 Neovim 里执行一段 lua 看结果`
- `通过 NVIM_SOCKET_PATH 连上我的 nvim，看看当前窗口和 buffer`

## Workflows

For common Neovim workflows covering config editing, LSP interaction, debugging,
plugin management, and runtime inspection, see the `references/` directory.
