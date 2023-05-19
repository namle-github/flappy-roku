function init()
    m.dropAnimation = m.top.findNode("dropAnimation")
    m.drop = m.top.findNode("drop")
    m.flyAnimation = m.top.findNode("flyAnimation")
    m.fly = m.top.findNode("fly")
    currentPos = m.top.pitch
    m.drop.keyValue = [currentPos, [50, 229]]
    m.top.isDead = false
end function

function drop(isDropping as boolean) as void
    if (isDropping = true)
        m.dropAnimation.control = "start"
    else
        m.dropAnimation.control = "stop"
    end if
end function

function fly()
    currentPos = m.top.pitch
    m.fly.keyValue = [currentPos, [currentPos[0], currentPos[1] - 40]]
    m.flyAnimation.control = "start"
end function

function onPitchChange()
    if (m.top.pitch[1] = 229)
        m.dropAnimation.control = "stop"
        ' m.top.isDead = true
    end if
end function

function onFlyStateChange()
    if (m.top.isFlying = "stopped")
        currentPos = m.top.pitch
        m.drop.keyValue = [currentPos, [50, 229]]
        m.dropAnimation.control = "start"
    end if
end function

function onDeadChange(event)
    ' ?" @@@ "event.GetData()
    ' if (event.GetData() = true) m.audio.control = "play"
    ' return event.GetData()
end function