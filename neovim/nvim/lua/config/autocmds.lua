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

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "h" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- clangd: expand C/C++ macros via code action
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "clangd" then
      return
    end

    vim.keymap.set("n", "<leader>xm", function()
      vim.lsp.buf.code_action({
        apply = true,
        filter = function(action)
          return action and action.title and action.title:lower():find("expand macro", 1, true) ~= nil
        end,
      })
    end, { buffer = args.buf, desc = "Expand C/C++ macro (clangd)" })
  end,
})
