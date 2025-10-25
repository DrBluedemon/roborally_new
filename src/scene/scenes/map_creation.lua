local map_creation = {
    uiComponent = TULIBOA.new(),
    uiElements= {},
    uiGroup = "setup",
    mapSelected = false,
    selectedTile = SELECTION_BOX,
    selectedTileType = 0,
    tileRotation = 0,
}
local MapConstructor = require("src.map.MapConstructor")
local wallType = { 
                [WALL] = true, 
                [WALL_CORNER] = true, 
                [PUSHER_WALL] = true}
local laserType = {[LASER_SHOOT_ONE] = true,
                [LASER_SHOOT_TWO] = true}
local checkPoint = {
    [CHECKPOINTS] = true
}


-- [ Main Functions ] ---
function map_creation:onLoad()
end

function map_creation:keypressed(key, scancode, isrepeat)
    if key == "q" then
        self.tileRotation = (self.tileRotation - 1) % 4
    elseif key == "e" then
        self.tileRotation = (self.tileRotation + 1) % 4
    end
end

function map_creation:mousepressed(x, y, button, isTouch)
    if button == 1 then
        self.pressedPlace = true
    end

    if button == 2 then
        self.pressedRemove = true
    end
end

function map_creation:mousereleased(x, y, button, isTouch)
    if button == 1 and self.pressedPlace then
        self.pressedPlace = false
        self:placeTile()
    end

    if button == 2 and self.pressedRemove then
        self.pressedRemove = false
        print("yay")
        self:removeTile()
    end
end

function map_creation:removeTile()
    if not self.map then return end
    if not self.mapSelected then return end
    
    local tileX, tileY = self:getMouseGridPosition()

    if tileX > self.map:getMapData().width then return end

    tileX = math.max(math.min(tileX, self.map:getMapData().width - 1), 0)
    tileY = math.max(math.min(tileY, self.map:getMapData().height - 1), 0)
    
    self.map:removeTile(tileX + 1, tileY + 1)

    self.map:generateMapImage()
end

function map_creation:placeTile()
    if self.selectedTile == SELECTION_BOX then return end
    if not self.map then return end
    if not self.mapSelected then return end
    
    local tileX, tileY = self:getMouseGridPosition()

    if tileX > self.map:getMapData().width then return end

    tileX = math.max(math.min(tileX, self.map:getMapData().width - 1), 0)
    tileY = math.max(math.min(tileY, self.map:getMapData().height - 1), 0)

    local layer = nil
    if wallType[self.selectedTile] then
        layer = "wall"
    elseif laserType[self.selectedTile] then
        layer = "laser"
    elseif checkPoint[self.selectedTile] then
        layer = "checkPoint"
    end

    self.map:addTile(self.selectedTile, 
                    self.selectedTileType, 
                    self.tileRotation,
                    tileX + 1,
                    tileY + 1,
                    layer)

    self.map:generateMapImage()
end

function map_creation:onSetupUi()
    self.button = Ui_Handler:newElement("button", self.uiComponent, self)
    self.button:setPos(0, 0)
    self.button:setSize(200, 50)
    self.button:setText("Zurück")
    self.button.onClick = function()
        Scene_Manager:SetNewScene("main_menu", "right_to_left")
    end

    self:UIMapSetup()
end

function map_creation:update(dt)
    FLUX.update(dt)
end

function map_creation:getMouseGridPosition()
    local size = self.map:getMapData().height
    local mouseX, mouseY = PUSH:toGame(love.mouse.getPosition())
    if not mouseX then mouseX = 9999999999 end
    if not mouseY then mouseY = 9999999999 end

    size = 8 / size

    mouseX = mouseX - 100
    mouseY = mouseY - 100

    mouseX = math.floor(mouseX / (100 * size ))
    mouseY = math.floor(mouseY / (100 * size ))

    return mouseX, mouseY
end

function map_creation:loadImportetMap(mapData)
    if not self.map then 
        self.map = MapConstructor:newMap("test", 12, 12)
    end

    self.selectedTile = SELECTION_BOX
    self.selectedTileType = 0
    self.mapSelected = true
    self.map:loadMapData(mapData)
    self.map:generateMapImage()

    self:tileSelectionAll()
    self:switchUIGroup("tile_selection")
end

function map_creation:draw(layerName)
    if layerName == "game_1" and self.mapSelected == true then
        local mapData = self.map:getMapData()
        local size = mapData.height
        local mouseX, mouseY = self:getMouseGridPosition()
        local cursorTile = TILE_MANAGER:GetTile(self.selectedTile, self.selectedTileType).img
        local rotation = (self.tileRotation * 90) * math.pi / 180
        size = 8 / mapData.height

        mouseX = math.max(math.min(mouseX, self.map:getMapData().width - 1), 0)
        mouseY = math.max(math.min(mouseY, self.map:getMapData().height - 1), 0)

        local tileX = (100 + ((100 * mouseX) * size))
        local tileY = (100 + ((100 * mouseY) * size))

        -- Assuming the tile is 100x100 px
        local tileSize = 100
        local originOffset = tileSize / 2

        love.graphics.draw(
            cursorTile,
            tileX + originOffset * size, -- shift position to center
            tileY + originOffset * size,
            rotation,
            size,
            size,
            originOffset,
            originOffset
        )
    end


    if layerName == "game_2" and self.map then
        local mapData = self.map:getMapData()
        local sizeW = mapData.width
        local sizeH = mapData.height

        local size = 8 / sizeH

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

function map_creation:UIMapSetup(hide)
    local map_creation = self
    self.setup = {}
    local mapName = ""
    local mapSizeW = 0
    local mapSizeH = 0

    self.errorLabel = Ui_Handler:newElement("label", self.uiComponent)
    self.errorLabel:setColor(Color(255, 0, 0, 255))
    self.errorLabel:setFontSize(24)
    self.errorLabel:setPos(_GgameWidth * 0.82, 100)
    self.errorLabel.waitTime = 1.5
    self.errorLabel.update = function(self, dt)
        local text = self:getText()
        local font = self:getFont()

        if text ~= "" and not self.transitionStart then
            self.transitionStart = true
            self.textWidth = font:getWidth(text)

            local x = (_GgameWidth * 0.5) - (self.textWidth / 2)
            local hideY = _GgameHeight * 1.2
            local showY = _GgameHeight * 0.93

            -- Start below screen
            self:setPos(x, hideY)

            -- Slide in (0.5s), wait (1.5s), slide out (0.5s)
            FLUX.to(self, 0.5, { y = showY })  -- `_y` is a dummy field we define below
                :onstart(function() self.y = hideY end)
                :onupdate(function()
                    self:setPos(x, self.y)
                end)
                :after(self, self.waitTime, {})  -- Wait
                :after(self, 0.5, { y = hideY })
                :onupdate(function()
                    self:setPos(x, self.y)
                end)
                :oncomplete(function()
                    self.transitionStart = false
                    self:setText(nil)
                end)
        end

        self:setColor(Color(255, 0, 0, 255))
        self.waitTime = 1.5
    end

    self.mapPathButton = Ui_Handler:newElement("button", self.uiComponent)
    self.mapPathButton:setPos(_GgameWidth * 0.82, 700)
    self.mapPathButton:setSize(250, 40)
    self.mapPathButton:setText("Map Ordner")
    self.mapPathButton.onClick = function()
        love.system.setClipboardText(love.filesystem.getSaveDirectory() .. "/maps/")

        self.errorLabel:setColor(Color(255, 255, 255, 255))
        self.errorLabel:setText("Pfad wurde Kopiert")
    end


    self.setup.mapFinish = Ui_Handler:newElement("button", self.uiComponent)
    self.setup.mapFinish:setPos(_GgameWidth * 0.82, 480)
    self.setup.mapFinish:setSize(250, 40)
    self.setup.mapFinish:setText("Generieren")
    self.setup.mapFinish.onClick = function()
        if mapName ~= "" then
            if mapSizeW ~= 0 then

                if type(mapName) == "table" then
                    table.concat(mapName, "_")
                else
                    string.gsub(mapName, " ", "_")
                end

                map_creation.map = MapConstructor:newMap(mapName, mapSizeH, mapSizeW)
                map_creation.map:generateMapImage()
                self.errorLabel:setText("")     
                self.mapSelected = true
                self:tileSelectionAll()
                self:switchUIGroup("tile_selection")

            else
                self.errorLabel:setText("Wähle eine größe der Map")
            end
        else
            self.errorLabel:setText("Gib einen Namen für die Map ein")
        end
    end



    self.setup.mapNameLabel = Ui_Handler:newElement("label", self.uiComponent)
    self.setup.mapNameLabel:setFont(PIXEL_TEXT_FONT)
    self.setup.mapNameLabel:setFontSize(24)
    self.setup.mapNameLabel:setColor({255, 255, 255, 255})
    self.setup.mapNameLabel:setText("Map Name?")
    self.setup.mapNameLabel:setBold(false)
    self.setup.mapNameLabel:setPos(_GgameWidth * 0.82, 180)

    self.setup.mapNameEditText = Ui_Handler:newElement("edittext", self.uiComponent)
    self.setup.mapNameEditText:setSize(250, 40)
    self.setup.mapNameEditText:setFont(PIXEL_TEXT_FONT)
    self.setup.mapNameEditText:setBgColor(Color(0, 0, 0, 255))
    self.setup.mapNameEditText:setCursorColor(Color(255, 255, 255, 255))
    self.setup.mapNameEditText:setFontColor(Color(255, 255, 255, 255))
    self.setup.mapNameEditText:setFontSize(20)
    self.setup.mapNameEditText:setPos(_GgameWidth * 0.82, 220)
    self.setup.mapNameEditText.onTextInput = function()
        mapName = self.setup.mapNameEditText:getText() 
    end

    --
    self.setup.mapSizeLabel = Ui_Handler:newElement("label", self.uiComponent)
    self.setup.mapSizeLabel:setFont(PIXEL_TEXT_FONT)
    self.setup.mapSizeLabel:setFontSize(24)
    self.setup.mapSizeLabel:setColor({255, 255, 255, 255})
    self.setup.mapSizeLabel:setText("Wie groß?")
    self.setup.mapSizeLabel:setBold(false)
    self.setup.mapSizeLabel:setPos(_GgameWidth * 0.82, 280)

    self.setup.mapSizeDropdown = Ui_Handler:newElement("dropdown", self.uiComponent)
    self.setup.mapSizeDropdown:setOptions({"8x8", "12x12", "14x14", "8x4", "12x4", "14x4"})
    self.setup.mapSizeDropdown:setText("?")
    self.setup.mapSizeDropdown:setPos(_GgameWidth * 0.82, 320)
    self.setup.mapSizeDropdown:setSize(250, 50)
    self.setup.mapSizeDropdown:setOnSelect(function(value, index)
        mapSizeW = tonumber(value:match("^(%d+)x"))
        mapSizeH = tonumber(value:match("x(%d+)$"))
    end)

    for i, c in ipairs(self.uiComponent.activeElements) do
        local value = c and c.label and c.label.parent.id or 0
    end

    self:addUIElementToGroup("setup", self.setup, not hide)
end

function map_creation:tileSelectionAll()
    local map_creation = self
    local searchingTiles = TILE_TYPES

    self.tileSelectionButtons = {}
    local index = 0
    local skipTileIDs = {
        [VOID] = true,
        [PUSHER_HANDLE] = true,
        [PUSHER_HEAD] = true,
        [PUSHER_WALL] = true,
        [WHEN_TRIGGERS] = true,
        [SELECTION_BOX] = true,
        [LASER_BEAM_ONE_CROSS] = true,
        [LASER_BEAM_ONE] = true,
        [LASER_BEAM_TWO] = true,
        [LASER_BEAM_TWO_CROSS] = true
    }

    self.tileSelectionButtons.saveButton = Ui_Handler:newElement("button", self.uiComponent, self)
    self.tileSelectionButtons.saveButton:setPos(_GgameWidth * 0.82, 650)
    self.tileSelectionButtons.saveButton:setSize(200, 50)
    self.tileSelectionButtons.saveButton:setText("Speichern")
    self.tileSelectionButtons.saveButton.onClick = function()
        print(UTILS:TableToString(self.map:getMapData(), 5))

        local savePath = MAP_MANGER:saveMap(self.map:getMapData())
        self.map:generateMapImage()

        self.errorLabel.waitTime = 3
        self.errorLabel:setColor(Color(255, 255, 255, 255))
        self.errorLabel:setText(savePath)
    end

    self.tileSelectionButtons.backButton = Ui_Handler:newElement("button", self.uiComponent)
    self.tileSelectionButtons.backButton:setText("<")
    self.tileSelectionButtons.backButton:setPos(_GgameWidth * 0.82, 70)
    self.tileSelectionButtons.backButton:setSize(230, 50)
    self.tileSelectionButtons.backButton.onClick = function()
        map_creation.mapSelected = false
        map_creation.map = nil
        map_creation:UIMapSetup(true)
        map_creation:switchUIGroup("setup")
    end

    if tileID then
        local tiles = TILE_TYPES[tileID]
        searchingTiles = tiles
    end

    for i, ids in ipairs(searchingTiles) do
        if skipTileIDs[i] then goto continue end

        local img
        if type(ids) == "table" then
            local tileData = TILE_MANAGER:GetTile(i, 1)
            img = tileData.img
        else
            local tileData = nil
            if not tileID then
                local tileID = tileID or i
                tileData = TILE_MANAGER:GetTile(tileID, ids)
            else
                tileData = TILE_MANAGER:GetTiles()[ids]
            end
            img = tileData.img
        end

        local imgButton = Ui_Handler:newElement("image", self.uiComponent)
        imgButton.choices = ids
        imgButton.tileID = i
        imgButton:setImage(img)
        imgButton:setPos(_GgameWidth * 0.82 + (80 * (index % 3)), 130 + (80 * math.floor(index / 3)))
        imgButton:setSize(70, 70)

        imgButton.onClick = function()
            if type(imgButton.choices) == "table" then
                -- Multiple tile types → open type selection
                map_creation:tileSelectionTileID(imgButton.tileID)
                map_creation:switchUIGroup("tile_selection_tileid")
            else
                -- Only one tile type → select it directly
                self.selectedTile = imgButton.tileID
                self.selectedTileType = imgButton.choices
                self.tileRotation = 0
            end
        end

        self.tileSelectionButtons[index] = imgButton

        index = index + 1

        ::continue::
    end

    self:addUIElementToGroup("tile_selection", self.tileSelectionButtons)
end

function map_creation:tileSelectionTileID(tileID)
    local map_creation = self
    local searchingTiles = TILE_TYPES

    self.tileSelectionButtons = {}
    local index = 1

    self.tileSelectionButtons.backButton = Ui_Handler:newElement("button", self.uiComponent)
    self.tileSelectionButtons.backButton:setText("<")
    self.tileSelectionButtons.backButton:setPos(_GgameWidth * 0.82, 70)
    self.tileSelectionButtons.backButton:setSize(230, 50)
    self.tileSelectionButtons.backButton.onClick = function()
        map_creation:tileSelectionAll()
        map_creation:switchUIGroup("tile_selection")
        map_creation.selectedTile = SELECTION_BOX
        map_creation.selectedTileType = 0
    end

    if tileID then
        local tiles = TILE_TYPES[tileID]
        searchingTiles = tiles
    end

    for i, ids in ipairs(searchingTiles) do
        local img
        if type(ids) == "table" then
            local tileData = TILE_MANAGER:GetTile(i, 1)
            img = tileData.img
        else
            local tileData = nil
            if not tileID then
                local tileID = tileID or i
                tileData = TILE_MANAGER:GetTile(tileID, ids)
            else
                tileData = TILE_MANAGER:GetTiles()[ids]
            end
            img = tileData.img
        end

        local imgButton = Ui_Handler:newElement("image", self.uiComponent)
        imgButton.choices = i
        imgButton.tileID = tileID
        imgButton:setImage(img)
        imgButton:setPos(_GgameWidth * 0.82 + (80 * ((index - 1) % 3)), 150 + (80 * math.floor((index - 1) / 3)))
        imgButton:setSize(70, 70)

        imgButton.onClick = function()
            if type(imgButton.choices) == "table" then
                -- Multiple tile types → open type selection
                map_creation:tileSelection(imgButton.tileID)
                map_creation:switchUIGroup("tile_selection")
            else
                -- Only one tile type → select it directly
                map_creation.selectedTile = imgButton.tileID
                map_creation.selectedTileType = imgButton.choices
                map_creation.tileRotation = 0
                for i, button in ipairs(map_creation.tileSelectionButtons) do
                    button.selected = false
                    print(i)
                end
                imgButton.selected = true
            end
        end

        imgButton.pastDraw = function()
            if not imgButton.selected then return end
            love.graphics.setColor(1, 1, 0, 1) -- yellow outline
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", imgButton.x, imgButton.y, imgButton.w, imgButton.h)
        end

        self.tileSelectionButtons[index] = imgButton

        index = index + 1

        ::continue::
    end

    self:addUIElementToGroup("tile_selection_tileid", self.tileSelectionButtons)
end

function map_creation:addUIElementToGroup(group, elementOrTable, showOnLoad)
    showOnLoad = showOnLoad or false
    -- Initialize group table
    if not self.uiElements[group] then
        self.uiElements[group] = {}
    end

    -- Helper to add single UI element
    local function add(elem)
        if elem and type(elem.getPos) == "function" then
            elem:setVisible(showOnLoad)
            table.insert(self.uiElements[group], elem)
        else
            print("[UI WARNING] Tried to add non-UI element to group:", group)
        end
    end

    -- Add either single element or all from table
    if type(elementOrTable) == "table" then
        for _, subElem in pairs(elementOrTable) do
            add(subElem)
        end
    else
        add(elementOrTable)
    end
end

function map_creation:switchUIGroup(newGroup)
    local currentGroup = self.uiGroup
    local total = 0
    local completed = 0

    -- Animate out current group
    if self.uiElements[currentGroup] then
        local elements = self.uiElements[currentGroup]
        total = #elements

        for _, element in ipairs(elements) do
            local x, y = element:getPos()
            element._y = y -- store original y

            FLUX.to(element, 1, { _y = -500 }):ease("backin")
                :onupdate(function()
                    element:setPos(x, element._y)
                end)
                :oncomplete(function()
                    completed = completed + 1

                    if completed == total then
                        -- After a 1-second delay, animate in new group
                        FLUX.to({}, 1, {}):oncomplete(function()
                            if self.uiElements[newGroup] then
                                for _, newElement in ipairs(self.uiElements[newGroup]) do
                                    local x2, targetY = newElement:getPos()
                                    newElement._y = -500
                                    newElement:setPos(x2, newElement._y)
                                    newElement:setVisible(true)

                                    FLUX.to(newElement, 1, { _y = targetY }):ease("backout")
                                        :onupdate(function()
                                            newElement:setPos(x2, newElement._y)
                                        end)
                                end
                            end
                            self.uiGroup = newGroup
                        end)
                    end
                end)
        end
    else
        -- No current group, just animate in new one immediately
        if self.uiElements[newGroup] then
            for _, newElement in ipairs(self.uiElements[newGroup]) do
                local x, targetY = newElement:getPos()
                newElement._y = -500
                newElement:setPos(x, newElement._y)

                FLUX.to(newElement, 0.4, { _y = targetY }):ease("backout")
                    :onupdate(function()
                        newElement:setPos(x, newElement._y)
                    end)
            end
        end
        self.uiGroup = newGroup
    end
end






return map_creation