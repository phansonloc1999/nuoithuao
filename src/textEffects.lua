local tween = require("libs.tween")

function increaseHunger()
    increaseHungerTxt = { string = love.graphics.newText(font, "+1"), x = 100, y = 30 }
    increaseHungerTwn = tween.new(1, increaseHungerTxt, { x = 100, y = 0})
end