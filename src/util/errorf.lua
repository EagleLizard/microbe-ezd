
---panics with message
---@param s string
---@param ... any
---@return nil
local function errorf(s, ...)
  return error(string.format(s, ...))
end

return errorf
