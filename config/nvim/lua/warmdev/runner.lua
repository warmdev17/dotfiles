local Terminal = require("toggleterm.terminal").Terminal

local M = {}

function M.run_current_file()
  local filename = vim.fn.expand("%")
  local basename = vim.fn.expand("%:r")
  local ext = vim.fn.expand("%:e")
  local cmd = ""

  if ext == "c" then
    cmd = "build " .. basename .. " -c"
  elseif ext == "cpp" then
    cmd = "build " .. basename .. " -p"
  elseif ext == "py" then
    cmd = "python " .. filename
  elseif ext == "js" then
    cmd = "node " .. filename
  elseif ext == "ts" then
    cmd = "ts-node " .. filename
  elseif ext == "java" then
    cmd = "javac " .. filename .. " && java " .. basename
  else
    vim.notify("❌ Không hỗ trợ file ." .. ext, vim.log.levels.WARN)
    return
  end

  local runner = Terminal:new({
    cmd = cmd,
    direction = "float",
    close_on_exit = false,
    hidden = true,
    shell = vim.o.shell,
  })

  runner:toggle()
end

return M
