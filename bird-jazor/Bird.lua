Bird = Class{}

GRAVITY = 20
JUMP_VELOCITY = -5
COLLISION_ALLOWANCE = 2

function Bird:init()
    self.image  = love.graphics.newImage('bird.png')
    self.width  = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH  / 2 - (self.width  / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = JUMP_VELOCITY
    end

    self.y  = self.y  + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
    if (self.x + COLLISION_ALLOWANCE) + (self.width - COLLISION_ALLOWANCE * 2) >= pipe.x and self.x + COLLISION_ALLOWANCE <= pipe.x + PIPE_WIDTH then

        if (self.y + COLLISION_ALLOWANCE) + (self.height - COLLISION_ALLOWANCE * 2) >= pipe.y and self.y + COLLISION_ALLOWANCE <= pipe.y + PIPE_HEIGHT then
            return true
        end

    end

    return false
end
