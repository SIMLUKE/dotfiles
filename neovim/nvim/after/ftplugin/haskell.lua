-- ~/.config/nvim/after/ftplugin/haskell.lua
local ht = require("haskell-tools")
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr }

-- LSP: haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
vim.keymap.set("n", "<space>cl", vim.lsp.codelens.run, opts)

-- Hoogle search for the type signature of the definition under the cursor
vim.keymap.set("n", "<space>hs", ht.hoogle.hoogle_signature, opts)

-- Evaluate all code snippets
vim.keymap.set("n", "<space>ea", ht.lsp.buf_eval_all, opts)

-- Toggle a GHCi repl for the current package
vim.keymap.set("n", "<leader>rr", ht.repl.toggle, opts)

-- Toggle a GHCi repl for the current buffer
vim.keymap.set("n", "<leader>rf", function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, opts)

-- Quit GHCi repl
vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts)

local wk = require("which-key")
wk.add({
  { "<leader>ca", desc = "evaluate all" },
  { "<leader>h", group = "haskell-tools" },
  { "<leader>hr", desc = "GHCi repl for package" },
  { "<leader>hf", desc = "GHCi repl for file" },
  { "<leader>hs", desc = "search signature", mode = "n" },
})
