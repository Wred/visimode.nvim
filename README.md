# visimode.nvim
Neovim plugin to make insert mode more visible.

![visimode demo](images/visimode-demo.gif)

## Install with lazy

```lua
{
    "wred/visimode.nvim",
    event = {
        "InsertEnter",
    },
    opts = {
	    lighten_by = 0.9,
    }
}
```
