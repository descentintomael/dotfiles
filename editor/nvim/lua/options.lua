-- Editor Options
-- Ported from vimrc

local opt = vim.opt

-- Editing
opt.backspace = { "start", "indent", "eol" }
opt.autoindent = true
opt.autoread = true
opt.smarttab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true
opt.gdefault = true -- Make search/replace global by default

-- Interface
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.showcmd = true
opt.showmode = true
opt.laststatus = 2
opt.colorcolumn = "80"
opt.title = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.tags = "./tags;"

-- History & Undo
opt.history = 500
opt.undolevels = 150
opt.undoreload = 200
opt.undofile = true
opt.undodir = vim.fn.expand("~/.vim/undo")

-- Feedback
opt.showmatch = true
opt.matchtime = 2

-- Redraw / Warnings
opt.lazyredraw = true
opt.errorbells = false
opt.visualbell = true

-- Navigation
opt.scrolloff = 5
opt.sidescrolloff = 5

-- Mouse
opt.mouse = "a"

-- Encoding
opt.encoding = "utf-8"
opt.fileencodings = { "ucs-bom", "utf-8", "default", "latin1" }

-- Files
opt.autowrite = true
opt.swapfile = false
opt.backup = false

-- Folding
opt.foldenable = false

-- Completion
opt.wildmenu = true
opt.wildmode = { "list", "full" }
opt.wildignore:append({ "*/tmp/*", "*.so", "*.swp", "*.zip", "*.sql", "*.log" })

-- Display whitespace
opt.list = true
opt.listchars = { tab = ">>", trail = "." }

-- Timeouts
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10

-- Use ripgrep for grep if available
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end
