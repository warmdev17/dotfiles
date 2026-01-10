return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  config = function()
    require("nvim-silicon").setup({
      font = "JetBrainsMono Nerd Font=34;Noto Color Emoji=34",
      theme = "/home/warmdev/.config/silicon/Catppuccin-Mocha.tmTheme",
      background = "#11111b",
      output = function()
        return os.getenv("HOME") .. "/Pictures/Code/silicon_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
      end,
      line_number = false,
      shadow_blur_radius = 0,
      shadow_color = nil,
      no_round_corner = true,
      window_title = "warmdev",
      num_separator = " ",
      to_clipboard = true,
    })
  end,
}
