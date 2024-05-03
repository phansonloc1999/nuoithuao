local push = require "libs.push"
local textEffects = require "src.textEffects"
local gameWidth, gameHeight = 76, 150 --fixed game resolution
local windowWidth, windowHeight = 380, 750

function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})
    dog = love.graphics.newImage("assets/dog.png")
    bone = love.graphics.newImage("assets/bone.png")
    box = love.graphics.newImage("assets/box.png")
    font = love.graphics.newFont("assets/font.ttf", 20)
    hunger = 0
    hungerMax = 5
    boneSfx = love.audio.newSource("assets/bone.wav", "static")
end

function love.draw()
    push:start()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
    love.graphics.draw(dog, gameWidth / 2 - dog:getWidth() / 2, gameHeight / 2 - dog:getHeight() / 2)
    love.graphics.draw(box, gameWidth / 2 - gameWidth / 4 - bone:getWidth() / 2 - 1, gameHeight / 2 + gameHeight / 3 - bone:getHeight() / 2 - 1)
    love.graphics.draw(bone, gameWidth / 2 - gameWidth / 4 - bone:getWidth() / 2, gameHeight / 2 + gameHeight / 3 - bone:getHeight() / 2)
    push:finish()

    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Hunger: ".. hunger.. "/" .. hungerMax)

    if (increaseHungerTxt) then
        love.graphics.setColor(0, 255, 0)
        love.graphics.draw(increaseHungerTxt.string, increaseHungerTxt.x, increaseHungerTxt.y)
    end
end

function love.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    mouseX, mouseY = push:toGame(mouseX, mouseY)
    if (mouseX > gameWidth / 2 - gameWidth / 4 - bone:getWidth() / 2 - 1)
        and (mouseX < gameWidth / 2 - gameWidth / 4 - bone:getWidth() / 2 - 1 + 17)
        and (mouseY > gameHeight / 2 + gameHeight / 3 - bone:getHeight() / 2 - 1)
        and (mouseY < gameHeight / 2 + gameHeight / 3 - bone:getHeight() / 2 - 1 + 17)
        and (love.mouse.isPressed(1))
    then
        hunger = math.min(hunger + 1, hungerMax)
        boneSfx:play()
        increaseHunger()
        return
    end

    if (increaseHungerTwn) then
        if (increaseHungerTwn:update(dt)) then
            increaseHungerTwn = nil
            increaseHungerTxt = nil
        end
    end
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