function initState()
    m.gameState = GameStates().START
end function

function GameStates() as object
    return {
        "START": "start",
        "PLAYING": "playing",
        "GAME_OVER": "gameover"
    }
end function

function SetState(state as string) as void
    m.gameState = state
end function

function GetState() as string
    return m.gameState
end function