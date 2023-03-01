'**
'** Example: Edit a Label size and color with BrightScript
'**

function init()
    m.home = m.top.CreateChild("HomeView")
    m.home.setFocus(true)
end function

' function onKeyEvent(key as string, press as boolean) as boolean
'   handled = false
'   if (press = true)
'     if (key = "OK")
'         ?"Main Scene"
'         handled = true
'     else if (key = "left")

'     end if
'   end if

'   return handled
' end function