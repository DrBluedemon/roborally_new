local test_rectangle = {}

function test_rectangle:DoTransition(currentScene, newScene)
    self.currentScene = currentScene
    self.newScene = newScene

    self.newScene.canvas_offset = {x = 9999, y = 0}

    self.t = 0
    self.duration = 0.2 -- seconds per animation phase (more time!)
    self.wait_duration = 0.2 -- pause between in/out
    self.active = true
    self.phase = "in"

    self.rect_size = 50
    self.rectangles = {}

    local w = _GgameWidth
    local h = _GgameHeight
    self.cols = math.ceil(w / self.rect_size)
    self.rows = math.ceil(h / self.rect_size)

    self.center_row = math.floor(self.rows / 2)
    self.start_col = 1
    self.rectangles_count = 0

    for y = 1, self.rows do
        self.rectangles[y] = {}
        for x = 1, self.cols do
            local horiz_delay = (x - self.start_col) * 0.06 -- was 0.03
            local vert_delay = math.abs(y - self.center_row) * 0.04 -- was 0.02
            local delay = horiz_delay + vert_delay

            self.rectangles[y][x] = {
                scale = 0,
                delay = delay
            }

            self.rectangles_count = self.rectangles_count + 1
        end
    end
end

function test_rectangle:update(dt)
    if not self.active then return end

    self.t = self.t + dt
    local allDoneRects = 0
    local allDone = false

    if self.phase == "in" then
        for y = 1, self.rows do
            for x = 1, self.cols do
                local rect = self.rectangles[y][x]
                if self.t >= rect.delay then
                    local progress = math.min((self.t - rect.delay) / self.duration, 1)
                    rect.scale = progress
                end

                if rect.scale >= 1 then
                    allDoneRects = allDoneRects + 1
                end
            end
        end

        if allDoneRects == self.rectangles_count then
            print("TF: " .. allDoneRects)
            print("WHY: " .. self.rectangles_count)
            self.phase = "wait"
            self.t = 0
            Scene_Manager:FinaliseSceneSwitch(self.newScene)

            self.newScene.canvas_offset = {x = 0, y = 0}
        end

    elseif self.phase == "wait" then
        if self.t >= self.wait_duration then
            self.phase = "out"
            self.t = 0
        end

    elseif self.phase == "out" then
        for y = 1, self.rows do
            for x = 1, self.cols do
                local rect = self.rectangles[y][x]
                if self.t >= rect.delay then
                    local progress = math.min((self.t - rect.delay) / self.duration, 1)
                    rect.scale = 1 - progress
                else
                    allDone = false
                end
            end
        end

        if allDone then
            self.active = false
        end
    end
end

function test_rectangle:drawOverlay()
    if not self.active then return end

    love.graphics.setColor(1, 0, 0)

    for y = 1, self.rows do
        for x = 1, self.cols do
            local rect = self.rectangles[y][x]
            local scale = rect.scale
            local base_x = (x - 1) * self.rect_size
            local base_y = (y - 1) * self.rect_size
            local size = self.rect_size * scale

            local draw_x = base_x + (self.rect_size - size) / 2
            local draw_y = base_y + (self.rect_size - size) / 2

            love.graphics.rectangle("fill", draw_x, draw_y, size, size)
        end
    end

    love.graphics.setColor(1, 1, 1)
end

function test_rectangle:isActive()
    return self.active
end

return test_rectangle
