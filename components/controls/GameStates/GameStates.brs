'******************************************************************************
'** GameStates.brs
'** Manages the different states of the game
'******************************************************************************

'******************************************************************************
'** Initialization
'******************************************************************************
function initState()
    m.gameState = GameStates().START
end function

'******************************************************************************
'** GameStates() as object
'** Returns an object representing the different game states
'******************************************************************************
function GameStates() as object
    return {
        "START": "start",
        "PLAYING": "playing",
        "GAME_OVER": "gameover"
    }
end function

'******************************************************************************
'** SetState(state as string) as void
'** Sets the current game state
'** @param state - the new state to set
'******************************************************************************
function SetState(state as string) as void
    m.gameState = state
end function

'******************************************************************************
'** GetState() as string
'** Retrieves the current game state
'** @return - the current game state
'******************************************************************************
function GetState() as string
    return m.gameState
end function