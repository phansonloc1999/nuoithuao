push = require "libs.push"
require("src.stateMachine")
require("src.playState")
require("src.gameOverState")

GAME_WIDTH, GAME_HEIGHT = 76, 150 --fixed game resolution
osString = love.system.getOS()
if osString == "Windows" or osString == "Linux" then
    WINDOW_WIDTH, WINDOW_HEIGHT = 304, 600
else
    if osString == "Android" or osString == "iOS" then
    	WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions(1)
    end
end

function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    love.setDeprecationOutput(false)
    
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {resizable = false, fullscreen = true, highdpi = true, usedpiscale = false})
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {pixelperfect = true, highdpi = true, canvas = true})
    math.randomseed(os.time())

    StateMachine.push(PlayState)
end

function love.draw()
    StateMachine.draw()
end

function love.update(dt)
    StateMachine.update(dt) 
end

love.mouse.buttonsPressed = {}

function love.mousepressed(x, y, button, istouch)
    if (button == 1) then
        love.mouse.buttonsPressed[1] = true
    end 
end

function love.mouse.isPressed(button)
    temp = love.mouse.buttonsPressed[button]
    love.mouse.buttonsPressed[button] = false
    return temp
end

function love.mousereleased(x, y, button)
    love.mouse.buttonsPressed[button] = false
end

function love.quit()
    StateMachine.quit()
end

function love.resize(w, h)
    return push:resize(w, h)
end
