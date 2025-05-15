local map_creation = {
    uiComponent = UIManager:new()
}
local MapConstructor = require("src.map.MapConstructor")

function map_creation:onLoad()

    local button = Ui_Handler:newElement("button", self.uiComponent:getControlContainer())
    button:setPos(100, 100)
    button:setSize(200, 50)
    button:setIcon("assets/img/icon_haha.png")
    button:setText("Du Lusche")
    button.events:on(UI_CLICK, function()
        Scene_Manager:SetNewScene("main_menu", "test_rectangle")
    end)

    print(LASER_SHOOT_ONE)

    self.map = MapConstructor:newMap("test", 8, 8)
    self.map:addTile(LASER_SHOOT_ONE, 0, 2, 2, 3)
    self.map:addTile(HOLE, 0, 0, 5, 7)
    self.map:addTile(HOLE, 0, 0, 3, 1)
    self.map:addTile(HOLE, 0, 0, 1, 8)
    self.map:generateMapImage()

    print("Loaded 2")
end

function map_creation:update(dt)
    self.uiComponent:update(dt)
end

function map_creation:draw(layerName)
    if layerName == "background" then
--         love.graphics.setColor(255, 0, 0)
--        love.graphics.rectangle("fill", 0,0, _GgameWidth, _GgameHeight)
    end

    if layerName == "game_1" then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(self.map:getMapImage(), CAM.x * 100, CAM.y * 100)
    end

    if layerName == "ui" then
        self.uiComponent:draw()
    end
end

return map_creation