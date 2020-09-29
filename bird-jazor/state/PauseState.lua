PauseState = Class{__includes = BaseState}


function PauseState:enter(params)
    self.playParams = params
    sounds['music']:pause()
    sounds['pause']:play()
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('p') or love.mouse.wasPressed(0, 0, 1, 1) then
        gStateMachine:change('play', self.playParams)
    end
end

function PauseState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf('||', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
end
