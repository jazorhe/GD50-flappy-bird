ScoreState = Class{__includes = BaseState}

COOLDOWN = 0.75

function ScoreState:init()
    self.timer = 0
end

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    self.timer = self.timer + dt
    
    if self.timer > COOLDOWN then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or
            love.mouse.wasPressed(0, 0, 1, 1) then
            gStateMachine:change('play')
        end
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end
