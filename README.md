<div align="center">

  <h1>java-maven-test.nvim</h1>
  <h6>Neovim plugin that allows you to easily search and execute your tests within Neovim </h6>

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim 0.10](https://img.shields.io/badge/Neovim%200.10-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)
![Work In Progress](https://img.shields.io/badge/Work%20In%20Progress-orange?style=for-the-badge)

</div>

## Table of Contents

- [The problem](#problem)
- [The solution](#solution)
- [Functionalities](#functionalities)
- [Installation](#installation)
- [Key - mappings](#keymapings)

## The problem :warning: <a name="problem"></a> ##
You open Neovim, your preferred editor, with the intention of running tests without having to leave your preferred environment.

## The solution :trophy: <a name="solution"></a> ##

This Neovim plugin, java-maven-test.nvim, integrates with telescope.nvim and nvim-treesitter to facilitate interactive fuzzy searching and execution of Java tests within a class.

[![asciicast](https://asciinema.org/a/YJnUsr3ujc1GHgoRsXGZWxeS4.svg)](https://asciinema.org/a/YJnUsr3ujc1GHgoRsXGZWxeS4)

### Functionalities :pick: <a name="functionalities"></a> ###

- [x] Execute test case under the cursor
- [x] Execute all test in a given class
- [x] Fuzzy find trough all tests in a class and pick which one to execute

### Installation :star: <a name="installation"></a> ###
* Make sure you have Neovim v0.9.0 or greater. :exclamation:
* Dependecies: treesiter && telescope && plenary (telescope dep)
* Install using you plugin manager

***

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
***

## Key - mapings :musical_keyboard: <a name="keymapings"></a> ##

Set the keymapings as you see fit, here is one example:

```lua
local tests = require("java-maven-test")
local mvn   = require("java-maven-test.mvn")

vim.keymap.set("n", "<leader>ft", function() tests.find() end) 

vim.keymap.set("n", "<leader>rt", function() mvn.execute_test_at_cursor() end)     
vim.keymap.set("n", "<leader>ra", function() mvn.execute_all_tests_in_class() end)  
```
***

| Key - map     | Action                                                             |
|---------------|--------------------------------------------------------------------|
| `<leader>rt`  | Execute test under the cursor                                      |
| `<leader>ra`  | Execute all tests in currently opened class                        |
| `<leader>ft`  | Fuzzy find trough tests in a given class and execute selected one  |
