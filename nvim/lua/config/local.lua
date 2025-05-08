local M = {
  settings = {},
}

function M.load()
  local status, mod = pcall(require, 'config.local_settings')
  if status and mod then
    M.settings = mod
  end
end

return M
