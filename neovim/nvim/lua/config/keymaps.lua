-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<CR>", "m`o<Esc>``")
vim.keymap.set("n", "<S-CR>", "m`O<Esc>``")
vim.keymap.set("n", "<leader>p", "<cmd>WorkspacesOpen<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gG", "<cmd>Neogit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-CR>", vim.lsp.buf.definition, { noremap = true, silent = true })
