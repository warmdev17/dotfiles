return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<c-t>]],
      direction = "float",
      float_opts = { border = "curved", winblend = 0 },
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
    },
  },
}
