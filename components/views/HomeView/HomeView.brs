'**
'** HomeView
'**

function init()
  m.top.setFocus(true)
  initRegistry()
  m.record = getRegistryField("best-score")

  ' Background
  m.background = m.top.findNode("background")
  m.backScene = m.top.findNode("backScene")
  m.base = m.top.findNode("base")
  m.message = m.top.findNode("message")
  m.sceneAnimation = m.top.findNode("sceneAnimation")
  m.bgAnimation = m.top.findNode("bgAnimation")
  m.baseAnimation = m.top.findNode("baseAnimation")
  m.bgMovement = m.top.findNode("bgMovement")
  ' Pipes
  m.lowPipes = m.top.findNode("lowPipes")
  m.upPipes = m.top.findNode("upPipes")
  m.pipesAnimation = m.top.findNode("pipesAnimation")
  m.lowPipesAnimation = m.top.findNode("lowPipesAnimation")
  m.upPipesAnimation = m.top.findNode("upPipesAnimation")
  ' Bird
  m.bird = m.top.findNode("bird")
  ' Score
  m.scoreLayoutGroup = m.top.findNode("scoreLayoutGroup")
  m.scoreText = m.top.findNode("scoreText")
  m.score = m.top.findNode("score")
  m.score.text = m.record

  ' Timer for background change
  m.timer = CreateObject("roSGNode", "Timer")
  m.timer.duration = 1
  m.timer.repeat = true
  m.timer.ObserveField("fire", "onTimerFireChangeBackgroundColor")

  m.backScene.blendColor = "0x0A1824"

  m.screenSize = CreateObject("roDeviceInfo").GetUIResolution()
  m.message.translation = [(m.background.width - m.message.width) / 2, 100]
  m.scoreLayoutGroup.translation = [(m.background.width - m.scoreLayoutGroup.boundingRect().width) / 2, m.base.translation[1] + 50]
  m.lowPipes.translation = [m.lowPipes.translation[0], m.background.height - m.lowPipes.height]
  m.upPipes.translation = [m.upPipes.translation[0], m.background.height - m.upPipes.height]
  m.lowPipesAnimation.keyValue = [m.lowPipes.translation, [m.lowPipes.translation[0] - 100, m.lowPipes.translation[1]]]
  m.upPipesAnimation.keyValue = [m.upPipes.translation, [m.upPipes.translation[0] - 100, m.upPipes.translation[1]]]

  initState()
  ' ?"STATE: ", m.gameState
  setScore(m.record)
end function

function onKeyEvent(key as string, press as boolean) as boolean
  handled = false
  if (press = true)
    if (key = "OK" and m.gameState = "start")
      resetGame()
      startGame()
      m.bird.callFunc("drop", true)
      m.upPipes.ObserveField("translation", "OnPipeMoving")
      handled = true
    else if (key = "OK" and m.gameState = "gameover")
      resetGame()
    else if (key = "up")
      if (m.bird.isDropping <> "stopped" or m.bird.isFlying = "running")
        m.bird.callFunc("drop", false)
        m.bird.callFunc("fly")
        handled = true
      end if
    end if
  end if

  return handled
end function

function onLanding()
  m.bird.callFunc("drop", false)
end function

function OnPipeMoving()
  m.lowPipesAnimation.keyValue = [m.lowPipes.translation, [m.lowPipes.translation[0] - 100, m.lowPipes.translation[1]]]
  m.upPipesAnimation.keyValue = [m.upPipes.translation, [m.upPipes.translation[0] - 100, m.upPipes.translation[1]]]

  newLowPipe = m.lowPipes.callFunc("createNewPipe", false)
  newUpPipe = m.upPipes.callFunc("createNewPipe", true)

  if (not m.bird.isDead)
    m.pipesAnimation.control = "start"
  else
    stopGame()
  end if

  if (m.lastPipePos <> invalid)
    offsetX = 300 + Cint(Rnd(0) * 100) * Cint(Cos(Rnd(3.14)))
    offsetY = Cint(Rnd(0) * newLowPipe.height / 3) * Cint(Cos(Rnd(3.14)))
    newLowPipe.translation = [m.lastPipePos + offsetX, newLowPipe.translation[1] + offsetY]
    newUpPipe.translation = [newLowPipe.translation[0], newUpPipe.translation[1] + offsetY]
  end if

  if (m.lowPipes.getChildCount() < 3)
    m.lowPipes.appendChild(newLowPipe)
  end if
  if (m.upPipes.getChildCount() < 3)
    m.upPipes.appendChild(newUpPipe)
  end if

  if (m.lowPipes.getChildCount() > 0)
    m.lastPipePos = m.lowPipes.getChild(m.lowPipes.getChildCount() - 1).translation[0]
  end if

  firstLowPipe = m.lowPipes.getChild(0)
  firstUpPipe = m.upPipes.getChild(0)
  lowPipesX = m.lowPipes.translation[0]
  lowPipesY = m.lowPipes.translation[1]
  upPipesX = m.upPipes.translation[0]
  upPipesY = m.upPipes.translation[1]

  pipeSize = [firstLowPipe.width, firstLowPipe.height]
  firstLowPipePosX = firstLowPipe.translation[0] + lowPipesX
  firstUpPipePosX = firstUpPipe.translation[0] + upPipesX
  firstLowPipePosY = firstLowPipe.translation[1] + lowPipesY
  firstUpPipePosY = firstUpPipe.translation[1] + upPipesY

  birdPosX = m.bird.translation[0] + m.bird.pitch[0]
  birdPosY = m.bird.translation[1] + m.bird.pitch[1]
  birdSize = [m.bird.boundingRect().width, m.bird.boundingRect().height]

  firstLowPipeRangeX = [firstLowPipePosX, firstLowPipePosX + pipeSize[0]]
  firstUpPipeRangeX = [firstUpPipePosX, firstUpPipePosX + pipeSize[0]]
  firstLowPipeRangeY = [firstLowPipePosY, firstLowPipePosY + pipeSize[1]]
  firstUpPipeRangeY = [firstUpPipePosY - pipeSize[1], firstUpPipePosY]

  birdRangeX = [birdPosX, birdPosX + birdSize[0]]
  birdRangeY = [birdPosY, birdPosY + birdSize[1]]

  if ((isCrossed(birdRangeX, firstUpPipeRangeX) and isCrossed(birdRangeY, firstUpPipeRangeY)) or ((isCrossed(birdRangeX, firstLowPipeRangeX) and isCrossed(birdRangeY, firstLowPipeRangeY)))) stopGame()

  if ((birdPosX - firstLowPipePosX) >= 25 and (m.checked = false or m.checked = invalid))
    m.scoreValue++
    setScore(m.scoreValue)
    ' ?"Score: ", m.scoreValue
    m.checked = true
  end if

  if (firstLowPipe.translation[0] + lowPipesX < -firstLowPipe.width)
    m.lowPipes.removeChildIndex(0)
  end if
  if (firstUpPipe.translation[0] + upPipesX < -firstUpPipe.width)
    m.upPipes.removeChildIndex(0)
    m.checked = false
  end if
end function

function isCrossed(range1 as object, range2 as object) as boolean
  return ((range1[0] >= range2[0] and range1[0] <= range2[1]) or (range1[1] >= range2[0] and range1[1] <= range2[1])) or ((range2[0] >= range1[0] and range2[0] <= range1[1]) or (range2[1] >= range1[0] and range2[1] <= range1[1]))
end function

function startGame()
  m.scoreText.text = "SCORE:"
  m.scoreValue = 0
  setScore(m.scoreValue)

  m.sceneAnimation.control = "start"
  m.pipesAnimation.control = "start"
  m.bgAnimation.control = "start"
  m.message.visible = false
  m.timer.control = "start"
  SetState(GameStates().PLAYING)
end function

function stopGame()
  if (m.record < m.scoreValue or m.record = invalid)
    m.record = m.scoreValue
    setRegistryField("best-score", m.scoreValue)
  end if

  m.sceneAnimation.control = "stop"
  m.pipesAnimation.control = "stop"
  m.bgAnimation.control = "stop"
  m.bird.CallFunc("drop", false)
  SetState(GameStates().GAME_OVER)
  m.bird.birdUri = "pkg:/images/flappy-bird/bird-dark_$$RES$$.png"
end function

function resetGame()
  m.sceneAnimation.control = "none"
  m.pipesAnimation.control = "none"
  m.upPipes.UnobserveField("translation")
  ' IMPORTANT: set last pipe to invalid to bring the state truely back to the start
  m.lastPipePos = invalid
  ' Reset pipes
  m.lowPipes.translation = [0, m.background.height - m.lowPipes.height]
  m.upPipes.translation = [0, m.background.height - m.upPipes.height]
  m.lowPipesAnimation.keyValue = [m.lowPipes.translation, [m.lowPipes.translation[0] - 100, m.lowPipes.translation[1]]]
  m.upPipesAnimation.keyValue = [m.upPipes.translation, [m.upPipes.translation[0] - 100, m.upPipes.translation[1]]]
  ' Reset bird position
  m.bird.translation = [50, 360]
  m.bird.pitch = [0, 0]
  ' Show welcome message
  m.message.visible = true

  m.upPipes.removeChildrenIndex(m.upPipes.getChildCount(), 0)
  m.lowPipes.removeChildrenIndex(m.lowPipes.getChildCount(), 0)

  SetState(GameStates().START)
  m.bird.birdUri = "pkg:/images/flappy-bird/bird_$$RES$$.png"
  m.bird.isDead = false

  m.scoreText.text = "RECORD:"
  setScore(m.record)
end function

function setScore(score as integer) as void
  scoreString = Str(score).Trim()
  m.score.text = scoreString
end function

function onTimerFireChangeBackgroundColor()
  if (GetState() <> GameStates().GAME_OVER and GetState() <> GameStates().START and m.scoreValue > 0 and m.scoreValue mod 10 = 0)
    backgroundColor = ColorPalette()[Int(Rnd(0) * ColorPalette().Count())]
    m.backScene.blendColor = backgroundColor
  end if
end function

