-- ~/.config/nvim/lua/plugins/luasnip.lua
return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    version = "v2.*",
    build = (vim.fn.has("win32") == 0) and "echo 'NOTE: jsregexp is optional'; make install_jsregexp" or nil,

    dependencies = {
      -- Bộ snippet cộng đồng (VSCode format)
      {
        "rafamadriz/friendly-snippets",
        config = function()
          -- Load snippets VSCode + thư mục snippets cá nhân
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
          })
        end,
      },
    },

    opts = {
      history = true, -- cho phép jump về các node cũ
      update_events = "TextChanged,TextChangedI",
      delete_check_events = "TextChanged",
      enable_autosnippets = false, -- bật nếu thích autosnippet
      ext_opts = nil, -- có thể tuỳ biến highlight cho node ở đây
      region_check_events = "CursorMoved",
      ft_func = require("luasnip.extras.filetype_functions").from_cursor,
    },

    config = function(_, opts)
      local ls = require("luasnip")
      ls.config.set_config(opts)

      -- === KEYMAPS: Jump/Expand bằng Tab, lùi bằng S-Tab ===
      -- Ưu tiên khi đang ở trong snippet; nếu không thì fallback thành Tab thật.
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
          return ""
        end
        return "<Tab>"
      end, { expr = true, silent = true, desc = "LuaSnip expand/jump forward" })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
          return ""
        end
        return "<S-Tab>"
      end, { expr = true, silent = true, desc = "LuaSnip jump backward" })

      -- ChoiceNode: đổi lựa chọn (tuỳ thích)
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = "LuaSnip next choice" })

      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end, { silent = true, desc = "LuaSnip prev choice" })

      -- Thoát snippet hiện tại (khi đang kẹt placeholder cuối)
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if ls.in_snippet() then
          ls.unlink_current()
        end
      end, { silent = true, desc = "LuaSnip unlink current snippet" })

      -- === LOADERS (nếu muốn thêm kiểu Lua) ===
      -- require("luasnip.loaders.from_lua").lazy_load({
      --   paths = { vim.fn.stdpath("config") .. "/lua/snippets" }
      -- })

      -- Tạo autocommand reload snippets khi sửa file trong thư mục snippets cá nhân
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = {
          vim.fn.stdpath("config") .. "/snippets/*.json",
          vim.fn.stdpath("config") .. "/snippets/**/*.json",
        },
        callback = function()
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
          })
          vim.notify("Reloaded VSCode snippets", vim.log.levels.INFO)
        end,
      })
    end,
  },
}
