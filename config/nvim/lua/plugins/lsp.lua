return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      emmet_language_server = {
        filetypes = {
          "css",
          "eruby",
          "html",
          "javascript",
          "javascriptreact",
          "less",
          "sass",
          "scss",
          "pug",
          "typescriptreact",
        },
      },
      ["*"] = {
        keys = {
          { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", has = "definition" },
          { "K", false },
        },
      },
    },
  },
}
