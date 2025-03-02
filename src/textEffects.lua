local tween = require("libs.tween")

function increaseHunger()
    increaseHungerTxt = { string = love.graphics.newText(font, "+1"), x = 230, y = 0 }
    increaseHungerTwn = tween.new(1, increaseHungerTxt, { x = 230, y = 30 })
end

function increaseStamina()
    increaseStaminaTxt = { string = love.graphics.newText(font, "+".. math.floor(3 * staminaMax / 4)), x = 230, y = 30 }
    increaseStaminaTwn = tween.new(1, increaseStaminaTxt, { x = 230, y = 60 })
end

function decreaseHunger()
    decreaseHungerTxt = { string = love.graphics.newText(font, "-"..math.floor(hungerMax / 2)), x = 230, y = 0 }
    decreaseHungerTwn = tween.new(1, decreaseHungerTxt, { x = 230, y = 30 })
end

function decreaseStamina()
    decreaseStaminaTxt = { string = love.graphics.newText(font, "-"..math.floor(staminaMax / 2)), x = 230, y = 30 }
    decreaseStaminaTwn = tween.new(1, decreaseStaminaTxt, { x = 230, y = 60 })
end