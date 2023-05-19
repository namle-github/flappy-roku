'******************************************************************************
'** AudioPlugin.brs
'** Handle tasks relating to Audio
'******************************************************************************

'******************************************************************************
'** createAudio()
'******************************************************************************
function createAudio(url as string) as object
    ' if (audio = invalid)
    audio = createObject("roSGNode", "Audio")
    ' end if
    audiocontent = createObject("RoSGNode", "ContentNode")
    audiocontent.url = url
    audio.content = audiocontent
    ' m.top.appendChild(audio)
    ' audio.control = "play"
    return audio
end function
