return {
  {
    "smjonas/inc-rename.nvim",
    opts = {},
  },
  {
    "yousefakbar/notmuch.nvim",
    opts = {
      notmuch_db_path = "/home/warmdev/Documents/Mail",
      maildir_sync_cmd = "mbsync personal",
      keymaps = {
        sendmail = "<C-g><C-g>",
      },
    },
  },
  {
    "fredrikaverpil/godoc.nvim",
    version = "*",
    dependencies = {
      { "nvim-telescope/telescope.nvim" }, -- optional
      { "folke/snacks.nvim" }, -- optional
      { "nvim-mini/mini.pick" }, -- optional
      { "ibhagwan/fzf-lua" }, -- optional
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          ensure_installed = { "go" },
        },
      },
    },
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
    cmd = { "GoDoc" }, -- optional
    opts = {}, -- see further down below for configuration
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
  -- {
  --   "mattn/emmet-vim",
  --   init = function()
  --     vim.g.user_emmet_complete_tag = 0
  --     vim.g.user_emmet_complete_full_tag = 0
  --     -- vim.g.user_emmet_install_global = 0
  --     vim.g.user_emmet_leader_key = "<C-y>" -- Phím tắt kích hoạt
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = { "html", "css", "javascriptreact" },
  --       command = "EmmetInstall",
  --     })
  --   end,
  -- },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   main = "ibl",
  --   opts = function(_, opts)
  --     -- Other blankline configuration here
  --     return require("indent-rainbowline").make_opts(opts, {
  --       -- How transparent should the rainbow colors be. 1 is completely opaque, 0 is invisible. 0.07 by default
  --       color_transparency = 0.15,
  --       -- Catppuccin Mocha colors
  --       colors = { 0xf38ba8, 0xa6e3a1, 0x74c7ec },
  --     })
  --   end,
  --   dependencies = {
  --     "TheGLander/indent-rainbowline.nvim",
  --   },
  -- },
  {
    "uga-rosa/ccc.nvim",
  },
}
