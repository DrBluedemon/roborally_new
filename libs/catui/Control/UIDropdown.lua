local UIDropdown = UIControl:extend("UIDropdown", {
    isOpen = false,
    items = {},
    selectedIndex = 1,
    onChange = nil
})

function UIDropdown:init(container)
    UIControl.init(self)

    self.container = container

    self.button = Ui_Handler:newElement("button", self:getContainer())
    self.button:setSize(200, 40)
    self.button:setText("Select an option")
    self.button.events:on(UI_CLICK, function()
        self:toggle()
    end)

    self.dropdownButtons = {}
end

function UIDropdown:setItems(items)
    self.items = items
    -- If open, refresh options immediately
    if self.isOpen then
        self:removeOptionButtons()
        self:createOptionButtons()
    end
end

function UIDropdown:setSize(width, height)
    self.button:setSize(width, height)

    for _, btn in ipairs(self.dropdownButtons) do
        btn:setSize(width, height)
    end
end

function UIDropdown:createOptionButtons()
    if #self.dropdownButtons > 0 then return end -- already created

    local x, y = self.button:getX(), self.button:getY()
    local w, h = self.button:getWidth(), self.button:getHeight()

    for i, item in ipairs(self.items) do
        local btn = Ui_Handler:newElement("button", self:getContainer())
        btn:setSize(w, h)
        btn:setText(item)
        btn:setPos(x, y + i * h)
        btn.events:on(UI_CLICK, function()
            self:select(i)
        end)
        table.insert(self.dropdownButtons, btn)
    end
end

function UIDropdown:removeOptionButtons()
    for _, btn in ipairs(self.dropdownButtons) do
        local parent = btn:getParent()
        if parent and parent.removeChild then
            parent:removeChild(btn)
        end
    end
    self.dropdownButtons = {}
end


function UIDropdown:getContainer()
    return self.container
end

function UIDropdown:select(index)
    self.selectedIndex = index
    self.button:setText(self.items[index])
    self:toggle(false)
    if self.onChange then
        self.onChange(self.items[index], index)
    end
end

function UIDropdown:toggle(force)
    self.isOpen = force ~= nil and force or not self.isOpen

    if self.isOpen then
        self:createOptionButtons()
    else
        self:removeOptionButtons()
    end
end

function UIDropdown:setPos(x, y)
    self.button:setPos(x, y)
    -- reposition option buttons if open
    if self.isOpen then
        local w, h = self.button:getWidth(), self.button:getHeight()
        for i, btn in ipairs(self.dropdownButtons) do
            btn:setPos(x, y + i * h)
        end
    end
end

function UIDropdown:setText(text)
    self.button:setText(text)
end

function UIDropdown:setOnChange(callback)
    self.onChange = callback
end

return UIDropdown
