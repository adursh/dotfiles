local g = vim.g
local opt = vim.opt

-- Tabs / Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

-- UI
opt.number = true
-- opt.relativenumber = true
opt.cursorline = true
g.background = "dark"

-- Clipboard / Swapfile
-- opt.clipboard = "unnamedplus"
opt.swapfile = false

opt.splitbelow = true
opt.splitright = true
-- opt.scrolloff = 999
opt.termguicolors = true
opt.wrap = true
opt.ignorecase = true
opt.inccommand = "split"
opt.hlsearch = true
-- vim.o.pumblend = 20

-- title
opt.titlestring = "this"
opt.title = true

--search
opt.smartcase = true
opt.hlsearch = false

vim.opt.showcmd = true
vim.opt.backspace = { "start", "eol", "indent" }
