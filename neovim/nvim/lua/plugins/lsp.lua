-- LSP configuration
-- This file contains global LSP server configurations
-- For per-project configuration, use the LSP's native config files:
--   - Python: pyproject.toml, pyrightconfig.json, ruff.toml
--   - C/C++: compile_commands.json, .clangd, compile_flags.txt
--   - See documentation for more details

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable Pyright (using Pyrefly instead)
        pyright = false,

        asm_lsp = {},

        -- Bash LSP
        bashls = {},

        -- C/C++ LSP - Configured via lazyvim.plugins.extras.lang.clangd
        -- Uses compile_commands.json, .clangd, or compile_flags.txt for project config
        -- See LazyVim clangd extra for configuration

        -- Python type checker - Configure via pyproject.toml
        pyrefly = {
          settings = {
            pyrefly = {
              disableOrganizeImports = true, -- Let Ruff handle imports
            },
            python = {
              analysis = {
                typeCheckingMode = "standard",
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
          before_init = function(_, config)
            local path = config.root_dir
            -- Search for virtual environment in common locations
            local venv_paths = {
              path .. "/.venv",
              path .. "/venv",
              path .. "/.virtualenv",
            }

            for _, venv_path in ipairs(venv_paths) do
              local python_path = venv_path .. "/bin/python"
              if vim.fn.executable(python_path) == 1 then
                config.settings.python.pythonPath = python_path
                break
              end
            end
          end,
        },

        -- Python linter/formatter - Configure via pyproject.toml or ruff.toml
        ruff = {
          init_options = {
            settings = {
              args = {},
            },
          },
        },
      },
    },
  },
  -- Hyprlang LSP (custom setup via autocmd)
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- Check if hyprls exists before setting up autocmd
      local hyprls_path = vim.fn.expand("$HOME") .. "/go/bin/hyprls"
      local hyprls_exists = vim.fn.executable(hyprls_path) == 1

      if hyprls_exists then
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
          pattern = { "*.hl", "hypr*.conf" },
          callback = function()
            vim.lsp.start({
              name = "hyprlang",
              cmd = { hyprls_path },
              root_dir = vim.fn.getcwd(),
              silent = true,
            })
          end,
        })
      end
    end,
  },
}
