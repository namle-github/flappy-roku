function init()
    ?"pipes init"
end function

function createNewPipe(rotate = false as boolean) as object
    newPipe = CreateObject("roSGNode", "Poster")
    newPipe.setFields({
        uri: "pkg:/images/flappy-bird/pipe.png",
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