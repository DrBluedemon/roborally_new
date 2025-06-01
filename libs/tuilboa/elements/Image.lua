local Image = Element:extend()

function Image:new()
    local instance = setmetatable({}, Image)

    instance.img = nil
    instance.visible = true
    instance.enabled = true
    instance.pressed = false
    instance.onClick = function() end

    return instance
end

function Image:setImage(img)
    if type(img) == "string" then
        self.img = img
    else
        self.img = img
    end
end

function Image:setEnabled(state)
    self.enabled = state and true or false
end

function Image:isEnabled()
    return self.enabled ~= false
end

function Image:draw()
    if not self.visible then return end

    local drawImg
    if type(self.img) == "string" then
        drawImg = love.graphics.newImage("assets/img/" .. self.img)
    else
        drawImg = self.img
    end

    if drawImg then
        local imgW, imgH = drawImg:getDimensions()
        local scaleX = self.w / imgW
        local scaleY = self.h / imgH

        -- Draw the image
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(drawImg, self.x, self.y, 0, scaleX, scaleY)

        -- Draw hover outline
        if self:isHovered() then
            love.graphics.setColor(1, 1, 0, 1) -- yellow outline
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
        end
    end
end

function Image:mousepressed(mx, my, button, isTouch)
    if not self:isEnabled() then return end
    if button == 1 and self:isHovered(mx, my) then
        self.pressed = true
    end
end

function Image:mousereleased(mx, my, button, isTouch)
    if not self:isEnabled() then return end
    if button == 1 and self.pressed then
        self.pressed = false
        if self:isHovered(mx, my) then
            print("gfasdasdhgeawsdgaewg")
            self:onClick(button)
        end
    end
end

return Image
