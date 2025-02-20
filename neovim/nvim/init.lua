require("config.lazy")
require("workspaces").setup()
require("colorizer").setup()

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    c = { "clang-format", "clang-format", stop_after_first = true },
  },
})

require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

local eslint = require("eslint")
eslint.setup({
  bin = "eslint",
  code_actions = {
    enable = true,
    apply_on_save = {
      enable = true,
      types = { "directive", "problem", "suggestion", "layout" },
    },
    disable_rule_comment = {
      enable = true,
      location = "separate_line",
    },
  },
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = "type",
  },
})

require("typescript-tools").setup({
  on_attach = function() end,
  handlers = { ... },
  settings = {
    separate_diagnostic_server = true,
    publish_diagnostic_on = "insert_leave",
    expose_as_code_action = {},
    tsserver_plugins = { "@styled/typescript-styled-plugin" },
    tsserver_max_memory = "auto",
    tsserver_format_options = {},
    tsserver_file_preferences = {},
    tsserver_locale = "en",
    complete_function_calls = false,
    include_completions_with_insert_text = true,
    code_lens = "off",
    disable_member_code_lens = true,
    jsx_close_tag = {
      enable = false,
      filetypes = { "javascriptreact", "typescriptreact" },
    },
  },
})

require("scrollEOF").setup({
  pattern = "*",
  insert_mode = false,
  floating = false,
  disabled_filetypes = {},
  disabled_modes = {},
})

require("mini.surround").setup({})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  modules = {},
  sync_install = false,

  auto_install = true,

  ignore_install = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

require("neo-tree").setup({
  event_handlers = {
    {
      event = "file_open_requested",
      handler = function()
        require("neo-tree.command").execute({ action = "close" })
      end,
    },
  },
})

vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_scale_factor = 0.8

-- LSP
require("lspconfig").asm_lsp.setup({})
-- Hyprlang LSP
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function(event)
    vim.lsp.start({
      name = "hyprlang",
      cmd = { vim.fn.expand("$HOME") .. "/go/bin/hyprls" },
      root_dir = vim.fn.getcwd(),
      silent = true,
    })
  end,
})

require("lspconfig").bashls.setup({})

local nvim_lsp = require("lspconfig")
require("lspconfig").hls.setup({
  root_dir = nvim_lsp.util.root_pattern(".git"),
})

require("lspconfig").clangd.setup({
  root_dir = nvim_lsp.util.root_pattern(".git", "compile_flags.txt"),
})

require("lspconfig").pyright.setup({
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        ignore = { "*" },
      },
    },
  },
})

require("lspconfig").ruff.setup({
  init_options = {
    settings = {
      args = {},
    },
  },
})
