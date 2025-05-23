-- TUILBOA = [T]he [UI] [L]ib [B]ecause [O]f [A]nger

-- Shared element definitions (loaded once)
local sharedElements = {}

-- Class table
local tuilboa = {}
tuilboa.__index = tuilboa

--- Static Init (loads all elements once)
function tuilboa.initElements()
    local files = love.filesystem.getDirectoryItems("libs/tuilboa/elements")

    for _, file in ipairs(files) do
        if file:match("%.lua$") then
            local elementName = file:gsub("%.lua$", "")
            local elementModule = require("libs.tuilboa.elements." .. elementName)

            print(elementModule)

            if getmetatable(elementModule) ~= Element then
                setmetatable(elementModule, { __index = Element })
            end

            sharedElements[elementName:lower()] = elementModule
        end
    end
end

--- Creates a new instance of tuilboa
function tuilboa.new()
    local self = setmetatable({}, tuilboa)
    self.elements = sharedElements
    self.activeElements = {}
    return self
end

--- Create and register a new element instance
function tuilboa:newElement(name)
    local proto = self.elements[name:lower()]
    if not proto then return nil end

    -- call the constructor of the proto class, passing any args
    proto.handler = self
    local instance = proto:new()

    instance.id = #self.activeElements + 1
    table.insert(self.activeElements, instance)
    return instance
end

--- Removes all active elements
function tuilboa:removeAllActiveElements()
    for i = #self.activeElements, 1, -1 do
        table.remove(self.activeElements, i)
    end
end

--- Removes a specific element
function tuilboa:removeElement(element)
    for i, other in ipairs(self.activeElements) do
        if other == element then
            table.remove(self.activeElements, i)
            break
        end
    end
end
--- Sets every child to be not Enbaled
function tuilboa:setChildrenEnabled(state)
    for _, element in ipairs(self.activeElements) do
        if element.children then
            for _, child in ipairs(element.children) do
                if child.setEnabled then
                    child:setEnabled(state)
                else
                    child.enabled = state
                end
            end
        end
    end
end


--- UI Event Handlers
function tuilboa:update(dt)
    for _, e in ipairs(self.activeElements) do if e.update then e:postUpdate(dt) e:update(dt) end end
end

function tuilboa:draw()
    for _, e in ipairs(self.activeElements) do if e.draw then e:draw() end end
end

function tuilboa:mouseMove(x, y, dx, dy)
    x, y = x or 999999999, y or 999999999
    for _, e in ipairs(self.activeElements) do if e.mouseMove then e:mouseMove(x, y, dx, dy) end end
end

function tuilboa:mouseDown(x, y, button, isTouch)
    x, y = x or 999999999, y or 999999999
    for _, e in ipairs(self.activeElements) do if e.mousepressed then e:mousepressed(x, y, button, isTouch) end end
end

function tuilboa:mouseUp(x, y, button, isTouch)
    x, y = x or 999999999, y or 999999999
    for _, e in ipairs(self.activeElements) do if e.mousereleased then e:mousereleased(x, y, button, isTouch) end end
end

function tuilboa:wheelMove(x, y)
    for _, e in ipairs(self.activeElements) do if e.wheelMove then e:wheelMove(x, y) end end
end

function tuilboa:keyDown(key, scancode, isrepeat)
    for _, e in ipairs(self.activeElements) do if e.keyDown then e:keyDown(key, scancode, isrepeat) end end
end

function tuilboa:keyUp(key)
    for _, e in ipairs(self.activeElements) do if e.keyUp then e:keyUp(key) end end
end

function tuilboa:textInput(text)
    for _, e in ipairs(self.activeElements) do if e.textInput then e:textInput(text) end end
end

--- Return the class, NOT an instance
return tuilboa
