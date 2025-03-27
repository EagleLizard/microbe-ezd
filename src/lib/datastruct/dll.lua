
local printf = require "util.printf"

local DllNode = (function ()
  ---@class ezd.DllNode
  ---@field val any
  ---@field next ezd.DllNode|nil
  ---@field prev ezd.DllNode|nil
  local DllNode = {}
  DllNode.__index = DllNode
  function DllNode.new(val)
    local self = setmetatable({}, DllNode)
    self.val = val
    self.next = nil
    self.prev = nil
    return self
  end
  return DllNode
end)()

local Dll = (function ()
  ---@class ezd.Dll
  ---@field head ezd.DllNode|nil
  ---@field tail ezd.DllNode|nil
  local Dll = {}
  Dll.__index = Dll
  function Dll.new()
    local self = setmetatable({}, Dll)
    self.head = nil
    self.tail = nil
    return self
  end
  function Dll:pushBack(val)
    local nextNode = DllNode.new(val)
    if self.head == nil then
      -- printf("asdf")
      self.head = nextNode
    elseif self.tail == nil then
      self.tail = nextNode
      self.head.next = self.tail
      self.tail.prev = self.head
    else
      self.tail.next = nextNode
      self.tail.next.prev = self.tail
      self.tail = self.tail.next
    end
    -- printf("%s\n", nextNode)
    -- printf("\n", val)
    -- if self.head == nil then
    --   self.head = DllNode.new(val)
    --   -- self.tail = self.head
    -- elseif self.head == self.tail then
    --   self.tail = DllNode.new(val)
    --   self.head.next = self.tail
    --   self.tail.prev = self.head
    -- else
    --   self.tail.next = DllNode.new(val)
    --   self.tail.next.prev = self.tail
    --   self.tail = self.tail.next
    -- end
  end
  function Dll:pop()
    if self.head == nil then
      return nil
    end
    local res = nil
    if self.head == self.tail then
      --[[ unset both ]]
      res = self.tail
      self.head = nil
      self.tail = nil
    else
      res = self.tail
      self.tail = self.tail.prev
      self.tail.next = nil
    end
    if res ~= nil then
      res.prev = nil
    end
    return res.val
  end
  ---comment
  ---@param fn fun(val: any)
  function Dll:each(fn)
    -- printf("head: %s\n", self.head.val)
    local currNode = self.head
    while currNode ~= nil do
      fn(currNode.val)
      currNode = currNode.next
    end
  end
  return Dll
end)()

local dllModule = {
  Dll = Dll,
}

return dllModule
