local push = require "libs.push"
local gameWidth, gameHeight = 76, 150 --fixed game resolution
local windowWidth, windowHeight = 380, 750

function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})
    dog = love.graphics.newImage("assets/dog.png")
end

function love.draw()
    push:start()
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
    love.graphics.draw(dog, gameWidth / 2 - dog:getWidth() / 2, gameHeight / 2 - dog:getHeight() / 2)
    push:finish()
end

function love.update(dt)
    
end