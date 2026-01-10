return {
  {
    "catppuccin/nvim",
    opts = function(_, opts)
      local ok, module = pcall(require, "catppuccin.special.bufferline")
      if ok and module and module.get_theme then
        module.get = module.get_theme
      end
      return opts
    end,
  },
}
