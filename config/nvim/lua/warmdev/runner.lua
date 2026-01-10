local Terminal = require("toggleterm.terminal").Terminal

local M = {}

local function shellescape(s)
  return vim.fn.shellescape(s)
end

-- Detect Java package and return the fully-qualified class name
local function get_java_fqcn(java_file)
  local lines = vim.fn.readfile(java_file, "", 200)
  local pkg = nil
  for _, line in ipairs(lines) do
    local m = line:match("^%s*package%s+([%w_%.]+)%s*;")
    if m then
      pkg = m
      break
    end
  end
  local classname = vim.fn.fnamemodify(java_file, ":t:r")
  if pkg and #pkg > 0 then
    return pkg .. "." .. classname
  end
  return classname
end

function M.run_current_file()
  local file = vim.fn.expand("%:p") -- đường dẫn tuyệt đối
  local name = vim.fn.expand("%:p:r") -- bỏ đuôi
  local ext = vim.fn.expand("%:e")
  local cwd = vim.fn.fnamemodify(file, ":h")

  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return
  end

  local cmd = ""

  if ext == "c" then
    cmd = "build -c " .. shellescape(name)
  elseif ext == "cpp" then
    cmd = "build -p " .. shellescape(name)
  elseif ext == "py" then
    cmd = "python " .. shellescape(file)
  elseif ext == "js" then
    cmd = "node " .. shellescape(file)
  elseif ext == "ts" then
    cmd = "ts-node " .. shellescape(file)
  elseif ext == "java" then
    -- Compile all Java files in the same directory and run the main class
    local fqcn = get_java_fqcn(file)
    cmd = string.format("javac %s/*.java && java -cp %s %s", shellescape(cwd), shellescape(cwd), shellescape(fqcn))
  else
    vim.notify("Unsupported file type: ." .. ext, vim.log.levels.WARN)
    return
  end

  local runner = Terminal:new({
    cmd = cmd,
    dir = cwd,
    direction = "float",
    close_on_exit = false,
    hidden = true,
    shell = vim.o.shell,
  })

  vim.notify("Running command: " .. cmd, vim.log.levels.INFO)
  runner:toggle()
end

return M
