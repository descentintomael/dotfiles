-- Key Mappings
-- Ported from vimrc to preserve muscle memory

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Quick escape with ';
map("i", "';", "<Esc>", opts)
map("v", "';", "<Esc>", opts)
map("n", "';", ":w<CR>", opts)

-- Window navigation (remove ctrl-w prefix)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-h>", "<C-w>h", opts)

-- Window movement
map("n", "<C-J>", "<C-w>J", opts)
map("n", "<C-K>", "<C-w>K", opts)
map("n", "<C-L>", "<C-w>L", opts)
map("n", "<C-H>", "<C-w>H", opts)

-- Line navigation (respect wrapping)
map("n", "k", "gk", { buffer = true, silent = true })
map("n", "j", "gj", { buffer = true, silent = true })
map("n", "0", "g0", { buffer = true, silent = true })
map("n", "$", "g$", { buffer = true, silent = true })

-- Switch between last two files
map("n", "<leader><leader>", ":w<CR><C-^>", opts)

-- Toggle search highlighting
map("n", "<leader>h", ":set hlsearch! hlsearch?<CR>", opts)

-- Toggle relative/absolute line numbers
map("n", "<leader>n", function()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.wo.number = true
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end, opts)

-- Vimrc management
map("n", "<leader>ev", ":tabe $MYVIMRC<CR>", opts)
map("n", "<leader>sv", ":so $MYVIMRC<CR>", opts)

-- Ruby debugging - insert binding.pry above current line
map("n", "<leader>bp", "Obinding.pry<Esc>", opts)

-- Disable Ex mode
map("n", "Q", "<Nop>", opts)

-- Disable K looking stuff up
map("n", "K", "<Nop>", opts)

-- Bind :Q to :q
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Qall", "qall", {})

-- Tab as completion in insert mode (will be overridden by completion plugin)
map("i", "<Tab>", "<C-P>", opts)

-- Rename current file
map("n", "<C-n>", function()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("New file name: ", old_name, "file")
  if new_name ~= "" and new_name ~= old_name then
    vim.cmd("saveas " .. new_name)
    vim.fn.delete(old_name)
    vim.cmd("redraw!")
  end
end, opts)

-- Merge tab into split in previous window
map("n", "<C-w>u", function()
  if vim.fn.tabpagenr() == 1 then
    return
  end
  local buffer_name = vim.fn.bufname("%")
  if vim.fn.tabpagenr("$") == vim.fn.tabpagenr() then
    vim.cmd("close!")
  else
    vim.cmd("close!")
    vim.cmd("tabprev")
  end
  vim.cmd("split")
  vim.cmd("buffer " .. buffer_name)
end, opts)
