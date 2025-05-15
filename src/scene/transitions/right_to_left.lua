local right_to_left = {}

function right_to_left:DoTransition(currentScene, newScene)
    local w = _GgameWidth

    currentScene.canvas_offset = { x = 0, y = 0 }
    newScene.canvas_offset = { x = w, y = 0 }

    self.active = true
    self.currentScene = currentScene
    self.newScene = newScene

    -- Animate current scene out and new scene in
    FLUX.to(currentScene.canvas_offset, 1, { x = -w }):ease("quadinout")
    FLUX.to(newScene.canvas_offset, 1, { x = 0 }):ease("quadinout")
        :oncomplete(function()
            self.active = false
            -- Finalize the transition
            Scene_Manager:FinaliseSceneSwitch()
        end)
end

function right_to_left:update(dt)
    -- All work is done by FLUX, so no update logic is needed
end

function right_to_left:isActive()
    return self.active
end

function right_to_left:draw()
    -- Optional: can add visual effects on top of the scenes
end

function right_to_left:drawOverlay()
    -- Optional: draw things like black bars, fading UI, etc.
end

return right_to_left
