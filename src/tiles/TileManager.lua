local tileSet = love.filesystem.read("assets/tileset.json")
tileSet = JSON.decode(tileSet)

local texture = love.graphics.newImage("assets/img/assets.png")

local TileManger = {
    tiles = {}
}

function TileManger:LoadTiles()
    local tilesCount = tileSet.tilecount

    for i = 1,tilesCount , 1 do
        local tile = {}

        local y = math.floor( (i - 1) / 8 )
        local x = (i - 1) % 8

        local canvas = love.graphics.newCanvas(100, 100)
        love.graphics.setCanvas(canvas)
        love.graphics.clear()
        love.graphics.draw(texture, love.graphics.newQuad(x * 100 , y * 100, 100, 100, texture), 0, 0)
        love.graphics.setCanvas()

        local imageData = canvas:newImageData()
        local tileImage = love.graphics.newImage(imageData)

        tile.img = tileImage
        tile.data = self:GetTileData(i - 1)

        self.tiles[i - 1] = tile
    end
end

function TileManger:GetTiles()
    return self.tiles
end

function TileManger:GetTile(tileID, tileType)
    local tiles = TILE_TYPES[tileID]

    if type(tiles) == "table" then
        return self.tiles[tiles[tileType]] or nil
    else
        return self.tiles[tiles] or nil
    end
end

function TileManger:GetTileData(tileID)
    for tileset_ID, data in pairs(tileSet.tiles) do
        if tileset_ID == tileID then
            return data.properties.value
        end
    end
end

function TileManger:checkVaildTileID(tileID)
    local isValid = false

    for tileType, data in pairs(TILE_TYPES) do
        if type(data) == "table" then
            for i, data_tileID in ipairs(data) do
                if tileID == data_tileID then isValid = true end

            end

        else
            if tileID == data then isValid = true end

        end
    end

    return isValid
end

function TileManger:GetTileType(tileID)
    for tileType, data in pairs(TILE_TYPES) do
        if type(data) == "table" then
            for i, data_tileID in ipairs(data) do
                if tileID == data_tileID then return tileType end
            end
        else
            if tileID == data then return tileType end

        end
    end
end

return TileManger