function drawPoop()
    if (hasPoop and isDog) then
        love.graphics.draw(poop, GAME_WIDTH / 2 + dog:getWidth() / 2, GAME_HEIGHT / 2 + dog:getHeight() / 2 - poop:getHeight())
    end
end

function poopUpdate(dt)
    if dog and (mouseX > GAME_WIDTH / 2 + dog:getWidth() / 2)
    and (mouseX < GAME_WIDTH / 2 + dog:getWidth() / 2 + poop:getWidth())
    and (mouseY > GAME_HEIGHT / 2 + dog:getHeight() / 2 - poop:getHeight())
    and (mouseY < GAME_HEIGHT / 2 + dog:getHeight() / 2)
    and (hasPoop)
    and (love.mouse.isDown(1)) then
        hasPoop = false
        if hasPoop and hunger > 2 * hungerMax / 3 then poopChanceThreshold = 80 end
        if hasPoop and hunger <= 2 * hungerMax / 3 then poopChanceThreshold = 20 end
    end

    if (poopInterval > 0) and not hasPoop then
        poopInterval = math.max(0, poopInterval - dt)
        if (poopInterval == 0) then
            hasPoop = math.random(1, 100) < poopChanceThreshold and true or false
            poopInterval = 30
            if hasPoop and hunger > 2 * hungerMax / 3 then poopChanceThreshold = 80 end
            if hasPoop and hunger <= 2 * hungerMax / 3 then poopChanceThreshold = 20 end
        end
    end

    if (hasPoop) then
        sickChanceThreshold = math.max(0, sickChanceThreshold - 1)
    else
        poopChanceThreshold = poopChanceThreshold + 0.01
        print(poopChanceThreshold)
    end
end