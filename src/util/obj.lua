
---shallow assign from source object to dest object.
---Mutates and returns the destObj.
---@generic T
---@param destObj T
---@param ... table
---@return T
local function assign(destObj, ...)
  local srcObjs = { ... }
  for _, srcObj in ipairs(srcObjs) do
    if srcObj ~= nil then
      for k,v in pairs(srcObj) do
        destObj[k] = v
      end
    end
  end
  return destObj
end

local objModule = {
  assign = assign,
}

return objModule
