Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('images/pipe.png')
local PIPE_SCROLL = -60

PIPE_SPEED  = 60
PIPE_WIDTH  = 70
PIPE_HEIGHT = 288

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    self.width  = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)

end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, 1, self.orientation == 'top' and -1 or 1)
end
