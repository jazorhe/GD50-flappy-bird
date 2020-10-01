CountdownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:enter(params)
    if params then
        self.params = params
    end
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1
        if self.count == 0 then
            if self.params then
                gStateMachine:change('play', self.params)
            else
                gStateMachine:change('play')
            end
        end

    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')

    if self.params then
        for k , pair in pairs(self.params['pipePairs']) do
            pair:render()
        end

        self.params['bird']:render()
    end

end
