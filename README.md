## The problem :warning: ##

You open your favorite editor, Neovim, you wan't to execute some test without leaving your favorite enivoronment, but this seems impossible. 

## The solution :trophy: ##

This Neovim plugin, Java Maven Test, integrates with telescope.nvim and nvim-treesitter to enable interactive fuzzy finding and executing Java tests within a class.

[![asciicast](https://asciinema.org/a/YJnUsr3ujc1GHgoRsXGZWxeS4.svg)](https://asciinema.org/a/YJnUsr3ujc1GHgoRsXGZWxeS4)


### Installation :star: ###
* Make sure you have Neovim v0.9.0 or greater. :exclamation:
* Dependecies: treesiter && telescope && plenary (telescope dep)
* Install using you plugin manager

`Vim-Plug`  
```lua
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'jkeresman01/java-maven-test.nvim'
```

`Packer`
```lua

use {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} }
}

 use 'nvim-treesitter/nvim-treesitter'

 use 'jkeresman01/java-maven-test.nvim'
```

## Keymapings :musical_keyboard: ##

Set the keymapings as you see fit, here is one example:

```lua
local tests = require("java-maven-test")
local mvn   = require("java-maven-test.mvn")

vim.keymap.set("n", "<leader>rt", function() mvn.execute_test_at_cursor() end)        -- execute test under the cursor
vim.keymap.set("n", "<leader>ra", function() mvn.execute_all_tests_in_class() end)    -- execute all tests in currently opened class
vim.keymap.set("n", "<leader>ft", function() tests.find() end)                        -- fuzzy find trough tests in a given class and execute selected one
```

Same stuff presented in a table (easier to read):

| Keybind       | Action                                                             |
|---------------|--------------------------------------------------------------------|
| `<leader>rt`  | Execute test under the cursor                                      |
| `<leader>c`   | Execute all tests in currently opened class                        |
| `<CR>`        | Fuzzy find trough tests in a given class and execute selected one  |
