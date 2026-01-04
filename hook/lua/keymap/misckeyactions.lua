function DisableFAMetrics()
    local state = import('/mods/fa-live-metrics/modules/exporter_state.lua')
    state.Disable()
end

function ToggleFAMetrics()
    local state = import('/mods/fa-live-metrics/modules/exporter_state.lua')
    state.Toggle()
    local toggleInfo = {text = "Toggeled FA Metrics disabled=" .. tostring(state.GetDisabledState()), size = 20, color = 'FFF0AAAA', duration = 1, location = 'center'}
    import('/lua/ui/game/textdisplay.lua').PrintToScreen(toggleInfo)
end

local KeyMapper = import('/lua/keymap/keymapper.lua')
KeyMapper.SetUserKeyAction('Disable FA Exporter', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").DisableFAMetrics()', category = 'FA Metrics', order = 80})
KeyMapper.SetUserKeyAction('Toggle FA Exporter', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").ToggleFAMetrics()', category = 'FA Metrics', order = 80})
-- KeyMapper.SetUserKeyAction('Set Frequency to 10s', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").Frequency(10)', category = 'FA Metrics', order = 80})
-- KeyMapper.SetUserKeyAction('Disable Unit Collection', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").Frequency(10)', category = 'FA Metrics', order = 80})
-- KeyMapper.SetUserKeyAction('Toggle Unit Collection', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").ToggleUnitCollection()', category = 'FA Metrics', order = 80})