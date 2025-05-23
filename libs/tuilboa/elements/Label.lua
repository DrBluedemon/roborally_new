local Label = Element:extend()

-- Defaults
Label.text = ""
Label.fontPath = "assets/font/Grand9K Pixel.ttf"
Label.fontSize = 16
Label.lineHeight = 1.0
Label.font = love.graphics.newFont(Label.fontPath, Label.fontSize)
Label.color = {1, 1, 1, 1}
Label.align = "left"
Label.isBold = false
Label.visible = true
Label.drawable = love.graphics.newText(Label.font, Label.text)

-- Set the label text and update drawable
function Label:setText(text)
    self.text = text or ""
    self.drawable = love.graphics.newText(self.font, self.text)
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

return Label
