local Dropdown = Element:extend()

function Dropdown:new()
    local instance = setmetatable({}, Dropdown)

    instance.visible = true
    instance.enabled = true
    instance.expanded = false
    instance.options = {}
    instance.selectedIndex = 1
    instance.onSelect = function(index, value) end

    instance.w = 150
    instance.h = 50
    instance.optionHeight = 50
    instance.x = 0
    instance.y = 0

    -- Main button
    instance.button = Ui_Handler:newElement("button", instance.handler, instance)
    instance.button:setText("Select")
    instance.button:setSize(instance.w, instance.h)
    instance.button.onClick = function()
        instance.expanded = not instance.expanded
        if #instance.options > 0 then
            for _, btn in ipairs(instance.optionButtons) do
                btn:setVisible(instance.expanded)
                print(btn:isVisible())
            end 
        end
    end

    instance.optionButtons = {}

    return instance
end

function Dropdown:setOptions(options)
    self.options = options
    self.selectedIndex = 1
    -- self.button:setText(options[1] or "Select")

    -- Remove old option buttons
    for _, btn in ipairs(self.optionButtons) do
        btn:setVisible(false)
    end
    self.optionButtons = {}

    -- Create and position new buttons
    for i, value in ipairs(options) do
        local btn = Ui_Handler:newElement("button", self.handler, self)
        btn:setText(value)
        btn:setPos(self.x, self.y + self.h + (i - 1) * self.optionHeight)
        btn:setSize(self.w, self.optionHeight)
        btn.onClick = function()
            self.selectedIndex = i
            self.button:setText(value)
            self.expanded = false
            self.onSelect(value, i)
        end
        btn:setVisible(false)
        table.insert(self.optionButtons, btn)
    end
end

function Dropdown:setText(text)
    self.button:setText(text)
end

function Dropdown:setSize(w, h)
    self.w = w
    self.h = h
    self.button:setSize(w, h)

    for i, btn in ipairs(self.optionButtons) do
        btn:setSize(w, self.optionHeight)
    end
end

function Dropdown:setPos(x, y)
    self.x = x
    self.y = y
    self.button:setPos(x, y)
    local gasfdgasgdf, yASDG = self.button:getAbsolutePosition()

    for i, btn in ipairs(self.optionButtons) do
        btn:setPos(self.x, self.y + self.h + (i - 1) * self.optionHeight)
    end
end

function Dropdown:setOnSelect(func)
    self.onSelect = func or function() end
end

function Dropdown:update(dt)
    self.button:update(dt)

    for _, btn in ipairs(self.optionButtons) do
        btn:setVisible(self.expanded)
        btn:update(dt)
    end
end

function Dropdown:setZ(z)
    self.z = -150
end

function Dropdown:setVisible(state)
    self.vibible = state
    
    self.button:setVisible(state)
end

function Dropdown:draw()
    if not self.visible then return end

    self.button:draw()

    if self.expanded then
        for _, btn in ipairs(self.optionButtons) do
            btn:draw()
        end
    end
end

return Dropdown
