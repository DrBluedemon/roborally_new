local Map_Constructor = {}
local bit = require("bit")

-- Helper function to pack orientation (2 bits) and tileID (7 bits)
function Map_Constructor:packTile(orientation, tileID)
    return bit.bor(bit.lshift(orientation, 7), bit.band(tileID, 0x7F))
end

-- Helper function to unpack the orientation and tile ID
function Map_Constructor:unpackTile(packedValue)
    local orientation = bit.rshift(packedValue, 7)
    local tileID = bit.band(packedValue, 0x7F)
    return orientation, tileID
end
function Map_Constructor:Init()
    return self
end

-- Function to create a new map
function Map_Constructor:newMap(name, width, height)
    self.mapData = {
        name = name,
        width = width,
        height = height,
        tiles = {}
    }

    self.mapData.tiles = {}
    for y = 1, height do
        self.mapData.tiles[y] = {}
        for x = 1, width do
            self.mapData.tiles[y][x] = {
                tileID = 0,
                tileOrientation = 0,
                tileType = 0,
                tileData = 0,
                layer = {}
            } -- Initially, set all tiles to 0 (empty/no tile)
        end
    end

    return self
end

--  Function to update the Name
function Map_Constructor:setName(name)
    self.mapData.name = name
end

-- Function to add a tile with a specified tileID and orientation
function Map_Constructor:addTile(tileID, tileType, orientation, x, y, layer)
    -- Pack the tileID and orientation into a single value
    if not layer then
        self.mapData.tiles[y][x].tileID = tileID
        self.mapData.tiles[y][x].tileOrientation = orientation
        self.mapData.tiles[y][x].tileType = tileType 
    else
        self.mapData.tiles[y][x].layer[layer] = {}
        self.mapData.tiles[y][x].layer[layer].tileID = tileID
        self.mapData.tiles[y][x].layer[layer].tileOrientation = orientation
        self.mapData.tiles[y][x].layer[layer].tileType = tileType 
    end

    -- self:generateMapImage()
end

-- Function to remove a tile at a specific position
function Map_Constructor:removeTile(x, y)
    print("REMOVED TILE")
    self.mapData.tiles[y][x] = {
                tileID = 0,
                tileOrientation = 0,
                tileType = 0,
                tileData = 0,
                layer = {}
            }
end

-- Function to get the tile ID from a specific location
function Map_Constructor:getTileID(x, y)
    local tileID = self.mapData.tiles[y][x].tileID
    return tileID
end

-- Function to get the orientation from a specific location
function Map_Constructor:getOrientation(x, y)
    local orientation = self.mapData.tiles[y][x].tileOrientation
    return orientation
end

function Map_Constructor:getTileType(x, y)
    local tileType = self.mapData.tiles[y][x].tileType
    return tileType
end

function Map_Constructor:generateMapImage()
    local mapWidth = self.mapData.width
    local mapHeight = self.mapData.height
    local canvas = love.graphics.newCanvas(mapWidth * 100, mapHeight * 100)

    -- Save current canvas
    local previousCanvas = love.graphics.getCanvas()

    -- Render to canvas
    love.graphics.setCanvas(canvas)
    love.graphics.origin()  -- Reset any transformations (especially from push)
    love.graphics.clear()

    -- Draw base floor
    for y = 1, mapHeight do
        for x = 1, mapWidth do
            local tileID = FLOOR
            local tile_Img = TILE_MANAGER:GetTile(tileID).img
            love.graphics.draw(tile_Img, 100 * (x - 1), 100 * (y - 1))
        end
    end

    -- Draw additional layers
    for y = 1, mapHeight do
        for x = 1, mapWidth do
            local tile = self.mapData.tiles[y][x]

            if tile and tile.tileID then
                local tileID = tile.tileID
                local orientation = tile.tileOrientation or 0
                local tileType = tile.tileType or 0

                if tileID ~= 0 then
                    local tile_Img = TILE_MANAGER:GetTile(tileID, tileType).img
                    local rotation = math.rad(orientation * 90)

                    love.graphics.draw(
                        tile_Img,
                        100 * (x - 1) + 50,
                        100 * (y - 1) + 50,
                        rotation,
                        1, 1,
                        50, 50
                    )
                end

                if tile.layer then
                    for _, layerTile in pairs(tile.layer) do
                        tileID = layerTile.tileID
                        orientation = layerTile.tileOrientation or 0
                        tileType = layerTile.tileType or 0
                        local tile_Img = TILE_MANAGER:GetTile(tileID, tileType).img
                        local rotation = math.rad(orientation * 90)

                        love.graphics.draw(
                            tile_Img,
                            100 * (x - 1) + 50,
                            100 * (y - 1) + 50,
                            rotation,
                            1, 1,
                            50, 50
                        )
                    end
                end
            end
        end
    end

    -- Restore original canvas
    love.graphics.setCanvas(previousCanvas)

    -- Generate image
    local mapImage = canvas:newImageData()
    mapImage = love.graphics.newImage(mapImage)

    print("Generated Image")
    self.mapData.img = mapImage
end

function Map_Constructor:getMapImage()
    return self.mapData.img
end

-- Return the Map data
function Map_Constructor:getMapData()
    return self.mapData
end

function Map_Constructor:loadMapData(mapData)
    self.mapData = mapData
    self:generateMapImage()
end

return Map_Constructor
