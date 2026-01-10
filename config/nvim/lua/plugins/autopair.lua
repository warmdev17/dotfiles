return {

  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "L3MON4D3/LuaSnip",
  --     "saadparwaiz1/cmp_luasnip",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-path",
  --     "hrsh7th/cmp-nvim-lsp",
  --   },
  --   opts = function()
  --     local cmp = require("cmp")
  --     local luasnip = require("luasnip")
  --
  --     -- load friendly snippets nếu ní muốn (tuỳ chọn)
  --     -- require("luasnip.loaders.from_vscode").lazy_load()
  --
  --     return {
  --       preselect = cmp.PreselectMode.Item,
  --       completion = { completeopt = "menu,menuone,noinsert" },
  --       snippet = {
  --         expand = function(args)
  --           require("luasnip").lsp_expand(args.body)
  --         end,
  --       },
  --       mapping = {
  --         -- Tab: move suggestions > jump snippet > fallback
  --         ["<Tab>"] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             cmp.select_next_item()
  --           elseif luasnip.jumpable(1) then
  --             luasnip.jump(1)
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --
  --         -- Shift-Tab: move up suggestions > jump back in snippet > fallback
  --         ["<S-Tab>"] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             cmp.select_prev_item()
  --           elseif luasnip.jumpable(-1) then
  --             luasnip.jump(-1)
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --
  --         ["<CR>"] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             local entry = cmp.get_selected_entry()
  --             local item = entry and entry.completion_item or nil
  --             local label = item and (item.insertText or item.label) or ""
  --             local should_newline = label:match(":$") ~= nil
  --
  --             cmp.confirm({ select = true })
  --
  --             if should_newline then
  --               vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
  --             end
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --
  --         ["<C-e>"] = cmp.mapping.abort(),
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --       },
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" },
  --         { name = "luasnip" },
  --         { name = "path" },
  --         { name = "buffer" },
  --       }),
  --       formatting = {
  --         format = function(entry, vim_item)
  --           return vim_item
  --         end,
  --       },
  --       experimental = {
  --         ghost_text = true,
  --       },
  --     }
  --   end,
  --   config = function(_, opts)
  --     local cmp = require("cmp")
  --     cmp.setup(opts)
  --
  --     local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
  --     if ok then
  --       cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  --     end
  --   end,
  -- },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      enable_check_bracket_line = false,
      disable_in_macro = true,
      disable_in_visualblock = false,
      fast_wrap = {},
      map_cr = true,
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)

      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      npairs.add_rules({
        Rule("{", "}")
          :with_pair(function()
            return true
          end)
          :with_move(function()
            return true
          end)
          :with_cr(function()
            return true
          end)
          :set_end_pair_length(1),
      }, { "css", "scss", "less" })
    end,
  },

  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
}
