# Help File Conventions

Conventions for writing Neovim help documentation (vimdoc files). For core plugin best practices, see [SKILL.md](SKILL.md).

## Help File Structure

### First Line (Header)

```vim
*plugin-name.txt*  Short description of the plugin
```

The first line must be:

- A help tag in asterisks (e.g., `*myplugin.txt*`)
- A tab character
- A short description (shown in `:help` LOCAL ADDITIONS)

### Modeline

At the bottom of the file, add a modeline:

```vim
" vim: tw=78 ts=8 sts=4 sw=4 noet fdm=marker
```

**Important:**

- Use `'textwidth'` and `'tabstop'` for formatting
- Set `'filetype'` to `help`
- **Never** set global options in modeline (use local options only)

### Full Template

```vim
*myplugin.txt*  A plugin that does amazing things

Author:  Your Name <your.email@example.com>
License: MIT License
Version: 1.0.0

==============================================================================
CONTENTS                                                *myplugin-contents*

    1. Introduction ................ |myplugin-introduction|
    2. Usage ........................ |myplugin-usage|
    3. Commands .................... |myplugin-commands|
    4. Mappings .................... |myplugin-mappings|
    5. Configuration ................ |myplugin-configuration|
    6. Development .................. |myplugin-development|
    7. Changelog .................... |myplugin-changelog|
    8. Contributing ................ |myplugin-contributing|

==============================================================================
INTRODUCTION                                        *myplugin-introduction*

MyPlugin is a plugin that does amazing things for Neovim.

==============================================================================
USAGE                                                  *myplugin-usage*

Basic usage example:

    :MyPluginStart

To use a custom configuration:

    lua require('myplugin').setup({
        option = 'value',
    })

==============================================================================
COMMANDS                                              *myplugin-commands*

                                                            *:MyPluginStart*
:MyPluginStart

    Start the plugin.

                                                            *:MyPluginStop*
:MyPluginStop[!]

    Stop the plugin. With [!], force stop immediately.

==============================================================================
MAPPINGS                                              *myplugin-mappings*

<Plug>(MyPluginAction)                                *<Plug>(MyPluginAction)*

    Perform the main action. Users can map this in their |init.lua|:

        vim.keymap.set('n', '<leader>a', '<Plug>(MyPluginAction)')

==============================================================================
CONFIGURATION                                      *myplugin-configuration*

                                                    *myplugin-config-option*
option (default: 'default')

    Description of this option.

                                                    *myplugin-config-flag*
flag (default: true)

    Description of this flag.

==============================================================================
DEVELOPMENT                                        *myplugin-development*

Running tests: >

    :MyPluginTest
<

==============================================================================
CHANGELOG                                            *myplugin-changelog*

1.0.0 (2024-01-01)
      * Initial release

==============================================================================
CONTRIBUTING                                      *myplugin-contributing*

Contributions are welcome! Please see CONTRIBUTING.md in the repository.

==============================================================================
vim:tw=78 ts=8 sts=4 sw=4 noet fdm=marker
```

## Help Tags

### Defining Tags

Place tag names between asterisks:

```vim
*myplugin-tag-name*
```

**Tag naming conventions:**

- Start with your plugin name: `myplugin-*`
- Use descriptive names: `myplugin-config-option`
- Right-align tags on the line (for readability)

### Linking to Tags

To create a hyperlink to another tag, surround it with bars:

```vim
See |myplugin-option| for more details.
```

### Linking to Options

Put option names between single quotes:

```vim
Set 'textwidth' to 80 for proper formatting.
```

### Linking to Commands

Link to commands with their full name including the colon:

```vim
Use |:MyPluginCommand| to run the command.
```

## Notation and Highlighting

### Code and Commands

For inline code, use backticks:

```vim
Use `vim.keymap.set()` to create mappings.
```

For code blocks, use `>` and `<` markers:

```vim
>
    vim.keymap.set('n', '<leader>a', function()
        require('myplugin').action()
    end)
<
```

For syntax-highlighted blocks:

```vim
>lua
    vim.keymap.set('n', '<leader>a', function()
        require('myplugin').action()
    end)
<
```

### Column Headings

End heading lines with a space and tilde:

```vim
Column Heading~
```

### Section Separators

Use a line of `=` characters from column 1:

```vim
==============================================================================
```

### Special Highlights

These words/phrases get automatic highlighting:

- `Note`, `Notes`
- `Todo`
- `Error`
- Special key names: `<CR>`, `<Leader>`, etc.
- Items in `{braces}`: `{lhs}`, `{rhs}`, `{option}`
- TAG\* for search keywords

## Help Tag Keywords

For searchability, add tags at the end of sections (right-aligned):

```vim
==============================================================================
CONFIGURATION                                      *myplugin-configuration*
                                                        *myplugin-conf*

This section covers configuration.                    *myplugin-setting*
```

The `*tag*` entries right-aligned on lines create search keywords that users can find with `:helpgrep` or `:help tag<Ctrl-D>`.

## Best Practices

1. **Keep lines under 78 characters** - Use the modeline to set `tw=78`
2. **Use spaces for indentation** - Set in modeline: `sts=4 sw=4`
3. **Don't wrap lines manually** - Let Neovim handle text wrapping
4. **Use descriptive tags** - Prefix all tags with your plugin name
5. **Link liberally** - Help users navigate with `|tags|`
6. **Document all commands** - Include `:CommandName` tags
7. **Document all mappings** - Include `<Plug>(MappingName)` tags
8. **Provide examples** - Show code blocks for common usage
9. **Keep it up to date** - Update help when changing behavior

## Generating Tags

After creating/modifying help files, generate tags:

```vim
:helptags ~/.config/nvim/doc
```

Or for all runtime directories:

```vim
:helptags ALL
```

## Testing Help Files

1. Open your help file:

   ```vim
   :e doc/myplugin.txt
   ```

2. Check syntax highlighting:
   - Tags should be highlighted
   - Links should be clickable
   - Code blocks should be clearly demarcated

3. Test navigation:

   ```vim
   :help myplugin
   ```

4. Test tag jumping:
   - Place cursor on a tag
   - Press `CTRL-]` to jump
   - Press `CTRL-T` to return

5. Test search:
   ```vim
   :helpgrep myplugin
   :copen
   ```

## Common Mistakes to Avoid

1. **Not setting the filetype** - Always include `filetype=help` in modeline
2. **Setting global options** - Never set global options in modeline
3. **Inconsistent tag naming** - Always prefix with plugin name
4. **Missing modeline** - Always include modeline at the end
5. **Manual line wrapping** - Let Neovim handle wrapping via `textwidth`
6. **Forgetting to generate tags** - Run `:helptags` after changes
7. **Using duplicate tags** - Check for conflicts with built-in tags

## Quick Reference

| Element           | Syntax       | Example                   |
| ----------------- | ------------ | ------------------------- |
| Tag               | `*name*`     | `*myplugin-tag*`          |
| Link              | `\|tag\|`    | `See \|myplugin-config\|` |
| Option            | `'name'`     | `'textwidth'`             |
| Command           | `:Name`      | `:MyPluginCmd`            |
| Inline code       | `` `code` `` | `vim.keymap.set()`        |
| Code block        | `>`...`<`    | `>lua\nend<`              |
| Section separator | line of `=`  | `=======================` |
| Column heading    | `text~`      | `Column Heading~`         |
| Note              | `Note`       | `Note: This is important` |

For official documentation, see:

- `:help help-writing` - Complete help file guide
- `:help helphelp` - Help on help files
- `:help help-tags` - Help tag conventions
