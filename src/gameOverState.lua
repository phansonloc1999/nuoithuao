GameOverState = {}

local gameOverTxt

function GameOverState.load()
    font = love.graphics.newFont("assets/font.ttf", 20)
    gameOverTxt = love.graphics.newText(font, "Game Over")
end

function GameOverState.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(gameOverTxt, WINDOW_WIDTH / 2 - gameOverTxt:getWidth() / 2, WINDOW_HEIGHT / 2 - gameOverTxt:getHeight() / 2)
end

function GameOverState.update(dt)
end

function GameOverState.quit()
    
end