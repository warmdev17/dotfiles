return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "luacheck",
        "shellcheck",
        "typescript-language-server",
        "tailwindcss-language-server",
        "css-lsp",
        "clangd",
        "emmet-language-server",
        "clang-format",
        "google-java-format",
        "arduino-language-server",
        -- "java-language-server",
        -- "jdtls",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "K", false }
    end,
    opts = {
      require("lspconfig").arduino_language_server.setup({}),
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }

          -- wrap existing on_attach if any
          local original_on_attach = opts.on_attach
          opts.on_attach = function(client, bufnr)
            -- call original if exists
            if original_on_attach then
              original_on_attach(client, bufnr)
            end
          end

          return false -- prevent LazyVim from doing default setup
        end,
      },
    },
  },
}
