ScoreState = Class{__includes = BaseState}

COOLDOWN = 0.75
MEDAL_SILVER = 1
MEDAL_GOLD   = 2
MEDAL_BRONZE = 3

function ScoreState:init()
    self.spritesheet  = love.graphics.newImage('medals.png')
    self.medalWidth   = 80
    self.medalHeight  = 90
    self.medalSprites = generateQuads(self.spritesheet, self.medalWidth, self.medalHeight)
    self.timer = 0
end

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COOLDOWN then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or
            love.mouse.wasPressed(1) then
            gStateMachine:change('play')
        end
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)

    if self.score <= 2 then
        love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    elseif self.score <= 5 then
        love.graphics.printf('You\'ve received a Bronze Medal!', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(self.spritesheet, self.medalSprites[MEDAL_BRONZE], VIRTUAL_WIDTH / 2 - 40, 125)

    elseif self.score <= 7 then
        love.graphics.printf('You\'ve received a Silver Medal!', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(self.spritesheet, self.medalSprites[MEDAL_SILVER], VIRTUAL_WIDTH / 2 - 40, 125)

    else
        love.graphics.printf('You\'ve received a Gold Medal!', 0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(self.spritesheet, self.medalSprites[MEDAL_GOLD], VIRTUAL_WIDTH / 2 - 40, 125)
    end

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 220, VIRTUAL_WIDTH, 'center')
end
