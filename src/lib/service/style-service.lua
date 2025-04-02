
--[[ singleton, static ]]
local StyleService = (function ()
  ---@class ezd.lib.StyleService
  local StyleService = {}

  local defaultFont = love.graphics.getFont()

  function StyleService.getDefaultFont()
    return defaultFont
  end

  return StyleService
end)()

return StyleService
