local Scene_Manager = {
    scenes = {},
    transitions = {},
    active_scene = "",
    new_scene = nil,
    transition = nil,
    active_uiComponents = {}
}

function Scene_Manager:LoadScenes()
    local files = love.filesystem.getDirectoryItems("src/scene/scenes")

    for _, file in ipairs(files) do
        if file:match("%.lua$") then
            local sceneName = file:gsub("%.lua$", "")
            local scenePath = "src.scene.scenes." .. sceneName

            self.scenes[sceneName] = require(scenePath)
            self.scenes[sceneName].canvas = love.graphics.newCanvas(_GgameWidth, _GgameHeight)
            self.scenes[sceneName].canvas_offset = { x = 0, y = 0 }
        end
    end
end

function Scene_Manager:LoadTransitions()
    local files = love.filesystem.getDirectoryItems("src/scene/transitions")

    for _, file in ipairs(files) do
        if file:match("%.lua$") then
            local transName = file:gsub("%.lua$", "")
            local transPath = "src.scene.transitions." .. transName
            self.transitions[transName] = require(transPath)
        end
    end
end

function Scene_Manager:GetTransition(name)
    return self.transitions[name] or nil
end

function Scene_Manager:GetCurrentScene()
    return self:GetScene(self.active_scene)
end

function Scene_Manager:GetCurrentSceneName()
    return self.active_scene
end

function Scene_Manager:GetScene(name)
    return self.scenes[name] or nil
end

function Scene_Manager:SetNewScene(newSceneName, transitionName)
    local currentScene = self:GetCurrentScene()
    local newScene = self:GetScene(newSceneName)

    if transitionName then
        self.active_uiComponents = {}
        local transition = self.transitions[transitionName]
        self.transition = transition
        self.new_scene = newSceneName

        table.insert(self.active_uiComponents, currentScene.uiComponent)
        table.insert(self.active_uiComponents, newScene.uiComponent)

        if newScene.onLoad then newScene:onLoad() end
        if newScene.onSetupUi then newScene:onSetupUi() end

        currentScene.uiComponent:setChildrenEnabled(false)
        newScene.uiComponent:setChildrenEnabled(false)

        if transition and transition.DoTransition then
            transition:DoTransition(currentScene, newScene)
        end
    else
        -- No transition
        if currentScene and currentScene.uiComponent then
            -- currentScene.uiComponent:removeAllActiveElements()
        end

        self.active_scene = newSceneName
        local new_active_scene = self:GetCurrentScene()
        table.insert(self.active_uiComponents, new_active_scene.uiComponent)

        new_active_scene.canvas_offset = { x = 0, y = 0 }

        if new_active_scene.onLoad then new_active_scene:onLoad() end
        if new_active_scene.onSetupUi then new_active_scene:onSetupUi() end
    end
end

function Scene_Manager:FinaliseSceneSwitch()
    local oldScene = self:GetCurrentScene()
    local newScene = self:GetScene(self.new_scene)

    if oldScene and oldScene.uiComponent then
        oldScene.uiComponent:removeAllActiveElements()
    end

    if newScene then
        newScene.uiComponent:setChildrenEnabled(true)
        self.active_scene = self.new_scene
        self.new_scene = nil
        newScene.canvas_offset = { x = 0, y = 0 }

        if newScene.EndTransition then
            newScene:EndTransition(oldScene)
        end
    end
end

function Scene_Manager:UpdateScene(dt)
    local currentScene = self:GetCurrentScene()
    local newScene = self.new_scene and self:GetScene(self.new_scene) or nil

    if self.transition and not self.transition:isActive() then
        self.transition =nil
    end

    if self.transition then
        if self.transition.update then self.transition:update(dt) end
        if currentScene and currentScene.update then currentScene:update(dt) end
        if newScene and newScene.update then newScene:update(dt) end
    else
        if currentScene and currentScene.update then currentScene:update(dt) end
        if currentScene and currentScene.uiComponet then currentScene:update(dt) end
    end
end

function Scene_Manager:DrawScene()
    local currentScene = self:GetCurrentScene()
    local nextScene = self.new_scene and self:GetScene(self.new_scene) or nil
    local transition = self.transition

    if not currentScene then return end

    for _, layerName in ipairs(Graphics_Handler.layer_order) do
        Graphics_Handler:DrawToLayer(layerName, function()
            if currentScene.draw then currentScene:draw(layerName) end
        end)
    end

    love.graphics.setCanvas(currentScene.canvas)
    love.graphics.clear()
    Graphics_Handler:DrawLayers()

    if nextScene then
        for _, layerName in ipairs(Graphics_Handler.layer_order) do
            Graphics_Handler:DrawToLayer(layerName, function()
                if nextScene.draw then nextScene:draw(layerName) end
            end)
        end

        love.graphics.setCanvas(nextScene.canvas)
        love.graphics.clear()
        Graphics_Handler:DrawLayers()
    end

    if transition and transition.draw then
        Graphics_Handler:DrawToLayer("transition", function()
            transition:draw()
        end)
    end

    love.graphics.setCanvas()
    love.graphics.clear()

    PUSH:start()

    local offsetCurrent = currentScene.canvas_offset or { x = 0, y = 0 }
    love.graphics.draw(currentScene.canvas, offsetCurrent.x, offsetCurrent.y)

    if nextScene then
        local offsetNext = nextScene.canvas_offset or { x = 0, y = 0 }
        love.graphics.draw(nextScene.canvas, offsetNext.x, offsetNext.y)
    end

    if transition and transition.drawOverlay then
        transition:drawOverlay()
    end

    PUSH:finish()
end

function Scene_Manager:mousemoved(x, y, dx, dy)
    local currentScene = self:GetCurrentScene()
    if currentScene.mousemoved then currentScene:mousemoved(x, y, dx, dy) end
end

function Scene_Manager:mousepressed(x, y, button, isTouch)
    local currentScene = self:GetCurrentScene()
    if currentScene.mousepressed then currentScene:mousepressed(x, y, button, isTouch) end
end

function Scene_Manager:mousereleased(x ,y, button, isTouch)
    local currentScene = self:GetCurrentScene()
    if currentScene.mousereleased then currentScene:mousereleased(x, y, button, isTouch) end
end

function Scene_Manager:keypressed(key, scancode, isrepeat)
    local currentScene = self:GetCurrentScene()
    if currentScene.keypressed then currentScene:keypressed(key, scancode, isrepeat) end
end

function Scene_Manager:keyreleased(key)
    local currentScene = self:GetCurrentScene()
    if currentScene.keyreleased then currentScene:keyreleased(key) end
end

function Scene_Manager:wheelmoved(x, y)
    local currentScene = self:GetCurrentScene()
    if currentScene.wheelmoved then currentScene:wheelmoved(x, y) end
end

return Scene_Manager
