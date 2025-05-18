JSON = require("libs.json")
PUSH = require("libs.push")
FLUX = require("libs.flux")
TILE_MANAGER = require("src.tiles.TileManager")
require("libs.catui")
require("src.cam")
require("src.tiles.TileTypes")

MapConstructor = require("src.map.MapConstructor")
Graphics_Handler = require("src.GraphicsHandler")
Scene_Manager = require("src.scene.SceneManager")
Ui_Handler = require("src.ui_Handler")
local push = require("libs.push")


--- [ VARIABLES ] ------
_GgameWidth, _GgameHeight = 1600, 1000 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()

-- push:setupScreen(_GgameWidth, _GgameHeight, windowWidth, windowHeight, {fullscreen = true})
push:setupScreen(_GgameWidth, _GgameHeight, windowWidth, windowHeight, {fullscreen = true})

--- [ FUNCTIONS ] ------
function love.load()
    TILE_MANAGER:LoadTiles()

    Scene_Manager:LoadScenes()
    Scene_Manager:LoadTransitions()
    Scene_Manager:SetNewScene("map_creation")

    Graphics_Handler:SetupLayers(_GgameWidth, _GgameHeight)
end

function love.update(dt)
    CAM.x = CAM.x  + ((love.keyboard.isDown("d") and 1 or 0) - (love.keyboard.isDown("a") and 1 or 0)) * dt
    CAM.y = CAM.y + ((love.keyboard.isDown("s") and 1 or 0) - (love.keyboard.isDown("w") and 1 or 0)) * dt

    FLUX.update(dt)

    Scene_Manager:UpdateScene(dt)
end

function love.draw()
    Scene_Manager:DrawScene()
end

function love.mousemoved(x, y, dx, dy)
    local x, y = PUSH:toGame(x, y)
    Ui_Handler:mouseMove(x, y, dx, dy)
end

function love.mousepressed(x, y, button, isTouch)
    local x, y = PUSH:toGame(x, y)
    Ui_Handler:mouseDown(x, y, button, isTouch)
end

function love.mousereleased(x, y, button, isTouch)
    local x, y = PUSH:toGame(x, y)
    Ui_Handler:mouseUp(x, y, button, isTouch)
end

function love.keypressed(key, scancode, isrepeat)
    Ui_Handler:keyDown(key, scancode, isrepeat)
end

function love.keyreleased(key)
    Ui_Handler:keyUp(key)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.wheelmoved(x, y)
    Ui_Handler:wheelMove(x, y)
end

function love.textinput(text)
    Ui_Handler:textInput(text)
end