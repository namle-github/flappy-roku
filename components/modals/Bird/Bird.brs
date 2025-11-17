'******************************************************************************
'** Bird.brs
'******************************************************************************

'******************************************************************************
'** Initialization
'******************************************************************************
function init()
    m.dropAnimation = m.top.findNode("dropAnimation")
    m.drop = m.top.findNode("drop")
    m.flyAnimation = m.top.findNode("flyAnimation")
    m.fly = m.top.findNode("fly")
    currentPos = m.top.pitch
    m.drop.keyValue = [currentPos, [50, 229]]
    m.top.isDead = false
end function

'******************************************************************************
'** drop(isDropping as boolean) as void
'** Starts or stops the drop animation based on isDropping parameter
'** @param isDropping - boolean indicating if the drop animation should start
'******************************************************************************
function drop(isDropping as boolean) as void
    if (isDropping = true)
        m.dropAnimation.control = "start"
    else
        m.dropAnimation.control = "stop"
    end if
end function

'******************************************************************************
'** fly() as void
'** Initiates the fly animation for the bird
'******************************************************************************
function fly()
    currentPos = m.top.pitch
    m.fly.keyValue = [currentPos, [currentPos[0], currentPos[1] - 40]]
    m.flyAnimation.control = "start"
end function

'******************************************************************************
'** onPitchChange() as void
'** Handles changes in the bird's pitch to determine if it has hit the ground
'******************************************************************************
function onPitchChange()
    if (m.top.pitch[1] = 229)
        m.dropAnimation.control = "stop"
        m.top.isDead = true
    end if
end function

'******************************************************************************
'** onFlyStateChange() as void
'** Handles changes in the fly state to manage drop animation
'******************************************************************************
function onFlyStateChange()
    if (m.top.isFlying = "stopped")
        currentPos = m.top.pitch
        m.drop.keyValue = [currentPos, [50, 229]]
        m.dropAnimation.control = "start"
    end if
end function

'******************************************************************************
'** onDeadChanged(event) as boolean
'** Handles changes in the dead state of the bird
'******************************************************************************
function onDeadChanged(event)
    return event.GetData()
end function