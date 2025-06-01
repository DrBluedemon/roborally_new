local EditText = Element:extend()

EditText.text = ""
EditText.fontPath = "assets/font/Grand9K Pixel.ttf"
EditText.fontSize = 16
EditText.font = love.graphics.newFont(EditText.fontPath, EditText.fontSize)
EditText.textColor = {1, 1, 1, 1}
EditText.bgColor = {0.1, 0.1, 0.1, 1}
EditText.cursorColor = {1, 1, 1, 1}
EditText.caret = 0
EditText.focused = false
EditText.visible = true
EditText.drawable = love.graphics.newText(EditText.font, "")
EditText.blinkTimer = 0
EditText.blinkInterval = 0.5
EditText.blinkState = true
EditText.scrollOffsetX = 0
EditText.autoScroll = true




function EditText:new()
    local instance = setmetatable({}, EditText)
    instance.text = ""
    instance.fontPath = self.fontPath
    instance.fontSize = self.fontSize
    instance.font = love.graphics.newFont(instance.fontPath, instance.fontSize)
    instance.textColor = {1, 1, 1, 1}
    instance.bgColor = {0, 0, 0, 1}
    instance.cursorColor = {1, 1, 1, 1}
    instance.caret = 0
    instance.focused = false
    instance.visible = true
    instance.drawable = love.graphics.newText(instance.font, "")
    instance.blinkTimer = 0
    instance.blinkInterval = 0.5
    instance.blinkState = true
    instance.scrollOffsetX = 0
    instance.autoScroll = true
    instance:setEnabled(true)
    return instance
end

function EditText:ensureCaretVisible()
    local caretPixel = self.font:getWidth(self.text:sub(1, self.caret))
    local visibleWidth = self.w - 10 -- 5px padding on each side

    if caretPixel - self.scrollOffsetX > visibleWidth then
        self.scrollOffsetX = caretPixel - visibleWidth
    elseif caretPixel - self.scrollOffsetX < 0 then
        self.scrollOffsetX = caretPixel
    end
end

function EditText:setAutoScroll(state)
    self.autoScroll = state and true or false

    -- Optionally, trim text immediately if disabling auto-scroll
    if not self.autoScroll then
        local result = ""
        for i = 1, #self.text do
            local test = result .. self.text:sub(i, i)
            if self.font:getWidth(test) > self.w - 10 then
                break
            end
            result = test
        end
        self.text = result
        self.caret = #self.text
        self:updateDrawable()
        self.scrollOffsetX = 0
    end
end


-- Public setters
function EditText:setText(text)
    self.text = text or ""
    self.caret = #self.text
    self:updateDrawable()
end

function EditText:getText()
    return self.text
end

function EditText:setFont(fontPath)
    self.fontPath = fontPath
    self.font = love.graphics.newFont(fontPath, self.fontSize)
    self:updateDrawable()
end

function EditText:setFontSize(size)
    self.fontSize = size or 16
    self.font = love.graphics.newFont(self.fontPath, self.fontSize)
    self:updateDrawable()
end

function EditText:setFontColor(r)
    self.textColor = r
end

function EditText:setCursorColor(r)
    self.cursorColor = r
end

function EditText:setBgColor(r)
    self.bgColor = r
end

function EditText:updateDrawable()
    self.drawable = love.graphics.newText(self.font, self.text)
end

-- Mouse focus
function EditText:mousepressed(mx, my, button)
    if button == 1 and self:isHovered(mx, my) then
        print("YAY")
        self.focused = true
    else
        print("naw....")
        self.focused = false
    end
end

function EditText:textInput(t)
    if not self.focused then return end

    -- Predict the new text
    local newText = self.text:sub(1, self.caret) .. t .. self.text:sub(self.caret + 1)

    -- Check if it fits
    if not self.autoScroll then
        local predictedWidth = self.font:getWidth(newText)
        if predictedWidth > self.w - 10 then
            return -- Don't accept more characters if it exceeds box width
        end
    end

    -- Accept input
    self.text = newText
    self.caret = self.caret + #t
    self:updateDrawable()
    self:ensureCaretVisible()

    if self.onTextInput then
        self:onTextInput(self.text)
    end
end


function EditText:keypressed(key)
    if not self.focused then return end

    if key == "backspace" then
        if self.caret > 0 then
            self.text = self.text:sub(1, self.caret - 1) .. self.text:sub(self.caret + 1)
            self.caret = self.caret - 1
            self:updateDrawable()
        end
    elseif key == "delete" then
        if self.caret < #self.text then
            self.text = self.text:sub(1, self.caret) .. self.text:sub(self.caret + 2)
            self:updateDrawable()
        end
    elseif key == "left" then
        self.caret = math.max(0, self.caret - 1)
    elseif key == "right" then
        self.caret = math.min(#self.text, self.caret + 1)
    elseif key == "home" then
        self.caret = 0
    elseif key == "end" then
        self.caret = #self.text
    end
    self:ensureCaretVisible()
end


-- Cursor blinking
function EditText:update(dt)
    if not self.focused then return end
    self.blinkTimer = self.blinkTimer + dt
    if self.blinkTimer >= self.blinkInterval then
        self.blinkTimer = 0
        self.blinkState = not self.blinkState
    end
end

-- Draw function
function EditText:draw()
    if not self.visible then return end
    local x, y = self:getAbsolutePosition()

    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", x, y, self.w, self.h)

    local textX = x + 5
    local textY = y + (self.h - self.font:getHeight()) / 2

    love.graphics.setScissor(x, y, self.w, self.h)
    love.graphics.setColor(self.textColor)
    love.graphics.draw(self.drawable, textX - self.scrollOffsetX, textY)

    if self.focused and self.blinkState then
        local caretX = textX + self.font:getWidth(self.text:sub(1, self.caret)) - self.scrollOffsetX
        love.graphics.setColor(self.cursorColor)
        love.graphics.line(caretX, textY, caretX, textY + self.font:getHeight())
    end
    love.graphics.setScissor()
    love.graphics.setColor(1, 1, 1, 1)
end


return EditText
