return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = true,
    opts = {
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      auto_integrations = true,
      integrations = { bufferline = true },
      transparent_background = true,
      float = {
        transparent = true,
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      if (vim.g.colors_name or ""):find("catppuccin") then
        local ok, catpp_buf = pcall(require, "catppuccin.special.bufferline")
        if ok and catpp_buf and catpp_buf.get_theme then
          opts.highlights = catpp_buf.get_theme()
        end
      end
      return opts
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.config.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = {
            {
              filetype_names = {
                TelescopePrompt = "Telescope",
                dashboard = "Dashboard",
                packer = "Packer",
                fzf = "FZF",
                alpha = "Alpha",
              },
              "mode",
              icon_only = false,
              fmt = function(str)
                local m = vim.api.nvim_get_mode().mode
                local icons = {
                  n = "", -- Normal
                  i = "", -- Insert
                  v = "󰈈", -- Visual (char)
                  V = "󰈈", -- Visual Line
                  ["\22"] = "󰈈", -- Visual Block (Control-V)
                  c = "", -- Command-line
                  R = "󰑖", -- Replace
                  t = "", -- Terminal
                }
                local names = {
                  n = "NORMAL",
                  i = "INSERT",
                  v = "VISUAL",
                  V = "V-LINE",
                  ["\22"] = "V-BLOCK",
                  c = "CMD",
                  R = "REPLACE",
                  t = "Terminal",
                }
                local icon = icons[m] or ""
                local name = names[m] or str
                return icon .. " " .. name
              end,
              separator = "",
            },
          },
          lualine_b = { "branch" },

          lualine_c = {
            "filename",
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_x = {
            Snacks.profiler.status(),
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = function()
                return { fg = Snacks.util.color("Statement") }
              end,
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = function()
                return { fg = Snacks.util.color("Constant") }
              end,
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = function()
                return { fg = Snacks.util.color("Debug") }
              end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function()
                return { fg = Snacks.util.color("Special") }
              end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            { "fileformat" },
            { "filetype", icon_only = true },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 1 } },
          },
          lualine_z = {
            { "location", padding = { left = 1, right = 1 } },
          },
        },
        extensions = { "neo-tree", "lazy", "fzf" },
      }

      if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end

      return opts
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    opts = { diagnostics = { virtual_text = false } },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[

██╗    ██╗ █████╗ ██████╗ ███╗   ███╗██████╗ ███████╗██╗   ██╗
██║    ██║██╔══██╗██╔══██╗████╗ ████║██╔══██╗██╔════╝██║   ██║
██║ █╗ ██║███████║██████╔╝██╔████╔██║██║  ██║█████╗  ██║   ██║
██║███╗██║██╔══██║██╔══██╗██║╚██╔╝██║██║  ██║██╔══╝  ╚██╗ ██╔╝
╚███╔███╔╝██║  ██║██║  ██║██║ ╚═╝ ██║██████╔╝███████╗ ╚████╔╝ 
 ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝ ╚══════╝  ╚═══╝  
          ]],
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        hidden = true,
      },
      picker = {
        sources = {
          files = {
            hidden = true,
          },
        },
      },
    },
  },
  {
    "karb94/neoscroll.nvim",
    opts = {},
  },
}
