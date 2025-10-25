JSON = require("libs.json")
PUSH = require("libs.push")
FLUX = require("libs.flux")
TILE_MANAGER = require("src.tiles.TileManager")
require("src.cam")
require("src.tiles.TileTypes")
require("libs.color")
require("libs.tuilboa.Element")
UTILS = require("libs.utils")
TULIBOA = require("libs.tuilboa.tuilboa")

MapConstructor = require("src.map.MapConstructor")
MAP_MANGER = require("src.map.MapManager")
Graphics_Handler = require("src.GraphicsHandler")
Scene_Manager = require("src.scene.SceneManager")
Ui_Handler = require("src.ui_Handler")
local push = require("libs.push")

PIXEL_TEXT_FONT = "assets/font/Grand9K Pixel.ttf"
local loaded = false


--- [ VARIABLES ] ------
_GgameWidth, _GgameHeight = 1600, 1000 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()

PUSH:setupScreen(_GgameWidth, _GgameHeight, windowWidth, windowHeight, {fullscreen = flase})

-- push:setupScreen(_GgameWidth, _GgameHeight, windowWidth, windowHeight, {fullscreen = true})

--- [ FUNCTIONS ] ------
function love.load()
    love.keyboard.setKeyRepeat(true)
    TILE_MANAGER:LoadTiles()
    TULIBOA.initElements()
    MAP_MANGER:loadMaps()



    Scene_Manager:LoadScenes()
    Scene_Manager:LoadTransitions()
    Scene_Manager:SetNewScene("map_creation")

    Graphics_Handler:SetupLayers(_GgameWidth, _GgameHeight)
    loaded = true
end

function love.update(dt)
    if not loaded then return end
    CAM.x = CAM.x  + ((love.keyboard.isDown("d") and 1 or 0) - (love.keyboard.isDown("a") and 1 or 0)) * dt
    CAM.y = CAM.y + ((love.keyboard.isDown("s") and 1 or 0) - (love.keyboard.isDown("w") and 1 or 0)) * dt

    FLUX.update(dt)

    Ui_Handler:update(dt)

    Scene_Manager:UpdateScene(dt)
end

function love.draw()
    if not loaded then return end
    Scene_Manager:DrawScene()
end

function love.mousemoved(x, y, dx, dy)
    if not loaded then return end
    local x, y = PUSH:toGame(x, y)
    Ui_Handler:mouseMove(x, y, dx, dy)
    Scene_Manager:mousemoved(x, y, dx, dy)
end

function love.mousepressed(x, y, button, isTouch)
    if not loaded then return end
    local x, y = PUSH:toGame(x, y)
    Ui_Handler:mouseDown(x, y, button, isTouch)
    Scene_Manager:mousepressed(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
    if not loaded then return end
    local x, y = PUSH:toGame(x, y)
    Ui_Handler:mouseUp(x, y, button, isTouch)
    Scene_Manager:mousereleased(x, y, button, isTouch)
end

function love.keypressed(key, scancode, isrepeat)
    if not loaded then return end
    Ui_Handler:keyDown(key, scancode, isrepeat)
    Scene_Manager:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
    if not loaded then return end
    Ui_Handler:keyUp(key)
    Scene_Manager:keyreleased(key)
end

function love.resize(w, h)
    if not loaded then return end
    PUSH:resize(w, h)
end

function love.wheelmoved(x, y)
    if not loaded then return end
    Ui_Handler:wheelMove(x, y)
    Scene_Manager:wheelmoved(x,y)
end

function love.textinput(text)
    if not loaded then return end
    Ui_Handler:textInput(text)
end

function love.filedropped(file)
    if not loaded then return end
    if Scene_Manager:GetCurrentSceneName() == "map_creation" then
        -- Open the file for reading
        file:open("r")  -- "r" = read mode

        -- Read the whole content
        local content = file:read()
        content = JSON.decode(content)

        -- Don't forget to close the file
        file:close()
        Scene_Manager:GetCurrentScene():loadImportetMap(content)
    end
end