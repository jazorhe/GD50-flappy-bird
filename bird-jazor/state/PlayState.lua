PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.bird       = Bird()
    self.pipePairs  = {}
    self.spawnTimer = 0
    self.score      = 0
    self.lastY      = -PIPE_HEIGHT + math.random(80) + 20
    self.mouseX = 0
    self.mouseY = 0
end

function PlayState:enter(params)
    if params then
        self.bird       = params['bird']
        self.pipePairs  = params['pipePairs']
        self.spawnTimer = params['spawnTimer']
        self.score      = params['score']
        self.lastY      = params['lastY']
        sounds['music']:play()
        sounds['pause']:play()
    end
end

function PlayState:update(dt)

    autoScroll(dt)

    if love.keyboard.wasPressed('p') or love.mouse.areaWasPressed((VIRTUAL_WIDTH - 17) * 2.5, 8 * 2.5, 20 * 2.5, 1) then
        self.playParams = {
            ['bird'] = self.bird,
            ['pipePairs'] = self.pipePairs,
            ['spawnTimer'] = self.spawnTimer,
            ['score'] = self.score,
            ['lastY'] = self.lastY
        }
        gStateMachine:change('pause', self.playParams)
    end

    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer > 1.8 then
        if math.random(100) == 1 or self.spawnTimer > 4 then
            local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20, 20) , VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastY = y

            table.insert(self.pipePairs, PipePair(y))
            self.spawnTimer = 0
        end
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
    end

    for k, pair in pairs(self.pipePairs) do
        pair:update(dt)

        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('score', {
                    score = self.score
                })
                sounds['explosion']:play()
                sounds['hurt']:play()
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {
            score = self.score
        })
        sounds['explosion']:play()
        sounds['hurt']:play()
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

end

function PlayState:render()

    for k , pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    -- love.graphics.print('mouseX: ' .. tostring(self.mouseX), 8, 60)
    -- love.graphics.print('mousey: ' .. tostring(self.mouseY), 8, 120)

    love.graphics.setFont(mediumFont)
    love.graphics.print('||', VIRTUAL_WIDTH - 17, 8)

    self.bird:render()
end
