local GH = {
    layer_order = {
        [5] = "transition",
        [4] = "ui",
        [3] = "game_1",
        [2] = "game_2",
        [1] = "background"
    }
    , -- keeps the original order
    layers = {}           -- stores the canvases by name
}

function GH:SetupLayers(width, height)
    for i, layer in ipairs(GH.layer_order) do
        self.layers[layer] = love.graphics.newCanvas(width, height)
    end
end

function GH:GetLayer(layerName)
    return self.layers[layerName]
end

function GH:DrawToLayer(layerName, drawFunc)
    local canvas = self:GetLayer(layerName)

    if not canvas then
        error("Layer '" .. layerName .. "' does not exist.")
    end

    love.graphics.setCanvas(canvas)
    love.graphics.clear() -- optional: clear the layer before drawing

    drawFunc() -- run your custom drawing logic

    love.graphics.setCanvas() -- reset to default (screen)
end

function GH:DrawLayers()
    love.graphics.setColor(1, 1, 1)
    for i, layer in ipairs(GH.layer_order) do
        love.graphics.draw(GH.layers[layer])
    end
end

return GH