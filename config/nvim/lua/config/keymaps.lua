-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open Oil (file explorer)
vim.keymap.set("n", "<leader>o", "<cmd>Oil --float<CR>", { desc = "Explorer" })

-- Center buffer while navigating
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "gg", "ggzz")
vim.keymap.set("n", "%", "%zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")

vim.keymap.set("x", "p", '"_dP', { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", ":NvimTmuxNavigateLeft<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", ":NvimTmuxNavigateDown<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", ":NvimTmuxNavigateUp<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", ":NvimTmuxNavigateRight<CR>", { noremap = true, silent = true })
