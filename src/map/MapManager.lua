local Map_Manager = {
    maps = {}
}

local function convertName(name)
    return name:gsub("%s+", "_")
end

function Map_Manager:loadMaps()
    local map_save_dir = love.filesystem.getSaveDirectory() .. "/maps/"
    local map_save_folder = love.filesystem.getDirectoryItems(map_save_dir)

    if not map_save_folder then return end

    for i, fileName in ipairs(map_save_folder) do
        local mapFileDir = map_save_dir .. "/" .. fileName
        local mapData, size = love.filesystem.read(mapFileDir)
        mapData = JSON.decode(mapData)

        self.maps[mapData.name] = mapData
    end
end

function Map_Manager:saveMap(mapData)
    love.filesystem.createDirectory("maps") -- ensures the folder exists

    mapData.img = nil -- remove non-serializable field (like userdata)

    local filename = "maps/" .. convertName(mapData.name) .. ".json"
    local encodedData = JSON.encode(mapData)

    love.filesystem.write(filename, encodedData)

    return love.filesystem.getSaveDirectory() .. "/" .. filename
end


function Map_Manager:isThereSameMap(mapName)
    return self.maps[mapName] and true or false
end


return Map_Manager