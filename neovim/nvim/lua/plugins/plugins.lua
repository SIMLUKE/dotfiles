return {
  -- Core dependencies
  { "nvim-lua/plenary.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "notomo/promise.nvim" },
  { "lewis6991/async.nvim" },

  -- Merge conflict resolution (VSCode-style: accept current/incoming/both)
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPre",
    opts = {
      default_mappings = false,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
    keys = {
      { "<leader>gco", "<cmd>GitConflictChooseOurs<cr>",   desc = "Conflict: Accept Current (ours)" },
      { "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Conflict: Accept Incoming (theirs)" },
      { "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>",   desc = "Conflict: Accept Both" },
      { "<leader>gcn", "<cmd>GitConflictChooseNone<cr>",   desc = "Conflict: Accept None" },
      { "]x",          "<cmd>GitConflictNextConflict<cr>",  desc = "Conflict: Next" },
      { "[x",          "<cmd>GitConflictPrevConflict<cr>",  desc = "Conflict: Prev" },
      { "<leader>gcl", "<cmd>GitConflictListQf<cr>",        desc = "Conflict: List all" },
    },
  },

  -- Git integration
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "ibhagwan/fzf-lua", -- optional
    },
    config = true,
  },

  -- UI enhancements
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      latex = { enabled = false },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  { "kevinhwang91/nvim-ufo" },

  -- Additional utilities
  { "lg-epitech/headers.nvim" },

  -- Mason (LSP installer)
  { "mason-org/mason.nvim" },
  { "mason-org/mason-lspconfig.nvim" },
}
