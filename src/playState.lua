PlayState = {}

require "src.textEffects"
require "src.emoteEffects" 
require "src.poop"

function PlayState.load()
    dogBrown = love.graphics.newImage("assets/dog-brown.png")
    dogOrange = love.graphics.newImage("assets/dog-orange.png")
    dogGray = love.graphics.newImage("assets/dog-gray.png")
    dogDarkBrown = love.graphics.newImage("assets/dog-dark-brown.png")
    bone = love.graphics.newImage("assets/bone.png")
    box = love.graphics.newImage("assets/box.png")
    bed = love.graphics.newImage("assets/bed.png")
    pill = love.graphics.newImage("assets/pill.png")
    sick = love.graphics.newImage("assets/sick.png")
    weight = love.graphics.newImage("assets/weight.png")
    egg = love.graphics.newImage("assets/egg.png")
    eggBroken = love.graphics.newImage("assets/egg-broken.png")

    font = love.graphics.newFont("assets/font.ttf", 50)
    
    boneSfx = love.audio.newSource("assets/bone.wav", "static")
    sleepSfx = love.audio.newSource("assets/sleep.wav", "static")
    pillSfx = love.audio.newSource("assets/pill.wav", "static")

    hunger = 5
    hungerMax = 10
    stamina = 5
    staminaMax = 15
    health = 10
    healthMax = 20
    sickCooldownInterval = 60
    sickCooldown = sickCooldownInterval
    sickChance = math.random(1, 100)
    sickChanceThreshold = 30
    gymCooldownInterval = 30
    gymCooldown = 0
    healthRegenInterval = 2
    healthRegen = healthRegenInterval
    hungerLossInterval = 8
    healthLossInterval = 5
    isEgg = false
    isDog = false
    isSick = false
    isGym = false
    isSleeping = false
    
    saveInterval = 0

    if (not love.filesystem.exists("save.dat")) then
        file = love.filesystem.newFile("save.dat")
        file:open("w")
        file:write("5\n10\n5\n15\n10\n20\nisEgg")
        isEgg = true
        isDog = false
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
        is = lines[7]
        if (is == "isEgg") then isEgg = true end
        if (is == "isDog") then isDog = true end
        color = lines[8]
        if color == "brown" then dog = dogBrown end
        if color == "darkBrown" then dog = dogDarkBrown end
        if color == "gray" then dog = dogGray end
        if color == "orange" then dog = dogOrange end
        file:close()
    end

    loadPoop()
end

function PlayState.draw()
    push:start()
    love.graphics.setColor(0, 0, 255)
    love.graphics.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
    love.graphics.setColor(255, 255, 255)
    
    if (isEgg) then
        if (hungerMax < 100) and (staminaMax < 100) then
            if (shakeTwns == nil) then
                love.graphics.draw(egg, GAME_WIDTH / 2 - egg:getWidth() / 2, GAME_HEIGHT / 2 - egg:getHeight() / 2)    
            else
                love.graphics.draw(egg, shakePos.x, GAME_HEIGHT / 2 - egg:getHeight() / 2)
            end
        else
            if (shakeTwns == nil) then
                love.graphics.draw(eggBroken, GAME_WIDTH / 2 - egg:getWidth() / 2, GAME_HEIGHT / 2 - egg:getHeight() / 2)
            else 
                love.graphics.draw(eggBroken, shakePos.x, GAME_HEIGHT / 2 - egg:getHeight() / 2)
            end
        end
    end
    if (isDog) then
        love.graphics.draw(dog, GAME_WIDTH / 2 - dog:getWidth() / 2, GAME_HEIGHT / 2 - dog:getHeight() / 2)
    end
    drawPoop()
    
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
    if (pillSmall) then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(pillSmall.img, pillSmall.x, pillSmall.y)
    end
    if (weightLift) then
        love.graphics.draw(weightLift.img, weightLift.x, weightLift.y)
    end
    push:finish()

    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Hunger: ".. hunger .. "/" .. hungerMax)
    love.graphics.print("Stamina: ".. stamina .. "/" .. staminaMax, 0, 50)
    love.graphics.print("Health: ".. health .. "/" .. healthMax, 0, 100)

    if (increaseHungerTxt) then
        love.graphics.setColor(0, 255, 0)
        love.graphics.draw(increaseHungerTxt.string, increaseHungerTxt.x, increaseHungerTxt.y)
    end

    if (sleepTxt) then
        love.graphics.setColor(0, 0, 0)
        local x, y = push:toReal(GAME_WIDTH / 2, GAME_HEIGHT / 2)
        love.graphics.draw(sleepTxt, x, y - sleepTxt:getHeight() * 2)
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

function PlayState.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    mouseX, mouseY = push:toGame(mouseX, mouseY)
    mouseX = mouseX and mouseX or 0
    mouseY = mouseY and mouseY or 0
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
        isSick = false
        sickCooldown = sickCooldownInterval
        hungerMax = hungerMax * 2
        staminaMax = staminaMax * 2
        healthMax = healthMax * 2
        emotePillSmall()
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
        if (isEgg) then
            emoteShake()
        elseif (isDog) then
            emoteWeightLift()
        end
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
    if (pillSmallTwn) then 
        if (pillSmallTwn:update(dt)) then
            pillSmall = nil
            pillSmallTwn = nil
        end
    end
    if (weightLiftTwns) then
        if (weightLiftTwns[currentWeightLiftTwn]) then
            if (weightLiftTwns[currentWeightLiftTwn]:update(dt)) then
                currentWeightLiftTwn = currentWeightLiftTwn + 1
            end
        else
            weightLift = nil
            weightLiftTwns = nil
            currentWeightLiftTwn = nil
        end
    end
    if (shakeTwns) then
        if (shakeTwns[shakeCurrentTwn]) then
            if (shakeTwns[shakeCurrentTwn]:update(dt)) then
                shakeCurrentTwn = shakeCurrentTwn + 1
                if (shakeTwns[shakeCurrentTwn] == nil) then
                    shakeTwns = nil
                end
            end
        end
    end

    if (sickCooldown <= 0) then
        sickCooldown = sickCooldownInterval
        sickChance = math.random(1, 100)
        if (sickChance < sickChanceThreshold) then
            staminaMax = math.floor(staminaMax / 2)
            hungerMax = math.floor(hungerMax / 2)
            healthMax = math.floor(healthMax / 2)
            stamina = math.min(stamina, staminaMax)
            hunger = math.min(hunger, hungerMax)
            health = math.min(health, healthMax)
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
            hunger = math.max(0, hunger - math.ceil(hungerMax / 100 * 1))
            hungerLossInterval = 8
        end
    end
    poopUpdate(dt)

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

    if (hungerMax < 150 and staminaMax < 150 and healthMax < 150 and not isDog) then
        isEgg = true
        isDog = false
    end
    if (hungerMax > 150 and hungerMax < 250 and staminaMax > 150 and staminaMax < 250 and healthMax > 150 and healthMax < 250 and not isDog) then
        isEgg = false
        isDog = true
        local color = math.random(1, 4)
        if (color == 1) then dog = dogBrown end
        if (color == 2) then dog = dogDarkBrown end
        if (color == 3) then dog = dogGray end
        if (color == 4) then dog = dogOrange end
    end

    if (health <= 0) then
        StateMachine.push(GameOverState)
    end
    
    saveInterval = saveInterval + dt
    if (saveInterval >= 1) then
        file = love.filesystem.newFile("save.dat")
        file:open("w")
        file:write(hunger.."\n"..hungerMax.."\n"..stamina.."\n"..staminaMax.."\n"..health.."\n"..healthMax.."\n")
        if (isEgg) then file:write("isEgg\n") end
        if (isDog) then
            file:write("isDog\n")
            if dog == dogBrown then file:write("brown") end
            if dog == dogDarkBrown then file:write("darkBrown") end
            if dog == dogGray then file:write("gray") end
            if dog == dogOrange then file:write("orange") end
        end
        file:close()
        saveInterval = 0
    end
end

function PlayState.quit()
end