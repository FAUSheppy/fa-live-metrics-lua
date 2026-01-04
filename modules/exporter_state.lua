local KeyMapper = import('/lua/keymap/keymapper.lua')
local textDisplay = import('/lua/ui/game/textdisplay.lua')
local StopExporter = false

function Disable()
    StopExporter = true
    LOG('[FA_Metrics_Exporter] Exporter stopped via hotkey')
end

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
        ["Disable FA Exporter"] = true,
        ["Toggle FA Exporter"]  = true
    }

    local msg =  "Setup a hotkey to toggle Metrics Export in case it lags the UI!"
    for key, value in pairs(kmap) do
        LOG("[FA_Metrics_Exporter] Debug: " .. key .. " v: " .. value)
        if match[value] then
            msg = "Hotkey to disable FA_Metrics if UI lags is: " .. key
        end
    end

    local data1 = {text = msg, size = 20, color = 'ffffffff', duration = 5, location = 'center'}
    textDisplay.PrintToScreen(data1)
end