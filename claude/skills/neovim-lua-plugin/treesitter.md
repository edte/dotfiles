# Treesitter Integration for Neovim Plugins

Complete guide to Treesitter integration for Neovim plugins. For core plugin best practices, see [SKILL.md](SKILL.md).

## Table of Contents

- [Overview](#overview)
- [Parsers](#parsers)
- [Queries](#queries)
- [Syntax Highlighting](#syntax-highlighting)
- [Language Injections](#language-injections)
- [API Reference](#api-reference)
- [Common Patterns](#common-patterns)

## Overview

Treesitter provides incremental parsing for syntax highlighting, code navigation, and more.

**Start Treesitter for a buffer:**

```lua
vim.treesitter.start(bufnr, 'lua')
```

## Parsers

### Loading Parsers

Parsers are searched in `parser/` directory on 'runtimepath':

```lua
-- Check if parser can be loaded
if vim.treesitter.language.add('markdown') then
  vim.treesitter.start(bufnr, 'markdown')
end
```

### Load Parser from Path

```lua
vim.treesitter.language.add('python', { 
  path = "/path/to/python.so" 
})
```

### WASM Parsers

If built with `ENABLE_WASMTIME`:

```lua
vim.treesitter.language.add('python', { 
  path = "/path/to/python.wasm" 
})
```

### Register Filetype to Parser

Associate parser with filetypes:

```lua
vim.treesitter.language.register('xml', { 'svg', 'xslt' })
```

## Queries

Treesitter queries extract information from parsed trees using patterns in `*.scm` files.

### Query Files

Located in `queries/{lang}/{purpose}.scm` on 'runtimepath':

```
queries/
└── lua/
    ├── highlights.scm
    ├── injections.scm
    └── folds.scm
```

### Query Modelines

**Inherits from another language:**

```scheme
;; inherits: typescript,jsx
```

**Extends existing queries:**

```scheme
;; extends
```

### Query Predicates

Built-in predicates:

| Predicate | Purpose |
|-----------|---------|
| `#eq?` | Match string equality |
| `#match?` | Match regexp pattern |
| `#lua-match?` | Match lua pattern |
| `#contains?` | Match substring |
| `#any-of?` | Match any of strings |
| `#has-ancestor?` | Match ancestor type |
| `#has-parent?` | Match parent type |

Example predicates:

```scheme
;; Match specific identifier
((identifier) @variable.builtin
  (#eq? @variable.builtin "self"))

;; Match regexp
((identifier) @constant
  (#match? @constant "^[A-Z_]+$"))

;; Match any of keywords
((identifier) @keyword
  (#any-of? @keyword "if" "else" "while"))
```

### Query Directives

Built-in directives:

| Directive | Purpose |
|-----------|---------|
| `#set!` | Set metadata |
| `#offset!` | Apply offset to range |
| `#gsub!` | Transform text |
| `#trim!` | Trim whitespace |

Example directives:

```scheme
;; Set metadata
((identifier) @foo
  (#set! @foo kind "parameter"))

;; Conceal node
((fenced_code_block_delimiter) @conceal
  (#set! conceal ""))
```

## Syntax Highlighting

### Standard Capture Names

Common captures for highlights:

```scheme
; Variables
@variable
@variable.builtin
@variable.parameter
@variable.member

; Constants
@constant
@constant.builtin

; Functions
@function
@function.builtin
@function.call
@function.method

; Keywords
@keyword
@keyword.function
@keyword.import
@keyword.conditional
@keyword.repeat

; Comments
@comment
@comment.documentation

; Strings
@string
@string.special

; Markup
@markup.heading
@markup.link
@markup.raw
```

### Language-Specific Highlights

Append language name for specific highlighting:

```vim
hi @comment.c guifg=Blue
hi @comment.lua guifg=DarkBlue
hi link @comment.documentation.java String
```

### Spell Checking

Mark regions for spell checking:

```scheme
(comment) @spell
```

Disable with `@nospell`.

### Concealing

Hide or replace nodes:

```scheme
;; Replace with single character
"!=" @operator (#set! conceal "≠")

;; Hide entire line
((comment) @comment
  (#set! conceal_lines ""))
```

## Language Injections

Inject one language into another:

```scheme
; Inject language from node
((jsx_element) @injection.content
  (#set! injection.language "javascript"))

; Language from attribute
((tag
  (attribute
    (attribute_value) @injection.language))
  (text) @injection.content)

; Combined injection
(template_string
  (interpolation) @injection.content
  (#set! injection.language "lua")
  (#set! injection.combined))
```

## API Reference

### vim.treesitter.start(bufnr, lang)

Start Treesitter highlighting:

```lua
vim.treesitter.start(bufnr, 'lua')
```

### vim.treesitter.get_parser(bufnr, lang)

Get parser for buffer:

```lua
local parser = vim.treesitter.get_parser(bufnr, lang)
local tree = parser:parse()[1]
local root = tree:root()
```

### vim.treesitter.get_node(opts)

Get node at position:

```lua
local node = vim.treesitter.get_node({
  bufnr = 0,
  pos = { row, col },
})
```

### vim.treesitter.query.parse(lang, query)

Parse query string:

```lua
local query = vim.treesitter.query.parse('lua', [[
  ((function_declaration
     name: (identifier) @name))
]])
```

### TSNode Methods

| Method | Returns |
|--------|---------|
| `node:type()` | Node type as string |
| `node:range()` | Start/end row, col |
| `node:child_count()` | Number of children |
| `node:named_children()` | List of named children |
| `node:parent()` | Parent node |
| `node:text()` | Node text |

## Common Patterns

### Inspect Tree Under Cursor

```vim
:InspectTree
```

Or via Lua:

```lua
vim.treesitter.inspect_tree({ winid = 0 })
```

### Query Parsing Example

```lua
local query = vim.treesitter.query.parse('vimdoc', [[
  ((h1) @str
    (#trim! @str 1 1 1 1))
]])
local tree = vim.treesitter.get_parser():parse()[1]
for id, node, metadata in query:iter_captures(tree:root(), 0) do
  local name = query.captures[id]
  local text = vim.treesitter.get_node_text(node, bufnr)
  print(name, text)
end
```

### Incremental Parsing

```lua
local parser = vim.treesitter.get_parser(bufnr)

-- Parse specific range
local tree = parser:parse({ start_row, end_row })[1]

-- Check if tree is valid
if not parser:is_valid() then
  -- Parse again
  tree = parser:parse()[1]
end
```

### Custom Highlight Captures

```lua
vim.treesitter.query.set('c', 'highlights', [[
  ;inherits c
  (identifier) @spell
]])
```

### Get Captures at Cursor

```lua
local captures = vim.treesitter.get_captures_at_cursor()
-- Returns: { "@function", "@function.builtin", ... }
```

## Official Documentation

- `:help treesitter` - Complete Treesitter documentation
- `:help lua-treesitter` - Lua API reference
- https://neovim.io/doc/user/treesitter.html - Online documentation
- https://tree-sitter.github.io/tree-sitter/ - Treesitter library
