-- TUILBOA = [T]he [UI] [L]ib [B]ecause [O]f [A]nger

-- Shared element definitions (loaded once)
local sharedElements = {}
local ids = -1


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
    self.id = ids + 1
    self:removeAllActiveElements()
    ids = ids + 1
    return self
end

--- Create and register a new element instance
function tuilboa:newElement(name)
    local proto = self.elements[name:lower()]
    if not proto then return nil end

    -- call the constructor of the proto class, passing any args
    proto.handler = self
    local instance = proto:new()

    table.insert(self.activeElements, instance)

    instance.id = #self.activeElements

    return instance
end

--- Removes all active elements
function tuilboa:removeAllActiveElements()
    self.activeElements = {}
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

        if element.setEnabled then
            element:setEnabled(state)
        end
    end
end

function tuilboa:hitTest(mx, my, e)
    local gameMouseX, gameMouseY = PUSH:toGame(love.mouse.getX(), love.mouse.getY())

    mx = mx or gameMouseX
    my = my or gameMouseY

    local x, y = e:getAbsolutePosition()
    local w, h = e.w, e.h
    return mx >= x and mx <= x + w and
           my >= y and my <= y + h
end

function tuilboa:makeHitCheck(mx, my)
    local topElement
    local test = {}

    for i, e in ipairs(self.activeElements) do
        if e then
            local zCkeck = topElement and topElement.z or 0

            if self:hitTest(mx, my, e) and zCkeck < e.z and e:isVisible() and e:getEnabled() then
                topElement = e
            end 
        end
    end

    return topElement
end

function tuilboa:isGettingHoverd(mx, my, e)
    local topElement

    for i, e in ipairs(self.activeElements) do
        local zCkeck = topElement and topElement.z or 0

        if self:hitTest(mx, my, e) and zCkeck < e.z and e:isVisible() and e:getEnabled() then
            topElement = e
        end
    end

    local isParent = topElement and topElement.parent and topElement.parent.id == e.id 
    return topElement and topElement.id == e.id or isParent
end

--- UI Event Handlers
function tuilboa:update(dt)
    for _, e in ipairs(self.activeElements) do
        e:update(dt)
    end
end

function tuilboa:draw()
    for _, e in ipairs(self.activeElements) do if e.draw then e:postDraw() e:draw() e:pastDraw() end end
end

function tuilboa:mouseMove(x, y, dx, dy)
    x, y = x or 999999999, y or 999999999
    for _, e in ipairs(self.activeElements) do if e.mouseMove then e:mouseMove(x, y, dx, dy) end end
end

function tuilboa:mouseDown(x, y, button, isTouch)
    x, y = x or 999999999, y or 999999999

    local e = self:makeHitCheck(x, y)


    if e and e.mousepressed then 
        e:mousepressed(x, y, button, isTouch)
    end 
end

function tuilboa:mouseUp(x, y, button, isTouch)
    x, y = x or 999999999, y or 999999999
    for _, e in ipairs(self.activeElements) do if e.mousereleased then e:mousereleased(x, y, button, isTouch) end end
end

function tuilboa:wheelMove(x, y)
    for _, e in ipairs(self.activeElements) do if e.wheelMove then e:wheelMove(x, y) end end
end

function tuilboa:keyDown(key, scancode, isrepeat)
    for _, e in ipairs(self.activeElements) do if e.keypressed then e:keypressed(key, scancode, isrepeat) end end
end

function tuilboa:keyUp(key)
    for _, e in ipairs(self.activeElements) do if e.keyUp then e:keyUp(key) end end
end

function tuilboa:textInput(text)
    for _, e in ipairs(self.activeElements) do if e.textInput then e:textInput(text) end end
end

--- Return the class, NOT an instance
return tuilboa
