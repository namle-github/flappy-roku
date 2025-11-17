'******************************************************************************
'** Pipes.brs
'** BrightScript code for the Pipes component
'******************************************************************************

'******************************************************************************
'** Initialization
'******************************************************************************
function init()
end function

'******************************************************************************
'** createNewPipe(rotate as boolean) as object
'** Creates a new pipe Poster node, optionally rotated
'** @param rotate - boolean indicating if the pipe should be rotated
'** @return - the newly created pipe Poster node
'******************************************************************************
function createNewPipe(rotate = false as boolean) as object
    newPipe = CreateObject("roSGNode", "Poster")
    newPipe.setFields({
        uri: "pkg:/images/flappy-bird/pipe_$$RES$$.png",
        width: 78,
        height: 480,
        scaleRotateCenter: [39, 0],
    })

    if (rotate = true)
        newPipe.rotation = 3.14
        newPipe.translation = [newPipe.translation[0] + 434, newPipe.translation[1] - 75]
    else
        newPipe.translation = [newPipe.translation[0] + 434, newPipe.translation[1] + 75]
    end if

    return newPipe
end function