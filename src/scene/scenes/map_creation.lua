local map_creation = {
    uiComponent = UIManager:new()
}
local MapConstructor = require("src.map.MapConstructor")


-- [ Main Functions ] ---
function map_creation:onLoad()
end

function map_creation:onSetupUi()
    self:UIMapSetup()
end

function map_creation:update(dt)
    self.uiComponent:update(dt)
end

function map_creation:draw(layerName)
    if layerName == "ui" then
        love.graphics.setColor(0.188, 0.188, 0.188)
        love.graphics.rectangle("fill", _GgameWidth * 0.8, 0, _GgameWidth * 0.2, _GgameHeight)
        self.uiComponent:draw()
    end
end

-- [ Extra UI Stuff] ----

function map_creation:UIMapSetup()
    self.dropdown = Ui_Handler:newElement("dropdown", self.uiComponent:getControlContainer())
    self.dropdown:setItems({"8x8", "12x12", "14x14"})
    self.dropdown:setText("Welche Größe?")
    self.dropdown:setPos(_GgameWidth * 0.82, 200)
    self.dropdown:setSize(250, 50)
    self.dropdown:setOnChange(function(value, index)
        print("Selected:", value)
    end)
end

return map_creation
