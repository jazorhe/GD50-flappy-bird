push = require 'push'

Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'state/BaseState'
require 'state/PlayState'
require 'state/ScoreState'
require 'state/TitleScreenState'

WINDOW_WIDTH = 1280
WINDIW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- where the background image loops itself
local BACKGROUND_LOOPING_POINT = 413

function love.load()
    -- Plant Random Seed
    math.randomseed(os.time())

    -- initialize window
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird - Jazor')

    -- initialize fonts
    smallFont  = love.graphics.newFont('font.ttf',   8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont   = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDIW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play']  = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    -- Redefine love.resize() Function
    push:resize(w,h)
end

function love.keypressed(key)
    -- flag input table for any key pressed
    love.keyboard.keysPressed[key] = true

    -- quit the game with escape key
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    -- return key pressed from last frame, to be used by other classes in game
    if love.keyboard.keysPressed[key] == true then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- update background and ground scrolling offsets
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    -- update state machine
    gStateMachine:update(dt)

    -- reset input table
    love.keyboard.keysPressed = {}
end

function love.draw()
    -- use push to draw
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end
