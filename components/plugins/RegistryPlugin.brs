'******************************************************************************
'** RegistryPlugin.brs
'** Handle tasks relating to Registry
'** 32739
'******************************************************************************

'******************************************************************************
'** initRegistry()
'******************************************************************************
function initRegistry()
    m.registry = CreateObject("roRegistry")
    m.section = CreateObject("roRegistrySection", "gameStorage")

    ' ?" Section List: ", FormatJson(m.registry.GetSectionList())
    ' ?" Available space: ", FormatJson(m.registry.GetSpaceAvailable())
end function

'******************************************************************************
'** deleteRegistrySection()
'******************************************************************************
function deleteRegistrySection(section as string) as boolean
    isSuccess = false
    if (m.registry <> invalid)
        isSuccess = m.registry.Delete(section) and m.registry.Flush()
    end if

    return isSuccess
end function

'******************************************************************************
'** setRegistryField()
'******************************************************************************
function setRegistryField(fieldName as string, value as integer) as boolean
    isSuccess = false
    m.section.Write(fieldName, FormatJson(value))
    m.section.Flush()
    return isSuccess
end function

'******************************************************************************
'** getRegistryField()
'******************************************************************************
function getRegistryField(fieldName as string) as integer
    readValue = m.section.Read(fieldName)
    if (readValue <> "") return ParseJson(readValue)
    return 0
end function
