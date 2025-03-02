function loadPoop()
    poop = love.graphics.newImage("assets/poop.png")
    poopInterval = 60
    poopChanceThreshold = 20
    hasPoop = false
end

function drawPoop()
    if (hasPoop and isDog) then
        love.graphics.draw(poop, GAME_WIDTH / 2 + dog:getWidth() / 2, GAME_HEIGHT / 2 + dog:getHeight() / 2 - poop:getHeight())
    end
end

function poopUpdate(dt)
    if dog and not isSleeping and not isGym
    and (mouseX > GAME_WIDTH / 2 + dog:getWidth() / 2)
    and (mouseX < GAME_WIDTH / 2 + dog:getWidth() / 2 + poop:getWidth())
    and (mouseY > GAME_HEIGHT / 2 + dog:getHeight() / 2 - poop:getHeight())
    and (mouseY < GAME_HEIGHT / 2 + dog:getHeight() / 2)
    and (hasPoop)
    and (love.mouse.isPressed(1)) then
        hasPoop = false
        poopInterval = 60
        poopChanceThreshold = 20
    end

    if (poopInterval > 0) and not hasPoop then
        poopInterval = math.max(0, poopInterval - dt)
        if (poopInterval == 0) then
            if hunger > 2 * hungerMax / 3 then poopChanceThreshold = 80 end
            hasPoop = math.random(1, 100) < poopChanceThreshold and true or false
            poopInterval = 30
        end
    end

    if (hasPoop) then
        sickChanceThreshold = math.min(100, sickChanceThreshold + 0.01)
    else
        poopChanceThreshold = math.min(100, poopChanceThreshold + 0.01)
    end
end