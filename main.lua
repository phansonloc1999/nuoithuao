local push = require "libs.push"
require "src.textEffects"
require "src.emoteEffects" 
GAME_WIDTH, GAME_HEIGHT = 76, 150 --fixed game resolution
local windowWidth, windowHeight = 380, 750

function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, {fullscreen = false})
    dog = love.graphics.newImage("assets/dog.png")
    bone = love.graphics.newImage("assets/bone.png")
    box = love.graphics.newImage("assets/box.png")
    font = love.graphics.newFont("assets/font.ttf", 20)
    hunger = 0
    hungerMax = 10
    boneSfx = love.audio.newSource("assets/bone.wav", "static")
end

function love.draw()
    push:start()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
    love.graphics.draw(dog, GAME_WIDTH / 2 - dog:getWidth() / 2, GAME_HEIGHT / 2 - dog:getHeight() / 2)
    love.graphics.draw(box, GAME_WIDTH / 2 - GAME_WIDTH / 4 - bone:getWidth() / 2 - 1, GAME_HEIGHT / 2 + GAME_HEIGHT / 3 - bone:getHeight() / 2 - 1)
    love.graphics.draw(bone, GAME_WIDTH / 2 - GAME_WIDTH / 4 - bone:getWidth() / 2, GAME_HEIGHT / 2 + GAME_HEIGHT / 3 - bone:getHeight() / 2)
    
    if (heart) then
        love.graphics.draw(heart.img, heart.x, heart.y)
    end
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
    if (mouseX > GAME_WIDTH / 2 - GAME_WIDTH / 4 - bone:getWidth() / 2 - 1)
        and (mouseX < GAME_WIDTH / 2 - GAME_WIDTH / 4 - bone:getWidth() / 2 - 1 + 17)
        and (mouseY > GAME_HEIGHT / 2 + GAME_HEIGHT / 3 - bone:getHeight() / 2 - 1)
        and (mouseY < GAME_HEIGHT / 2 + GAME_HEIGHT / 3 - bone:getHeight() / 2 - 1 + 17)
        and (love.mouse.isPressed(1))
    then
        hunger = math.min(hunger + 1, hungerMax)
        boneSfx:play()
        increaseHunger()
        emoteHeart()
        return
    end

    if (increaseHungerTwn) then
        if (increaseHungerTwn:update(dt)) then
            increaseHungerTwn = nil
            increaseHungerTxt = nil
        end
    end

    if (heartTween) then
        if (heartTween:update(dt)) then
            heart = nil
            heartTween = nil
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