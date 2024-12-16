GameOverState = {}

local gameOverTxt, gameOverTxtX, gameOverTxtY

function GameOverState.load()
    font = love.graphics.newFont("assets/font.ttf", 20)
    gameOverTxt = love.graphics.newText(font, "Game Over")
    gameOverTxtX, gameOverTxtY = push:toReal(GAME_WIDTH / 2, GAME_HEIGHT / 2)
end

function GameOverState.draw()
    love.graphics.setColor(255, 255, 255)
    if (osString == "Android") or (osString == "iOS") then
        love.graphics.draw(gameOverTxt, GAME_WIDTH / 2, GAME_HEIGHT / 2)
    end
    love.graphics.draw(gameOverTxt, gameOverTxtX - gameOverTxt:getWidth() / 2, gameOverTxtY - gameOverTxt:getHeight() / 2)
end

function GameOverState.update(dt)
end

function GameOverState.quit()
    
end