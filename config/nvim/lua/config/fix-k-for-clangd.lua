vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    if client and client.name == "clangd" then
      vim.schedule(function()
        -- Xoá keymap hiện tại của K
        pcall(vim.api.nvim_buf_del_keymap, bufnr, "n", "K")

        -- Gán lại nếu muốn
        vim.keymap.set("n", "K", "5kzz", {
          buffer = bufnr,
          desc = "Up 5 lines (override hover)",
        })
      end)
    end
  end,
})
