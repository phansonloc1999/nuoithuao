local tween = require "libs.tween"

function emoteHeart()
    heart = { img = love.graphics.newImage("assets/heart.png"), x = GAME_WIDTH / 2, y = GAME_HEIGHT / 2 - 5}
    heartTween = tween.new(0.5, heart, { x = GAME_WIDTH / 2, y = GAME_HEIGHT / 2 - 15})
end