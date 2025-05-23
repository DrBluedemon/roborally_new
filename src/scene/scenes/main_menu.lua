local main_scene = {
    uiComponent = TULIBOA.new()
}
function main_scene:onLoad()

    self.uiComponent:removeAllActiveElements()

    self.button = Ui_Handler:newElement("button", self.uiComponent)
    self.button:setPos(100, 100)
    self.button:setSize(200, 50)
    self.button:setText("UwU")

    print("Loaded")
end

function main_scene:update(dt)
    self.uiComponent:update(dt)

    self.button:setX(self.button:getX() + 1)
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