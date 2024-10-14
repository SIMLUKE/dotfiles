-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "lua" },
  callback = function()
    vim.bo.shiftwidth = 2 -- Number of spaces for indentation
    vim.bo.tabstop = 2 -- Number of spaces for a tab
    vim.bo.expandtab = true -- Convert tabs to spaces
  end,
})
