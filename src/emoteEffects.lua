local tween = require "libs.tween"

function emoteHeart()
    heart = { img = love.graphics.newImage("assets/heart.png"), x = GAME_WIDTH / 2, y = GAME_HEIGHT / 2 - 5}
    heartTween = tween.new(0.5, heart, { x = GAME_WIDTH / 2, y = GAME_HEIGHT / 2 - 15})
end

function emoteSleep()
    sleepTxt = love.graphics.newText(font)
    sleepTxt:add( {{0, 0, 0}, "Z"}, 0, 0)
    sleepTxt:add( {{0, 0, 0}, "Z"}, 15, -15)
    sleepTween = tween.new(5, {}, {})
    isSleeping = true
end