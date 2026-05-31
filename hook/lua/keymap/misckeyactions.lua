function ToggleFAMetrics()
    local state = import('/mods/LiveMetrics/modules/exporter_state.lua')
    state.Toggle()
    local message = "Toggeled FA Metrics disabled=" .. tostring(state.GetDisabledState())
    local toggleInfo = {text = message, size = 20, color = 'FFF0AAAA', duration = 1, location = 'center'}
    import('/lua/ui/game/textdisplay.lua').PrintToScreen(toggleInfo)
end

function remind(message)
	local data = {text = message, size = 40, color = 'ffffffff', duration = 5, location = 'center'}
	import('/lua/ui/game/textdisplay.lua').PrintToScreen(data)
end

local KeyMapper = import('/lua/keymap/keymapper.lua')
KeyMapper.SetUserKeyAction('Toggle FA Exporter', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").ToggleFAMetrics()', category = 'FA Metrics', order = 80})
-- KeyMapper.SetUserKeyAction('Set Frequency to 10s', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").Frequency(10)', category = 'FA Metrics', order = 80})
-- KeyMapper.SetUserKeyAction('Disable Unit Collection', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").Frequency(10)', category = 'FA Metrics', order = 80})
-- KeyMapper.SetUserKeyAction('Toggle Unit Collection', {action = 'UI_Lua import("/lua/keymap/misckeyactions.lua").ToggleUnitCollection()', category = 'FA Metrics', order = 80})