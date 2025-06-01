local Button = Element:extend()

function Button:new()
    local instance = setmetatable({}, Button)

    -- Enabled by default
    instance.enabled = true

    -- Create a Label inside the Button for text display
    instance.font = "assets/font/Grand9K Pixel.ttf"
    instance.label = Ui_Handler:newElement("label", self.handler, instance)
    instance.label:setText("Button")
    instance.label:setFont("assets/font/Grand9K Pixel.ttf")
    instance.label:setVisible(true)
    instance.label:setColor(Color(255, 255, 255, 255))
    instance.label:setFontSize(20)
    instance.label:setSize(100, 100)
    instance.label:setAlign("center")  -- Assuming your Label supports align
    instance.label:setPos(100, 6)
    instance.label:setSize(100, 100)
    instance.label:setEnabled(true)
    instance.label:setParent(instance)

    -- Colors
    instance.bgColor = Color(74, 74, 74)
    instance.hoverColor = Color(92, 92, 92)
    instance.pressedColor = Color(120, 120, 120)

    instance.textColor = {1, 1, 1, 1}
    instance.pressed = false
    instance:setEnabled(true)

--    instance.onClick = function() end

    instance.visible = true

    return instance
end

function Button:setEnabled(state)
    self.enabled = state and true or false
    if self.label.setEnabled then
        self.label:setEnabled(state)
    else
        self.label.enabled = state
    end
end

function Button:isEnabled()
    return self.enabled ~= false
end

function Button:setText(text)
    self.label:setText(text)
end

function Button:setFont(font)
    self.label:setFont(font)
end

function Button:setTextColor(r, g, b, a)
    self.textColor = {r or 1, g or 1, b or 1, a or 1}
    self.label.textColor = self.textColor  -- Assuming Label uses this
end

function Button:setBgColor(r, g, b, a)
    self.bgColor = Color(r, g, b, a)
end

function Button:setHoverColor(r, g, b, a)
    self.hoverColor = Color(r, g, b, a)
end

function Button:setPressedColor(r, g, b, a)
    self.pressedColor = Color(r, g, b, a)
end

function Button:setOnClick(func)
    self.onClick = func or function() end
end

function Button:update(dt)
    if not self:isEnabled() then return end
    if self.label.update then
        self.label:update(dt)
    end
end

function Button:draw()
    if not self.visible then return end

    local x, y = self:getAbsolutePosition()

    local bg = self.bgColor
    if self.pressed then
        bg = self.pressedColor
    elseif self:isHovered() then
        bg = self.hoverColor
    end

    love.graphics.setColor(Color(30, 30, 30))
    love.graphics.rectangle("fill", x, y, self.w, self.h, 0)

    love.graphics.setColor(bg)
    love.graphics.rectangle("fill", x + 4, y + 4, self.w - 8, self.h - 8, 0)

    -- Position label centered inside button
    self.label:draw()

    love.graphics.setColor(1, 1, 1, 1)
end

function Button:setSize(w, h)
    self.w = w
    self.h = h
end

function Button:mousepressed(mx, my, button, isTouch)
    if not self:isEnabled() then return end
    if button == 1 and self:isHovered(mx, my) then
        self.pressed = true
    end
end

function Button:mousereleased(mx, my, button, isTouch)
    if not self:isEnabled() then return end
    if button == 1 and self.pressed then
        self.pressed = false
        if self:isHovered(mx, my) then
            self:onClick(button)
        end
    end
end

return Button
