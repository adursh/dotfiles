vim.g.mapleader = " "

-- Netrw
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)

-- Navigate vim panels better
vim.keymap.set({"n", "i"}, "<C-h>", "<Cmd>wincmd h<CR>", {})
vim.keymap.set({"n", "i"}, "<C-j>", "<Cmd>wincmd j<CR>", {})
vim.keymap.set({"n", "i"}, "<C-k>", "<Cmd>wincmd k<CR>", {})
vim.keymap.set({"n", "i"}, "<C-l>", "<Cmd>wincmd l<CR>", {})

-- Nevigate better in terminal mode
function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	local map = vim.api.nvim_buf_set_keymap
	map(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	map(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
	map(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
	map(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
	map(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		pcall(set_terminal_keymaps)
        vim.cmd("startinsert")
	end,
})

-- clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- set ctrl+backspace
vim.keymap.set("i", "<C-BS>", "<C-\\><C-o>db", { noremap = true })


vim.keymap.set('i', '<C-c>', '<nop>', { noremap = true, silent = true })  -- Was: exit insert mode
vim.keymap.set('i', '<C-h>', '<nop>', { noremap = true, silent = true })  -- Was: backspace
vim.keymap.set('i', '<C-w>', '<nop>', { noremap = true, silent = true })  -- Was: delete word backward
vim.keymap.set('i', '<C-u>', '<nop>', { noremap = true, silent = true })  -- Was: delete line before cursor
vim.keymap.set('i', '<C-d>', '<nop>', { noremap = true, silent = true })  -- Was: decrease indent  
vim.keymap.set('i', '<C-t>', '<nop>', { noremap = true, silent = true })  -- Was: increase indent
vim.keymap.set('i', '<C-j>', '<nop>', { noremap = true, silent = true })  -- Was: new line
vim.keymap.set('i', '<C-m>', '<nop>', { noremap = true, silent = true })  -- Was: new line (Enter)
vim.keymap.set('i', '<C-i>', '<nop>', { noremap = true, silent = true })  -- Was: tab character
-- vim.keymap.set('i', '<C-n>', '<nop>', { noremap = true, silent = true })  -- Was: next completion
-- vim.keymap.set('i', '<C-p>', '<nop>', { noremap = true, silent = true })  -- Was: previous completion
vim.keymap.set('i', '<C-x>', '<nop>', { noremap = true, silent = true })  -- Was: completion mode prefix
vim.keymap.set('i', '<C-y>', '<nop>', { noremap = true, silent = true })  -- Was: accept completion
vim.keymap.set('i', '<C-v>', '<nop>', { noremap = true, silent = true })  -- Was: insert literal character
