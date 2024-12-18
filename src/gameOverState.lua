GameOverState = {}

local gameOverTxt, gameOverTxtX, gameOverTxtY

function GameOverState.load()
    font = love.graphics.newFont("assets/font.ttf", 20)
    gameOverTxt = love.graphics.newText(font, "Game Over")
    gameOverTxtX, gameOverTxtY = push:toReal(GAME_WIDTH / 2, GAME_HEIGHT / 2)

    file = love.filesystem.newFile("save.dat")
    file:open("w")
    file:write("0\n0\n0\n0\n0\n0\nisEgg")
    file:close()
end

function GameOverState.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(gameOverTxt, gameOverTxtX - gameOverTxt:getWidth() / 2, gameOverTxtY - gameOverTxt:getHeight() / 2)
end

function GameOverState.update(dt)
    if (love.mouse.isDown(1)) then
        file = love.filesystem.newFile("save.dat")
        file:open("w")
        file:write("5\n10\n5\n15\n10\n20\nisEgg")
        file:close()
        StateMachine.pop()
        StateMachine.pop()
        StateMachine.push(PlayState)
    end
end

function GameOverState.quit()
    
end