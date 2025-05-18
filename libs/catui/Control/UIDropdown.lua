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
    self:updateOptions()
end

function UIDropdown:setSize(width, height)
    self.button:setSize(width, height)

    for i, btn in ipairs(self.dropdownButtons) do
        btn:setSize(width, height)
    end
end

function UIDropdown:updateOptions()
    -- Clear old buttons
    for _, btn in ipairs(self.dropdownButtons) do
        btn:remove()
    end
    self.dropdownButtons = {}

    for i, item in ipairs(self.items) do
        local btn = Ui_Handler:newElement("button", self:getContainer())
        btn:setSize(200, 40)
        btn:setText(item)
        btn:setPos(self.button:getX(), self.button:getY() + i * 40)
        btn:setVisible(false)
        btn.events:on(UI_CLICK, function()
            self:select(i)
        end)
        table.insert(self.dropdownButtons, btn)
    end
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
    for _, btn in ipairs(self.dropdownButtons) do
        btn:setVisible(self.isOpen)
    end
end

function UIDropdown:setPos(x, y)
    self.button:setPos(x, y)
    for i, btn in ipairs(self.dropdownButtons) do
        btn:setPos(x, y + i * 40)
    end
end

function UIDropdown:setText(text)
    self.button:setText(text)
end

function UIDropdown:setSize(w, h)
    self.button:setSize(w, h)
    for _, btn in ipairs(self.dropdownButtons) do
        btn:setSize(w, h)
    end
end

function UIDropdown:setOnChange(callback)
    self.onChange = callback
end

return UIDropdown
