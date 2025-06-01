--[[ THIS IS THE MAIN ELEMENT, DO CHANGES AT YOUR OWN COST!! ]]

Element = {}
Element.__index = Element

function Element:new(x, y, w, h)
    local e = setmetatable({}, self)
    e.x = x or 10
    e.y = y or 10
    e.z = 1
    e.w = w or 10
    e.h = h or 10
    e.enabled = false
    e.visible = true
    e.parent = nil
    return e
end

-- Drawing
function Element:postDraw()
    
end

function Element:pastDraw()
    
end

function Element:draw()
    if not self.visible then return end
    love.graphics.setColor(1, 1, 1, 1)
    local x, y = self:getAbsolutePosition()
    love.graphics.rectangle("line", x, y, self.w, self.h)
end

-- Update
function Element:update(dt)
    -- Override in child
end

-- Extra Update
function Element:postUpdate(dt)
    if self.parent then
        --self:setPos(self.x, self.y)
    end
end

-- Click logic
function Element:mousepressed(x, y, button)
    if self:isHovered(x, y) then
        self:onClick(button)
    end
end

function Element:onClick(button)
    print("Clicked Element. Override me!")
end

-- Hover check (uses absolute position)
function Element:isHovered(mx, my)
    local gameMouseX, gameMouseY = PUSH:toGame(love.mouse.getX(), love.mouse.getY())

    mx = mx or gameMouseX
    my = my or gameMouseY
    local x, y = self:getAbsolutePosition()
    return mx >= x 
    and mx <= x + self.w and
           my >= y and 
           my <= y + self.h and 
           self.handler:isGettingHoverd(mx, my, self)
end

-- Parenting
function Element:setParent(parent)
    self.parent = parent
    parent:addChild(self)
end

function Element:getAbsolutePosition()
    local x, y = self.x, self.y
    if self.parent then
        local px, py = self.parent.getAbsolutePosition
                        and self.parent:getAbsolutePosition() 
                        or self.parent.x, self.parent.y
        x = x + px
        y = y + py
    end
    return x, y
end

function Element:addChild(child)
    self.children = self.children or {}

    table.insert(self.children, child)
end

-- Setters
function Element:setX(x)
    self.x = x
end
function Element:setY(y) 
    self.y = y
end
function Element:setZ(z)
    self.z = z
    -- if not self.children then return end
    -- for _, c in ipairs(self.children) do
    --     c:setZ(z + 1)
    -- end
end

function Element:setPos(x, y)    
    self.x = x 
    self.y = y
end

function Element:setWidth(w) self.w = w end
function Element:setHeight(h) self.h = h end
function Element:setSize(w, h)
    self.w = w
    self.h = h
end

function Element:setVisible(state)
    self.visible = state
    if self.children then
        for i, child in ipairs(self.children) do
            child:setVisible(state)
        end 
    end
end

function Element:setEnabled(state)
    self.enabled = state
end

-- Getters
function Element:getX() return self.x end
function Element:getY() return self.y end
function Element:getZ() return self.z end
function Element:getWidth() return self.w end
function Element:getHeight() return self.h end
function Element:isVisible() return self.visible end
function Element:getParent() return self.parent end
function Element:getEnabled() return self.enabled end
function Element:isEnabled() return self.enabled end
function Element:getPos() return self.x, self.y end


-- Inheritance helper
function Element:extend()
    local cls = {}
    for k, v in pairs(self) do
        cls[k] = v
    end
    cls.__index = cls
    setmetatable(cls, self)
    return cls
end