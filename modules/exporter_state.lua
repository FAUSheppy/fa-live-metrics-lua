local KeyMapper = import('/lua/keymap/keymapper.lua')
local StopExporter = false

function Toggle()
    StopExporter = not StopExporter
    LOG('[FA_Metrics_Exporter] Exporter toggled via hotkey')
end

function GetDisabledState()
    return StopExporter
end

function PrintWarningIfHotkeyNotSet()
    local kmap = KeyMapper.GetUserKeyMap()
    local match = {
        ["Toggle FA Exporter"]  = true
    }

    local msg =  "Setup a hotkey to toggle Metrics Export in case it lags the UI! (i.e Ctrl-Alt-P)"
    for key, value in pairs(kmap) do
        if match[value] then
            msg = ""
        end
    end

    if msg ~= "" then
        local data1 = {text = msg, size = 20, color = 'ffffffff', duration = 5, location = 'center'}
        import('/lua/ui/game/textdisplay.lua').PrintToScreen(data1)
        --textDisplay.PrintToScreen(data1)
    end
end

function PrintWarningIngame(string)
    local data = {text = string, size = 20, color = 'ffffffff', duration = 10, location = 'center'}
    import('/lua/ui/game/textdisplay.lua').PrintToScreen(data)
end