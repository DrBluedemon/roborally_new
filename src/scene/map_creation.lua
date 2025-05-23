local map_creation = {
    uiComponent = TULIBOA.new(),
    uiElements= {},
    uiGroup = "setup",
    mapSelected = false,
    selectedTile = SELECTION_BOX,
    selectedTileType = 0,
}
local MapConstructor = require("src.map.MapConstructor")


-- [ Main Functions ] ---
function map_creation:onLoad()
end

function map_creation:onSetupUi()
    local button = Ui_Handler:newElement("button", self.uiComponent:getControlContainer())
    button:setPos(0, 0)
    button:setSize(200, 50)
    button:setText("Zurück")
    button.events:on(UI_CLICK, function()
        Scene_Manager:SetNewScene("main_menu", "test_rectangle")
    end)

    self:UIMapSetup()
end

function map_creation:update(dt)
    self.uiComponent:update(dt)
    FLUX.update(dt)
end

function map_creation:getMouseGridPosition()
    local size = self.map:getMapData().width
    local mouseX, mouseY = PUSH:toGame(love.mouse.getPosition())
    size = 8 / size

    mouseX = mouseX - 100
    mouseY = mouseY - 100

    mouseX = math.floor(mouseX / (100 * size ))
    mouseY = math.floor(mouseY / (100 * size ))

    mouseX = math.max(math.min(mouseX, self.map:getMapData().width - 1), 0)
    mouseY = math.max(math.min(mouseY, self.map:getMapData().width - 1), 0)

    return mouseX, mouseY
end

function map_creation:draw(layerName)
    if layerName == "game_1" and self.mapSelected == true then
        local mapData = self.map:getMapData()
        local size = mapData.width
        local mouseX, mouseY = self:getMouseGridPosition()
        local cursorTile = TILE_MANAGER:GetTile(self.selectedTile, self.selectedTileType).img

        size = 8 / size

        local tileX = (100 + ((100 * mouseX) * size))
        local tileY = (100 + ((100 * mouseY) * size))


        love.graphics.draw(cursorTile, tileX, tileY, 0, size, size)
    end

    if layerName == "game_2" and self.map then
        local mapData = self.map:getMapData()
        local size = mapData.width

        size = 8 / size

        local x, y = PUSH:toGame(100, 100)
        x = x * size
        y = y * size

        love.graphics.draw(self.map:getMapImage(), 100, 100, 0, size, size)
    end

    if layerName == "ui" then
        love.graphics.setColor(0.188, 0.188, 0.188)
        love.graphics.rectangle("fill", _GgameWidth * 0.8, 0, _GgameWidth * 0.2, _GgameHeight)
        self.uiComponent:draw()
    end
end

-- [ Extra UI Stuff] ----

function map_creation:UIMapSetup()
    local map_creation = self
    self.setup = {}
    local mapName = ""
    local mapSize = 0

    self.errorLabel = Ui_Handler:newElement("label", self.uiComponent:getControlContainer())
    self.errorLabel:setFontColor(Color(255, 0, 0, 255))
    self.errorLabel:setFontSize(24)
    self.errorLabel:setPos(_GgameWidth * 0.82, 100)

    self.errorLabel.events:on(UI_UPDATE, function(dt)
        local text = self.errorLabel:getText()
        local font = self.errorLabel:getFont()

        if text ~= "" and not self.transitionStart then
            self.transitionTime = 0
            self.transitionStart = true
            self.textWidth = font:getWidth(text)

            -- Start off-screen below
            self.errorLabel:setPos((_GgameWidth * 0.5) - (self.textWidth / 2), _GgameHeight * 1.2)
        end

        if self.transitionStart then
            self.transitionTime = self.transitionTime + dt

            local showY = _GgameHeight * 0.93
            local hideY = _GgameHeight * 1.2
            local x = (_GgameWidth * 0.5) - (self.textWidth / 2)

            -- Slide in (0 - 0.5s)
            if self.transitionTime <= 2 then
                local t = self.transitionTime / 2
                local y = hideY - (hideY - showY) * t
                self.errorLabel:setPos(x, y)

            -- Stay (0.5s - 2.0s)
            elseif self.transitionTime <= 10.0 then
                self.errorLabel:setPos(x, showY)

            -- Slide out (2.0s - 2.5s)
            elseif self.transitionTime <= 12 then
                local t = (self.transitionTime - 10)
                local y = showY + (hideY - showY) * t
                self.errorLabel:setPos(x, y)

            -- Done
            else
                self.transitionStart = false
                self.errorLabel:setText(nil) -- Optionally hide text after
            end
        end
    end)

    self.setup.mapFinish = Ui_Handler:newElement("button", self.uiComponent:getControlContainer())
    self.setup.mapFinish:setPos(_GgameWidth * 0.82, 480)
    self.setup.mapFinish:setSize(250, 40)
    self.setup.mapFinish:setText("Speichern")
    self.setup.mapFinish.events:on(UI_CLICK, function()
        if mapName ~= "" then
            if mapSize ~= 0 then

                if type(mapName) == "table" then
                    table.concat(mapName, "_")
                else
                    string.gsub(mapName, " ", "_")
                end

                map_creation.map = MapConstructor:newMap(mapName, mapSize, mapSize)
                map_creation.map:generateMapImage()
                self.errorLabel:setText("")     
                self.mapSelected = true
                self:switchUIGroup("test")

            else
                self.errorLabel:setText("Wähle eine größe der Map")
            end
        else
            self.errorLabel:setText("Gib einen Namen für die Map ein")
        end
    end)



    self.setup.mapNameLabel = Ui_Handler:newElement("label", self.uiComponent:getControlContainer())
    self.setup.mapNameLabel:setFont(PIXEL_TEXT_FONT)
    self.setup.mapNameLabel:setFontSize(24)
    self.setup.mapNameLabel:setFontColor({255, 255, 255, 255})
    self.setup.mapNameLabel:setText("Map Name?")
    self.setup.mapNameLabel:setBold(false)
    self.setup.mapNameLabel:setPos(_GgameWidth * 0.82, 180)

    self.setup.mapNameEditText = Ui_Handler:newElement("edittext", self.uiComponent:getControlContainer())
    self.setup.mapNameEditText:setSize(250, 40)
    self.setup.mapNameEditText:setFont(PIXEL_TEXT_FONT)
    self.setup.mapNameEditText:setBackgroundColor(Color(0, 0, 0, 255))
    self.setup.mapNameEditText:setCursorColor(Color(255, 255, 255, 255))
    self.setup.mapNameEditText:setFontColor(Color(255, 255, 255, 255))
    self.setup.mapNameEditText:setFontSize(20)
    self.setup.mapNameEditText:setPos(_GgameWidth * 0.82, 220)
    self.setup.mapNameEditText.onTextInput = function()
        mapName = self.setup.mapNameEditText:getText() 
    end

    --
    self.setup.mapSizeLabel = Ui_Handler:newElement("label", self.uiComponent:getControlContainer())
    self.setup.mapSizeLabel:setFont(PIXEL_TEXT_FONT)
    self.setup.mapSizeLabel:setFontSize(24)
    self.setup.mapSizeLabel:setFontColor({255, 255, 255, 255})
    self.setup.mapSizeLabel:setText("Wie groß?")
    self.setup.mapSizeLabel:setBold(false)
    self.setup.mapSizeLabel:setPos(_GgameWidth * 0.82, 280)

    self.setup.mapSizeDropdown = Ui_Handler:newElement("dropdown", self.uiComponent:getControlContainer())
    self.setup.mapSizeDropdown:setItems({"8x8", "12x12", "14x14"})
    self.setup.mapSizeDropdown:setText("?")
    self.setup.mapSizeDropdown:setPos(_GgameWidth * 0.82, 320)
    self.setup.mapSizeDropdown:setSize(250, 50)
    self.setup.mapSizeDropdown:setOnChange(function(value, index)
        mapSize = tonumber(value:match("^(.-)x"))
    end)

    self:addUIElementToGroup("setup", self.setup)
end

function map_creation:tileSelection()
    self.test.test = Ui_Handler:newElement("label", self.uiComponent:getControlContainer())
    self.test.test:setFontColor(Color(255, 0, 0, 255))
    self.test.test:setFontSize(24)
    self.test.test:setPos(_GgameWidth * 0.82, 100)
    self.test.test:setText("Gay")

    self:addUIElementToGroup("test", self.test)
end

function map_creation:addUIElementToGroup(group, element)
    if self.uiElements[group] == nil then
        self.uiElements[group] = {}
    end

    table.insert(self.uiElements[group], element)
end

function map_creation:switchUIGroup(newGroup)
    local current_group = self.uiGroup

    if self.uiElements[current_group] then
        for _, element in pairs(self.uiElements[current_group]) do
            local x, y = element:getPos()
            FLUX.to(element, 0.5, { y = -500 }):ease("backin")
                :onupdate(function(obj)
                    element:setPos(x, obj._y)
                end)
        end
    end

    if self.uiElements[newGroup] then
        for _, element in pairs(self.uiElements[newGroup]) do
            local x, targetY = element:getPos()
            element:setPos(x, element._y)

            FLUX.to(element, 0.5, { _y = targetY }):ease("backout")
                :onupdate(function(obj)
                    element:setPos(x, obj._y)
                end)
        end
    end

    self.uiGroup = newGroup
end

return map_creation
