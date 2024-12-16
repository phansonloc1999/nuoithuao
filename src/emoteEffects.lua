local tween = require "libs.tween"

function emoteHeart()
    heart = { img = love.graphics.newImage("assets/heart.png"), x = GAME_WIDTH / 2, y = GAME_HEIGHT / 2 - 5}
    heartTween = tween.new(0.5, heart, { x = GAME_WIDTH / 2, y = GAME_HEIGHT / 2 - 15})
end

function emoteSleep()
    sleepTxt = love.graphics.newText(font)
    sleepTxt:add( {{0, 0, 0}, "Z"}, 0, 0)
    sleepTxt:add( {{0, 0, 0}, "Z"}, 15, -15)
    sleepTxt:add( {{0, 0, 0}, "Z"}, 30, -30)
    sleepTween = tween.new(20, {}, {})
    isSleeping = true
end

function emotePillSmall()
    local image = love.graphics.newImage("assets/pill small.png")
    pillSmall = { img = image, x = GAME_WIDTH / 2 - image:getWidth() / 2, y = GAME_HEIGHT / 2 - 17}
    pillSmallTwn = tween.new(0.5, pillSmall, { x = GAME_WIDTH / 2 - image:getWidth() / 2, y = GAME_HEIGHT / 2 - 5})
end

function emoteWeightLift()
    weightLift = { img = weight, x = GAME_WIDTH / 2 - weight:getWidth() / 2, y = GAME_HEIGHT / 2 - weight:getHeight() / 2}
    weightLiftTwns = {}
    currentWeightLiftTwn = 1
    for i = 1, 30, 1 do
        if (i % 2 == 1) then
            weightLiftTwns[i] = tween.new(1, weightLift, { y = GAME_HEIGHT / 2 - weight:getHeight() / 2 - 10 })
        elseif (i % 2 == 0) then
            weightLiftTwns[i] = tween.new(1, weightLift, { y = GAME_HEIGHT / 2 - weight:getHeight() / 2 })
        end
    end
end