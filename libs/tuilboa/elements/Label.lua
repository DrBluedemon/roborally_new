local Label = Element:extend()

function Label:new()
    local instance = setmetatable({}, Label)

    instance.text = ""
    instance.fontPath = "assets/font/Grand9K Pixel.ttf"
    instance.fontSize = 16
    instance.lineHeight = 1.0
    instance.font = love.graphics.newFont(instance.fontPath, instance.fontSize)
    instance.color = {1, 1, 1, 1}
    instance.align = "left"
    instance.isBold = false
    instance.visible = true
    instance.drawable = love.graphics.newText(instance.font, instance.text)
    instance.w = instance.drawable:getWidth()
    instance.h = instance.drawable:getHeight()

    return instance
end

function Label:update(dt)
end

-- Set the label text and update drawable
function Label:setText(text)
    self.text = text or ""
    self.drawable = love.graphics.newText(self.font, self.text)
    self.w = self.drawable:getWidth()
    self.h = self.drawable:getHeight()
end

-- Set font size and recreate font and drawable
function Label:setFontSize(size)
    self.fontSize = size or 16
    self.font = love.graphics.newFont(self.fontPath, self.fontSize)
    self.font:setLineHeight(self.lineHeight)
    self.drawable = love.graphics.newText(self.font, self.text)
end

-- Set line height and update font + drawable
function Label:setLineHeight(height)
    self.lineHeight = height or 1.0
    if self.font then
        self.font:setLineHeight(self.lineHeight)
        self.drawable = love.graphics.newText(self.font, self.text)
    end
end

-- Set the font
function Label:setFont(font)
    self.font = love.graphics.newFont(font)
    self.drawable = love.graphics.newText(self.font, self.text)
end

function Label:setAlign(align)
    if align == "left" or align == "center" or align == "right" then
        self.align = align
    end
end

-- Enable or disable bold drawing
function Label:setBold(isBold)
    self.isBold = isBold
end

function Label:mousepressed(x, y, button)
    if self.parent and self:getEnabled() then
        self.parent:mousepressed(x, y, button)
    end
end

-- Set color
function Label:setColor(r, g, b, a)
    self.color = {r or 1, g or 1, b or 1, a or 1}
end

-- Draw label with alignment and optional bold
function Label:draw()
    if not self.visible or not self.drawable then return end

    local x, y = self:getAbsolutePosition()
    local r, g, b, a = unpack(self.color)

    -- Alignment adjustment
    local offsetX = 0
    local w = self.drawable:getWidth()

    if self.align == "center" then
        offsetX = -w / 2
    elseif self.align == "right" then
        offsetX = -w
    end

    -- Bold offset drawing
    if self.isBold then
        local offsets = {
            {1, 0}, {-1, 0}, {0, 1}, {0, -1}
        }

        for _, offset in ipairs(offsets) do
            love.graphics.setColor(r, g, b, a)
            love.graphics.draw(self.drawable, x + offsetX + offset[1], y + offset[2])
        end
    end

    love.graphics.setColor(r, g, b, a)
    love.graphics.draw(self.drawable, x + offsetX, y)

    love.graphics.setColor(1, 1, 1, 1)
end

--- Getters
function Label:getText() return self.text end
function Label:getFont() return self.font end


return Label
