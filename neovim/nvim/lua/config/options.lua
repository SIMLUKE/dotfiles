-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Scrolling
vim.opt.scrolloff = 5

-- Indentation defaults
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Line numbers
-- vim.opt.relativenumber = false

-- LSP log level (reduce logging to prevent large log files)
vim.lsp.set_log_level("WARN") -- Only log warnings and errors

-- Filetype detection for Hyprlang
local home = vim.fn.expand("$HOME")
vim.filetype.add({
  pattern = {
    [home .. "/Dotfiles/hyprland/hypr/.*%.conf"] = "hyprlang",
    [home .. "/Dotfiles/hypr/conf/.*%.conf"] = "hyprlang",
    [".*hypr.*%.conf"] = "hyprlang",
    [".*%.hl"] = "hyprlang",
  },
})

vim.o.guifont = "FiraCode Nerd Font:h15"
