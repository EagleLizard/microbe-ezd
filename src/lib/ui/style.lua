
local defaultColor = {
  r = 1,
  g = 1,
  b = 1,
}

local function setDefault()
  love.graphics.setColor(defaultColor.r, defaultColor.g, defaultColor.b)
end

local style = {
  setDefault = setDefault,
}

return style
