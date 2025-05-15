local main_scene = {
    uiComponent = UIManager:new()
}

function main_scene:onLoad()

    local button = Ui_Handler:newElement("button", self.uiComponent:getControlContainer())
    button:setPos(100, 100)
    button:setSize(200, 50)
    button:setIcon("assets/img/icon_haha.png")
    button:setText("Dies ist ein Test")
    button.events:on(UI_CLICK, function()
        Scene_Manager:SetNewScene("map_creation", "test_rectangle")
    end)

    print("Loaded")
end

function main_scene:update(dt)
    self.uiComponent:update(dt)
end

function main_scene:draw(layerName)
    if layerName == "background" then
        love.graphics.rectangle("fill", 0, 0, _GgameWidth, _GgameHeight)
    end

    if layerName == "ui" then
        self.uiComponent:draw()
    end
end

return main_scene