
--[[ 
  superclass for entities
]]
local Entity = (function ()
  ---@class ezd.Entity
  ---@field id integer
  local Entity = {}
  Entity.__index = Entity

  local entityIdCounter = 0
  local function getEntityId()
    local id = entityIdCounter
    entityIdCounter = entityIdCounter + 1
    return id
  end

  function Entity.new()
    local self = setmetatable({}, Entity)
    self.id = getEntityId()
    return self
  end

  return Entity
end)()

return Entity
