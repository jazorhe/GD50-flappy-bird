PipePair = Class{}

function PipePair:init(y)
    GAP_HEIGHT = math.random(90, 140)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    self.remove = false
    self.scored = false
end

function PipePair:update(dt)
    if self.x > -PIPE_HEIGHT then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['upper'].x = self.x
        self.pipes['lower'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
