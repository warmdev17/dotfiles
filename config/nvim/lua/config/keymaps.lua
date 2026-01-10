-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local maps = vim.keymap
local opts = { noremap = true, silent = true }

-- increament/decreament
maps.set("n", "+", "<C-a>")
maps.set("n", "-", "<C-x>")

-- delete a word backward
maps.set("n", "dw", "vb_d")

-- select all
maps.set("n", "<C-a>", "gg<S-v>G")

-- jumplist
maps.set("n", "<C-m>", "<C-i>", opts)

maps.set("n", "te", "tabedit", opts)

-- buffer
maps.set("n", "<Tab>", ":bnext<CR>", opts)
maps.set("n", "<S-Tab>", ":bprevious<CR>", opts)
maps.set("n", "<leader>bb", ":buffers<CR>", opts) -- liệt kê buffer
maps.set("n", "bd", ":bdelete<CR>", opts) -- đóng buffer hiện tại
maps.set("n", "<leader>bD", ":%bdelete<CR>", opts) -- đóng tất cả buffer
maps.set("n", "<leader>ba", ":buffer #<CR>", opts)

-- split
maps.set("n", "ss", ":split<CR>", opts)
maps.set("n", "sv", ":vsplit<CR>", opts)

maps.set("n", "<C-d>", function()
  vim.diagnostic.jump({ count = 1 })
end, opts)

-- movement
-- maps.set({ "n", "v" }, "j", "jzz", opts)
-- maps.set({ "n", "v" }, "k", "kzz", opts)
maps.set({ "n", "v" }, "J", "5j", opts)
maps.set({ "n", "v" }, "K", "5k", opts)
maps.set({ "n", "v" }, "H", "5h", opts)
maps.set({ "n", "v" }, "L", "5l", opts)

maps.set("n", "M", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

-- x without yank
maps.set({ "n", "v" }, "x", '"_x', opts)

-- deleteline
maps.set("n", "<leader>d", "dd", { desc = "Delete line" })

-- quick esc
maps.set("i", "jj", "<ESC>", opts)

-- vim.keymap.set("n", "<leader>r", function()
--   require("warmdev.runner").run_current_file()
-- end, { desc = "Compile or Run Current File", noremap = true, silent = true })

vim.keymap.set("n", "<leader>ut", function()
  if vim.b.completion == false then
    vim.b.completion = nil
    vim.notify("Blink: completion enabled")
  else
    vim.b.completion = false
    vim.notify("Blink: completion disabled")
  end
end, { desc = "Toggle blink completion (buffer)" })

maps.set("n", "<leader>rn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Incremental rename" })
