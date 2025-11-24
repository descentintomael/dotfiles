-- Neovim Configuration
-- Ported from vimrc with modern Lua setup

-- Set leader key before loading plugins
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Load configuration modules
require("options")
require("keymaps")
require("plugins")
