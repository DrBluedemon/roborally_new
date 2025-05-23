local Button = Element:extend()

function Button:new()
    local instance = self

    print("Test")

    -- Enabled by default
    instance.enabled = true

    -- Create a Label inside the Button for text display
    instance.font = "assets/font/Grand9K Pixel.ttf"
    instance.fontSize = 24
    instance.label = Ui_Handler:newElement("label", self.handler)
    instance.label:setText("Button")
    instance.label:setFont("assets/font/Grand9K Pixel.ttf")
    instance.label:setVisible(true)
    instance.label:setColor(Color(255, 0, 0, 255))
    instance.label:setFontSize(24)
    instance.label:setAlign("center")  -- Assuming your Label supports align
    instance.label:setPos(100, 0)

    instance:addChild(instance.label)

    -- Colors
    instance.bgColor = {0.2, 0.2, 0.8, 1}
    instance.hoverColor = {0.3, 0.3, 1, 1}
    instance.pressedColor = {0.1, 0.1, 0.6, 1}

    instance.textColor = {1, 1, 1, 1}
    instance.pressed = false

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
    self.bgColor = {r or 0.2, g or 0.2, b or 0.8, a or 1}
end

function Button:setHoverColor(r, g, b, a)
    self.hoverColor = {r or 0.3, g or 0.3, b or 1, a or 1}
end

function Button:setPressedColor(r, g, b, a)
    self.pressedColor = {r or 0.1, g or 0.1, b or 0.6, a or 1}
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
    if not self.visible or not self:isEnabled() then return end

    local x, y = self:getAbsolutePosition()

    local bg = self.bgColor
    if self.pressed then
        bg = self.pressedColor
    elseif self:isHovered() then
        bg = self.hoverColor
    end

    love.graphics.setColor(bg)
    love.graphics.rectangle("fill", x, y, self.w, self.h, 5, 5)

    -- Position label centered inside button
    self.label:draw()

    love.graphics.setColor(1, 1, 1, 1)
end

function Button:setPos(x, y)
    self.x = x
    self.y = y
end

function Button:mousepressed(mx, my, button, isTouch)
    if not self:isEnabled() then return end
    if button == 1 and self:isHovered(mx, my) then
        print("pressed")
        self.pressed = true
    end
end

function Button:mousereleased(mx, my, button, isTouch)
    if not self:isEnabled() then return end
    if button == 1 and self.pressed then
        print("release")
        self.pressed = false
        if self:isHovered(mx, my) then
            self:onClick(button)
        end
    end
end

return Button
