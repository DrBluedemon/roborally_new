local main_scene = {
    uiComponent = TULIBOA.new()
}
function main_scene:onLoad()
    self.mapCreation = Ui_Handler:newElement("button", self.uiComponent, self)
    self.mapCreation:setPos(20, 500)
    self.mapCreation:setSize(200, 50)
    self.mapCreation:setText("Mapeditor")
    self.mapCreation.onClick = function()
        Scene_Manager:SetNewScene("map_creation", "right_to_left")
    end
end

function main_scene:update(dt)
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