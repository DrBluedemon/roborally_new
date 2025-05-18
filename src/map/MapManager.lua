local Map_Manager = {
    maps = {}
}

local function convertName(name)
    return name:gsub("%s+", "_")
end

function Map_Manager:loadMaps()
    local map_save_dir = love.filesystem.getSaveDirectory .. "/maps/"
    local map_save_folder = love.filesystem.getDirectoryItems(map_save_dir)

    for i, fileName in ipairs(map_save_folder) do
        local mapFileDir = map_save_dir .. "/" .. fileName
        local mapData, size = love.filesystem.read(mapFileDir)
        mapData = JSON.decode(mapData)

        self.maps[mapData.name] = mapData
    end
end

function Map_Manager:saveMap(mapData)
    local map_save_dir = love.filesystem.getSaveDirectory .. "/maps/"

    love.filesystem.write(map_save_dir .. "/" .. convertName(mapData.name), JSON.encode(mapData))
end

function Map_Manager:isThereSameMap(mapName)
    return self.maps[mapName] and true or false
end


return Map_Manager