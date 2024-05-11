local tween = require("libs.tween")

function increaseHunger()
    increaseHungerTxt = { string = love.graphics.newText(font, "+1"), x = 100, y = 30 }
    increaseHungerTwn = tween.new(1, increaseHungerTxt, { x = 100, y = 0})
end

function increaseStamina()
    increaseStaminaTxt = { string = love.graphics.newText(font, "+".. math.floor(3 * staminaMax / 4)), x = 100, y = 60 }
    increaseStaminaTwn = tween.new(1, increaseStaminaTxt, { x = 100, y = 30 })
end

function decreaseHunger()
    decreaseHungerTxt = { string = love.graphics.newText(font, "-"..math.floor(hungerMax / 2)), x = 100, y = 30 }
    decreaseHungerTwn = tween.new(1, decreaseHungerTxt, { x = 100, y = 0})
end

function decreaseStamina()
    decreaseStaminaTxt = { string = love.graphics.newText(font, "-"..math.floor(staminaMax / 2)), x = 100, y = 60 }
    decreaseStaminaTwn = tween.new(1, decreaseStaminaTxt, { x = 100, y = 30 })
end