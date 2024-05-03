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
    bed = love.graphics.newImage("assets/bed.png")
    pill = love.graphics.newImage("assets/pill.png")
    sick = love.graphics.newImage("assets/sick.png")

    font = love.graphics.newFont("assets/font.ttf", 20)
    
    boneSfx = love.audio.newSource("assets/bone.wav", "static")
    sleepSfx = love.audio.newSource("assets/sleep.wav", "static")

    hunger = 0
    hungerMax = 10
    stamina = 25
    staminaMax = 50
    health = 50
    healthMax = 100
    isSleeping = false
    sickCooldownInterval = 60
    sickCooldown = sickCooldownInterval
    sickProbabilityThreshold = 3
    isSick = false
end

function love.draw()
    push:start()
    love.graphics.setColor(0, 0, 255)
    love.graphics.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
    love.graphics.setColor(255, 255, 255)
    
    love.graphics.draw(dog, GAME_WIDTH / 2 - dog:getWidth() / 2, GAME_HEIGHT / 2 - dog:getHeight() / 2)
    
    love.graphics.setColor(0, 255, 0)
    love.graphics.draw(box, GAME_WIDTH / 2 - GAME_WIDTH / 4 - bone:getWidth() / 2 - 1, GAME_HEIGHT / 2 + math.floor(GAME_HEIGHT / 4) - bone:getHeight() / 2)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(bone, GAME_WIDTH / 2 - GAME_WIDTH / 4 - bone:getWidth() / 2, GAME_HEIGHT / 2 + math.floor(GAME_HEIGHT / 4) - bone:getHeight() / 2 + 1)
    
    love.graphics.setColor(0, 255, 0)
    love.graphics.draw(box, GAME_WIDTH / 2 + GAME_WIDTH / 4 - bed:getWidth() / 2, GAME_HEIGHT / 2 + math.floor(GAME_HEIGHT / 4) - bed:getHeight() / 2)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(bed, GAME_WIDTH / 2 + GAME_WIDTH / 4 - bed:getWidth() / 2 + 1, GAME_HEIGHT / 2 + math.floor(GAME_HEIGHT / 4) - bed:getHeight() / 2)
    
    love.graphics.setColor(0, 255, 0)
    love.graphics.draw(box, GAME_WIDTH / 2 + GAME_WIDTH / 4 - pill:getWidth() / 2, GAME_HEIGHT / 2 + GAME_HEIGHT / 3 + pill:getHeight() / 2 - 9)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(pill, GAME_WIDTH / 2 + GAME_WIDTH / 4 - pill:getWidth() / 2 + 1, GAME_HEIGHT / 2 + GAME_HEIGHT / 3 + pill:getHeight() / 2 - 9)

    if (heart) then
        love.graphics.draw(heart.img, heart.x, heart.y)
    end

    if (isSick) then
        love.graphics.draw(sick, GAME_WIDTH / 2 + 7, GAME_HEIGHT / 2 - 14)
    end
    push:finish()

    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Hunger: ".. hunger .. "/" .. hungerMax)
    love.graphics.print("Stamina: ".. stamina .. "/" .. staminaMax, 0, 30)
    love.graphics.print("Health: ".. health .. "/" .. healthMax, 0, 60)

    if (increaseHungerTxt) then
        love.graphics.setColor(0, 255, 0)
        love.graphics.draw(increaseHungerTxt.string, increaseHungerTxt.x, increaseHungerTxt.y)
    end

    if (sleepTxt) then
        love.graphics.setColor(0, 0, 0)
        love.graphics.draw(sleepTxt, windowWidth / 2, windowHeight / 2 - 60)
    end
    if (increaseStaminaTxt) then
        love.graphics.setColor(0, 255, 0)
        love.graphics.draw(increaseStaminaTxt.string, increaseStaminaTxt.x, increaseStaminaTxt.y)
    end
end

function love.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    mouseX, mouseY = push:toGame(mouseX, mouseY)
    if (mouseX > GAME_WIDTH / 2 - GAME_WIDTH / 4 - bone:getWidth() / 2 - 1)
        and (mouseX < GAME_WIDTH / 2 - GAME_WIDTH / 4 - bone:getWidth() / 2 - 1 + 17)
        and (mouseY > GAME_HEIGHT / 2 + math.floor(GAME_HEIGHT / 4) - bone:getHeight() / 2)
        and (mouseY < GAME_HEIGHT / 2 + math.floor(GAME_HEIGHT / 4) - bone:getHeight() / 2 + 17)
        and (love.mouse.isPressed(1))
        and (isSleeping == false)
    then
        hunger = math.min(hunger + 1, hungerMax)
        boneSfx:play()
        increaseHunger()
        emoteHeart()
    end

    if (mouseX > GAME_WIDTH / 2 + GAME_WIDTH / 4 - bed:getWidth() / 2)
        and (mouseX < GAME_WIDTH / 2 + GAME_WIDTH / 4 - bed:getWidth() / 2 - 1 + box:getWidth())
        and (mouseY > GAME_HEIGHT / 2 + math.floor(GAME_HEIGHT / 4) - bed:getHeight() / 2)
        and (mouseY < GAME_HEIGHT / 2 + math.floor(GAME_HEIGHT / 4) - bed:getHeight() / 2 + box:getHeight())
        and (love.mouse.isPressed(1))
    then
        stamina = math.min(stamina + 25, staminaMax)
        sleepSfx:play()
        increaseStamina()
        emoteSleep()
    end

    if (mouseX > GAME_WIDTH / 2 + GAME_WIDTH / 4 - pill:getWidth() / 2)
        and (mouseX < GAME_WIDTH / 2 + GAME_WIDTH / 4 - pill:getWidth() / 2 + box:getWidth())
        and (mouseY > GAME_HEIGHT / 2 + GAME_HEIGHT / 3 + pill:getHeight() / 2 - 9)
        and (mouseY < GAME_HEIGHT / 2 + GAME_HEIGHT / 3 + pill:getHeight() / 2 - 9 + box:getHeight())
        and (love.mouse.isPressed(1))
    then
        emoteHeart()
        isSick = false
        sickCooldown = sickCooldownInterval
        hungerMax = hungerMax * 2
        staminaMax = staminaMax * 2
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

    if (sleepTween) then
        if (sleepTween:update(dt)) then
            sleepTxt = nil
            sleepTween = nil
            isSleeping = false
        end
    end
    if (increaseStaminaTwn) then
        if (increaseStaminaTwn:update(dt)) then
            increaseStaminaTwn = nil
            increaseStaminaTxt = nil
        end
    end

   
    if (sickCooldown <= 0) then
        sickCooldown = sickCooldownInterval
        math.randomseed(os.time())
        sickProbability = math.random(1, 5)
        sickProbabilityThreshold = 3
        if (sickProbability > sickProbabilityThreshold) then
            staminaMax = math.floor(staminaMax / 2)
            hungerMax = math.floor(hungerMax / 2)
            stamina = math.min(stamina, staminaMax)
            hunger = math.min(hunger, hungerMax)
            isSick = true
        end
    elseif (sickCooldown > 0) then
        sickCooldown = sickCooldown - dt
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