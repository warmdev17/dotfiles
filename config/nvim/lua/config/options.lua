-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

vim.opt.termguicolors = true

-- after/plugin/diagnostic_undercurl.lua
vim.opt.termguicolors = true

local function set_undercurl()
  local set = vim.api.nvim_set_hl
  set(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#f38ba8" })
  set(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#f9e2af" })
  set(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#89b4fa" })
  set(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#94e2d5" })
end

set_undercurl()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_undercurl,
})

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  float = {
    border = "rounded",
    source = true,
  },
})
