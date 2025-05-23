local ui_handler = {}

function ui_handler:newElement(elementName, tuilboa, parent)
    local element = tuilboa:newElement(elementName)
    return element
end

function ui_handler:update(dt)
    for i, componet in ipairs(Scene_Manager.active_uiComponents) do
        componet:update(dt)
    end
end

function ui_handler:mouseMove(x, y, dx, dy)
    for i, componet in ipairs(Scene_Manager.active_uiComponents) do
        if not x then x = 999999999 end
        if not y then y = 999999999 end

        componet:mouseMove(x, y, dx, dy)
    end
end

function ui_handler:mouseDown(x, y, button, isTouch)
    for i, componet in ipairs(Scene_Manager.active_uiComponents) do
        if not x then x = 999999999 end
        if not y then y = 999999999 end

        componet:mouseDown(x, y, button, isTouch)
    end
end

function ui_handler:mouseUp(x, y, button, isTouch)
    for i, componet in ipairs(Scene_Manager.active_uiComponents) do
        if not x then x = 999999999 end
        if not y then y = 999999999 end

        componet:mouseUp(x, y, button, isTouch)
    end
end

function ui_handler:wheelMove(x, y)
    for i, componet in ipairs(Scene_Manager.active_uiComponents) do
        componet:wheelMove(x, y)
    end
end

function ui_handler:keyDown(key, scancode, isrepeat)
    for i, componet in ipairs(Scene_Manager.active_uiComponents) do
        componet:keyDown(key, scancode, isrepeat)
    end
end

function ui_handler:keyUp(key)
    for i, componet in ipairs(Scene_Manager.active_uiComponents) do
        componet:keyUp(key)
    end
end

function ui_handler:textInput(text)
    for i, componet in ipairs(Scene_Manager.active_uiComponents) do
        componet:textInput(text)
    end
end

return ui_handler