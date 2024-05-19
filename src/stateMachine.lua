StateMachine = {}

local states = {}

function StateMachine.push(newState)
    states[#states+1] = newState
    states[#states].load()
end

function StateMachine.pop()
    local temp = states[#states]
    states[#states] = nil
    return temp
end

function StateMachine.load()
    states[#states].load()
end

function StateMachine.draw()
   states[#states].draw() 
end

function StateMachine.update(dt)
    states[#states].update(dt)
end

function StateMachine.quit()
    states[#states].quit()
end