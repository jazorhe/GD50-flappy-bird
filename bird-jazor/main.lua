push = require 'push'

Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'

require 'Util'
require 'StateMachine'
require 'state/BaseState'
require 'state/PlayState'
require 'state/PauseState'
require 'state/ScoreState'
require 'state/CountdownState'
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

    -- initialize sound effects
    sounds = {
        ['jump']      = love.audio.newSource('jump.wav', 'static'),
        ['hurt']      = love.audio.newSource('hurt.wav', 'static'),
        ['score']     = love.audio.newSource('score.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['pause']     = love.audio.newSource('pause.wav', 'static'),
        ['music']     = love.audio.newSource('marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDIW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize global state machine
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown']  = function() return CountdownState() end,
        ['play']  = function() return PlayState() end,
        ['pause']  = function() return PauseState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed  = {}
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


function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        button = 'primary'
    elseif button == 2 then
        button = 'secondary'
    elseif button == 3 then
        button = 'middle'
    else
        button = 'unknown'
    end

    love.mouse.buttonsPressed[button] = {
        ['x'] = x,
        ['y'] = y,
        ['pressed'] = true,
        ['istouch'] = istouch
    }
end


function love.keyboard.wasPressed(key)
    -- return key pressed from last frame, to be used by other classes in game
    if love.keyboard.keysPressed[key] == true then
        return true
    else
        return false
    end
end

function love.mouse.wasPressed(button)
    if button == 1 then
        button = 'primary'
    elseif button == 2 then
        button = 'secondary'
    elseif button == 3 then
        button = 'middle'
    else
        button = 'unknown'
    end

    if love.mouse.buttonsPressed[button] and love.mouse.buttonsPressed[button]['pressed'] == true then
        return true
    else
        return false
    end
end

local function inCircle(cx, cy, radius, x, y)
    local dx = cx - x
    local dy = cy - y
    return dx * dx + dy * dy <= radius * radius
end

function love.mouse.areaWasPressed(cx, cy, radius, button)
    if love.mouse.wasPressed(button) then
        if button == 1 then
            button = 'primary'
        elseif button == 2 then
            button = 'secondary'
        elseif button == 3 then
            button = 'middle'
        else
            button = 'unknown'
        end

        x = love.mouse.buttonsPressed[button]['x']
        y = love.mouse.buttonsPressed[button]['y']

        if inCircle(cx, cy, radius, x, y) then
            return true
        end
    end
    return false
end

function autoScroll(dt)
    -- update background and ground scrolling offsets
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end

function love.update(dt)
    -- update state machine
    gStateMachine:update(dt)

    -- reset input table
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed  = {}
end

function love.draw()
    -- use push to draw
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end

-- Assignment 1 TODO:

-- [x] The Gap Update: Randomize the gap between pipes (vertical space), such that they’re no longer hardcoded to 90 pixels.

-- [x] The Pipe Spawn Update: Randomize the interval at which pairs of pipes spawn, such that they’re no longer always 2 seconds apart.

-- [x] The Medal Update: When a player enters the ScoreState, award them a “medal” via an image displayed along with the score; this can be any image or any type of medal you choose (e.g., ribbons, actual medals, trophies, etc.), so long as each is different and based on the points they scored that life. Choose 3 different ones, as well as the minimum score needed for each one (though make it fair and not too hard to test :)).

-- [x] The Pause Update: Implement a pause feature, such that the user can simply press “P” (or some other key) and pause the state of the game. This pause effect will be slightly fancier than the pause feature we showed in class, though not ultimately that much different. When they pause the game, a simple sound effect should play (I recommend testing out bfxr for this, as seen in Lecture 0!). At the same time this sound effect plays, the music should pause, and once the user presses P again, the gameplay and the music should resume just as they were! To cap it off, display a pause icon in the middle of the screen, nice and large, so as to make it clear the game is paused.
