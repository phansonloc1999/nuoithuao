local tween = require("libs.tween")

function increaseHunger()
    if osString == "Windows" or osString == "Linux" then
        increaseHungerTxt = { string = love.graphics.newText(font, "+1"), x = 100, y = 0 }
        increaseHungerTwn = tween.new(1, increaseHungerTxt, { x = 100, y = 20 })
    elseif osString == "Android" or osString == "iOS" then
        increaseHungerTxt = { string = love.graphics.newText(font, "+1"), x = 250, y = 30 }
        increaseHungerTwn = tween.new(1, increaseHungerTxt, { x = 250, y = 50 })
    end
end

function increaseStamina()
    if osString == "Windows" or osString == "Linux" then
        increaseStaminaTxt = { string = love.graphics.newText(font, "+".. math.floor(3 * staminaMax / 4)), x = 100, y = 20 }
        increaseStaminaTwn = tween.new(1, increaseStaminaTxt, { x = 100, y = 40 })
    elseif osString == "Android" or osString == "iOS" then
        increaseStaminaTxt = { string = love.graphics.newText(font, "+".. math.floor(3 * staminaMax / 4)), x = 250, y = 80 }
        increaseStaminaTwn = tween.new(1, increaseStaminaTxt, { x = 250, y = 100 })
    end
end

function decreaseHunger()
    if osString == "Windows" or osString == "Linux" then
        decreaseHungerTxt = { string = love.graphics.newText(font, "-"..math.floor(hungerMax / 2)), x = 100, y = 0 }
        decreaseHungerTwn = tween.new(1, decreaseHungerTxt, { x = 100, y = 20 })
    elseif osString == "Android" or osString == "iOS" then
        decreaseHungerTxt = { string = love.graphics.newText(font, "-"..math.floor(hungerMax / 2)), x = 250, y = 30 }
        decreaseHungerTwn = tween.new(1, decreaseHungerTxt, { x = 250, y = 50 })
    end
end

function decreaseStamina()
    if osString == "Windows" or osString == "Linux" then
        decreaseStaminaTxt = { string = love.graphics.newText(font, "-"..math.floor(staminaMax / 2)), x = 100, y = 20 }
        decreaseStaminaTwn = tween.new(1, decreaseStaminaTxt, { x = 100, y = 40 })
    elseif osString == "Android" or osString == "iOS" then
        decreaseStaminaTxt = { string = love.graphics.newText(font, "-"..math.floor(staminaMax / 2)), x = 250, y = 80 }
        decreaseStaminaTwn = tween.new(1, decreaseStaminaTxt, { x = 250, y = 100 })
    end
end