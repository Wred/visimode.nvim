# AGENTS.md

## Overview

visimode.nvim is a Neovim plugin that changes the background color when entering Insert mode. It lightens the current colorscheme's background rather than using a hardcoded color.

## Structure

```
lua/visimode/
├── init.lua          # Main plugin logic, setup(), enable/disable/toggle
├── config.lua        # Configuration validation and defaults
└── import/colors/    # Vendored color manipulation library
test/
├── visimode_spec.lua # Test suite
└── run.sh            # Test runner
```

## Key Patterns

- Uses Neovim's Lua API (`vim.api.*`, `vim.wo.*`)
- Config follows nvim-tree's validation pattern
- Autocmds are grouped under `VisimodeCommands` augroup
- Highlight group is `VisimodeInsert`
- Per-window state stored in `saved_winhighlight` table

## Running Tests

```bash
./test/run.sh
```

Tests run in headless Neovim. A mock Normal highlight is set before tests since the Color module requires an existing background.

## Important Notes

- `setup()` must be called for the plugin to work
- The plugin reads the Normal highlight's background at setup time
- Don't modify `lua/visimode/import/` - it's vendored code
