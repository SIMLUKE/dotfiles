return {
  "saghen/blink.cmp",
  opts = {
    snippets = {
      preset = "luasnip",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
    },
    keymap = {
      preset = "default",
      ["<CR>"] = { "accept", "fallback" },
      ["<S-CR>"] = {
        function(cmp)
          local auto_brackets_enabled = cmp.config.completion.accept.auto_brackets.enabled
          -- Temporarily disable auto brackets
          cmp.config.completion.accept.auto_brackets.enabled = false
          cmp.accept()
          -- Re-enable auto brackets
          cmp.config.completion.accept.auto_brackets.enabled = auto_brackets_enabled
        end,
        "fallback",
      },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_forward()
          else
            return cmp.select_next()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_backward()
          else
            return cmp.select_prev()
          end
        end,
        "snippet_backward",
        "fallback",
      },
    },
  },
}
