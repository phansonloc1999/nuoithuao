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
    weight = love.graphics.newImage("assets/weight.png")

    font = love.graphics.newFont("assets/font.ttf", 20)
    
    boneSfx = love.audio.newSource("assets/bone.wav", "static")
    sleepSfx = love.audio.newSource("assets/sleep.wav", "static")
    pillSfx = love.audio.newSource("assets/pill.wav", "static")

    hunger = 0
    hungerMax = 10
    stamina = 0
    staminaMax = 15
    health = 0
    healthMax = 20
    isSleeping = false
    sickCooldownInterval = 60
    sickCooldown = sickCooldownInterval
    sickProbabilityThreshold = 3
    isSick = false
    isGym = false
    gymCooldownInterval = 30
    gymCooldown = 0
    healthRegenInterval = 2
    healthRegen = healthRegenInterval
    hungerLossInterval = 10
    healthLossInterval = 5

    if (not love.filesystem.exists("save.dat")) then
        file = love.filesystem.newFile("save.dat")
        file:open("w")
        file:write("0\n10\n0\n15\n0\n20")
        file:close()
    else
        file = love.filesystem.newFile("save.dat")
        file:open("r")
        data = file:read(2048)
        lines = {}
        i = 1
        for line in data:gmatch("([^\n]*)\n?") do
            lines[i] = line
            i = i + 1
        end
        hunger = tonumber(lines[1])
        hungerMax = tonumber(lines[2])
        stamina = tonumber(lines[3])
        staminaMax = tonumber(lines[4])
        health = tonumber(lines[5])
        healthMax = tonumber(lines[6])
        file:close()
    end
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

    love.graphics.setColor(0, 255, 0)
    love.graphics.draw(box, GAME_WIDTH / 2 - GAME_WIDTH / 4 - weight:getWidth() / 2 - 1, GAME_HEIGHT / 2 + GAME_HEIGHT / 3 + weight:getHeight() / 2 - 9)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(weight, GAME_WIDTH / 2 - GAME_WIDTH / 4 - weight:getWidth() / 2, GAME_HEIGHT / 2 + GAME_HEIGHT / 3 + weight:getHeight() / 2 - 9)

    if (heart) then
        love.graphics.draw(heart.img, heart.x, heart.y)
    end

    if (isSick) then
        love.graphics.draw(sick, GAME_WIDTH / 2 + 3, GAME_HEIGHT / 2 - 11)
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

    if (decreaseHungerTxt) then
        love.graphics.setColor(255, 0, 0)
        love.graphics.draw(decreaseHungerTxt.string, decreaseHungerTxt.x, decreaseHungerTxt.y)
    end

    if (decreaseStaminaTxt) then
        love.graphics.setColor(255, 0, 0)
        love.graphics.draw(decreaseStaminaTxt.string, decreaseStaminaTxt.x, decreaseStaminaTxt.y)
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
        and (not isSleeping)
        and (not isGym)
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
        and (not isSleeping)
        and (not isGym)
    then
        isSleeping = true
        stamina = math.min(stamina + math.floor(3 * staminaMax / 4), staminaMax)
        sleepSfx:play()
        increaseStamina()
        emoteSleep()
    end

    if (mouseX > GAME_WIDTH / 2 + GAME_WIDTH / 4 - pill:getWidth() / 2)
        and (mouseX < GAME_WIDTH / 2 + GAME_WIDTH / 4 - pill:getWidth() / 2 + box:getWidth())
        and (mouseY > GAME_HEIGHT / 2 + GAME_HEIGHT / 3 + pill:getHeight() / 2 - 9)
        and (mouseY < GAME_HEIGHT / 2 + GAME_HEIGHT / 3 + pill:getHeight() / 2 - 9 + box:getHeight())
        and (love.mouse.isPressed(1))
        and (isSick)
        and (not isSleeping)
        and (not isGym)
    then
        emoteHeart()
        isSick = false
        sickCooldown = sickCooldownInterval
        hungerMax = hungerMax * 2
        staminaMax = staminaMax * 2
        pillSfx:play()
    end

    if (mouseX > GAME_WIDTH / 2 - GAME_WIDTH / 4 - weight:getWidth() / 2)
    and (mouseX < GAME_WIDTH / 2 - GAME_WIDTH / 4 - weight:getWidth() / 2 + weight:getWidth() + 1)
    and (mouseY > GAME_HEIGHT / 2 + GAME_HEIGHT / 3 + weight:getHeight() / 2 - 9)
    and (mouseY < GAME_HEIGHT / 2 + GAME_HEIGHT / 3 + weight:getHeight() / 2 - 9 + weight:getHeight() + 1)
    and love.mouse.isPressed(1)
    and (not isSleeping)
    and (not isGym)
    and (hunger >= hungerMax / 2)
    and (stamina >= staminaMax / 2)
    then
        isGym = true
        hunger = math.max(0, hunger - math.floor(staminaMax / 2))
        stamina = math.max(0, stamina - math.floor(hungerMax / 2))
        decreaseHunger()
        decreaseStamina()
        hungerMax = hungerMax + 30
        staminaMax = staminaMax + 30
        healthMax = healthMax + 30
        gymCooldown = gymCooldownInterval
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
    if (decreaseHungerTwn) then
        if (decreaseHungerTwn:update(dt)) then
            decreaseHungerTxt = nil
            decreaseHungerTwn = nil
        end
    end
    if (decreaseStaminaTwn) then
        if (decreaseStaminaTwn:update(dt)) then
            decreaseStaminaTxt = nil
            decreaseStaminaTwn = nil
        end
    end

    if (sickCooldown <= 0) then
        sickCooldown = sickCooldownInterval
        math.randomseed(os.time())
        sickProbability = math.random(1, 5)
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

    if (hunger >= 3 * hungerMax / 4) then
        if (healthRegen <= 0) then
            health = math.min(healthMax, health + 1)
            healthRegen = healthRegenInterval
        elseif (healthRegen > 0) then
            healthRegen = math.max(0, healthRegen - dt)
        end
    end

    if (hungerLossInterval > 0) then
        hungerLossInterval = math.max(0, hungerLossInterval - dt)
        if (hungerLossInterval <= 0) then
            hunger = math.max(0, hunger - 1)
            hungerLossInterval = 10
        end
    end

    if (hunger <= 0) then
        if (healthLossInterval > 0) then
            healthLossInterval = math.max(0, healthLossInterval - dt)
        elseif (healthLossInterval <= 0) then
            health = math.max(0, health - 1)
            healthLossInterval = 5
        end
    end

    if (gymCooldown > 0) then
        gymCooldown = math.max(0, gymCooldown - dt)
    elseif (gymCooldown <= 0) then
        isGym = false
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

function love.quit()
    file = love.filesystem.newFile("save.dat")
    file:open("w")
    file:write(hunger.."\n"..hungerMax.."\n"..stamina.."\n"..staminaMax.."\n"..health.."\n"..healthMax)
    file:close()
end