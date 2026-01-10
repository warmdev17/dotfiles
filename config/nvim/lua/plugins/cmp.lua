return {
  {
    "saghen/blink.cmp",
    init = function()
      pcall(vim.keymap.del, { "i", "s" }, "<Tab>")
      pcall(vim.keymap.del, { "i", "s" }, "<S-Tab>")
    end,
    opts = {
      snippets = { preset = "luasnip" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      keymap = {
        preset = "none",

        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "snippet_forward", "fallback" },
        ["<C-p>"] = { "snippet_backward", "fallback" },

        ["<CR>"] = { "accept", "fallback" },
      },
    },
  },
}
